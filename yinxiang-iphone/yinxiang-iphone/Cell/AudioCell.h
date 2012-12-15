//
//  AudioCell.h
//  yinxiang-iphone
//
//  Created by Bruce Yang on 12/15/12.
//  Copyright (c) 2012 yuxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioFile.h"

@interface AudioCell : UITableViewCell

@property (nonatomic, strong) AudioFile *audioFile;

@property (strong, nonatomic) IBOutlet UIImageView *cover;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *albumAndArtist;
@property (strong, nonatomic) IBOutlet UIImageView *mark;

@property (nonatomic) Boolean isPlaying;

@end
