//
//  Document.m
//  Hades
//
//  Created by 超 周 on 12-3-26.
//  Copyright (c) 2012年 china-ece. All rights reserved.
//

#import "Document.h"

@implementation Document
@synthesize docItems;
@synthesize flowPath;
@synthesize currnodeid;
@synthesize canEdit;
@synthesize canSubmit;
@synthesize isMutiChoice;
@synthesize version;
@synthesize isOfficial;

+ (id)generateByJSONData:(NSString*)json
{
    OLog(json);
    id repr = [json JSONValue];
    if (repr && [repr objectForKey:@"status"] != nil && [repr objectForKey:@"status"] == [[NSNumber alloc] initWithBool:YES]) {
        return [[Document alloc] initWithDictionary:[repr objectForKey:@"data"]];
    }
    return nil;
}

- (id)initWithDictionary:(NSDictionary*)dictionary
{
    isOfficial = NO;
    canEdit = ([dictionary objectForKey:@"editable"] == [[NSNumber alloc] initWithBool:YES]);
    canSubmit = ([dictionary objectForKey:@"submitable"] == [[NSNumber alloc] initWithBool:YES]);
    version = [[dictionary objectForKey:@"version"] integerValue];
    NSMutableArray *itemsArray = [[NSMutableArray alloc] init];
    for (NSDictionary *item in [dictionary objectForKey:@"items"]) {
        if (item.count == 0) {
            continue;
        }
        if (isOfficial == NO && [[item objectForKey:@"type"] isEqualToString:@"TextareaField"] && [[[item objectForKey:@"name"] lowercaseString] isEqualToString:@"processview"]) {
            isOfficial = YES;
            continue;
        }
        Item *detailField = [((Item*)[NSClassFromString([item objectForKey:@"type"]) alloc]) initWithDictionary:item];
        if (detailField != nil && detailField.display != 3){
            [itemsArray addObject:detailField];
        }
        else if(detailField == nil)
            OLog([@"cannot convert document item use type:" stringByAppendingString:[item objectForKey:@"type"]]);
    }
    docItems = itemsArray;
    NSMutableArray *pathArray = [[NSMutableArray alloc] init];
    for (id path in [dictionary objectForKey:@"flowPath"]) {
        if ([path isKindOfClass:[NSDictionary class]]) {
            [pathArray addObject:[[Branch alloc] initWithDictionary:path]];
        }
        else {
            isMutiChoice = (path == [[NSNumber alloc] initWithBool:YES]);
        }
    }
    flowPath = pathArray;
    currnodeid = [dictionary objectForKey:@"currNodeid"];
    return self;
}

- (void)dealloc
{
    docItems = nil;
}

@end


@implementation Item
@synthesize type;
@synthesize name;
@synthesize displayValue;
@synthesize dataValue;
@synthesize display;
@synthesize list_value;

- (id)initWithDictionary:(NSDictionary*)dictionary
{
    type = [dictionary objectForKey:@"type"];
    name = [dictionary objectForKey:@"name"];
    displayValue = [dictionary objectForKey:@"displayValue"];
    dataValue = [dictionary objectForKey:@"dataValue"];
    display = [[dictionary objectForKey:@"display"] integerValue];
    list_value = [dictionary objectForKey:@"list-value"];
    return self;
}

- (void)dealloc
{
    type = nil;
    name = nil;
    displayValue = nil;
    list_value = nil;
    mappingControl = nil;
}

@end


@implementation Branch
@synthesize flowtype;
@synthesize name;
@synthesize mode;
@synthesize pathid;
@synthesize userList;

- (id)initWithDictionary:(NSDictionary*)dictionary
{
    flowtype = [dictionary objectForKey:@"flowtype"];
    name = [dictionary objectForKey:@"name"];
    mode = [[dictionary objectForKey:@"mode"] integerValue];
    pathid = [dictionary objectForKey:@"pathid"];
    NSMutableArray *usersArray = [[NSMutableArray alloc] init];
    for (NSDictionary *user in [dictionary objectForKey:@"list-value"]) {
        [usersArray addObject:[[BranchUser alloc] initWithDictionary:user]];
    }
    userList = usersArray;
    flowtype = [dictionary objectForKey:@"flowtype"];
    return self;
}

@end


@implementation BranchUser
@synthesize displayValue;
@synthesize dataValue;

- (id)initWithDictionary:(NSDictionary*)dictionary
{
    displayValue = [dictionary objectForKey:@"displayValue"];
    dataValue = [dictionary objectForKey:@"dataValue"];
    return self;
}

@end
