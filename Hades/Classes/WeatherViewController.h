//
//  WeatherViewController.h
//  Hades
//
//  Created by 超 周 on 12-3-26.
//  Copyright (c) 2012年 china-ece. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Weather.h"

@interface WeatherViewController : UIViewController
{
    Weather *weather;
    double lastCheckTime;
}
@end
