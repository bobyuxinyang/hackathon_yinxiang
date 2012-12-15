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
            self.mark.image = [UIImage imageNamed:@"radio_select.png"];
        }
        else {
            self.mark.image = [UIImage imageNamed:@"radio_normal.png"];
        }
        
        _isPlaying = isPlaying;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    UIView *view = [[UIView alloc]initWithFrame:self.frame];
    view.backgroundColor = [UIColor colorWithRed:170.0f/255.0f green:220.f/255.0f blue:220.f/255.0f alpha:1.0f];
    
    self.selectedBackgroundView = view;
    }

- (void)setAudioFile:(AudioFile *)audioFile {
    if (![_audioFile isEqual:audioFile]) {
        self.cover.image = audioFile.coverImage;
        self.title.text = audioFile.title;
        self.albumAndArtist.text = [NSString stringWithFormat:@"%@ - %@", audioFile.album, audioFile.artist, nil];
    }
}

@end
