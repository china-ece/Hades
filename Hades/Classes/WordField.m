//
//  WordField.m
//  Hades
//
//  Created by 超 周 on 12-3-29.
//  Copyright (c) 2012年 china-ece. All rights reserved.
//

#import "WordField.h"
#import "OAAPI.h"

@implementation WordField
@synthesize documentVC;

- (UIControl*)getMappingInstance
{
    if (mappingControl == nil) {
        UIFont *font = [UIFont systemFontOfSize:14];
        if (self.displayValue != nil && ![self.displayValue isEqualToString:@""]) {
            __autoreleasing UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 200, 44)];
            [button setTitle:@"点击打开word正文文件" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.titleLabel.font = font;
            [button addTarget:self action:@selector(openWord:) forControlEvents:UIControlEventTouchUpInside];
            mappingControl = button;
        }else {
            __autoreleasing UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
            label.text = @"没有Word正文文件";
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

- (void)openWord:(id)sender
{
    __block ASIHTTPRequest *_request = [OAAPI downloadWordRequest:self.dataValue];
    __unsafe_unretained ASIHTTPRequest *request = _request;
    [request setCompletionBlock:^{
        [mappingControl.superview.superview setUserInteractionEnabled:YES];
        if (request.responseStatusCode != 200) {
            [[[UIAlertView alloc] initWithTitle:@"糟糕" message:@"文件不存在于服务器" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil] show];
        }else {
            [documentVC openWord:self.dataValue];
        }
    }];
    [request setFailedBlock:^{
        [mappingControl.superview.superview setUserInteractionEnabled:YES];
        [[[UIAlertView alloc] initWithTitle:@"糟糕" message:@"网络异常" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil] show];
    }];
    [mappingControl.superview.superview setUserInteractionEnabled:NO];
    [request startAsynchronous];
}

- (void)dealloc
{
    documentVC = nil;
}

@end
