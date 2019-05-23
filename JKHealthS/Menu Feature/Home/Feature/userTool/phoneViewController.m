//
//  phoneViewController.m
//  iHealthS
//
//  Created by Apple on 2019/4/9.
//  Copyright © 2019 whitelok.com. All rights reserved.
//

#import "phoneViewController.h"

@interface phoneViewController ()
@property (weak, nonatomic) IBOutlet UITextField *inputL;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;
@property (weak, nonatomic) IBOutlet UILabel *dataL;

@end

NSString *mobile, *phone, *operators, *style_citynm, *ctype;

@implementation phoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"号码归属地";
    
    self.okBtn.layer.borderColor = [[UIColor blackColor] CGColor];
    self.okBtn.layer.borderWidth = 2;
    self.okBtn.layer.borderWidth=1.0f;
    self.okBtn.layer.borderColor=[[UIColor blackColor] CGColor];
    self.okBtn.layer.cornerRadius = 10;
    [self.okBtn addTarget:self
                   action:@selector(handleButtonClicked:)
         forControlEvents:UIControlEventTouchUpInside
     ];
}

- (void) handleButtonClicked:(id)sender {
    NSLog(@"button have been clicked.");
    mobile = _inputL.text;
    [self startPhone];
}

-(void)startPhone{
    
    NSString *temp = [@"http://api.k780.com/?app=phone.get&phone=" stringByAppendingString:mobile];
    temp = [temp stringByAppendingString:@"&appkey=10003&sign=b59bc3ef6191eb9f747dd4e83c99f2a4&format=json"];
    
    //第一步，创建URL
    NSURL *url = [NSURL URLWithString:temp];
    
    //第二步，创建请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    //设置请求方式为POST，默认为GET
    [request setHTTPMethod:@"GET"];
    //第三步，连接服务器
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *jsonString = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
    NSLog(@"DATA: %@", jsonString);
    
    //将字符串写到缓冲区。
    NSData* jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    //解析json数据，使用系统方法 JSONObjectWithData:  options: error:
    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
    
    NSDictionary* phoneDic = [[dic objectForKey:@"result"] objectForKey:@"phone"];
    NSDictionary* operatorsDic = [[dic objectForKey:@"result"] objectForKey:@"operators"];
    NSDictionary* style_citynmDic = [[dic objectForKey:@"result"] objectForKey:@"style_citynm"];
    NSDictionary* ctypeDic = [[dic objectForKey:@"result"]
                                          objectForKey:@"ctype"];
    
    phone = [NSString stringWithFormat:@"%@", phoneDic];
    operators = [NSString stringWithFormat:@"%@", operatorsDic];
    style_citynm = [NSString stringWithFormat:@"%@", style_citynmDic];
    ctype = [NSString stringWithFormat:@"%@", ctypeDic];
    
    [self showIpData];
}

-(void) showIpData{
    self.dataL.text = @"查询结果：\n\n\t";
    self.dataL.text = [self.dataL.text stringByAppendingString:@"手机号码："];
    self.dataL.text = [self.dataL.text stringByAppendingString:phone];
    self.dataL.text = [self.dataL.text stringByAppendingString:@"\n\n\t"];
    self.dataL.text = [self.dataL.text stringByAppendingString:@"运营商："];
    self.dataL.text = [self.dataL.text stringByAppendingString:operators];
    self.dataL.text = [self.dataL.text stringByAppendingString:@"\n\n\t"];
    self.dataL.text = [self.dataL.text stringByAppendingString:@"所属地："];
    self.dataL.text = [self.dataL.text stringByAppendingString:style_citynm];
    self.dataL.text = [self.dataL.text stringByAppendingString:@"\n\n\t"];
    self.dataL.text = [self.dataL.text stringByAppendingString:@"类型："];
    self.dataL.text = [self.dataL.text stringByAppendingString:ctype];
}


@end
