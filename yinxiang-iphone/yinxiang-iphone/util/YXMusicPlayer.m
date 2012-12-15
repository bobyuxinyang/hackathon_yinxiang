//
//  MusciPlayer.m
//  yinxiang-iphone
//
//  Created by Bruce Yang on 12/15/12.
//  Copyright (c) 2012 yuxin. All rights reserved.
//

#import "YXMusicPlayer.h"
#import "define.h"

@implementation YXMusicPlayer

@synthesize musicList = _musicList;
@synthesize index = _index;
@synthesize player = _player;


- (void)setMusicList:(NSMutableArray *)musicList
{
    if (![_musicList isEqual:musicList]) {
        _musicList = musicList;
    }
}

- (void)setIndex:(NSInteger)index
{
    _index = index;
    
    AudioFile *file = [self.musicList objectAtIndex:index];
    self.player = [[AVAudioPlayer alloc]initWithContentsOfURL:file.path error:nil];
    self.player.delegate = self;
    [self.delegate fetchCurrentPlayingMusicInfo:file];
    
    [self.player prepareToPlay];
}

- (void)prev
{
    NSInteger prev_index = (self.index - 1 < 0) ? (self.musicList.count - 1) : (self.index - 1);
    self.index = prev_index;
    [self.player play];
}

- (void)next
{
    NSInteger next_index = (self.index + 1 >= self.musicList.count) ? 0 : (self.index + 1);
    self.index = next_index;
    [self.player play];
}

- (void)play
{
    [self.player play];
    
    if ([self.delegate respondsToSelector:@selector(handlePlayingStatus)]) {
        [self.delegate handlePlayingStatus];
    }
}

- (void)pause
{
    if (self.player.playing == YES)
	{
		[self.player pause];
        
        if ([self.delegate respondsToSelector:@selector(handlePauseStatus)]) {
            [self.delegate handlePauseStatus];
        }
	}
}

- (float)duration
{
    AudioFile *file = [self.musicList objectAtIndex:self.index];
    return file.duration;
}


- (NSString *)durationStr
{
    AudioFile *file = [self.musicList objectAtIndex:self.index];
    return file.durationInMinutes;
}

- (float)currentTime
{
    NSTimeInterval time = self.player.currentTime;
    float currentTime = time;
    return currentTime;
}

- (void)setCurrentTime:(float)currentTime
{
    self.player.currentTime = currentTime;
    NSLog(@"%f", self.player.currentTime);
}


- (void)exit
{
    [self.player stop];
    self.player = nil;
}

#pragma mark AVAudioPlayer delegate


- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)p successfully:(BOOL)flag
{
    [self next];
}

- (void)playerDecodeErrorDidOccur:(AVAudioPlayer *)p error:(NSError *)error
{
	NSLog(@"ERROR IN DECODE: %@\n", error);
	
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Decode Error"
														message:[NSString stringWithFormat:@"Unable to decode audio file with error: %@", [error localizedDescription]]
													   delegate:self
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
	[alertView show];
}

@end
