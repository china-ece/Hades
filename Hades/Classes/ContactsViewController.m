//
//  ContactsViewController.m
//  Hades
//
//  Created by 超 周 on 12-3-25.
//  Copyright (c) 2012年 china-ece. All rights reserved.
//

#import "ContactsViewController.h"
#import "ContactDetailViewController.h"
#import "Contact.h"
#import "OAAPI.h"

@implementation ContactsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)getMatchedContacts:(NSString*)search
{
    __block ASIHTTPRequest *_request = [OAAPI getContactsRequestUsingApps:search];
    __unsafe_unretained ASIHTTPRequest *request = _request;
    [request setCompletionBlock:^{
        [self.view setUserInteractionEnabled:YES];
        NSString *responseString = [request responseString];
        matchedContacts = [Contact generateByJSONData:responseString];
        if (matchedContacts == nil) {
            [[[UIAlertView alloc] initWithTitle:@"糟糕" message:@"网络请求失败了" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil] show];
        }else {
            [super.tableView reloadData];
        }
    }];
    [request setFailedBlock:^{
        [self.view setUserInteractionEnabled:YES];
        [[[UIAlertView alloc] initWithTitle:@"糟糕" message:@"网络异常" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil] show];
    }];
    [self.view setUserInteractionEnabled:NO];
    [request startAsynchronous];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UISearchBar * theSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0,0,320,40)];
    theSearchBar.delegate = self;
    theSearchBar.placeholder = @"请输入姓名关键字";
    theSearchBar.showsCancelButton = NO;
    [theSearchBar becomeFirstResponder];
    self.tableView.tableHeaderView = theSearchBar;
    UILabel *noResult = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 70)];
    noResult.text = @"没有匹配记录";
    noResult.textAlignment = UITextAlignmentCenter;
    noResult.textColor = [UIColor grayColor];
    self.tableView.backgroundView = noResult;
    self.tableView.backgroundView.hidden = YES;
    [self.navigationItem setTitle:@"通讯录检索"];
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

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self getMatchedContacts:searchBar.text];
}

- (void)buttonPressed:(id)sender
{
    UIButton *callButton = (UIButton*)sender;
    NSString *telephone = [@"tel://" stringByAppendingString:((Contact*)[matchedContacts objectAtIndex:callButton.tag]).telephone];
    OLog(telephone);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telephone]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.tableView.backgroundView.hidden = (matchedContacts.count != 0);
    return matchedContacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Contact *aContact = [matchedContacts objectAtIndex:indexPath.row];
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        UIButton *callButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
        [callButton setImage:[UIImage imageNamed:@"phone.png"] forState:UIControlStateNormal];
        [callButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        callButton.tag = indexPath.row;
        cell.accessoryView = callButton;
    }
    cell.textLabel.text = aContact.name;
    [cell.accessoryView viewWithTag:indexPath.row].hidden = (aContact.telephone.length == 0);
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     [self.navigationController pushViewController:[[ContactDetailViewController alloc] initWithContact:[matchedContacts objectAtIndex:indexPath.row]] animated:YES];
}

@end
