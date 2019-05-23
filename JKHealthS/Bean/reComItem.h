//
//  reComItem.h
//  JKHealth
//
//  Created by Apple on 2019/4/25.
//  Copyright © 2019 whitelok.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol REsults
@end

@interface REsults : JSONModel
@property NSNumber *isReCome;
@property NSString *title;
@property NSString *stringL;

@end

@implementation REsults
@end

@interface reComItem : JSONModel
@property NSArray<REsults> *results;
@end

@implementation reComItem

@end

NS_ASSUME_NONNULL_END
