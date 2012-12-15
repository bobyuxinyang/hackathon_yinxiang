//
//  XMPPManager.m
//  yinxiang-iphone
//
//  Created by YANG Yuxin on 12-12-15.
//  Copyright (c) 2012年 yuxin. All rights reserved.
//

#import "XMPPManager.h"
#import "YXSharePackage.h"

@interface XMPPManager() <XMPPStreamDelegate>

@end

@implementation XMPPManager
static XMPPManager *instance = nil;
+ (XMPPManager *)sharedManager
{
    @synchronized(self) {
        if (instance == nil) {
            instance = [[self alloc] init]; // assignment not done here
        }
    }
    return instance;
}

- (XMPPStream *)xmppStream
{
    if (_xmppStream == nil) {
        _xmppStream = [[XMPPStream alloc] init];
        [_xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return _xmppStream;
}

- (void)connectXMPP
{
    NSLog(@"Connect to XMPP server");
    // 用自己device ID的xmpp_user_id登陆
//    self.xmppStream.myJID = [XMPPJID jidWithString:XMPP_USER_ID];
    NSString *uuidString = [UIDevice currentDevice].uniqueIdentifier;
    NSString *xmpp_user_id = [NSString stringWithFormat:@"%@@%@", uuidString, XMPP_SERVER];
    self.xmppStream.myJID = [XMPPJID jidWithString:xmpp_user_id];
    self.xmppStream.hostName = XMPP_SERVER;
    NSError *error = nil;
    if (![self.xmppStream connect:&error]) {
        NSLog(@"cant connect %@", XMPP_SERVER);
        abort();
    }
}

#pragma mark -- XMPPStreamDelegate

- (void)xmppStreamDidConnect:(XMPPStream *)sender{
    
    NSError *error = nil;    
    //验证密码
    [self.xmppStream authenticateWithPassword:XMPP_PASSWORD error:&error];
}

//验证通过
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    NSLog(@"XMPP Signin Success using %@/%@", XMPP_USER_ID, XMPP_PASSWORD);
    //发送在线状态
    XMPPPresence *presence = [XMPPPresence presence];
    [[self xmppStream] sendElement:presence];
}

//收到消息
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{    
    NSString *msg = [[message elementForName:@"body"] stringValue];
    NSLog(@"received body = %@", msg);    
    YXSharePackage *receivedPackage = [YXSharePackage packageFromString:msg];
    if (receivedPackage != nil) {
        NSDictionary *yxSharePackageDic = [NSDictionary dictionaryWithObject:receivedPackage forKey:@"data"];        
        if (receivedPackage.type == YXSharePackageTypePause) {
            [[NSNotificationCenter defaultCenter] postNotificationName:YX_XMPP_CONTROL_PAUSE_NOTIFICATION object:self userInfo:yxSharePackageDic];
        } else if (receivedPackage.type == YXSharePackageTypePrev) {
            [[NSNotificationCenter defaultCenter] postNotificationName:YX_XMPP_CONTROL_PREV_NOTIFICATION object:self userInfo:yxSharePackageDic];
        } else if (receivedPackage.type == YXSharePackageTypeNext) {
            [[NSNotificationCenter defaultCenter] postNotificationName:YX_XMPP_CONTROL_NEXT_NOTIFICATION object:self userInfo:yxSharePackageDic];
        } else if (receivedPackage.type == YXSharePackageTypeStart) {
            [[NSNotificationCenter defaultCenter] postNotificationName:YX_XMPP_CONTROL_START_NOTIFICATION object:self userInfo:yxSharePackageDic];
        } else if (receivedPackage.type == YXSharePackageTypeSyncProgress) {
            [[NSNotificationCenter defaultCenter] postNotificationName:YX_XMPP_CONTROL_PROGRESS_NOTIFICATION object:self userInfo:yxSharePackageDic];
        } else if (receivedPackage.type == YXSharePackageTypeSyncSendText) {
            [[NSNotificationCenter defaultCenter] postNotificationName:YX_XMPP_CONTROL_SENDTEXT_NOTIFICATION object:self userInfo:yxSharePackageDic];
        } else if (receivedPackage.type == YXSharePackageTypeSyncSendAudio) {
            [[NSNotificationCenter defaultCenter] postNotificationName:YX_XMPP_CONTROL_SENDAUDIO_NOTIFICATION object:self userInfo:yxSharePackageDic];
        }
    }
}


@end
