//
//  LoginViewController.m
//  Hades
//
//  Created by 超 周 on 12-3-20.
//  Copyright (c) 2012年 china-ece. All rights reserved.
//

#import "LoginViewController.h"
#import "MainViewController.h"
#import "User.h"
#import "OAAPI.h"

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSArray *)gradientColors {
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:(id) [[UIColor colorWithRed:1.0f green:0.6f blue:0.2f alpha:1.0f] CGColor]];
    [array addObject:(id) [[UIColor colorWithRed:0.4f green:0.1f blue:0.0f alpha:1.0f] CGColor]];
    return array;
}

-(void)loadView
{
    [super loadView];
    //set background
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loginBG.png"]];
    [self.view addSubview:backgroundImage];
    //login form
    loginForm = [[UITableView alloc] initWithFrame:CGRectMake(0, 80, [self view].bounds.size.width, [self view].bounds.size.height) style:UITableViewStyleGrouped];
    [loginForm setBackgroundColor:[UIColor clearColor]];
    [loginForm setScrollEnabled:NO];
    [loginForm setAllowsSelection:NO];
    [loginForm setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [loginForm setDataSource:self];
    [loginForm setDelegate:self];
    [[self view] addSubview:loginForm];
    //line 1
    rowOfDomainInput = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [[rowOfDomainInput textLabel] setText:@"企业域"];
    domainInput = [self createCellTextField];
    [domainInput setPlaceholder:@"请输入企业域"];
    [domainInput setText:@"ece"];
    [domainInput setReturnKeyType:UIReturnKeyNext];
    [rowOfDomainInput addSubview:domainInput];
    //line 2
    rowOfUserInput = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [[rowOfUserInput textLabel] setText:@"用户名"];
    userInput = [self createCellTextField];
    [userInput setPlaceholder:@"请输入用户名"];
    [userInput setReturnKeyType:UIReturnKeyNext];
    [rowOfUserInput addSubview:userInput];
    //line 3
    rowOfPasswordInput = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [[rowOfPasswordInput textLabel] setText:@"密   码"];
    passwordInput = [self createCellTextField];
    [passwordInput setPlaceholder:@"请输入密码"];
    [passwordInput setReturnKeyType:UIReturnKeyDone];
    [passwordInput setSecureTextEntry:YES];
    [rowOfPasswordInput addSubview:passwordInput];
    //bar
    loginItem = [[UIBarButtonItem alloc] initWithTitle:@"登录" style:UIBarButtonItemStyleBordered target:self action:@selector(login)];
    [loginItem setEnabled:NO];
    [[self navigationItem] setTitle:@"华东有色OA"];
    [[self navigationItem] setRightBarButtonItem:loginItem];
}
                   
- (UITextField *)createCellTextField
{
    UITextField *field = [[UITextField alloc] initWithFrame:CGRectMake(100, 9, loginForm.bounds.size.width - 125, 30)];
    [field setAdjustsFontSizeToFitWidth:YES];
    [field setTextColor:[UIColor blackColor]];
    [field setBackgroundColor:[UIColor clearColor]];
    [field setAutocorrectionType:UITextAutocorrectionTypeNo];
    [field setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [field setTextAlignment:UITextAlignmentLeft];
    [field setEnabled:YES];
    [field setDelegate:self];
    [field setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    return field;
}

- (void)login
{
    __block ASIHTTPRequest *_request = [OAAPI getLoginRequestUsingDomain:[domainInput text] usingUserName:[userInput text] usingPassword:[passwordInput text]];
    __unsafe_unretained ASIHTTPRequest *request = _request;
    [request setCompletionBlock:^{
        [self.view setUserInteractionEnabled:YES];
        NSString *responseString = [request responseString];
        User *user = [User generateByJSONData:responseString];
        if(user == nil){
            [[[UIAlertView alloc] initWithTitle:@"糟糕" message:@"是不是记错用户名和密码了" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil] show];
        }
        else {
            if ([user.token rangeOfString:@"null"].length > 0) {
                [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请去OA里生成您的鉴证码" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil] show];
                return;
            }
            [user saveToFile];
            [self dismissModalViewControllerAnimated:YES];
        }
    }];
    [request setFailedBlock:^{
        [[[UIAlertView alloc] initWithTitle:@"糟糕" message:@"网络异常" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil] show];
        [self.view setUserInteractionEnabled:YES];
    }];
    [self.view setUserInteractionEnabled:NO];
    [request startAsynchronous];
}

- (void)validate
{
    if (domainInput.text.length > 0 && userInput.text.length > 0 && passwordInput.text.length > 0) {
        [loginItem setEnabled:YES];
    }else {
        [loginItem setEnabled:NO];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch ([indexPath row]) {
        case 0:
            return rowOfDomainInput;
            break;
        case 1:
            return rowOfUserInput;
            break;
        case 2:
            return rowOfPasswordInput;
            break;
        default:
            return nil;
            break;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == domainInput)
        [userInput becomeFirstResponder];
    else if (textField == userInput)
        [passwordInput becomeFirstResponder];
    else {
        [textField resignFirstResponder];
        [self validate];
        if (loginItem.isEnabled) {
            [self login];
        }else if (domainInput.text.length == 0) {
            [domainInput becomeFirstResponder];
        }else if (userInput.text.length == 0) {
            [userInput becomeFirstResponder];
        }
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [self performSelector:@selector(validate) withObject:nil afterDelay:0];   
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    loginForm = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
