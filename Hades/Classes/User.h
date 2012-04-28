//
//  User.h
//  Hades
//
//  Created by 超 周 on 12-3-23.
//  Copyright (c) 2012年 china-ece. All rights reserved.
//

#import "DataModel.h"

@interface User : NSObject<DataModel>

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *token;

- (void)saveToFile;

+ (User *)readFromAppDelegate;

+ (User *)readFromFile;

+ (NSString*)dataFilePath;

+ (void)clearAuth;

@end
