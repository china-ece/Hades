//
//  ContactsViewController.h
//  Hades
//
//  Created by 超 周 on 12-3-25.
//  Copyright (c) 2012年 china-ece. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactsViewController : UITableViewController<UISearchBarDelegate>
{
    NSArray *matchedContacts;
}
@end
