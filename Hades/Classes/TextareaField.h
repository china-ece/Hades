//
//  TextareaField.h
//  Hades
//
//  Created by 超 周 on 12-3-28.
//  Copyright (c) 2012年 china-ece. All rights reserved.
//

#import "Document.h"
#import "DocumentViewController.h"

@interface TextareaField : Item<UITextViewDelegate>
{
    NSString *old;
    NSString *append;
}

@property (nonatomic) DocumentViewController *documentVC;

@end
