//
//  DetailFlowUsersViewController.h
//  Hades
//
//  Created by 超 周 on 12-4-6.
//  Copyright (c) 2012年 china-ece. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Document.h"
#import "FlowPathViewController.h"

@interface DetailFlowUsersViewController : UITableViewController
{
    Branch *branch;
}

@property (nonatomic) FlowPathViewController *fpVC;

- (id)initWithBrach:(Branch*)aBranch;

@end
