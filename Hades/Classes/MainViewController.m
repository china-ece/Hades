//
//  MainViewController.m
//  Hades
//
//  Created by 超 周 on 12-3-22.
//  Copyright (c) 2012年 china-ece. All rights reserved.
//

#import "MainViewController.h"
#import "LoginViewController.h"
#import "OAAPI.h"
#import "User.h"
#import "Application.h"


@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) loadView
{
    [super loadView];
    //background
    UIImage *image = [UIImage imageNamed:@"mainBG.png"];
    UIImageView *background = [[UIImageView alloc] initWithImage:image];
    [self.view addSubview:background];
    //nav
    UIBarButtonItem *logout = [[UIBarButtonItem alloc] initWithTitle:@"注销" style:UIBarButtonItemStyleBordered target:self action:@selector(logout)];
    UIBarButtonItem *about = [[UIBarButtonItem alloc] initWithTitle:@"关于" style:UIBarButtonItemStyleBordered target:self action:@selector(about)];
    [self.navigationItem setLeftBarButtonItem:about];
    [self.navigationItem setRightBarButtonItem:logout];
    [self.navigationItem setTitle:@"华东有色OA"];
    //main
    NSArray *buttonImages = [NSArray arrayWithObjects:@"pendings.png",@"contacts.png",@"weather.png",nil];
    NSArray *buttonDesc = [NSArray arrayWithObjects:@"待办事项",@"通讯录",@"天气预报",nil];
    for (int index=0; index<buttonImages.count; index++) {
        UIControl *comboButton = [[UIControl alloc] init];
        //
        UIImage *image = [UIImage imageNamed:[buttonImages objectAtIndex:index]];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        [imageView setContentMode:UIViewContentModeCenter];
        [comboButton addSubview:imageView];
        //
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = UITextAlignmentCenter;
        [label setBackgroundColor:[UIColor clearColor]];
        [label setText:[buttonDesc objectAtIndex:index]];
        [comboButton addSubview:label];
        //
        comboButton.tag = index;
        CGFloat width = imageView.bounds.size.width;
        CGFloat height = imageView.bounds.size.height;
        imageView.frame = CGRectMake(0, 0, 75, 75);
        label.frame = CGRectMake(0, 75, 75, 18);
        comboButton.frame = CGRectMake((index%3)*(width+45)+20, floor(index/3)*(height+40)+50, 75, imageView.bounds.size.height + label.bounds.size.height);
        [comboButton setBackgroundColor:[UIColor clearColor]];
        [comboButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:comboButton];
    }
}

- (void) buttonPressed:(id)sender
{
    UIControl *button = (UIControl*)sender;
    switch (button.tag) {
        case 0:
            if (applicationArray.count > 0) {
                if (pendingVC == nil) {
                    pendingVC = [[PendingListViewController alloc] init];
                    NSMutableArray *appIDs = [[NSMutableArray alloc] init];
                    for (Application *app in applicationArray) {
                        [appIDs addObject:app.appid];
                    }
                    pendingVC.appIDs = appIDs;
                }
                [self.navigationController pushViewController:pendingVC animated:YES];
            }else {
                [[[UIAlertView alloc] initWithTitle:@"糟糕" message:@"您没有任何可用应用" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:@"重新获取应用", nil] show];
            }
            break;
        case 1:
            if (contactsVC == nil) {
                contactsVC = [[ContactsViewController alloc] init];
            }
            [self.navigationController pushViewController:contactsVC animated:YES];
            break;
        case 2:
            if (weatherVC == nil) {
                weatherVC = [[WeatherViewController alloc] init];
            }
            [self.navigationController pushViewController:weatherVC animated:YES];
            break;
        default:
            break;
    }
}

- (void) logout
{
    [User clearAuth];
    applicationArray = nil;
    pendingVC = nil;
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:loginVC];
    navC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentModalViewController:navC animated:YES];
}

- (void) about
{
    [[[UIAlertView alloc] initWithTitle:@"关于" message:@"开发人员：周超\n设计人员：朱婉菱\n\n版权所有：\n有色金属华东地质勘查局地质信息中心" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil] show];
}

- (void)readApps
{
    __block ASIHTTPRequest *_request = [OAAPI getAppsRequest];
    __unsafe_unretained ASIHTTPRequest *request = _request;
    [request setCompletionBlock:^{
        [self.view setUserInteractionEnabled:YES];
        NSString *responseString = [request responseString];
        applicationArray = [Application generateByJSONData:responseString];
    }];
    [request setFailedBlock:^{
        [self.view setUserInteractionEnabled:YES];
        [[[UIAlertView alloc] initWithTitle:@"糟糕" message:@"网络异常" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil] show];
    }];
    [self.view setUserInteractionEnabled:NO];
    [request startAsynchronous];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    User *user = [User readFromAppDelegate];
    if (user == nil) {
        [self logout];
    }else {
        [self.navigationItem setTitle:[user.name stringByAppendingString:@"的OA"]];
        if (applicationArray == nil) {
            [self readApps];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    applicationArray = nil;
    pendingVC = nil;
    contactsVC = nil;
    weatherVC = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:
            [self readApps];
            break;
        default:
            break;
    }
}

@end
