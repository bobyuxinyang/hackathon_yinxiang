//
//  define.h
//  yinxiang-iphone
//
//  Created by YANG Yuxin on 12-12-15.
//  Copyright (c) 2012年 yuxin. All rights reserved.
//

#ifndef yinxiang_iphone_defines_h
#define yinxiang_iphone_defines_h

#define YXDeviceName @"deviceName"

//#define XMPP_USER_ID @"cat@yuxins-macbook-air-2.local"
#define XMPP_USER_ID @"bob@yuxins-macbook-air-2.local"
//#define XMPP_USER_ID @"apple@yuxins-macbook-air-2.local"
#define XMPP_PASSWORD @"123456"
#define XMPP_SERVER @"yuxins-macbook-air-2.local"

//#define WEB_SERVER  @"http://127.0.0.1"
//#define API_URL     WEB_SERVER@"/phpsdk/api.php"
#define WEB_SERVER      @"http://linode.freefcw.com"
#define API_URL     WEB_SERVER@"/api.php"

// Notification Definitions
#define YX_XMPP_DATA_RECEIVED_NOTIFICATION @"YX_XMPP_DATA_RECEIVED_NOTIFICATION" // just for test
#define YX_XMPP_CONTROL_PAUSE_NOTIFICATION @"YX_XMPP_CONTROL_PAUSE_NOTIFICATION"
#define YX_XMPP_CONTROL_START_NOTIFICATION @"YX_XMPP_CONTROL_START_NOTIFICATION"
#define YX_XMPP_CONTROL_NEXT_NOTIFICATION @"YX_XMPP_CONTROL_NEXT_NOTIFICATION"
#define YX_XMPP_CONTROL_PREV_NOTIFICATION @"YX_XMPP_CONTROL_PREV_NOTIFICATION"
#define YX_XMPP_CONTROL_PROGRESS_NOTIFICATION @"YX_XMPP_CONTROL_PROGRESS_NOTIFICATION"
#define YX_XMPP_CONTROL_SENDTEXT_NOTIFICATION @"YX_XMPP_CONTROL_SENDTEXT_NOTIFICATION"
#define YX_XMPP_CONTROL_SENDAUDIO_NOTIFICATION @"YX_XMPP_CONTROL_SENDAUDIO_NOTIFICATION"
#define  YX_XMPPPartnerIdReceivedNotification @"YX_XMPPPartnerIdReceivedNotification"

#endif