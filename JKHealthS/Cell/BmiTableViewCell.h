//
//  BmiTableViewCell.h
//  JKHealth
//
//  Created by Apple on 2019/4/23.
//  Copyright © 2019 whitelok.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BmiTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateL;
@property (weak, nonatomic) IBOutlet UILabel *bmiL;

@end

NS_ASSUME_NONNULL_END
