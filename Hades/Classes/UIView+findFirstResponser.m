//
//  UIView.m
//  Hades
//
//  Created by 超 周 on 12-6-19.
//  Copyright (c) 2012年 china-ece. All rights reserved.
//

#import "UIView+findFirstResponser.h"

@implementation UIView (findFirstResponser)

- (UIView*)findFirstResponser
{
    if (self.isFirstResponder) {
        return self;
    }
    for (UIView *subView in self.subviews) {
        if ([subView isFirstResponder]){
            return subView;
        }
        UIView *rst = [subView findFirstResponser];
        if (rst){
            return rst;
        }
    }
    return nil;
}

@end
