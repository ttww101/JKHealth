//
//  IPViewController.m
//  iHealthS
//
//  Created by Apple on 2019/4/8.
//  Copyright © 2019 whitelok.com. All rights reserved.
//

#import "IPViewController.h"

@interface IPViewController ()
@property (weak, nonatomic) IBOutlet UILabel *dataL;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;
@property (weak, nonatomic) IBOutlet UITextField *inputL;

@end

NSString *ips,*ip,*operators,*detailed,*area_style_areanm;

@implementation IPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"IP查询";
    
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
    
    ips = _inputL.text;
    [self startIP];
}

-(void)startIP{
    
    NSString *temp = [@"http://api.k780.com/?app=ip.get&ip=" stringByAppendingString:ips];
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
    
    NSDictionary* ipDic = [[dic objectForKey:@"result"] objectForKey:@"ip"];
    NSDictionary* operatorsDic = [[dic objectForKey:@"result"] objectForKey:@"operators"];
    NSDictionary* detailedDic = [[dic objectForKey:@"result"] objectForKey:@"detailed"];
    NSDictionary* area_style_areanmDic = [[dic objectForKey:@"result"]
                                          objectForKey:@"area_style_areanm"];

    ip = [NSString stringWithFormat:@"%@", ipDic];
    operators = [NSString stringWithFormat:@"%@", operatorsDic];
    detailed = [NSString stringWithFormat:@"%@", detailedDic];
    area_style_areanm = [NSString stringWithFormat:@"%@", area_style_areanmDic];

    [self showIpData];
}

-(void) showIpData{
    self.dataL.text = @"查询结果：\n\n\t";
    self.dataL.text = [self.dataL.text stringByAppendingString:@"IP地址："];
    self.dataL.text = [self.dataL.text stringByAppendingString:ip];
    self.dataL.text = [self.dataL.text stringByAppendingString:@"\n\n\t"];
    self.dataL.text = [self.dataL.text stringByAppendingString:@"运营商："];
    self.dataL.text = [self.dataL.text stringByAppendingString:operators];
    self.dataL.text = [self.dataL.text stringByAppendingString:@"\n\n\t"];
    self.dataL.text = [self.dataL.text stringByAppendingString:@"详情："];
    self.dataL.text = [self.dataL.text stringByAppendingString:detailed];
    self.dataL.text = [self.dataL.text stringByAppendingString:@"\n\n\t"];
    self.dataL.text = [self.dataL.text stringByAppendingString:@"物理地址："];
    self.dataL.text = [self.dataL.text stringByAppendingString:area_style_areanm];
}

@end
