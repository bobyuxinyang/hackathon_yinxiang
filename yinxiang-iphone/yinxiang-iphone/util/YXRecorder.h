//
//  YXRecorder.h
//  Record_demo
//
//  Created by Bruce Yang on 12/15/12.
//  Copyright (c) 2012 Bruce Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

@interface YXRecorder : NSObject <AVAudioRecorderDelegate>

@property (nonatomic, strong) NSMutableDictionary *recordSetting;
@property (nonatomic, strong) NSString *recorderFilePath;
@property (nonatomic, strong) AVAudioRecorder *recorder;

@property (nonatomic, strong) NSData *fileData;

- (void)startRecording;
- (void)stopRecording;

@end
