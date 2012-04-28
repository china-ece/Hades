//
//  Document.h
//  Hades
//
//  Created by 超 周 on 12-3-26.
//  Copyright (c) 2012年 china-ece. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "DataModel.h"

@interface Document : NSObject<DataModel>

@property (nonatomic) NSArray *docItems;
@property (nonatomic) NSString *currnodeid;
@property (nonatomic) NSArray *flowPath;
@property (nonatomic) NSInteger version;
@property (nonatomic) BOOL canEdit;
@property (nonatomic) BOOL canSubmit;
@property (nonatomic) BOOL isMutiChoice;
@property (nonatomic) BOOL isOfficial;

@end

@class Item;
@protocol Itemtype <NSObject>

@optional
- (BOOL)isChanged;
- (id)getInstanceValue;
- (id)initWithDictionary:(NSDictionary*)dictionary;
- (UIControl*)getMappingInstance;//please keep return singleton

@end

@interface Item : NSObject<DataModel, Itemtype>
{
    UIControl *mappingControl;
}
@property (nonatomic) NSString *type;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *displayValue;
@property (nonatomic) NSString *dataValue;
@property (nonatomic) NSInteger display;
@property (nonatomic) NSArray *list_value;

@end


@interface Branch : NSObject<DataModel>

@property (nonatomic) NSString *pathid;
@property (nonatomic) NSString *name;
@property (nonatomic) NSInteger mode;
@property (nonatomic) NSString *flowtype;
@property (nonatomic) NSArray *userList;

@end


@interface BranchUser : NSObject<DataModel>

@property (nonatomic) NSString *displayValue;
@property (nonatomic) NSString *dataValue;

@end