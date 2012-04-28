//
//  OAAPI.h
//  Hades
//
//  Created by 超 周 on 12-3-21.
//  Copyright (c) 2012年 china-ece. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

@interface OAAPI : NSObject

+ (ASIHTTPRequest*)getLoginRequestUsingDomain:(NSString *)domain usingUserName:(NSString *)username usingPassword:(NSString *)password;

+ (ASIHTTPRequest*)getAppsRequest;

+ (ASIHTTPRequest*)getPendingsRequestUsingApps:(NSArray*)apps;

+ (ASIHTTPRequest*)getContactsRequestUsingApps:(NSString*)search;

+ (ASIHTTPRequest*)getWeatherRequest;

+ (ASIHTTPRequest*)getDocumentRequestUsingAppID:(NSString*)appID usingFormID:(NSString*)formID usingDocID:(NSString*)docID;

+ (ASIHTTPRequest*)getSubmitRequestUsingAppID:(NSString*)appID usingDocID:(NSString*)docID usingVersion:(NSInteger)version usingSubmitTo:(NSArray*)submitTo usingNextIDS:(NSArray*)nextids usingCurrnodeID:(NSString*)currnodeID usingFlowType:(NSString*)flowType;

+ (ASIHTTPRequest*)getSaveRequestUsingVersion:(NSInteger)version usingDocID:(NSString*)docID usingAppID:(NSString*)appid usingFields:(NSDictionary*)fields;

+ (ASIHTTPRequest*)downloadWordRequest:(NSString*)path;

@end
