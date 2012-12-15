//
//  AppUtil.h
//  yinxiang-iphone
//
//  Created by Bruce Yang on 12/15/12.
//  Copyright (c) 2012 yuxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SVStatusHUD/SVStatusHUD.h"

@interface AppUtil : NSObject
#define	APP_DIR				[[NSBundle mainBundle] bundlePath]

//获取应用程序的文档目录
+ (NSString *)getDocFolder;
// 获取应用程序文档目录中某个指定文件全路径
+ (NSString *)getFileFullPathInDocument:(NSString *)fileName;
// 获取应用程序Library目录路径
+ (NSString *)getLibFolder;
//获取应用程序Library目录中某个指定文件全路径
+ (NSString *)getFileFullPathInLibFolder:(NSString *)fileName;
// 获取应用程序bundle路径
+ (NSString *)getBundleFolder;

//xmpp controll hud
+ (void)showPlayHud;
+ (void)showPauseHud;
+ (void)showNextHud;
+ (void)showPreHud;
//+ (void)showProgressHud;
+ (void)showGoToIndexHud: (NSInteger)index;

@end

@interface YXNavigationController: UINavigationController

@end

@interface YXToolBar: UIToolbar

@end

