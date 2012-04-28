//
//  PendingListViewController.m
//  Hades
//
//  Created by 超 周 on 12-3-23.
//  Copyright (c) 2012年 china-ece. All rights reserved.
//

#import "PendingListViewController.h"
#import "DocumentViewController.h"
#import "Pending.h"
#import "OAAPI.h"

@implementation PendingListViewController
@synthesize appIDs;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    if (lastCheckTime != 0 && [NSDate.date timeIntervalSince1970] - lastCheckTime >= 30 * 60) {
        [self getPendings];
    }
}

- (void)getPendings
{
    __block ASIHTTPRequest *_request = [OAAPI getPendingsRequestUsingApps:self.appIDs];
    __unsafe_unretained ASIHTTPRequest *request = _request;
    [request setCompletionBlock:^{
        [self.view setUserInteractionEnabled:YES];
        NSString *responseString = [request responseString];
        pendings = [Pending generateByJSONData:responseString];
        if (pendings == nil) {
            [[[UIAlertView alloc] initWithTitle:@"糟糕" message:@"网络请求失败了" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil] show];
            lastCheckTime = 0;
        }else {
            pendings = pendings.reverseObjectEnumerator.allObjects;
            [super.tableView reloadData];
        }
        lastCheckTime = [NSDate.date timeIntervalSince1970];
    }];
    [request setFailedBlock:^{
        [self.view setUserInteractionEnabled:YES];
        [[[UIAlertView alloc] initWithTitle:@"糟糕" message:@"网络异常" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil] show];
        lastCheckTime = 0;
    }];
    [self.view setUserInteractionEnabled:NO];
    [request startAsynchronous];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self getPendings];
    UIBarButtonItem *refresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(getPendings)];
    [self.navigationItem setRightBarButtonItem:refresh];
    [self.navigationItem setTitle:@"待办事项"];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return pendings.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Pending *aPending = (Pending*)[pendings objectAtIndex:indexPath.row];
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        UILabel *summary = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 280, 70)];
        summary.text = aPending.summary;
        summary.numberOfLines = 0;
        summary.lineBreakMode = UILineBreakModeWordWrap;
        summary.tag = 100;
        [cell.contentView addSubview:summary];
        UILabel *date = [[UILabel alloc] initWithFrame:CGRectMake(220, 65, 100, 20)];
        date.text = aPending.date;
        date.tag = 200;
        [cell.contentView addSubview:date];
        
    }else {
        ((UILabel*)[cell viewWithTag:100]).text = aPending.summary;
        ((UILabel*)[cell viewWithTag:200]).text = aPending.date;
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DocumentViewController *docVC = [[DocumentViewController alloc] initWithPending:[pendings objectAtIndex:indexPath.row]];
    UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:docVC];
    navC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentModalViewController:navC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

@end
