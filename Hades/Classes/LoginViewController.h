//
//  LoginViewController.h
//  Hades
//
//  Created by 超 周 on 12-3-20.
//  Copyright (c) 2012年 china-ece. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    //form
    UITableView *loginForm;
    UITableViewCell *rowOfDomainInput;
    UITableViewCell *rowOfUserInput;
    UITableViewCell *rowOfPasswordInput;
    //line 1
    UILabel *labelDomain;
    UITextField *domainInput;
    //line 2
    UILabel *labelUser;
    UITextField *userInput;
    //line 3
    UILabel *labelPassword;
    UITextField *passwordInput;
    //bar
    UIBarButtonItem *cancelItem;
    UIBarButtonItem *loginItem;
}


@end
