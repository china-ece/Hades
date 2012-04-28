//
//  DocumentViewController.h
//  Hades
//
//  Created by 超 周 on 12-3-26.
//  Copyright (c) 2012年 china-ece. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Document.h"
#import "Pending.h"

@interface DocumentViewController : UITableViewController<UIActionSheetDelegate>
{
    Pending *pending;
}

@property (nonatomic) Document *document;

- (id)initWithPending:(Pending*)aPending;

- (void)openWord:(NSString*)filename;

@end
