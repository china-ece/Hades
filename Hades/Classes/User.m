//
//  User.m
//  Hades
//
//  Created by 超 周 on 12-3-23.
//  Copyright (c) 2012年 china-ece. All rights reserved.
//

#import "User.h"
#import "AppDelegate.h"

#define PLIST_FILE @"oauser.plist"

@implementation User
@synthesize name;
@synthesize token;

+ (User*)generateByJSONData:(NSString*)json
{
    OLog(json);
    id repr = [json objectFromJSONString];
    if (repr && [repr objectForKey:@"status"] != nil && [repr objectForKey:@"status"] == [[NSNumber alloc] initWithBool:YES]) {
        return [[User alloc] initWithDictionary:[repr objectForKey:@"data"]];
    }
    return nil;
}

- (User*)initWithDictionary:(NSDictionary*)dictionary
{
    name = [dictionary objectForKey:@"name"];
    token = [dictionary objectForKey:@"token"];
    if (name == nil || token == nil) {
        return nil;
    }
    return self;
}

- (void)saveToFile
{
    ((AppDelegate*)[UIApplication sharedApplication].delegate).user = self;
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:token,@"token",name,@"name",nil];
    [dic writeToFile:[User dataFilePath] atomically:YES];
}

+ (User *)readFromAppDelegate
{
    User *user = ((AppDelegate*)[UIApplication sharedApplication].delegate).user;
    if(user == nil)
        user = [User readFromFile];
    return user;
}

+ (User *)readFromFile
{
    User *user = [User alloc];
    NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:[User dataFilePath]];
    return [user initWithDictionary:dic];
}

+ (NSString*)dataFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingPathComponent:PLIST_FILE];
}

+ (void)clearAuth
{
    [[NSFileManager defaultManager] removeItemAtPath:[User dataFilePath] error:nil];
}

@end
