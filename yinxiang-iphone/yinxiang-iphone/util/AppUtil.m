//
//  AppUtil.m
//  yinxiang-iphone
//
//  Created by Bruce Yang on 12/15/12.
//  Copyright (c) 2012 yuxin. All rights reserved.
//

#import "AppUtil.h"

@implementation AppUtil

+ (NSString *)getDocFolder
{
	NSArray *userPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	return [userPaths objectAtIndex:0];
}


+ (NSString *)getFileFullPathInDocument:(NSString *)fileName
{
	NSString *docPath = [self getDocFolder];
	return [docPath stringByAppendingPathComponent:fileName];
}

+ (NSString *)getLibFolder
{
    NSArray *libPaths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
	return [libPaths objectAtIndex:0];
}

+ (NSString *)getFileFullPathInLibFolder:(NSString *)fileName
{
    NSString *libPath = [self getLibFolder];
    return [libPath stringByAppendingPathComponent:fileName];
}

+ (NSString *)getBundleFolder
{
    return APP_DIR;
}


+ (void)showPlayHud
{
    [SVStatusHUD showWithImage:[UIImage imageNamed:@"pop_play"] status:@"播放" duration:2.0f];
}

+ (void)showPauseHud
{
    [SVStatusHUD showWithImage:[UIImage imageNamed:@"pop_pause"] status:@"暂停" duration:2.0f];
}

+ (void)showNextHud
{
    [SVStatusHUD showWithImage:[UIImage imageNamed:@"pop_next"] status:@"下一首" duration:2.0f];
}

+ (void)showPreHud
{
    [SVStatusHUD showWithImage:[UIImage imageNamed:@"pop_prev"] status:@"上一首" duration:2.0f];  
}

+ (void)showGoToIndexHud: (NSInteger)index
{
    [SVStatusHUD showWithImage:[UIImage imageNamed:@"pop_next"] status:[NSString stringWithFormat:@"跳到第%d首", index, nil] duration:2.0f];
}

@end

@implementation YXNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //navigation bar
    [self.navigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0],
      
      UITextAttributeTextColor,
      [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0],
      
      UITextAttributeTextShadowColor,
      [NSValue valueWithUIOffset:UIOffsetMake(0, 0)],
      
      UITextAttributeTextShadowOffset,
      
      [UIFont fontWithName:@"Arial-Bold"size:0.0],
      UITextAttributeFont,
      nil]];
    
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setBarStyle:UIBarStyleBlackOpaque];
}

@end

@implementation YXToolBar

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setBackgroundImage:[UIImage imageNamed:@"navbar.png"] forToolbarPosition:UIToolbarPositionBottom barMetrics:UIBarMetricsDefault];
}

@end
