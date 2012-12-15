//
//  RenrenViewController.m
//  yinxiang-iphone
//
//  Created by YANG Yuxin on 12-12-15.
//  Copyright (c) 2012年 yuxin. All rights reserved.
//

#import "define.h"
#import "RenrenViewController.h"
#import "ASIFormDataRequest.h"
#import "XMPPManager.h"
#import "BumpViewController.h"

@interface RenrenViewController ()
{
    NSArray        *peoples;
}
@end

@implementation RenrenViewController

@synthesize renren = _renren;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:10];
    [params setObject:@"friends.getAppFriends" forKey:@"method"];
    [params setObject:@"name, tinyurl" forKey:@"fields"];
    
    [self.renren requestWithParams:params andDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [peoples count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    id p = [peoples objectAtIndex: indexPath.row];

    cell.textLabel.text = [(NSDictionary *)p objectForKey: @"name"];
//    [(NSDictionary *)p objectForKey: @"tinyurl"];
//    [(NSDictionary *)p objectForKey: @"uid"];
    
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSURL *url = [[NSURL alloc] initWithString:API_URL];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    
    [request setPostValue:@"query_xmppid" forKey:@"method"];
    
    NSDictionary *p = (NSDictionary *)[peoples objectAtIndex: indexPath.row];
    
    [request setPostValue:[p objectForKey: @"uid"] forKey:@"renren_id"];
    
    [request startSynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSData *jsonData = [request responseData];
    
    NSLog(@"data\n%@", [request responseString]);
    
    NSError *error;
    
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    
    
    if ([(NSDictionary *)jsonObject objectForKey:@"xmpp_id"])
    {
        NSString *xmpp_id = [(NSDictionary *)jsonObject objectForKey:@"xmpp_id"];
        [XMPPManager sharedManager].partnerUserId = xmpp_id;
        
        BumpViewController *bumpViewController = [self.navigationController.viewControllers objectAtIndex:0];
        [bumpViewController doConnect];

        [self.navigationController popViewControllerAnimated:YES];
    } else {
        //error
    }
}


/**
 * 接口请求成功，第三方开发者实现这个方法
 */
- (void)renren:(Renren *)renren requestDidReturnResponse:(ROResponse*)response
{
    //    NSLog(@"%@", response.rootObject);
    peoples = response.rootObject;
    
    [self.tableView reloadData];
}


/**
 * 接口请求失败，第三方开发者实现这个方法
 */
- (void)renren:(Renren *)renren requestFailWithError:(ROError*)error
{
    
}



@end
