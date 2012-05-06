//
//  DocumentViewController.m
//  Hades
//
//  Created by 超 周 on 12-3-26.
//  Copyright (c) 2012年 china-ece. All rights reserved.
//

#import "DocumentViewController.h"
#import "WordViewController.h"
#import "FlowPathViewController.h"
#import "WordField.h"
#import "TextareaField.h"
#import "OAAPI.h"

@implementation DocumentViewController
@synthesize document;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithPending:(Pending*)aPending
{
    pending = aPending;
    return self;
}

- (void)getDocument
{
    __block ASIHTTPRequest *_request = [OAAPI getDocumentRequestUsingAppID:pending.appid usingFormID:pending.formid usingDocID:pending.docid];
    __unsafe_unretained ASIHTTPRequest *request = _request;
    [request setCompletionBlock:^{
        [self.view setUserInteractionEnabled:YES];
        NSString *responseString = [request responseString];
        Document *doc = [Document generateByJSONData:responseString];
        if (doc == nil) {
            [[[UIAlertView alloc] initWithTitle:@"糟糕" message:@"网络请求失败了" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil] show];
        }else {
            document = doc;
            [self.tableView reloadData];
        }
    }];
    [request setFailedBlock:^{
        [self.view setUserInteractionEnabled:YES];
        [[[UIAlertView alloc] initWithTitle:@"糟糕" message:@"网络异常" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil] show];
    }];
    [self.view setUserInteractionEnabled:NO];
    [request startAsynchronous];
}

- (void)saveDocument
{
    NSMutableDictionary *fields = [[NSMutableDictionary alloc] init];
    for (Item *item in document.docItems) {
        if (item.isChanged){
            [fields setValue:item.getInstanceValue forKey:item.name];
        }
    }
    if (fields.count == 0) {
        return;
    }
    __block ASIHTTPRequest *_request = [OAAPI getSaveRequestUsingVersion:document.version usingDocID:pending.docid usingAppID:pending.appid usingFields:fields];
    __unsafe_unretained ASIHTTPRequest *request = _request;
    [request setCompletionBlock:^{
        [self.view setUserInteractionEnabled:YES];
        NSString *responseString = [request responseString];
        OLog(responseString);
        if (responseString == nil || [[responseString objectFromJSONString] objectForKey:@"status"] == [[NSNumber alloc] initWithBool:NO] ||[[[responseString objectFromJSONString] objectForKey:@"data"] objectForKey:@"result"] == [[NSNumber alloc] initWithBool:NO]) {
            [[[UIAlertView alloc] initWithTitle:@"糟糕" message:@"保存失败了" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil] show];
        }else {
            document.version++;
            [[[UIAlertView alloc] initWithTitle:@"搞定" message:@"保存成功" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil] show];
        }
    }];
    [request setFailedBlock:^{
        [self.view setUserInteractionEnabled:YES];
        [[[UIAlertView alloc] initWithTitle:@"糟糕" message:@"网络异常" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil] show];
    }];
    [self.view setUserInteractionEnabled:NO];
    [request startAsynchronous];
}

- (void)submitDocument
{
    FlowPathViewController *flowVC = [[FlowPathViewController alloc] initWithDocument:document andPending:pending];
    flowVC.docVC = self;
    UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:flowVC];
    navC.modalPresentationStyle = UIModalPresentationFullScreen;
    navC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:navC animated:YES];
}

- (void)openWord:(NSString*)filename
{
    [self.navigationController pushViewController:[[WordViewController alloc] initWithWordFilename:filename] animated:YES];
}

- (void)dismissDocVC
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)openActionSheet
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择相应文档操作" delegate:self cancelButtonTitle:@"取消操作" destructiveButtonTitle:nil otherButtonTitles:@"保存文档", @"提交文档", nil];
    [actionSheet showInView:self.view];
}

- (void)allowAction
{
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)denyAction
{
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)loadView
{
    [super loadView];
    
    [self getDocument];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(dismissDocVC)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(openActionSheet)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(denyAction) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(allowAction) name:UIKeyboardDidHideNotification object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    pending = nil;
    document = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == [actionSheet cancelButtonIndex]) {
        return;
    }
    switch (buttonIndex) {
        case 0://save
            if (document.canEdit) {
                [self saveDocument];
            }else {
                [[[UIAlertView alloc] initWithTitle:@"提示" message:@"此文档不允许保存" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil] show];
            }
            break;
        case 1://submit
            if (document.canSubmit) {
                [self submitDocument];
            }else {
                [[[UIAlertView alloc] initWithTitle:@"提示" message:@"此文档不允许提交" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil] show];
            }
            break;
        default:
            break;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return document.docItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [@"Cell" stringByAppendingFormat:@"%d",indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //
        Item *item = [document.docItems objectAtIndex:indexPath.row];
        UIControl *control = [item getMappingInstance];
        if (control != nil){
            control.tag = indexPath.row;
            if ([item.type isEqualToString:@"WordField"])
                ((WordField*)item).documentVC = self;
            if ([item.type isEqualToString:@"TextareaField"]) {
                ((TextareaField*)item).documentVC = self;
            }
            [cell.contentView addSubview:control];
        }
    }
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Item *item = [document.docItems objectAtIndex:indexPath.row];
    return ((UIControl*)[item getMappingInstance]).bounds.size.height + 10;
}

@end
