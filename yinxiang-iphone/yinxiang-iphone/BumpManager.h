//
//  BumpManager.h
//  playBump
//
//  Created by YANG Yuxin on 12-12-13.
//  Copyright (c) 2012年 yuxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BumpClient.h"
#import "XMPPManager.h"

#define BUMP_API_KEY @"f671d81e8e6c43ce833956063e736f1b"

@interface BumpManager : NSObject
+ (BumpManager *)shareManager;

- (void)configureBump;

@property (nonatomic) BumpChannelID currentChannel;
@end
