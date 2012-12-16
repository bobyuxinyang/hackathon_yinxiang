//
//  YXSharePackage.h
//  playBumpAndXmpp
//
//  Created by YANG Yuxin on 12-12-15.
//  Copyright (c) 2012年 yuxin. All rights reserved.
//

//2012-12-15 21:13:15.942 yinxiang-iphone[16286:c07] start -
//ewogICJiYXNlNjREYXRhIiA6ICIiLAogICJ0eXBlIiA6IDEsCiAgImRpY3Rpb25hcnlEYXRhIiA6IHsKCiAgfQp9
//
//2012-12-15 15:13:14.559 yinxiang-iphone[67116:c07] pause -
//ewogICJiYXNlNjREYXRhIiA6ICIiLAogICJ0eXBlIiA6IDAsCiAgImRpY3Rpb25hcnlEYXRhIiA6IHsKCiAgfQp9
//2012-12-15 15:13:14.561 yinxiang-iphone[67116:c07] prev -
//ewogICJiYXNlNjREYXRhIiA6ICIiLAogICJ0eXBlIiA6IDIsCiAgImRpY3Rpb25hcnlEYXRhIiA6IHsKCiAgfQp9
//2012-12-15 15:13:14.562 yinxiang-iphone[67116:c07] next -
//ewogICJiYXNlNjREYXRhIiA6ICIiLAogICJ0eXBlIiA6IDMsCiAgImRpY3Rpb25hcnlEYXRhIiA6IHsKCiAgfQp9
//2012-12-15 15:13:14.563 yinxiang-iphone[67116:c07] progress -
//ewogICJiYXNlNjREYXRhIiA6ICIiLAogICJ0eXBlIiA6IDQsCiAgImRpY3Rpb25hcnlEYXRhIiA6IHsKICAgICJpbmRleCIgOiAwLAogICAgImR1cmF0aW9uIiA6IDEwMAogIH0KfQ==
//2012-12-15 15:13:14.564 yinxiang-iphone[67116:c07] send Text -
//ewogICJiYXNlNjREYXRhIiA6ICIiLAogICJ0eXBlIiA6IDUsCiAgImRpY3Rpb25hcnlEYXRhIiA6IHsKICAgICJ0ZXh0IiA6ICJIZWxsbyBXb3JsZCBUZXh0IgogIH0KfQ==


#import <Foundation/Foundation.h>
typedef enum _YXSharePackageTypeEnum{
    YXSharePackageTypePause = 0, //    暂停
    YXSharePackageTypeStart = 1, //    开始播放
    YXSharePackageTypePrev = 2,  //    上一首
    YXSharePackageTypeNext = 3,  //    下一首
    YXSharePackageTypeSyncProgress = 4, //    时间同步（跳转）
    YXSharePackageTypeSyncSendText = 5, //    发送文字消息
    YXSharePackageTypeSyncSendAudio = 6,//    发送音频消息
    YXSharePackageTypeRequireConnection = 7,//    请求建立连接
    YXSharePackageTypeEndConnection = 8, //   请求取消连接
}YXSharePackageTypeEnum;

@interface YXSharePackage : NSObject
- (NSString *)toPackageString;
+ (YXSharePackage *)packageFromString:(NSString *)dataString;

@property (nonatomic) YXSharePackageTypeEnum type;

// dictionaryData字段
// index,int 标志第几首
// duration, int 播放时间
@property (nonatomic, strong) NSMutableDictionary *dictionaryData;
@property (nonatomic, strong) NSString *base64Data;
@end
