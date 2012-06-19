//
//  TextareaField.m
//  Hades
//
//  Created by 超 周 on 12-3-28.
//  Copyright (c) 2012年 china-ece. All rights reserved.
//

#import "TextareaField.h"
#import "User.h"

@implementation TextareaField
@synthesize documentVC;

- (UIControl*)getMappingInstance
{
    if (mappingControl == nil) {
        UIFont *font = [UIFont systemFontOfSize:14];
        __autoreleasing UITextView *field = [[UITextView alloc] initWithFrame:CGRectZero];
        field.font = font;
        field.text = self.displayValue;
        self.displayValue = field.text;//avoid control field parser
        field.delegate = self;
        if (self.display == 2) {
            field.frame = CGRectMake(5, 5, 310, 75);
        }else {
            CGSize size = CGSizeMake(310,2000.0f);
            CGSize labelsize = [self.displayValue sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
            field.frame = CGRectMake(5, 5, 310, labelsize.height == 0?75:labelsize.height+10);
        }
        UIBarButtonItem *b1 = [[UIBarButtonItem alloc] initWithTitle:@"已阅" style:UIBarButtonItemStyleBordered target:self action:@selector(easyButtonPressed:)];
        UIBarButtonItem *b2 = [[UIBarButtonItem alloc] initWithTitle:@"同意" style:UIBarButtonItemStyleBordered target:self action:@selector(easyButtonPressed:)];
        UIBarButtonItem *b3 = [[UIBarButtonItem alloc] initWithTitle:@"不同意" style:UIBarButtonItemStyleBordered target:self action:@selector(easyButtonPressed:)];
        NSMutableArray *buttons = [[NSMutableArray alloc] initWithObjects:b1,b2,b3, nil];
        UIToolbar *easyInput = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 310, 50)];
        easyInput.items = buttons;
        field.inputAccessoryView = easyInput;
        field.returnKeyType = UIReturnKeyDone;
        mappingControl = (UIControl*)field;
        
    }
    return mappingControl;
}

- (BOOL)isChanged
{
    return ![((UITextView*)mappingControl).text isEqualToString:self.displayValue];
}

- (id)getInstanceValue
{
    return [((UITextView*)mappingControl).text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (documentVC.document.isOfficial && self.display != 2){
        if (old != nil) {
            textView.text = append;
        }else {
            old = textView.text;
            textView.text = @"";
        }
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (documentVC.document.isOfficial && self.display != 2){
        append = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (append.length == 0) {
            textView.text = old;
            return;
        }
        NSDate* date = [NSDate date];
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        textView.text = [old stringByAppendingFormat:@"\n%@  %@  %@", append, [User readFromAppDelegate].name, [formatter stringFromDate:date]];
        //redraw
        UIFont *font = [UIFont systemFontOfSize:14];
        CGSize size = CGSizeMake(310,2000.0f);
        CGSize labelsize = [textView.text sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
        textView.frame = CGRectMake(5, 5, 310, labelsize.height == 0?75:labelsize.height+10);
        [documentVC.tableView reloadData];
    }
}

- (void)easyButtonPressed:(UIBarButtonItem*)sender
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIView *responser = (UIView*)[keyWindow performSelector:@selector(findFirstResponser)];
    if(responser != nil){
        if ([responser isKindOfClass:[UITextView class]]) {
            ((UITextView*)responser).text = sender.title;
        }
    }
}

@end
