//
//  BumpManager.m
//  playBump
//
//  Created by YANG Yuxin on 12-12-13.
//  Copyright (c) 2012年 yuxin. All rights reserved.
//

#import "BumpManager.h"
#import "base64.h"
#import "define.h"

@implementation BumpManager

static BumpManager *instance = nil;
+ (BumpManager *)shareManager
{
    @synchronized(self) {
        if (instance == nil) {
            instance = [[self alloc] init]; // assignment not done here
        }
    }
    return instance;
}


@synthesize currentChannel = _currentChannel;

- (void)configureBump {
    // userID is a string that you could use as the user's name, or an ID that is semantic within your environment
    NSLog(@"%@", [[UIDevice currentDevice] name]);
    
    [BumpClient configureWithAPIKey:BUMP_API_KEY andUserID:[[UIDevice currentDevice] name]];
    
    [[BumpClient sharedClient] setMatchBlock:^(BumpChannelID channel) {
        NSLog(@"Matched with user: %@", [[BumpClient sharedClient] userIDForChannel:channel]);
        [[BumpClient sharedClient] confirmMatch:YES onChannel:channel];
    }];
    
    [[BumpClient sharedClient] setChannelConfirmedBlock:^(BumpChannelID channel) {
        NSLog(@"Channel with %@ confirmed.", [[BumpClient sharedClient] userIDForChannel:channel]);
        self.currentChannel = channel;
        NSLog(@"Bump Matched");
        // 把自己的XMPP_USER_ID发给对方
        NSString *myUserId = [XMPPManager sharedManager].myUserId;
        NSString *myUserName = [XMPPManager sharedManager].myUserName;
        NSString *identityStr = [NSString stringWithFormat:@"%@|%@", myUserId, myUserName];
        
        [[BumpClient sharedClient] sendData:[identityStr dataUsingEncoding:NSUTF8StringEncoding]
                                  toChannel:channel];
    }];
    
    [[BumpClient sharedClient] setDataReceivedBlock:^(BumpChannelID channel, NSData *data) {
        NSString *identityStr = [NSString stringWithCString:[data bytes] encoding:NSUTF8StringEncoding];
        NSArray *identityArray = [identityStr componentsSeparatedByString:@"|"];
        NSString *partnerUserId = [identityArray objectAtIndex:0];
        NSString *partnerUserName = [identityArray objectAtIndex:1];
        [XMPPManager sharedManager].partnerUserId = partnerUserId;
        [XMPPManager sharedManager].partnerUserName = partnerUserName;
        [[NSNotificationCenter defaultCenter] postNotificationName:YX_XMPPPartnerIdReceivedNotification object:self];

        NSLog(@"Data received from %@: %@",
              [[BumpClient sharedClient] userIDForChannel:channel],
              partnerUserId);        
    }];
    
    
    // optional callback
    [[BumpClient sharedClient] setConnectionStateChangedBlock:^(BOOL connected) {
        if (connected) {
            NSLog(@"Bump connected...");
            [[NSNotificationCenter defaultCenter] postNotificationName:YX_BUMP_SERVER_CONNECTED object:self];
        } else {
            NSLog(@"Bump disconnected...");
            [[NSNotificationCenter defaultCenter] postNotificationName:YX_BUMP_SERVER_DISCONNECTED object:self];
        }
    }];
    
    // optional callback
    [[BumpClient sharedClient] setBumpEventBlock:^(bump_event event) {
        switch(event) {
            case BUMP_EVENT_BUMP:
                NSLog(@"Bump detected.");
                break;
            case BUMP_EVENT_NO_MATCH:
                NSLog(@"No match.");
                break;
        }
    }];
}

@end
