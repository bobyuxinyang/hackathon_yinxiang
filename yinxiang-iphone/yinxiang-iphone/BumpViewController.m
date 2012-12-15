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

@interface BumpViewController () <UIAlertViewDelegate>

@end

@implementation BumpViewController

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


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // just for test
    [self getTestSamples];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(controlPauseReceived:)
                                                 name:YX_XMPP_CONTROL_PAUSE_NOTIFICATION
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(controlStartReceived:)
                                                 name:YX_XMPP_CONTROL_START_NOTIFICATION
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(controlNextReceived:)
                                                 name:YX_XMPP_CONTROL_NEXT_NOTIFICATION
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(controlPrevReceived:)
                                                 name:YX_XMPP_CONTROL_PREV_NOTIFICATION
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(controlProgressReceived:)
                                                 name:YX_XMPP_CONTROL_PROGRESS_NOTIFICATION
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(controlTextInfoReceived:)
                                                 name:YX_XMPP_CONTROL_SENDTEXT_NOTIFICATION
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(controlAudioInfoReceived:)
                                                 name:YX_XMPP_CONTROL_SENDAUDIO_NOTIFICATION
                                               object:nil];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)loginUsingRenren:(id)sender {
    RenrenViewController *renrenVC = [[RenrenViewController alloc] initWithNibName:@"RenrenViewController" bundle:nil];
    [self.navigationController pushViewController:renrenVC animated:YES];
}
- (IBAction)testBump:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"是否与xxx的iphone链接" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"连接", nil];
    [alertView show];
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

@end
