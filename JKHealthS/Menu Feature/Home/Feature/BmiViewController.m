//
//  BmiViewController.m
//  JKHealth
//
//  Created by Apple on 2019/4/23.
//  Copyright © 2019 whitelok.com. All rights reserved.
//

#import "BmiViewController.h"
#import "BmiP2ViewController.h"

@interface BmiViewController ()
@property (weak, nonatomic) IBOutlet UILabel *topL;
@property (weak, nonatomic) IBOutlet UITextField *HL;
@property (weak, nonatomic) IBOutlet UITextField *WL;
@property (weak, nonatomic) IBOutlet UIButton *OKbtn;
@property (weak, nonatomic) IBOutlet UIButton *cleanBtn;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UILabel *ansL;

@end

NSString *ANS;

@implementation BmiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.navigationItem.title = @"身体质量指数纪录";
    
    [self setTopLable];
    [self setBtnEven];
}

-(void)setTopLable{
    self.topL.text = @"身体质量指数计算公式：\n\n";
    self.topL.text = [self.topL.text stringByAppendingString:@"体质指数(BMI) = 体重(kg)/身高m2 (m)"];
    self.topL.text = [self.topL.text stringByAppendingString:@"\n\n"];
    self.topL.text = [self.topL.text stringByAppendingString:@"例如：一个52公斤的人,身高是155公分"];
    self.topL.text = [self.topL.text stringByAppendingString:@"\n"];
    self.topL.text = [self.topL.text stringByAppendingString:@"则BMI为："];
    self.topL.text = [self.topL.text stringByAppendingString:@"\n"];
    self.topL.text = [self.topL.text stringByAppendingString:@"52(kg)/1.55m2 (m) = 21.6"];
    self.topL.text = [self.topL.text stringByAppendingString:@"\n"];
    self.topL.text = [self.topL.text stringByAppendingString:@"体重正常范围为 BMI = 18.5 ~ 24"];

    NSRange rangeA = [self.topL.text rangeOfString:@"体重正常范围为 BMI = 18.5 ~ 24"];
    NSMutableAttributedString *aStr = [[NSMutableAttributedString alloc] initWithString:self.topL.text];
    [aStr addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:rangeA];
    
    self.topL.attributedText = aStr;
}

-(void)setBtnEven{
    
    [self.OKbtn addTarget:self
                   action:@selector(OKButtonClicked:)
         forControlEvents:UIControlEventTouchUpInside
     ];
    
    [self.cleanBtn addTarget:self
                   action:@selector(CButtonClicked:)
         forControlEvents:UIControlEventTouchUpInside
     ];
    
    [self.saveBtn addTarget:self
                   action:@selector(SButtonClicked:)
         forControlEvents:UIControlEventTouchUpInside
     ];
    
}

- (void) OKButtonClicked:(id)sender {
    if(![self.HL.text isEqual:@""] && ![self.WL.text isEqual:@""]){
        float valueH = [self.HL.text floatValue];
        float valueW = [self.WL.text floatValue];
        float bmi = valueW / pow(valueH/100, 2);
        ANS = [[NSString alloc] initWithFormat:@"%f", bmi];
        _ansL.text = ANS;
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"错误"
                                                                                 message:@"请填入正确数值"
                                                                          preferredStyle:UIAlertControllerStyleAlert ];
        //添加确定到UIAlertController中
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        }];
        [alertController addAction:OKAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void) CButtonClicked:(id)sender {
    self.HL.text = nil;
    self.WL.text = nil;
    self.ansL.text = nil;
    ANS = nil;
}

- (void) SButtonClicked:(id)sender {
    NSLog(@"SAVE : %@", ANS);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"BP2"]) {
        
        BmiP2ViewController *view2 = segue.destinationViewController;
        //the destination is View 2
        view2.bmi = ANS;
    }
}

@end
