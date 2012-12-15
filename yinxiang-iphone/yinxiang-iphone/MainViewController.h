//
//  MainViewController.h
//  yinxiang-iphone
//
//  Created by YANG Yuxin on 12-12-15.
//  Copyright (c) 2012年 yuxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicListViewController.h"
#import "YXMusicPlayer.h"

@interface MainViewController : UIViewController <MusicSelectedDeleagate, MusicPlayerDeleagate, UIAlertViewDelegate>
@property (nonatomic, strong) MusicListViewController *musicListViewControler;
@end
