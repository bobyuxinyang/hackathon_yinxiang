//
//  MainViewController.m
//  yinxiang-iphone
//
//  Created by YANG Yuxin on 12-12-15.
//  Copyright (c) 2012年 yuxin. All rights reserved.
//

#import "MainViewController.h"
#import "AudioFile.h"
#import "YXSharePackage.h"
#import "AppUtil.h"
#import "define.h"
#import "XMPPManager.h"

@interface MainViewController () {
    NSTimer *timer;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIButton *pauseBtn;

@property (strong, nonatomic) IBOutlet UIButton *playBtn;
@property (strong, nonatomic) IBOutlet UISlider *progress;
@property (strong, nonatomic) IBOutlet UILabel *titleText;
@property (nonatomic, strong) YXMusicPlayer *player;
@property (strong, nonatomic) IBOutlet UIImageView *musicCover;
@property (strong, nonatomic) IBOutlet UILabel *durationText;
@property (strong, nonatomic) IBOutlet UILabel *currentTimeText;
@end

@implementation MainViewController
@synthesize player = _player;

@synthesize musicListViewControler = _musicListViewControler;

- (NSInteger)currentMusicIndex
{
    return self.player.index;
}

- (MusicListViewController *)musicListViewControler
{
    if (_musicListViewControler == nil) {
        _musicListViewControler = [[MusicListViewController alloc] initWithNibName:@"MusicListViewController" bundle:nil];
        _musicListViewControler.deleagte = self;
    }
    
    return _musicListViewControler;
}

- (YXMusicPlayer *)player
{
    if (_player == nil) {
        _player = [[YXMusicPlayer alloc] init];
        _player.delegate = self;
    }
    
    return _player;
}

- (void)updateCurrentTime
{
    NSString *currenTime = [NSString stringWithFormat:@"%d:%02d", (int)self.player.currentTime / 60, (int)(self.player.currentTime) % 60, nil];
    
    self.currentTimeText.text = currenTime;
    self.progress.value = self.player.currentTime / self.player.duration;
}

- (void)generateTimer
{
   timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(updateCurrentTime) userInfo:self.player repeats:YES];
}

- (IBAction)prev:(id)sender {
    [self.player prev];
    [[XMPPManager sharedManager] sendControllPrev];    
}

- (IBAction)play:(id)sender {
    [self.player play];
    //timer
    [self generateTimer];

    self.playBtn.alpha = 0.0f;
    self.pauseBtn.alpha = 1.0f;

    [[XMPPManager sharedManager] sendControllStart];    
}


- (IBAction)pause:(id)sender {
    [self.player pause];
    //timer;
    timer = nil;

    self.playBtn.alpha = 1.0f;
    self.pauseBtn.alpha = 0.0f;

    [[XMPPManager sharedManager] sendControllPause];    
}


- (IBAction)next:(id)sender {
    [self.player next];

    [[XMPPManager sharedManager] sendControllNext];    
}


- (IBAction)slideTouchDown:(id)sender {
    timer = nil;
}

- (IBAction)slideTouchUpInside:(id)sender {
    [self generateTimer];

    [[XMPPManager sharedManager] sendControllSyncProgressAtIndex:self.currentMusicIndex AndDuration:(int)self.player.currentTime];    
}

- (IBAction)slideTouchUpOutside:(id)sender {
     [self generateTimer];
     [[XMPPManager sharedManager] sendControllSyncProgressAtIndex:self.currentMusicIndex AndDuration:(int)self.player.currentTime];    
}

- (IBAction)handleSliderChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    [self.player setCurrentTime:slider.value * self.player.duration];
}

- (void)setUpMusicList
{
    NSMutableArray *list = [NSMutableArray array];
    [list addObject:[[AudioFile alloc] initWithPath:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Let It Be" ofType:@"mp3"]] coverImage:[UIImage imageNamed:@"Let It Be.jpg"]]];
    
    [list addObject:[[AudioFile alloc] initWithPath:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Eye Of The Tiger" ofType:@"mp3"]] coverImage:[UIImage imageNamed:@"Eye Of The Tiger.png"]]];
    
    self.player.musicList = self.musicListViewControler.audioList = list;
}

- (void)registerNotification
{
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self registerNotification];
    [self setUpMusicList];
    //播放第一首
    //todo:
    timer = nil;
    self.player.index = 0;
    [self play:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.progress.backgroundColor = [UIColor clearColor];
    UIImage *min_stetchTrack = [UIImage imageNamed:@"musiccontrol_progress_full.png"];
    UIImage *max_stetchTrack = [UIImage imageNamed:@"musiccontrol_progress_empty.png"];
    
    [self.progress setThumbImage: [UIImage imageNamed:@"musiccontrol_key.png"] forState:UIControlStateNormal];
        [self.progress setThumbImage: [UIImage imageNamed:@"musiccontrol_key.png"] forState:UIControlStateHighlighted];
    
    [self.progress setMinimumTrackImage:min_stetchTrack forState:UIControlStateNormal];
    [self.progress setMaximumTrackImage:max_stetchTrack forState:UIControlStateNormal];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.view.backgroundColor = [UIColor colorWithRed:242.0f/255.0f green:250.0f/255.0f blue:251.0f/255.0f alpha:1.0f];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)cancelShare:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"是否解除与xxx的iphone的连接" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"连接", nil];
    [alertView show];
}

- (IBAction)gotoMusicList:(id)sender {
    [self presentViewController:self.musicListViewControler animated:YES completion:nil];
}


#pragma mark -- XMPP Notification
- (void)controlPauseReceived:(NSNotification *)noti
{
    YXSharePackage *package = [noti.userInfo objectForKey:@"data"];
    NSLog(@"...pause");
    
    [AppUtil showPauseHud];
    [self.player pause];
    timer = nil;
}

- (void)controlStartReceived:(NSNotification *)noti
{
    YXSharePackage *package = [noti.userInfo objectForKey:@"data"];
    NSLog(@"...start");

    [AppUtil showPlayHud];
    [self.player play];
    [self generateTimer];
}

- (void)controlNextReceived:(NSNotification *)noti
{
    YXSharePackage *package = [noti.userInfo objectForKey:@"data"];
    NSLog(@"...next");
    
    [AppUtil showNextHud];
    [self.player next];
}

- (void)controlPrevReceived:(NSNotification *)noti
{
    YXSharePackage *package = [noti.userInfo objectForKey:@"data"];
    NSLog(@"...prev");
    
    [AppUtil showPreHud];
    [self.player prev];
}

- (void)controlProgressReceived:(NSNotification *)noti
{
    YXSharePackage *package = [noti.userInfo objectForKey:@"data"];
    NSLog(@"...progress sync");

    NSLog(@"%@", [package.dictionaryData objectForKey:@"index"]);
    NSLog(@"%@", [package.dictionaryData objectForKey:@"duration"]);
    NSInteger time = [[package.dictionaryData objectForKey:@"duration"] integerValue];
    timer = nil;
    
    [AppUtil showProgressHud];
    [self.player setCurrentTime:time];
    [self generateTimer];
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

#pragma mark -- UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSLog(@"Bump share end");
        
        [self.player exit];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark -- MusicSelectedDeleagate
- (void)didMusiceSelected:(NSInteger)index
{
    NSLog(@"%d", index);
    self.player.index = index;
    [self.player play];
}

#pragma mark -- MusicPlayerDeleagate
- (void)fetchCurrentPlayingMusicInfo:(AudioFile *)audio
{
    self.musicCover.image = audio.coverImage;
    self.titleText.text = [NSString stringWithFormat:@"%@ - %@", audio.artist, audio.title, nil];
    self.durationText.text = audio.durationInMinutes;
}

@end
