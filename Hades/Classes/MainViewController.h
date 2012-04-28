//
//  MainViewController.h
//  Hades
//
//  Created by 超 周 on 12-3-22.
//  Copyright (c) 2012年 china-ece. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PendingListViewController.h"
#import "ContactsViewController.h"
#import "WeatherViewController.h"

@interface MainViewController : UIViewController<UIAlertViewDelegate>
{
    NSArray *applicationArray;
    PendingListViewController *pendingVC;
    ContactsViewController *contactsVC;
    WeatherViewController *weatherVC;
}

@end
