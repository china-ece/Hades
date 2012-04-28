//
//  WordViewController.m
//  Hades
//
//  Created by 超 周 on 12-3-29.
//  Copyright (c) 2012年 china-ece. All rights reserved.
//

#import "WordViewController.h"

@implementation WordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithWordFilename:(NSString *)aFilename
{
    filename = aFilename;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDir = [paths objectAtIndex:0];
    NSString *wordPath = [[cachesDir stringByAppendingPathComponent:filename] stringByAppendingString:@".doc"];
    NSURL *url = [NSURL fileURLWithPath:wordPath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIWebView *webview = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [webview loadRequest:request];
    [self.view addSubview:webview];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
