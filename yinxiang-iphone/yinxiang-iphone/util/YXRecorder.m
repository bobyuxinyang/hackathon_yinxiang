//
//  YXRecorder.m
//  Record_demo
//
//  Created by Bruce Yang on 12/15/12.
//  Copyright (c) 2012 Bruce Yang. All rights reserved.
//

#import "YXRecorder.h"

@implementation YXRecorder

@synthesize recorderFilePath = _recorderFilePath;
@synthesize recorder = _recorder;
@synthesize recordSetting = _recordSetting;
@synthesize fileData = _fileData;

- (NSMutableDictionary *)recordSetting
{
    if (_recordSetting == nil) {
        self.recordSetting = [[NSMutableDictionary alloc] init];
        [self.recordSetting setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
        [self.recordSetting setValue:[NSNumber numberWithFloat:9600.0] forKey:AVSampleRateKey];
        [self.recordSetting setValue:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
        [self.recordSetting setValue:[NSNumber numberWithInt:8] forKey:AVLinearPCMBitDepthKey];
        [self.recordSetting setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
        [self.recordSetting setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
    }
    
    return _recordSetting;
}

- (AVAudioRecorder *)recorder
{
    if (_recorder == nil) {
        NSURL *url =[NSURL fileURLWithPath:self.recorderFilePath];
        NSError*err = nil;
        _recorder =[[AVAudioRecorder alloc] initWithURL:url settings:self.recordSetting error:&err];
        //todo: err
    }
    
    return _recorder;
}

- (void)startRecording
{
    AVAudioSession* audioSession = [AVAudioSession sharedInstance];
    NSError *err = nil;
    [audioSession setCategory :AVAudioSessionCategoryPlayAndRecord error:&err];
    
    if(err){
        NSLog(@"audioSession: %@ %d %@",[err domain],[err code],[[err userInfo] description]);
        return;
    }

    [audioSession setActive:YES error:&err];
    if(err) {
        NSLog(@"audioSession: %@ %d %@",[err domain],[err code],[[err userInfo] description]);
        return;
    }
    
    // Create a new dated file
    if(!self.recorder){
        NSLog(@"recorder: %@ %d %@",[err domain],[err code],[[err userInfo] description]);
        UIAlertView*alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                       message:[err localizedDescription]
                                                      delegate:nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    //prepare to record
    [self.recorder setDelegate:self];
    [self.recorder prepareToRecord];
    self.recorder.meteringEnabled = YES;
    
    BOOL audioHWAvailable = audioSession.inputIsAvailable;
    if(!audioHWAvailable){
        UIAlertView*cantRecordAlert =
        [[UIAlertView alloc] initWithTitle:@"Warning"
                                   message:@"Audio input hardware not available"
                                  delegate:nil
                         cancelButtonTitle:@"OK"
                         otherButtonTitles:nil];
        [cantRecordAlert show];
        return;
    }
    // start recording
    [self.recorder recordForDuration:(NSTimeInterval)30];
}


- (void)stopRecording{
    [self.recorder stop];
    
    //file data
    NSURL *url = [NSURL fileURLWithPath: self.recorderFilePath];
    NSError *err = nil;
    NSData *audioData = [NSData dataWithContentsOfFile:[url path] options: 0 error:&err];
    if(audioData)
        self.fileData = audioData;
    else {
        NSLog(@"audio data: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
    }
    
}

#pragma mark -- AVAudioRecorderDelegate
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *) aRecorder successfully:(BOOL)flag
{
    NSLog (@"success");
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error
{
    NSLog(@"error");
}

@end
