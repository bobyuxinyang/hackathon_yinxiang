//
//  MusicListViewController.m
//  yinxiang-iphone
//
//  Created by YANG Yuxin on 12-12-15.
//  Copyright (c) 2012年 yuxin. All rights reserved.
//

#import "MusicListViewController.h"
#import "AudioFile.h"
#import "AudioCell.h"
#import "AppUtil.h"
#import "define.h"

@interface MusicListViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSInteger selectedRowIndex;
@property (strong, nonatomic) IBOutlet YXToolBar *toolbar;

@end

@implementation MusicListViewController
@synthesize tableView = _tableView;
@synthesize audioList = _audioList;
@synthesize selectedRowIndex = _selectedRowIndex;


- (void) setSelectedRowIndex:(NSInteger)selectedRowIndex
{
    _selectedRowIndex = selectedRowIndex;
    [self.tableView reloadData];
}

- (NSMutableArray *)audioList
{
    if (_audioList == nil) {
        _audioList = [NSMutableArray array];
    }
    return _audioList;
}

- (IBAction)doneMusicChoose:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //footer
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setTableFooterView:v];
    
    //separator
    self.tableView.separatorColor = [UIColor colorWithRed:79/255 green:136/255 blue:136/255 alpha:1.0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    self.view.backgroundColor = [UIColor colorWithRed:242.0f/255.0f green:250.0f/255.0f blue:251.0f/255.0f alpha:1.0f];
    
    self.selectedRowIndex = [self.deleagte currentMusicIndex];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - tableView datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%d", self.audioList.count);
    return self.audioList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *indentifier = @"Audio Cell";
    AudioCell *cell = [self.tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"AudioCell" owner:self options:nil].lastObject;
    }
    
    cell.isPlaying = (indexPath.row == self.selectedRowIndex);
    cell.audioFile = [self.audioList objectAtIndex:indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64.0f;
}

#pragma mark - tableView delgate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedRowIndex = indexPath.row;
    [self dismissViewControllerAnimated:YES completion:^(void ){
        [self.deleagte didMusiceSelected:self.selectedRowIndex];
    }];
    
//    [self showPlayerViewController];
//    
//    PlayerViewController *controller = [PlayerViewController sharedInstance];
//    controller.playMode = kPlayModeCycle;
//    controller.playedContentType = kPlayedContentIsAllPrograms;
//    
//    [controller playPrograms:self.programList inChannel:nil startFromIndex:indexPath.row];
}



@end
