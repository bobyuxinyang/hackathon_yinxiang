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
+ (XMPPManager *)sharedManager;
- (void)connectXMPP;
@end
