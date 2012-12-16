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

@synthesize partnerUserId = _partnerUserId;
@synthesize myUserId = _myUserId;
@synthesize myUserName = _myUserName;
@synthesize partnerUserName = _partnerUserName;

- (NSString *)myUserId
{
    NSString *xmpp_user_id = [NSString stringWithFormat:@"%@@%@", [UIDevice currentDevice].uniqueIdentifier, XMPP_SERVER];
    return xmpp_user_id;
}

- (NSString *)myUserName
{
    NSString *customizedUserName = [[NSUserDefaults standardUserDefaults] objectForKey:YXDeviceName];
    if (customizedUserName == nil) {
        customizedUserName = [[UIDevice currentDevice] name];
    }
    return customizedUserName;
}

- (void)setMyUserName:(NSString *)myUserName
{
    [[NSUserDefaults standardUserDefaults] setObject:myUserName forKey:YXDeviceName];
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
    self.xmppStream.myJID = [XMPPJID jidWithString:self.myUserId];
    self.xmppStream.hostName = XMPP_SERVER;
//    self.xmppStream.hostName = @"192.168.5.112";
    NSError *error = nil;
    if (![self.xmppStream connect:&error]) {
        NSLog(@"cant connect %@", XMPP_SERVER);
        abort();
    }
}

- (void)sendMessage:(NSString *)message
{   
    //本地输入框中的信息    
    if (message.length > 0) {
        
        //XMPPFramework主要是通过KissXML来生成XML文件
        //生成<body>文档
        NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
//        body = [DDXMLNode cdataElementWithName:@"body" stringValue:message];
        [body setStringValue:message];
        
        //生成XML消息文档
        NSXMLElement *mes = [NSXMLElement elementWithName:@"message"];
        //消息类型
        [mes addAttributeWithName:@"type" stringValue:@"chat"];
        //发送给谁
        [mes addAttributeWithName:@"to" stringValue:[[XMPPManager sharedManager] partnerUserId]];
        //        [mes addAttributeWithName:@"to" stringValue:[BumpManager shareManager].partnerJid];
        //由谁发送
        [mes addAttributeWithName:@"from" stringValue:self.myUserId];
        //组合
        [mes addChild:body];
        
//        NSLog(@"%@", [mes stringValue]);
//        NSLog(@"%@", mes);
        //发送消息
        [self.xmppStream sendElement:mes];
        
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
    NSLog(@"XMPP Signin Success using %@/%@", self.xmppStream.myJID.user, XMPP_PASSWORD);
    //发送在线状态
    XMPPPresence *presence = [XMPPPresence presence];
    [[self xmppStream] sendElement:presence];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:YX_XMPP_SERVER_CONNECTED object:self];
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
        } else if (receivedPackage.type == YXSharePackageTypeRequireConnection) {
            [[NSNotificationCenter defaultCenter] postNotificationName:YX_XMPP_CONTROL_REQUIRE_CONNECTION_NOTIFICATION object:self userInfo:yxSharePackageDic];
        } else if (receivedPackage.type == YXSharePackageTypeEndConnection) {
            [[NSNotificationCenter defaultCenter] postNotificationName:YX_XMPP_CONTROL_END_CONNECTION_NOTIFICATION object:self userInfo:yxSharePackageDic];
        }
    }
}




- (void)sendControllPause
{
    YXSharePackage *package = [[YXSharePackage alloc] init];
    package.type = YXSharePackageTypePause;
    [self sendMessage:[package toPackageString]];
    NSLog(@"send pause");
}
- (void)sendControllStart
{
    YXSharePackage *package = [[YXSharePackage alloc] init];
    package.type = YXSharePackageTypeStart;
    [self sendMessage:[package toPackageString]];
    NSLog(@"send start");
}
- (void)sendControllPrev
{
    YXSharePackage *package = [[YXSharePackage alloc] init];
    package.type = YXSharePackageTypePrev;
    [self sendMessage:[package toPackageString]];
    NSLog(@"send prev");    
}

- (void)sendControllNext
{
    YXSharePackage *package = [[YXSharePackage alloc] init];
    package.type = YXSharePackageTypeNext;
    [self sendMessage:[package toPackageString]];
    NSLog(@"send next");
}

- (void)sendControllSyncProgressAtIndex:(NSInteger)index
                            AndDuration:(NSInteger)duration
{
    YXSharePackage *package = [[YXSharePackage alloc] init];
    package.type = YXSharePackageTypeSyncProgress;
    [package.dictionaryData setValue:[NSNumber numberWithInteger:index] forKey:@"index"];
    [package.dictionaryData setValue:[NSNumber numberWithInteger:duration] forKey:@"duration"];
    [self sendMessage:[package toPackageString]];
    NSLog(@"send sync progress");
}

- (void)sendControllSendText:(NSString *)text
{
   NSLog(@"send send text");                
}

- (void)sendControllRequireConnection:(NSString *)myUserName
                                AndId:(NSString *)myUserId
{
    YXSharePackage *package = [[YXSharePackage alloc] init];
    package.type = YXSharePackageTypeRequireConnection;
    [package.dictionaryData setValue:myUserName forKey:@"userName"];
    [package.dictionaryData setValue:myUserId forKey:@"userId"];
    [self sendMessage:[package toPackageString]];
    NSLog(@"send require connection");
}

- (void)sendControllEndConnection
{
    YXSharePackage *package = [[YXSharePackage alloc] init];
    package.type = YXSharePackageTypeEndConnection;
    [self sendMessage:[package toPackageString]];
    NSLog(@"send end connection");
}


@end
