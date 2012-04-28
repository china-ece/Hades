//
//  FlowPathViewController.h
//  Hades
//
//  Created by 超 周 on 12-4-6.
//  Copyright (c) 2012年 china-ece. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Document.h"
#import "Pending.h"
#import "DocumentViewController.h"

@interface FlowPathViewController : UITableViewController
{
    BOOL isCheck;
    Document *document;
    Pending *pending;
    NSArray *nextids;
    NSString *flowtype;
}

@property (nonatomic) NSArray *submitTo;
@property (nonatomic) DocumentViewController *docVC;

- (id)initWithDocument:(Document*)doc andPending:(Pending*)pend;

@end
