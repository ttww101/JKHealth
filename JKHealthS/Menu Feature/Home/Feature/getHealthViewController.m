//
//  Feature1ViewController.m
//  iHealthS
//
//  Created by Wu on 2019/3/13.
//  Copyright © 2019 whitelok.com. All rights reserved.
//

#import "getHealthViewController.h"
#import "UIView+Constraint.h"
#import "healthCell_title.h"
#import "healthCell_subTitle.h"
#import "getHealthP2ViewController.h"
#import "TitleData.h"
#import "userCenterViewController.h"
#import "JKHealth-Swift.h"
#import "reComItem.h"

@interface getHealthViewController ()
@property (weak, nonatomic) IBOutlet UITableView *mTable;

@property NSMutableArray * TitleData;
@property NSMutableArray * idData;
@property NSMutableArray * typeData;
@property NSMutableArray * typeJsonData;
@property (weak, nonatomic) NSString *subId;
@property (weak, nonatomic) NSString *typeId;
@property (weak, nonatomic) IBOutlet UIButton *tab_H;
@property (weak, nonatomic) IBOutlet UIButton *tab_C;
@property (weak, nonatomic) IBOutlet UIButton *tab_M;

@property NSMutableArray * reCom_Title;
@property NSMutableArray * reCom_string;

@end
NSUserDefaults *ud;

@implementation getHealthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    ud = [NSUserDefaults standardUserDefaults];
    
    self.navigationItem.title = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStylePlain target:self action:@selector(presentLeftMenuViewController:)];
    
    
    [self.tab_H addTarget:self
               action:@selector(TabHButtonClicked:)
     forControlEvents:UIControlEventTouchUpInside
     ];
    
    [self.tab_C addTarget:self
               action:@selector(TabCButtonClicked:)
     forControlEvents:UIControlEventTouchUpInside
     ];
    
    [self.tab_M addTarget:self
                   action:@selector(TabMButtonClicked:)
         forControlEvents:UIControlEventTouchUpInside
     ];
    
    _TitleData = [[NSMutableArray alloc] init];
    _idData = [[NSMutableArray alloc] init];
    _typeData = [[NSMutableArray alloc] init];
    _typeJsonData = [[NSMutableArray alloc] init];
    _reCom_Title = [[NSMutableArray alloc] init];
    _reCom_string = [[NSMutableArray alloc] init];
    
    [self getReCom];
    [self initTable];
}

-(void)getTitleJson{
    //第一步，创建URL
    NSURL *url = [NSURL URLWithString:@"http://47.75.131.189/02a2d4cd3a528b565ba2347db2c0ff54/"];
    NSDictionary *jsonBodyDict = @{@"type":@"title"};
    
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
    
    TitleData *TData = [[TitleData alloc] initWithString:jsonString error:nil];
    for(int i = 0 ; i < TData.data.count; i += 1){
        DATA *data = TData.data[i];
        [_typeData addObject:@"1"];
        [_idData addObject:@"0"];
        [_TitleData addObject:data.main_title];
        [_typeJsonData addObject:data.type];
        for(int j = 0; j < data.sec_title.count; j++){
             SUB *Sdata = data.sec_title[j];
             [_typeData addObject:@"2"];
             [_TitleData addObject:Sdata.title];
             [_idData addObject:Sdata.id];
             [_typeJsonData addObject:data.type];
        }
    }

    [self.mTable reloadData];
}

-(void)getReCom{
    //第一步，创建URL
    NSURL *url = [NSURL URLWithString:@"https://leancloud.cn:443/1.1/classes/reCom"];
    //第二步，创建请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    
    //head
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"wwjrmH5VlIPlKcR8dqWJ2NS2-gzGzoHsz" forHTTPHeaderField:@"X-LC-Id"];
    [request addValue:@"1QFf6nYQq9f45jwVp9LRK55w" forHTTPHeaderField:@"X-LC-Key"];
    //设置请求方式为POST，默认为GET
    [request setHTTPMethod:@"GET"];
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSString *jsonString = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
    
    reComItem *re = [[reComItem alloc] initWithString:jsonString error:nil];
    for(int i = 0 ; i < re.results.count; i += 1){
        REsults *data = re.results[i];
        
        if([data.isReCome boolValue]){
            [_reCom_Title addObject:data.title];
            [_reCom_string addObject:data.stringL];
        }
    }
    
    NSString * language = [[NSLocale preferredLanguages] firstObject];
    if( [self getloc:language]){
    [self getPrivacyPolic];
    }
}

-(void)getPrivacyPolic{
    if([ud boolForKey:@"isFast"]){
        if(_reCom_Title.count < 1){
            
        }else {
            OverWebViewController * ow = [[OverWebViewController alloc] init];
            [self presentViewController:ow animated:YES completion:^{
                for(int i = 0; i < _reCom_Title.count ; i++){
                    DiscussAccordingObject *DAo = [[DiscussAccordingObject alloc] init];
                    [DAo setAccordingTitle:_reCom_Title[i]];
                    [DAo setAccordingUrl:_reCom_string[i]];
                    [ow loadTitleUrlWithAbbs:nil accordingObj:DAo];
                }
            }];
        }
    }
    [ud setBool:false forKey:@"isFast"];
}

-(bool *)getloc:(NSString *)language{
    NSLog(@"language: %@",  language);
    //第一步，创建URL
    NSString *temp = @"http://47.75.131.189/proof_code/?code=";
    temp = [temp stringByAppendingString:language];
    NSURL *url = [NSURL URLWithString:temp];
    //第二步，创建请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    //设置请求方式为POST，默认为GET
    [request setHTTPMethod:@"GET"];
    //第三步，连接服务器
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSString *jsonString = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
    
    //将字符串写到缓冲区。
    NSData* jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    //解析json数据，使用系统方法 JSONObjectWithData:  options: error:
    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
    
    bool *rateDic = [[dic objectForKey:@"status"] boolValue];
    
    return rateDic;
}


-(void)initTable{
    self.mTable.dataSource = self;
    self.mTable.delegate =  self;
    [self.mTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self getTitleJson];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _TitleData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(_typeData[indexPath.row] == @"1"){
        healthCell_title *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_title"];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [cell.titleLable setText:[_TitleData objectAtIndex:indexPath.row]];
        
        return cell;
    } else {
        
        healthCell_subTitle *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_subTitle"];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [cell.subLable setText:[_TitleData objectAtIndex:indexPath.row]];
        
        cell.subButtom .tag = indexPath.row;
        [cell.subButtom addTarget:self action:@selector(onClicked:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (IBAction)onClicked:(UIButton *)sender{
    _subId = [_idData objectAtIndex:sender.tag];
    _typeId = [_typeJsonData objectAtIndex:sender.tag];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"HP2"]) {
        
        getHealthP2ViewController *view2 = segue.destinationViewController;
        //the destination is View 2
        view2.subId = _subId;
        view2.typeId = _typeId;
    }
}

- (void) TabHButtonClicked:(id)sender {
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"bmi" bundle:[NSBundle mainBundle]];
    getHealthViewController *controllerD = [storyboard instantiateViewControllerWithIdentifier:@"Bmi"];
    [self.navigationController pushViewController:controllerD animated:YES];
}

- (void) TabCButtonClicked:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"注意"
                                                                             message:@"留言板需要额外注册一个帐号,你可以在之后和本APP会员帐号做绑定"
                                                                      preferredStyle:UIAlertControllerStyleAlert ];
    //添加确定到UIAlertController中
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:cancelAction];
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        SendBirdTools *sbt = [SendBirdTools getInstanceWithSendBirdAppId:
                              @"567BB94B-DB70-4522-95EF-D018B69A338D"];
        UserInfoObject *us = [sbt getUserInfo];
        if(![us.userEmail isEqual:@""]){
            [sbt queryDiscussFromVc:self sendBirdOpenChannelUrl:@"post" sendBirdRepostOpenChannelUrl:@"repost" sendBirdLikeOpenChannelUrl:@"like" userInfo:us customQueryDiscussVC:nil accordingClickCallback:nil];
        } else {
            [sbt loginAccountFromSendBirdOpenChannelUrl:@"login" customLoginVC:nil loginCallback:^(UserInfoObject * us) {
                [sbt queryDiscussFromVc:self sendBirdOpenChannelUrl:@"post" sendBirdRepostOpenChannelUrl:@"repost" sendBirdLikeOpenChannelUrl:@"like" userInfo:us customQueryDiscussVC:nil accordingClickCallback:nil];
            }];
        }
        
    }];
    [alertController addAction:OKAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void) TabMButtonClicked:(id)sender {
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"userCenter" bundle:[NSBundle mainBundle]];
    getHealthViewController *controllerD = [storyboard instantiateViewControllerWithIdentifier:@"userCenter"];
    [self.navigationController pushViewController:controllerD animated:YES];
}
@end
