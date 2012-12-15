//
//  MusicListViewController.h
//  yinxiang-iphone
//
//  Created by YANG Yuxin on 12-12-15.
//  Copyright (c) 2012年 yuxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MusicSelectedDeleagate;

@interface MusicListViewController : UIViewController <UITableViewDataSource, UITabBarDelegate>;

@property (nonatomic, strong) NSMutableArray *audioList;
@property (nonatomic, strong) id<MusicSelectedDeleagate> deleagte;

@end

@protocol MusicSelectedDeleagate <NSObject>

@property (nonatomic, readonly) NSInteger currentMusicIndex;

- (void)didMusiceSelected: (NSInteger)index;

@end
