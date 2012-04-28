//
//  InputField.m
//  Hades
//
//  Created by 超 周 on 12-3-28.
//  Copyright (c) 2012年 china-ece. All rights reserved.
//

#import "InputField.h"

@implementation InputField

- (UIControl*)getMappingInstance
{
    if (mappingControl == nil) {
        UIFont *font = [UIFont systemFontOfSize:14];
        __autoreleasing UITextView *field = [[UITextView alloc] initWithFrame:CGRectZero];
        field.font = font;
        field.text = self.displayValue;
        self.displayValue = field.text;//avoid control field parser
        if (self.display == 2) {
            field.delegate = self;
            field.returnKeyType = UIReturnKeyDone;
            mappingControl = (UIControl*)field;
        }else {
            CGSize size = CGSizeMake(310,2000.0f);
            CGSize labelsize = [self.displayValue sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
            field.frame = CGRectMake(5, 5, 310, labelsize.height == 0?25:labelsize.height+10);
            field.editable = NO;
            field.scrollEnabled = NO;
            mappingControl = (UIControl*)field;
        }
        
    }
    return mappingControl;
}

- (BOOL)isChanged
{
    if (self.display != 2) {
        return NO;
    }
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


@end
