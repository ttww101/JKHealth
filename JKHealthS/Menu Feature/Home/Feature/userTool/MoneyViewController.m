//
//  MoneyViewController.m
//  iHealthS
//
//  Created by Apple on 2019/4/8.
//  Copyright © 2019 whitelok.com. All rights reserved.
//

#import "MoneyViewController.h"
#import "IGLDropDownMenu.h"
#import <QuartzCore/QuartzCore.h>

@interface MoneyViewController () <IGLDropDownMenuDelegate,UITextFieldDelegate>
@property (nonatomic, copy) NSArray *dataArray;
@property (nonatomic, strong) IGLDropDownMenu *dropDownMenu;
@property (nonatomic, strong) IGLDropDownMenu *dropDownMenu2;
@property (weak, nonatomic) IBOutlet UITextField *numText;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;
@property (weak, nonatomic) IBOutlet UILabel *dataL;

@end

NSString *tab1;
NSString *tab2;
NSString *num;
NSString *from;
NSString *to;
NSString *date;
NSString *rate;

@implementation MoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"匯率換算";
    
    self.numText.delegate = self;

    
    self.okBtn.layer.borderColor = [[UIColor blackColor] CGColor];
    self.okBtn.layer.borderWidth = 2;
    self.okBtn.layer.borderWidth=1.0f;
    self.okBtn.layer.borderColor=[[UIColor blackColor] CGColor];
    self.okBtn.layer.cornerRadius = 10;
    [self.okBtn addTarget:self
               action:@selector(handleButtonClicked:)
     forControlEvents:UIControlEventTouchUpInside
     ];
    
    self.dataArray = @[@{@"title":@"CNY 人民币"},
                       @{@"title":@"USD 美元"},
                       @{@"title":@"EUR 欧元"},
                       @{@"title":@"GBP 英镑"},
                       @{@"title":@"AUD 澳元"},
                       @{@"title":@"PY 日元"},
                       @{@"title":@"KRW 韩元"},
                       @{@"title":@"CAD 加拿大元"},
                       @{@"title":@"SGD 新加坡元"},
                       @{@"title":@"RUB 俄罗斯卢布"},
                       @{@"title":@"HKD 港币"},
                       @{@"title":@"TWD 新台币"}
                    ];
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    //建立資料
    NSMutableArray *dropdownItems = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.dataArray.count; i++) {
        NSDictionary *dict = self.dataArray[i];
        
        IGLDropDownItem *item = [[IGLDropDownItem alloc] init];
        [item setText:dict[@"title"]];
        [dropdownItems addObject:item];
    }
    
    //建立下拉選單
    self.dropDownMenu = [[IGLDropDownMenu alloc] init];
    self.dropDownMenu.menuText = @"from";
    self.dropDownMenu.paddingLeft = 15;  // padding left for the content of the button
    self.dropDownMenu.delegate = self;
    [self.dropDownMenu setFrame:CGRectMake(10, 80, 170, 45)];
    self.dropDownMenu.dropDownItems = dropdownItems;
    self.dropDownMenu.tag = 1;
    //額外參數
    self.dropDownMenu.type = IGLDropDownMenuTypeStack;
    self.dropDownMenu.gutterY = 5;
    self.dropDownMenu.itemAnimationDelay = 0.1;
    self.dropDownMenu.rotate = IGLDropDownMenuRotateRandom;

    [self.view addSubview:self.dropDownMenu];
    [self.dropDownMenu reloadView];
    
    //第二個元件
    //建立資料
    NSMutableArray *dropdownItems2 = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.dataArray.count; i++) {
        NSDictionary *dict = self.dataArray[i];
        
        IGLDropDownItem *item2 = [[IGLDropDownItem alloc] init];
        [item2 setText:dict[@"title"]];
        [dropdownItems2 addObject:item2];
    }
    
    //建立下拉選單
    self.dropDownMenu2 = [[IGLDropDownMenu alloc] init];
    self.dropDownMenu2.menuText = @"to";
    self.dropDownMenu2.paddingLeft = 15;  // padding left for the content of the button
    self.dropDownMenu2.delegate = self;
    [self.dropDownMenu2 setFrame:CGRectMake(screenSize.width - 180 , 80, 170, 45)];
    self.dropDownMenu2.dropDownItems = dropdownItems2;
    self.dropDownMenu2.tag = 2;

    //額外參數
    self.dropDownMenu2.type = IGLDropDownMenuTypeStack;
    self.dropDownMenu2.gutterY = 5;
    self.dropDownMenu2.itemAnimationDelay = 0.1;
    self.dropDownMenu2.rotate = IGLDropDownMenuRotateRandom;
    
    [self.view addSubview:self.dropDownMenu2];
    [self.dropDownMenu2 reloadView];
}

#pragma mark - IGLDropDownMenuDelegate

- (void)dropDownMenu:(IGLDropDownMenu *)dropDownMenu selectedItemAtIndex:(NSInteger)index
{
    if (dropDownMenu.tag == 1) {
        IGLDropDownItem *item = dropDownMenu.dropDownItems[index];
        tab1 = item.text;
        from = [[NSString alloc] initWithString:tab1];
    } else {
        IGLDropDownItem *item = dropDownMenu.dropDownItems[index];
        tab2 = item.text;
        to = [[NSString alloc] initWithString:tab2];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return [self validateNumber:string];
}

// 開始進入編輯狀態
- (void) textFieldDidBeginEditing:(UITextField*)textField {
    NSLog(@"textFieldDidBeginEditing:%@",textField.text);
}

// 可能進入結束編輯狀態
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    NSLog(@"textFieldShouldEndEditing:%@",textField.text);
    return true;
}

// 結束編輯狀態(意指完成輸入或離開焦點)
- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"textFieldDidEndEditing:%@",textField.text);
}

// 按下Return後會反應的事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    //利用此方式讓按下Return後會Toogle 鍵盤讓它消失
    [textField resignFirstResponder];
    return false;
}

- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

- (void) handleButtonClicked:(id)sender {
    num = _numText.text;
    
    if(tab1 != nil && tab2 != nil && num != nil){

        [self startMoney];
    } else {
        self.dataL.text = @"请填写资料";
    }

}

-(void)startMoney{
    
    NSString *temp = [@"http://api.k780.com/?app=finance.rate&scur=" stringByAppendingString:[from substringToIndex:3]];
    temp = [temp stringByAppendingString:@"&tcur="];
    temp = [temp stringByAppendingString:[to substringToIndex:3]];
    temp = [temp stringByAppendingString:@"&appkey=10003&sign=b59bc3ef6191eb9f747dd4e83c99f2a4"];
    
    //第一步，创建URL
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

    NSDictionary* rateDic = [[dic objectForKey:@"result"] objectForKey:@"rate"];
    NSDictionary* updateDic = [[dic objectForKey:@"result"] objectForKey:@"update"];
    
    date = [NSString stringWithFormat:@"%@", updateDic];
    rate = [NSString stringWithFormat:@"%@", rateDic];
    
    [self showData];
}

-(void) showData{
    self.dataL.text = @"换算结果：\n\n\t";
    self.dataL.text = [self.dataL.text stringByAppendingString:@"日期时间："];
    self.dataL.text = [self.dataL.text stringByAppendingString:date];
    self.dataL.text = [self.dataL.text stringByAppendingString:@"\n\n\t"];
    self.dataL.text = [self.dataL.text stringByAppendingString:@"原始货币："];
    self.dataL.text = [self.dataL.text stringByAppendingString:from];
    self.dataL.text = [self.dataL.text stringByAppendingString:@"\n\n\t"];
    self.dataL.text = [self.dataL.text stringByAppendingString:@"兑换货币："];
    self.dataL.text = [self.dataL.text stringByAppendingString:to];
    self.dataL.text = [self.dataL.text stringByAppendingString:@"\n\n\t"];
    self.dataL.text = [self.dataL.text stringByAppendingString:@"兑换数量："];
    self.dataL.text = [self.dataL.text stringByAppendingString:num];
    self.dataL.text = [self.dataL.text stringByAppendingString:@"\n\n\t"];
    self.dataL.text = [self.dataL.text stringByAppendingString:@"当前汇率："];
    self.dataL.text = [self.dataL.text stringByAppendingString:rate];
    self.dataL.text = [self.dataL.text stringByAppendingString:@"\n\n\t"];
    self.dataL.text = [self.dataL.text stringByAppendingString:@"兑换结果："];
    float value1 = [num floatValue];
    float value2 = [rate floatValue];
    self.dataL.text = [self.dataL.text stringByAppendingString:[NSString stringWithFormat:@"%f", value1 * value2]];
}

@end
