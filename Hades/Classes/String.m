//
//  StringField.m
//  Hades
//
//  Created by 超 周 on 12-3-27.
//  Copyright (c) 2012年 china-ece. All rights reserved.
//

#import "String.h"
#import <UIKit/UIKit.h>

@implementation String

- (UIControl*)getMappingInstance
{
    if (mappingControl == nil) {
        __autoreleasing UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.text = self.displayValue;
        label.textColor = [UIColor magentaColor];
        label.numberOfLines = 0;
        label.lineBreakMode = UILineBreakModeWordWrap;
        UIFont *font = [UIFont fontWithName:@"Helvetica" size:16];
        CGSize size = CGSizeMake(310,2000);
        CGSize labelsize = [self.displayValue sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
        label.frame = CGRectMake(5, 5, 310, labelsize.height);
        label.font = font;
        mappingControl = (UIControl*)label;
    }
    return mappingControl;
}

- (BOOL)isChanged
{
    return NO;
}

@end
