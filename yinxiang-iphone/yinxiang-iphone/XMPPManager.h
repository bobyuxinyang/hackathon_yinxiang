//
//  XMPPManager.h
//  yinxiang-iphone
//
//  Created by YANG Yuxin on 12-12-15.
//  Copyright (c) 2012年 yuxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPP.h"
#import "define.h"

@interface XMPPManager : NSObject
@property (nonatomic, strong) XMPPStream *xmppStream;
@property (nonatomic, copy) NSString *partnerUserId;
@property (nonatomic, copy) NSString *myUserId;
@property (nonatomic, copy) NSString *myUserName;
+ (XMPPManager *)sharedManager;
- (void)connectXMPP;
- (void)sendMessage:(NSString *)message;

// play control methods
- (void)sendControllPause;
- (void)sendControllStart;
- (void)sendControllPrev;
- (void)sendControllNext;
- (void)sendControllSyncProgressAtIndex:(NSInteger)index
                            AndDuration:(NSInteger)duration;
- (void)sendControllSendText:(NSString *)text;

@end
