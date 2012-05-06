//
//  Pending.m
//  Hades
//
//  Created by 超 周 on 12-3-24.
//  Copyright (c) 2012年 china-ece. All rights reserved.
//

#import "Pending.h"

@implementation Pending
@synthesize docid;
@synthesize formid;
@synthesize appid;
@synthesize summary;
@synthesize date;

+ (NSArray*)generateByJSONData:(NSString*)json
{
    OLog(json);
    id repr = [json objectFromJSONString];
    if (repr && [repr objectForKey:@"status"] != nil && [repr objectForKey:@"status"] == [[NSNumber alloc] initWithBool:YES]) {
        NSMutableArray *ret = [[NSMutableArray alloc] init];
        for(NSDictionary *dic in [repr objectForKey:@"data"]){
            [ret addObject:[[Pending alloc] initWithDictionary:dic]];
        }
        return ret;
    }
    return nil;
}

- (Pending*)initWithDictionary:(NSDictionary*)dictionary
{
    docid = [dictionary objectForKey:@"docid"];
    formid = [dictionary objectForKey:@"formid"];
    appid = [dictionary objectForKey:@"appid"];
    summary = [dictionary objectForKey:@"summary"];
    date = [dictionary objectForKey:@"date"];
    return self;
}

@end
