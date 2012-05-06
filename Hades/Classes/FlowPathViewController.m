//
//  FlowPathViewController.m
//  Hades
//
//  Created by 超 周 on 12-4-6.
//  Copyright (c) 2012年 china-ece. All rights reserved.
//

#import "FlowPathViewController.h"
#import "DetailFlowUsersViewController.h"
#import "OAAPI.h"

@implementation FlowPathViewController
@synthesize submitTo;
@synthesize docVC;

- (id)initWithDocument:(Document*)doc andPending:(Pending*)pend
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        document = doc;
        pending = pend;
        isCheck = NO;
        submitTo = nil;
        nextids = nil;
        flowtype = nil;
    }
    return self;
}

- (void)submit
{
    if (isCheck == YES && nextids != nil && flowtype != nil) {
        __block ASIHTTPRequest *_request = [OAAPI getSubmitRequestUsingAppID:pending.appid usingDocID:pending.docid usingVersion:document.version usingSubmitTo:submitTo usingNextIDS:nextids usingCurrnodeID:document.currnodeid usingFlowType:flowtype];
        __unsafe_unretained ASIHTTPRequest *request = _request;
        [request setCompletionBlock:^{
            [self.view setUserInteractionEnabled:YES];
            NSString *responseString = [request responseString];
            OLog(responseString);
            if (responseString == nil || [[responseString objectFromJSONString] objectForKey:@"status"] == [[NSNumber alloc] initWithBool:NO] ||[[[responseString objectFromJSONString] objectForKey:@"data"] objectForKey:@"result"] == [[NSNumber alloc] initWithBool:NO]) {
                [[[UIAlertView alloc] initWithTitle:@"糟糕" message:@"提交失败了" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil] show];
            }else {
                document.version++;
                [self dismiss];
                [docVC performSelector:@selector(dismissDocVC) withObject:nil afterDelay:1];
            }
        }];
        [request setFailedBlock:^{
            [self.view setUserInteractionEnabled:YES];
            [[[UIAlertView alloc] initWithTitle:@"糟糕" message:@"网络异常" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil] show];
        }];
        [self.view setUserInteractionEnabled:NO];
        [request startAsynchronous];
    }
    else {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"还没有选择提交路径哦！" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil] show];
    }
}

- (void)dismiss
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(dismiss)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交文档" style:UIBarButtonItemStyleBordered target:self action:@selector(submit)];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    document = nil;
    docVC = nil;
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
    if (document.canSubmit) {
        return document.flowPath.count;
    }
    else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    Branch *branch = ((Branch*)[document.flowPath objectAtIndex:indexPath.row]);
    cell.textLabel.text = branch.name;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        isCheck = NO;
    }else {
        if (isCheck == YES) {
            return;
        }
        //
        Branch *branch = ((Branch*)[document.flowPath objectAtIndex:indexPath.row]);
        nextids = [[NSMutableArray alloc] initWithObjects:branch.pathid, nil];
        flowtype = branch.flowtype;
        if (branch.mode == 0) {// non-code
            if (branch.userList.count > 0) {//choose users
                DetailFlowUsersViewController *detailVC = [[DetailFlowUsersViewController alloc] initWithBrach:branch];
                [self.navigationController pushViewController:detailVC animated:YES];
            }else {//non-choose
                NSMutableDictionary *submitBranch = [[NSMutableDictionary alloc] init];
                [submitBranch setValue:branch.pathid forKey:@"nodeid"];
                [submitBranch setValue:@"false" forKey:@"isToPerson"];
                [submitBranch setValue:@"[]" forKey:@"userids"];
                NSMutableArray *submitToByArray = [[NSMutableArray alloc] init];
                [submitToByArray addObject:submitBranch];
                submitTo = submitToByArray;
            }
        }else {// code
            submitTo = nil;
        }
        //
        isCheck = YES;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
}

@end
