//
//  MessageCell.m
//  yinxiang-iphone
//
//  Created by Bruce Yang on 12/16/12.
//  Copyright (c) 2012 yuxin. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell
@synthesize message = _message;

- (void)setMessage:(AudioMessage *)message
{
    if (![_message isEqual:message]) {
        _message = message;
        
        if ([message.type isEqualToString:@"mine"]) {
            UIImage *mine_image = [[UIImage imageNamed:@"dialogue_bubble_g.png"] stretchableImageWithLeftCapWidth:8.0f topCapHeight:8.0f];
            
            CGFloat width = message.duration <= 20? message.duration * 10.0f : 200.0f;
            NSLog(@"%f", width);
            CGFloat height = mine_image.size.height;
            
            UIImageView *mine_buddle = [[UIImageView alloc]initWithImage:mine_image];
            mine_buddle.frame = CGRectMake(320.f - 10.0f - width, 5.0f, width + 10.0f, height + 10.0f);
            [self addSubview:mine_buddle];
        }
        else {
            UIImage *other_image = [[UIImage imageNamed:@"dialogue_bubble_w.png"] stretchableImageWithLeftCapWidth:8.0f topCapHeight:8.0f];
            
            CGFloat width = message.duration <= 20? message.duration * 10.0f : 200.0f;
            CGFloat height = other_image.size.height;
            
            UIImageView *other_buddle = [[UIImageView alloc]initWithImage:other_image];
            other_buddle.frame = CGRectMake(5.0f, 5.0f, width + 10.0f, height + 10.0f);
            [self addSubview:other_buddle];
        }
    }
}

@end
