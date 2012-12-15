//
//  YXMusicPlayer.h
//  yinxiang-iphone
//
//  Created by Bruce Yang on 12/15/12.
//  Copyright (c) 2012 yuxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
#import "AudioFile.h"

@protocol MusicPlayerDeleagate;

@interface YXMusicPlayer : NSObject <AVAudioPlayerDelegate>

@property (nonatomic, strong) NSMutableArray *musicList;
@property (nonatomic) NSInteger index;
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) id<MusicPlayerDeleagate> delegate;

@property (nonatomic) float duration;
@property (nonatomic, strong) NSString *durationStr;
@property (nonatomic) float currentTime;


- (void)prev;
- (void)next;
- (void)play;
- (void)pause;

- (void)exit;

@end

@protocol MusicPlayerDeleagate <NSObject>;
- (void)fetchCurrentPlayingMusicInfo: (AudioFile *)audio;
@optional
- (void)handlePlayingStatus;
- (void)handlePauseStatus;
@end
