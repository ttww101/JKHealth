//
//  TitleData.h
//  iHealthS
//
//  Created by Apple on 2019/3/30.
//  Copyright © 2019 whitelok.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@protocol SUB
@end

@interface SUB : JSONModel
@property NSString *id;
@property NSString *title;

@end

@implementation SUB
@end

@protocol DATA
@end

@interface DATA : JSONModel
@property NSString *type;
@property NSString *main_title;
@property NSArray<SUB> *sec_title;

@end

@implementation DATA
@end

@interface TitleData : JSONModel
@property NSString *status;
@property NSString *msg;
@property NSArray<DATA> *data;

@end

@implementation TitleData
@end

