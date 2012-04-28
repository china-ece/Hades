//
//  Weather.m
//  Hades
//
//  Created by 超 周 on 12-3-26.
//  Copyright (c) 2012年 china-ece. All rights reserved.
//

#import "Weather.h"

@implementation Weather
@synthesize city;
@synthesize todayTemp;
@synthesize tomorrowTemp;
@synthesize todayWeather;
@synthesize tomorrowWeather;
@synthesize todayWind;
@synthesize tips;

+ (Weather*)generateByJSONData:(NSString*)json
{
    OLog(json);
    id repr = [json JSONValue];
    if (repr && [repr objectForKey:@"status"] != nil && [repr objectForKey:@"status"] == [[NSNumber alloc] initWithBool:YES]) {
        return [[Weather alloc] initWithDictionary:[repr objectForKey:@"data"]];
    }
    return nil;
}

- (Weather*)initWithDictionary:(NSDictionary*)dictionary
{
    city = [dictionary objectForKey:@"city"];
    todayTemp = [dictionary objectForKey:@"todayTemp"];
    tomorrowTemp = [dictionary objectForKey:@"tomorrowTemp"];
    todayWeather = [dictionary objectForKey:@"todayWeather"];
    tomorrowWeather = [dictionary objectForKey:@"tomorrowWeather"];
    todayWind = [dictionary objectForKey:@"todayWind"];
    tips = [dictionary objectForKey:@"tips"];
    return self;
}

@end
