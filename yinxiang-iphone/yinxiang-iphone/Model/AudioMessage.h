//
//  AudioMessage.h
//  yinxiang-iphone
//
//  Created by Bruce Yang on 12/16/12.
//  Copyright (c) 2012 yuxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioMessage : NSObject
@property (nonatomic) float duration;
@property (nonatomic, strong) NSDictionary *dict;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSURL *path;
@property (nonatomic) long size;

- (id)initWithPath: (NSString *)filePath: (NSString *)type;
@end
