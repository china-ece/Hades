//
//  OAAPI.m
//  Hades
//
//  Created by 超 周 on 12-3-21.
//  Copyright (c) 2012年 china-ece. All rights reserved.
//

#import "OAAPI.h"
#import "User.h"
#import "ASIFormDataRequest.h"
#import "JSONKit.h"

NSString *const baseURL = @"http://oa.china-ece.com:18081";
//NSString *const baseURL = @"http://localhost:8080";
//NSString *const baseURL = @"http://10.0.0.82:18081";

@implementation OAAPI

+ (ASIHTTPRequest*)getLoginRequestUsingDomain:(NSString *)domain usingUserName:(NSString *)username usingPassword:(NSString *)password
{
    NSString * url = [baseURL stringByAppendingString:@"/client/getToken.action"];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[[NSURL alloc] initWithString:url]];
    [request addPostValue:domain forKey:@"domain"];
    [request addPostValue:username forKey:@"user"];
    [request addPostValue:password forKey:@"pwd"];
    return request;
}

+ (ASIHTTPRequest*)getAppsRequest
{
    NSString * url = [baseURL stringByAppendingString:@"/client/getApps.action"];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[[NSURL alloc] initWithString:url]];
    [request addPostValue:[User readFromAppDelegate].token forKey:@"token"];
    return request;
}

+ (ASIHTTPRequest*)getPendingsRequestUsingApps:(NSArray *)apps
{
    NSString * url = [baseURL stringByAppendingString:@"/client/getPendings.action"];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[[NSURL alloc] initWithString:url]];
    [request addPostValue:[User readFromAppDelegate].token forKey:@"token"];
    [request addPostValue:[apps JSONString] forKey:@"params"];
    return request;
}

+ (ASIHTTPRequest*)getContactsRequestUsingApps:(NSString *)search
{
    NSMutableDictionary *searchDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:search, @"search", nil];
    NSString * url = [baseURL stringByAppendingString:@"/client/getContacts.action"];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[[NSURL alloc] initWithString:url]];
    [request addPostValue:[User readFromAppDelegate].token forKey:@"token"];
    [request addPostValue:[searchDic JSONString] forKey:@"params"];
    return request;
}

+ (ASIHTTPRequest*)getWeatherRequest
{
    NSString * url = [baseURL stringByAppendingString:@"/client/getWeather.action"];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[[NSURL alloc] initWithString:url]];
    return request;
}

+ (ASIHTTPRequest*)getDocumentRequestUsingAppID:(NSString *)appID usingFormID:(NSString *)formID usingDocID:(NSString *)docID
{
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:appID, @"appid", formID, @"formid", docID, @"docid", nil];
    NSString * url = [baseURL stringByAppendingString:@"/client/getDocument.action"];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[[NSURL alloc] initWithString:url]];
    [request addPostValue:[User readFromAppDelegate].token forKey:@"token"];
    [request addPostValue:[paramsDic JSONString] forKey:@"params"];
//    OLog([url stringByAppendingFormat:@"?token=%@&params=%@", [User readFromAppDelegate].token, [paramsDic JSONString]]);
    return request;
}

+ (ASIHTTPRequest*)downloadWordRequest:(NSString*)filename
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDir = [paths objectAtIndex:0];
    NSString *wordPath = [[cachesDir stringByAppendingPathComponent:filename] stringByAppendingString:@".doc"];
    NSString * url = [baseURL stringByAppendingString:[@"/uploads/doc/" stringByAppendingPathComponent:filename]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[[NSURL alloc] initWithString:url]];
    [request setDownloadDestinationPath:wordPath];
    return request;
}

+ (ASIHTTPRequest*)getSaveRequestUsingVersion:(NSInteger)version usingDocID:(NSString*)docID usingAppID:(NSString*)appID usingFields:(NSArray*)fields
{
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:appID, @"appid", docID, @"docid", [NSNumber numberWithInteger:version], @"version", fields, @"fields", nil];
    NSString * url = [baseURL stringByAppendingString:@"/client/saveDocument.action"];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[[NSURL alloc] initWithString:url]];
    [request addPostValue:[User readFromAppDelegate].token forKey:@"token"];
    [request addPostValue:[paramsDic JSONString] forKey:@"params"];
    return request;
}

+ (ASIHTTPRequest*)getSubmitRequestUsingAppID:(NSString*)appID usingDocID:(NSString*)docID usingVersion:(NSInteger)version usingSubmitTo:(NSArray*)submitTo usingNextIDS:(NSArray*)nextids usingCurrnodeID:(NSString*)currnodeID usingFlowType:(NSString*)flowType
{
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:appID, @"appid", docID, @"docid", [NSNumber numberWithInteger:version], @"version", currnodeID, @"currnodeid", nextids, @"nextids", flowType, @"flowtype", submitTo == nil?@"":[submitTo JSONString], @"submitto", nil];
    OLog([paramsDic JSONString]);
    NSString * url = [baseURL stringByAppendingString:@"/client/submitDocument.action"];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[[NSURL alloc] initWithString:url]];
    [request addPostValue:[User readFromAppDelegate].token forKey:@"token"];
    [request addPostValue:[paramsDic JSONString] forKey:@"params"];
    return request;
}

@end
