//
//  ViewController.h
//  yinxiang-iphone
//
//  Created by YANG Yuxin on 12-12-15.
//  Copyright (c) 2012年 yuxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"

@interface BumpViewController : UIViewController <RenrenDelegate, ASIHTTPRequestDelegate>

@property (retain,nonatomic)Renren *renren;

@end
