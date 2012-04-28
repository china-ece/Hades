//
//  Contact.h
//  Hades
//
//  Created by 超 周 on 12-3-25.
//  Copyright (c) 2012年 china-ece. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataModel.h"

@interface Contact : NSObject<DataModel>

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *telephone;
@property (nonatomic) NSString *email;

@end
