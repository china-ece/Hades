//
//  Pending.h
//  Hades
//
//  Created by 超 周 on 12-3-24.
//  Copyright (c) 2012年 china-ece. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataModel.h"

@interface Pending : NSObject<DataModel>

@property (nonatomic) NSString *docid;
@property (nonatomic) NSString *formid;
@property (nonatomic) NSString *appid;
@property (nonatomic) NSString *summary;
@property (nonatomic) NSString *date;

@end
