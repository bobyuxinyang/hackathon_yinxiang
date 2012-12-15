//
//  AudioFile.h
//  yinxiang-iphone
//
//  Created by Bruce Yang on 12/15/12.
//  Copyright (c) 2012 yuxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface AudioFile : NSObject

@property (nonatomic, strong) NSDictionary *fielDic;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *artist;
@property (nonatomic, strong) NSURL *path;
@property (nonatomic, strong) UIImage *coverImage;
@property (nonatomic, strong) NSString *album;

@property (nonatomic) float duration;
@property (nonatomic, strong) NSString *durationInMinutes;

- (AudioFile *)initWithPath: (NSURL *)filePath coverImage: (UIImage *)fileCoverImage;
    
@end
