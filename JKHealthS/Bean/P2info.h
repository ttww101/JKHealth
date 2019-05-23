//
//  P2info.h
//  iHealthS
//
//  Created by Apple on 2019/3/30.
//  Copyright © 2019 whitelok.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol INFO
@end

@interface INFO : JSONModel
@property NSString *title;
@property NSString *date;
@property NSArray *content;

@end

@implementation INFO
@end

@interface P2info : JSONModel
@property NSString *status;
@property NSString *msg;
@property NSArray<INFO> *data;

@end

@implementation P2info

@end
NS_ASSUME_NONNULL_END
