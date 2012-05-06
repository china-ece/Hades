//
//  Application.m
//  Hades
//
//  Created by 超 周 on 12-3-23.
//  Copyright (c) 2012年 china-ece. All rights reserved.
//

#import "Application.h"

@implementation Application
@synthesize appid;
@synthesize name;

+ (NSArray*)generateByJSONData:(NSString*)json
{
    OLog(json);
    id repr = [json objectFromJSONString];
    if (repr && [repr objectForKey:@"status"] != nil && [repr objectForKey:@"status"] == [[NSNumber alloc] initWithBool:YES]) {
        NSMutableArray *ret = [[NSMutableArray alloc] init];
        for(NSDictionary *dic in [repr objectForKey:@"data"]){
            [ret addObject:[[Application alloc] initWithDictionary:dic]];
        }
        return ret;
    }
    return nil;
}

- (Application*)initWithDictionary:(NSDictionary*)dictionary
{
    name = [dictionary objectForKey:@"name"];
    appid = [dictionary objectForKey:@"appid"];
    return self;
}

@end
