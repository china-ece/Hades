//
//  DepartmentField.m
//  Hades
//
//  Created by 超 周 on 12-3-30.
//  Copyright (c) 2012年 china-ece. All rights reserved.
//

#import "DepartmentField.h"

@implementation DepartmentField

- (UIControl*)getMappingInstance
{
    if (mappingControl == nil) {
        UIFont *font = [UIFont systemFontOfSize:14];
        if (self.display != 2) {
            __autoreleasing UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
            label.text = self.displayValue;
            label.numberOfLines = 0;
            label.lineBreakMode = UILineBreakModeWordWrap;
            CGSize size = CGSizeMake(310,2000.0f);
            CGSize labelsize = [self.displayValue sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
            label.frame = CGRectMake(5, 5, 310, labelsize.height);
            label.font = font;
            mappingControl = (UIControl*)label;
        }else {
            __autoreleasing UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
            label.text = @"未选择";
            label.font = font;
            [label sizeToFit];
            mappingControl = (UIControl*)label;
        }
    }
    return mappingControl;
}

- (BOOL)isChanged
{
    return NO;
}

@end
