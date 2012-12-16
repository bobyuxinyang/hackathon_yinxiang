//
//  ViewController.m
//  yinxiang-iphone
//
//  Created by YANG Yuxin on 12-12-15.
//  Copyright (c) 2012年 yuxin. All rights reserved.
//

#import "BumpViewController.h"
#import "RenrenViewController.h"
#import "MainViewController.h"
#import "YXSharePackage.h"
#import "define.h"
#import "XMPPManager.h"
#import "ASIFormDataRequest.h"
#import "BumpClient.h"
#import "BumpManager.h"
#import "UITextField+HideKeyBoard.h"

@interface BumpViewController () <UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UITextField *deviceName;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel1;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel2;

@end

@implementation BumpViewController

@synthesize renren = _renren;

// just for test
- (void)getTestSamples
{
    // 开始播放
    YXSharePackage *package0 = [[YXSharePackage alloc] init];
    package0.type = YXSharePackageTypeStart;
    NSLog(@"start - %@", [package0 toPackageString]);
    
    // 暂停播放
    YXSharePackage *package1 = [[YXSharePackage alloc] init];
    package1.type = YXSharePackageTypePause;
    NSLog(@"pause - %@", [package1 toPackageString]);
    
    //上一首
    YXSharePackage *package2 = [[YXSharePackage alloc] init];
    package2.type = YXSharePackageTypePrev;
    NSLog(@"prev - %@", [package2 toPackageString]);
    
    //下一首
    YXSharePackage *package3 = [[YXSharePackage alloc] init];
    package3.type = YXSharePackageTypeNext;
    NSLog(@"next - %@", [package3 toPackageString]);
    
    //跳转到 第1首，20时间
    YXSharePackage *package4 = [[YXSharePackage alloc] init];
    package4.type = YXSharePackageTypeSyncProgress;
    [package4.dictionaryData setValue:[NSNumber numberWithInt:0] forKey:@"index"];
    [package4.dictionaryData setValue:[NSNumber numberWithInt:100] forKey:@"duration"];
    NSLog(@"progress - %@", [package4 toPackageString]);
    
    //发送文字：你好
    YXSharePackage *package5 = [[YXSharePackage alloc] init];
    package5.type = YXSharePackageTypeSyncSendText;
    [package5.dictionaryData setObject:@"Hello World Text" forKey:@"text"];
    NSLog(@"send Text - %@", [package5 toPackageString]);
    
}

- (void)controlPauseReceived:(NSNotification *)noti
{
    YXSharePackage *package = [noti.userInfo objectForKey:@"data"];
    NSLog(@"...pause");
}
- (void)controlStartReceived:(NSNotification *)noti
{
    YXSharePackage *package = [noti.userInfo objectForKey:@"data"];
    NSLog(@"...start");    
}

- (void)controlNextReceived:(NSNotification *)noti
{
    YXSharePackage *package = [noti.userInfo objectForKey:@"data"];
    NSLog(@"...next");
}

- (void)controlPrevReceived:(NSNotification *)noti
{
    YXSharePackage *package = [noti.userInfo objectForKey:@"data"];
    NSLog(@"...prev");    
}

- (void)controlProgressReceived:(NSNotification *)noti
{
    YXSharePackage *package = [noti.userInfo objectForKey:@"data"];
    [[package.dictionaryData objectForKey:@"duration"] integerValue];
    [[package.dictionaryData objectForKey:@"duration"] integerValue];
    NSLog(@"...progress sync");
}

- (void)controlTextInfoReceived:(NSNotification *)noti
{
    YXSharePackage *package = [noti.userInfo objectForKey:@"data"];
    NSLog(@"...text received");    
}

- (void)controlAudioInfoReceived:(NSNotification *)noti
{
    YXSharePackage *package = [noti.userInfo objectForKey:@"data"];
    NSLog(@"...audio received");        
}

- (void)doConnect
{
    NSLog(@"Bump Success");
    
    NSString *message = [NSString stringWithFormat:@"是否与%@连接？?", [XMPPManager sharedManager].partnerUserName];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"连接", nil];
    [alertView show];
}

- (void)bumpSuccessed:(NSNotification *)noti
{
    [self doConnect];
}

- (void)xmppServerConnected:(NSNotification *)noti
{
    self.statusLabel1.hidden = YES;
}

- (void)bumpServerConnected:(NSNotification *)noti
{
    self.statusLabel2.hidden = YES;
}

- (void)bumpServerDisconnected:(NSNotification *)noti
{
    self.statusLabel2.hidden = NO;
    [[BumpClient sharedClient] connect];
}

- (void)xmppConnectionRequired:(NSNotification *)noti
{
    YXSharePackage *package = [noti.userInfo objectForKey:@"data"];
    NSString *userName = [package.dictionaryData objectForKey:@"userName"];
    NSString *userId = [package.dictionaryData objectForKey:@"userId"];
    NSLog(@"%@", userName);
    NSLog(@"%@", userId);

    [XMPPManager sharedManager].partnerUserName = userName;
    [XMPPManager sharedManager].partnerUserId = userId;
    
    [self doConnect];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bumpSuccessed:) name:YX_XMPPPartnerIdReceivedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xmppServerConnected:) name:YX_XMPP_SERVER_CONNECTED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bumpServerConnected:) name:YX_BUMP_SERVER_CONNECTED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bumpServerDisconnected:) name:YX_BUMP_SERVER_DISCONNECTED object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xmppConnectionRequired:) name:YX_XMPP_CONTROL_REQUIRE_CONNECTION_NOTIFICATION object:nil];
    
    // just for test
//    [self getTestSamples];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(controlPauseReceived:)
//                                                 name:YX_XMPP_CONTROL_PAUSE_NOTIFICATION
//                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(controlStartReceived:)
//                                                 name:YX_XMPP_CONTROL_START_NOTIFICATION
//                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(controlNextReceived:)
//                                                 name:YX_XMPP_CONTROL_NEXT_NOTIFICATION
//                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(controlPrevReceived:)
//                                                 name:YX_XMPP_CONTROL_PREV_NOTIFICATION
//                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(controlProgressReceived:)
//                                                 name:YX_XMPP_CONTROL_PROGRESS_NOTIFICATION
//                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(controlTextInfoReceived:)
//                                                 name:YX_XMPP_CONTROL_SENDTEXT_NOTIFICATION
//                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(controlAudioInfoReceived:)
//                                                 name:YX_XMPP_CONTROL_SENDAUDIO_NOTIFICATION
//                                               object:nil];
//    
    self.renren = [Renren sharedRenren];

}


- (IBAction)handleInputDone:(id)sender {
    UITextField *filed = (UITextField *)sender;

    [XMPPManager sharedManager].myUserName = filed.text;
    
    [sender resignFirstResponder];
}

- (void)fetchDeviceName
{
    self.deviceName.text = [XMPPManager sharedManager].myUserName;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navbar_logo.png"]];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    
    self.deviceName.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.deviceName hideKeyBoard:self.view];
    
    [self fetchDeviceName];


    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navbar_logo.png"]];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];

    [BumpManager shareManager].isBumpReady = YES;
    [[BumpClient sharedClient] connect];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginUsingRenren:(id)sender {

//    NSLog(@"time: %@", [NSString stringWithFormat:@"%d", (int)[self.renren.expirationDate timeIntervalSince1970]]);
    
	if ([self.renren isSessionValid]) {
        [self showRenrenFriends];
	} else {
        NSArray *permissions = [NSArray arrayWithObjects:@"publish_feed",nil];
		[self.renren authorizationWithPermisson:permissions andDelegate:self];
	}
    
}

- (void)showRenrenFriends
{
    RenrenViewController *renrenVC = [[RenrenViewController alloc] initWithNibName:@"RenrenViewController" bundle:nil];
    renrenVC.renren = self.renren;
    [self.navigationController pushViewController:renrenVC animated:YES];
}

- (IBAction)testBump:(id)sender {
    [self doConnect];
}

#pragma mark -- UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSLog(@"Bump Success");
        
        MainViewController *mainViewController = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
        [self presentViewController:mainViewController animated:YES completion:nil];
    }
}

#pragma mark - Renren Delegate

- (void)renrenDidLogin:(Renren *)renren
{
    
//    NSLog(@"accessToken     :%@", renren.accessToken);
//    NSLog(@"secret          :%@", renren.secret);
//    NSLog(@"sessionKey      :%@", renren.sessionKey);
//    NSLog(@"expirationDate  :%@", renren.expirationDate);
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(postUserData)
                                                 name:@"kNotificationDidGetLoggedInUserId"
                                               object:nil];

    // show friends
    [self showRenrenFriends];
}

- (void)postUserData
{
    NSURL *url = [[NSURL alloc] initWithString:API_URL];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    
    [request setPostValue:@"new_user" forKey:@"method"];
    
    // get logged in user id (NSNumber)
    // notice: it's may case error
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [request setPostValue:[defaults objectForKey:@"session_UserId"] forKey:@"renren_id"];
    
    [request setPostValue:[XMPPManager sharedManager].myUserId forKey:@"xmpp_id"];
    
    [request setPostValue:self.renren.accessToken forKey:@"accessToken"];
    [request setPostValue:[NSString stringWithFormat:@"%d", (int)[self.renren.expirationDate timeIntervalSince1970]] forKey:@"expires_at"];
    
    [request startAsynchronous];

}

- (void)requestFinished:(ASIHTTPRequest *)request
{    
    NSLog(@"data\n%@", [request responseString]);
}

- (void)renrenDialogDidCancel:(Renren *)renren
{
}

- (void)renren:(Renren *)renren loginFailWithError:(ROError *)error
{
    NSString *title = [NSString stringWithFormat:@"Error code:%d", [error code]];
	NSString *description = [NSString stringWithFormat:@"%@", [error localizedDescription]];
	UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:title message:description delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
	[alertView show];
}

- (void)renren:(Renren *)renren requestFailWithError:(ROError*)error{
	//Demo Test
    NSString* errorCode = [NSString stringWithFormat:@"Error:%d",error.code];
    NSString* errorMsg = [error localizedDescription];
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:errorCode message:errorMsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

- (IBAction)simulateBump:(id)sender {
    [[BumpClient sharedClient] simulateBump];
}


@end
