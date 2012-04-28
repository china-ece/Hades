//
//  ContactDetailViewController.h
//  Hades
//
//  Created by 超 周 on 12-3-25.
//  Copyright (c) 2012年 china-ece. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contact.h"

@interface ContactDetailViewController : UITableViewController
{
    Contact *detailContact;
}

- (id)initWithContact:(Contact*)contact;

@end
