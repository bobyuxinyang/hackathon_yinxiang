//
//  AudioCell.m
//  yinxiang-iphone
//
//  Created by Bruce Yang on 12/15/12.
//  Copyright (c) 2012 yuxin. All rights reserved.
//

#import "AudioCell.h"

@implementation AudioCell
@synthesize audioFile = _audioFile;
@synthesize isPlaying = _isPlaying;
@synthesize albumAndArtist = _albumAndArtist;

- (void)setIsPlaying:(Boolean)isPlaying
{
    if (_isPlaying != isPlaying) {
        if (isPlaying) {
            
        }
        else {
            
        }
        
        _isPlaying = isPlaying;
    }
}


- (void)setAudioFile:(AudioFile *)audioFile {
    if (![_audioFile isEqual:audioFile]) {
        self.cover.image = audioFile.coverImage;
        self.title.text = audioFile.title;
        self.albumAndArtist.text = [NSString stringWithFormat:@"%@ - %@", audioFile.album, audioFile.artist, nil];
    }
}

@end
