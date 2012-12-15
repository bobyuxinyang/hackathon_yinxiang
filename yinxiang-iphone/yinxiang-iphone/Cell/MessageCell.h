//
//  MessageCell.h
//  yinxiang-iphone
//
//  Created by Bruce Yang on 12/16/12.
//  Copyright (c) 2012 yuxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioMessage.h"

@interface MessageCell : UITableViewCell

@property (strong, nonatomic) AudioMessage *message;

@end
