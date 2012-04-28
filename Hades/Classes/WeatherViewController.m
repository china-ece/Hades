//
//  WeatherViewController.m
//  Hades
//
//  Created by 超 周 on 12-3-26.
//  Copyright (c) 2012年 china-ece. All rights reserved.
//

#import "WeatherViewController.h"
#import "OAAPI.h"


@implementation WeatherViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    if (lastCheckTime != 0 && [NSDate.date timeIntervalSince1970] - lastCheckTime >= 3 * 60 * 60) {
        [self readWeather];
    }
}

- (void)readWeather
{
    __block ASIHTTPRequest *_request = [OAAPI getWeatherRequest];
    __unsafe_unretained ASIHTTPRequest *request = _request;
    [request setCompletionBlock:^{
        [self.view setUserInteractionEnabled:YES];
        NSString *responseString = [request responseString];
        weather = [Weather generateByJSONData:responseString];
        if (weather == nil) {
            [[[UIAlertView alloc] initWithTitle:@"糟糕" message:@"网络请求失败了" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil] show];
            lastCheckTime = 0;
        }else {
            [self showWeather];
        }
        lastCheckTime = [NSDate.date timeIntervalSince1970];
    }];
    [request setFailedBlock:^{
        [self.view setUserInteractionEnabled:YES];
        [[[UIAlertView alloc] initWithTitle:@"糟糕" message:@"网络异常" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil] show];
        lastCheckTime = 0;
    }];
    [self.view setUserInteractionEnabled:NO];
    [request startAsynchronous];
}

-(void)showWeather
{
    UILabel *cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 40, 150, 30)];
    cityLabel.text = weather.city;
    cityLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:cityLabel];
    
    UILabel *todayDesc = [[UILabel alloc] initWithFrame:CGRectMake(30, 70, 270, 30)];
    todayDesc.text = [@"今日天气：\n" stringByAppendingFormat:@"%@ %@",weather.todayTemp,weather.todayWeather];
    [self.view addSubview:todayDesc];
    
    UILabel *tomorrowDesc = [[UILabel alloc] initWithFrame:CGRectMake(30, 100, 270, 30)];
    tomorrowDesc.text = [@"明日天气：\n" stringByAppendingFormat:@"%@ %@",weather.tomorrowTemp,weather.tomorrowWeather];
    [self.view addSubview:tomorrowDesc];
    
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 130, 250, 300)];
    NSString *tips = @"小提示：\n";
    tipsLabel.text = [tips stringByAppendingString:weather.tips];
    tipsLabel.numberOfLines = 0;
    tipsLabel.lineBreakMode = UILineBreakModeWordWrap;
    [self.view addSubview:tipsLabel];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self readWeather];
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
