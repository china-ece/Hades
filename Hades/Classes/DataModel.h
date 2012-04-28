//
//  DataModel.h
//  Hades
//
//  Created by 超 周 on 12-3-24.
//  Copyright (c) 2012年 china-ece. All rights reserved.
//

#import "SBJson.h"

@protocol DataModel <NSObject>

@optional
+ (id)generateByJSONData:(NSString*)json;

@required
- (id)initWithDictionary:(NSDictionary*)dictionary;

@end
