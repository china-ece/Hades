//
//  Contact.m
//  Hades
//
//  Created by 超 周 on 12-3-25.
//  Copyright (c) 2012年 china-ece. All rights reserved.
//

#import "Contact.h"

@implementation Contact
@synthesize name;
@synthesize telephone;
@synthesize email;

+ (id)generateByJSONData:(NSString*)json
{
    OLog(json);
    id repr = [json objectFromJSONString];
    if (repr && [repr objectForKey:@"status"] != nil && [repr objectForKey:@"status"] == [[NSNumber alloc] initWithBool:YES]) {
        NSMutableArray *ret = [[NSMutableArray alloc] init];
        for(NSDictionary *dic in [repr objectForKey:@"data"]){
            [ret addObject:[[Contact alloc] initWithDictionary:dic]];
        }
        return ret;
    }
    return nil;
}


- (id)initWithDictionary:(NSDictionary*)dictionary
{
    name = [dictionary objectForKey:@"name"];
    telephone = [dictionary objectForKey:@"telephone"];
    email = [dictionary objectForKey:@"email"];
    return self;
}

@end
