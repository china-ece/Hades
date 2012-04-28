//
//  PendingListViewController.h
//  Hades
//
//  Created by 超 周 on 12-3-23.
//  Copyright (c) 2012年 china-ece. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PendingListViewController : UITableViewController
{
    NSArray *pendings;
    double lastCheckTime;
}
@property (nonatomic) NSArray *appIDs;

@end
