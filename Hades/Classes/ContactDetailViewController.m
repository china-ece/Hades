//
//  ContactDetailViewController.m
//  Hades
//
//  Created by 超 周 on 12-3-25.
//  Copyright (c) 2012年 china-ece. All rights reserved.
//

#import "ContactDetailViewController.h"
#import <AddressBook/AddressBook.h>

@implementation ContactDetailViewController

- (id)initWithContact:(Contact*)contact
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        detailContact = contact;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.tableView setScrollEnabled:NO];
    [self.tableView setAllowsSelection:NO];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(addContact)]];
}

- (void)addContact
{
    CFErrorRef error = NULL;
    ABAddressBookRef iPhoneAddressBook = ABAddressBookCreate();
    ABRecordRef newPerson = ABPersonCreate();
    ABRecordSetValue(newPerson, kABPersonLastNameProperty, (__bridge CFStringRef)detailContact.name, &error);
    //
    ABMutableMultiValueRef multiPhone = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(multiPhone, (__bridge CFStringRef)detailContact.telephone, kABPersonPhoneMainLabel, NULL);
    ABRecordSetValue(newPerson, kABPersonPhoneProperty, multiPhone, &error);
    //
    ABMutableMultiValueRef multiEmail = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(multiEmail, (__bridge CFStringRef)detailContact.email, kABWorkLabel, NULL);
    ABRecordSetValue(newPerson, kABPersonEmailProperty, multiEmail, &error);
    //
    ABAddressBookAddRecord(iPhoneAddressBook, newPerson, &error);
    ABAddressBookSave(iPhoneAddressBook, &error);
    //
    CFRelease(multiPhone);
    CFRelease(multiEmail);
    CFRelease(newPerson);
    CFRelease(iPhoneAddressBook);
    if (error != NULL) {
        [[[UIAlertView alloc] initWithTitle:@"糟糕" message:@"联系人保存失败了" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil] show];
    }else {
        [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"成功" style:UIBarButtonItemStyleBordered target:nil action:nil]];
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = detailContact.name;
            break;
        case 1:
            cell.textLabel.text = detailContact.telephone;
            break;
        case 2:
            cell.textLabel.text = detailContact.email;
            break;
        default:
            break;
    }
    return cell;
}

@end
