//
//  DetailFlowUsersViewController.m
//  Hades
//
//  Created by 超 周 on 12-4-6.
//  Copyright (c) 2012年 china-ece. All rights reserved.
//

#import "DetailFlowUsersViewController.h"

@implementation DetailFlowUsersViewController
@synthesize fpVC;

- (id)initWithBrach:(Branch*)aBranch
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        branch = aBranch;
    }
    return self;
}

- (void)save
{
    NSMutableArray *userids = [[NSMutableArray alloc] init];
    NSInteger rows = [self.tableView numberOfRowsInSection:0];
    for (NSInteger i = 0; i < rows; i++) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
            [userids addObject:((BranchUser*)[branch.userList objectAtIndex:i]).dataValue];
        }
    }
    if (userids.count == 0) {//all pick
        for (NSInteger i = 0; i < rows; i++) {
            [userids addObject:((BranchUser*)[branch.userList objectAtIndex:i]).dataValue];
        }
    }
    NSMutableDictionary *submitBranch = [[NSMutableDictionary alloc] init];
    [submitBranch setValue:branch.pathid forKey:@"nodeid"];
    [submitBranch setValue:@"true" forKey:@"isToPerson"];
    [submitBranch setValue:[userids JSONString] forKey:@"userids"];
    NSMutableArray *submitTo = [[NSMutableArray alloc] init];
    [submitTo addObject:submitBranch];
    fpVC.submitTo = submitTo;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确认人员选择" style:UIBarButtonItemStyleBordered target:self action:@selector(save)];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    branch = nil;
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
    return branch.userList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    BranchUser *aUser = (BranchUser*)[branch.userList objectAtIndex:indexPath.row];
    cell.textLabel.text = aUser.displayValue;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
}

@end
