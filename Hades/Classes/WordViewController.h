//
//  WordViewController.h
//  Hades
//
//  Created by 超 周 on 12-3-29.
//  Copyright (c) 2012年 china-ece. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WordViewController : UIViewController
{
    NSString *filename;
}

- (id)initWithWordFilename:(NSString *)aFilename;

@end
