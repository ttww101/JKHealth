//
//  getHealth2ViewController.m
//  iHealthS
//
//  Created by Apple on 2019/3/30.
//  Copyright © 2019 whitelok.com. All rights reserved.
//

#import "getHealthP2ViewController.h"
#import "P2info.h"
#import <QuartzCore/QuartzCore.h>
#import "JKHealth-Swift.h"

@interface getHealthP2ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *infL;
@property (weak, nonatomic) IBOutlet UIButton *postBtn;
@property (weak, nonatomic) NSString *addstr;

@end
UserInfoObject *us;
SendBirdTools *sbt;

@implementation getHealthP2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _addstr = @"";
    
    sbt = [SendBirdTools getInstanceWithSendBirdAppId:
                          @"567BB94B-DB70-4522-95EF-D018B69A338D"];
    us = [sbt getUserInfo];
    if(![us.userEmail isEqual:@""]){
         [self.postBtn setHidden:false];
        self.postBtn.layer.borderWidth=1.0f;
        self.postBtn.layer.cornerRadius = 10;
        self.postBtn.layer.shadowOpacity = 0.5;
        self.postBtn.layer.shadowColor = [[UIColor blackColor] CGColor];
        self.postBtn.layer.shadowOffset = CGSizeMake(3.0, 3.0);
        self.postBtn.layer.shadowRadius = 5;
        [self.postBtn addTarget:self
                         action:@selector(handleButtonClicked:)
               forControlEvents:UIControlEventTouchUpInside
         ];
    } else {
         [self.postBtn setHidden:true];
    }
    
    [self getJson];
}

-(void) getJson{
    //第一步，创建URL
    NSURL *url = [NSURL URLWithString:@"http://47.75.131.189/02a2d4cd3a528b565ba2347db2c0ff54/"];
    NSDictionary *jsonBodyDict = @{@"type":_typeId, @"id":_subId};
    
    //第二步，创建请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    //设置请求方式为POST，默认为GET
    [request setHTTPMethod:@"POST"];
    //设置参数
    NSData *jsonBodyData = [NSJSONSerialization dataWithJSONObject:jsonBodyDict options:kNilOptions error:nil];
    [request setHTTPBody:jsonBodyData];
    //第三步，连接服务器
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSString *jsonString = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
    
    P2info *iData = [[P2info alloc] initWithString:jsonString error:nil];
    for(int i = 0 ; i < iData.data.count; i += 1){
        INFO *data = iData.data[i];
        
        for(int j = 0; j < data.content.count; j++){
            _addstr  = [NSString stringWithFormat: @"%@ \n %@", _addstr, data.content[j]];
        }
        
        [self.titleL setText:data.title];
        if([data.date  isEqual: @"none"]){
            [self.timeL setText:@""];
        } else{
              [self.timeL setText:data.date];
        }
        [self.infL setText:_addstr];
    }
}

- (void) handleButtonClicked:(id)sender {
    NSLog(@"button have been clicked.");
    
    DiscussAccordingObject *DA = [[DiscussAccordingObject alloc] init];
    DA.userEmail = us.userEmail;
    DA.userNickname = us.userNickname;
    DA.userImageUrl = us.userImageUrl;
    DA.accordingTitle = self.titleL.text;
    DA.accordingSubTitle = self.timeL.text;
    
    [sbt sendDiscussToVc:self sendBirdOpenChannelUrl:@"post" customSendDiscussVC:nil according:DA sendDiscussCallback:^(DiscussObject * DA2) {
        [sbt queryDiscussFromVc:self sendBirdOpenChannelUrl:@"post" sendBirdRepostOpenChannelUrl:@"repost" sendBirdLikeOpenChannelUrl:@"like" userInfo:us customQueryDiscussVC:nil accordingClickCallback:nil];
    }];
}

@end
