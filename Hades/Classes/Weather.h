//
//  Weather.h
//  Hades
//
//  Created by 超 周 on 12-3-26.
//  Copyright (c) 2012年 china-ece. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataModel.h"

@interface Weather : NSObject<DataModel>

@property (nonatomic) NSString *city;
@property (nonatomic) NSString *todayTemp;
@property (nonatomic) NSString *tomorrowTemp;
@property (nonatomic) NSString *todayWeather;
@property (nonatomic) NSString *tomorrowWeather;
@property (nonatomic) NSString *todayWind;
@property (nonatomic) NSString *tips;

@end
