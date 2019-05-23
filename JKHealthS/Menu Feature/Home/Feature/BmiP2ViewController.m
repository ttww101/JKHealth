//
//  BmiP2ViewController.m
//  JKHealth
//
//  Created by Apple on 2019/4/23.
//  Copyright © 2019 whitelok.com. All rights reserved.
//

#import "BmiP2ViewController.h"
#import "BmiTableViewCell.h"

@interface BmiP2ViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableD;

@end

NSString *timeL;
NSMutableArray *DATA_B;
NSMutableArray *DATA_D;
NSUserDefaults *ud;

@implementation BmiP2ViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    ud = [NSUserDefaults standardUserDefaults];
    
    if ([ud arrayForKey:@"DATA_D"] && [ud arrayForKey:@"DATA_B"]) {
        DATA_D = [[ud arrayForKey:@"DATA_D"] mutableCopy];
        DATA_B = [[ud arrayForKey:@"DATA_B"] mutableCopy];
    } else {
        DATA_B = [[NSMutableArray alloc]init];
        DATA_D = [[NSMutableArray alloc]init];
    }
    
    [self getTime];
}

-(void)initTable{
    self.tableD.dataSource = self;
    self.tableD.delegate =  self;
    [self.tableD setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

-(void) getTime{
    NSDate  *currentDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate];
    
    NSInteger year=[components year];
    NSInteger month=[components month];
    NSInteger day=[components day];
    timeL = [[NSString alloc] initWithFormat:@"%ld", year];
    timeL = [timeL stringByAppendingString:@"/"];
    timeL = [timeL stringByAppendingString:[[NSString alloc] initWithFormat:@"%ld", month]];
    timeL = [timeL stringByAppendingString:@"/"];
    timeL = [timeL stringByAppendingString:[[NSString alloc] initWithFormat:@"%ld", day]];
    
    [self getData];
}

-(void) getData{
    if(_bmi != nil){
        [DATA_D addObject:timeL];
        [DATA_B addObject:_bmi];
        NSLog(@"DATA: %@ %@",DATA_D, DATA_B);
        [ud setObject:DATA_D forKey:@"DATA_D"];
        [ud setObject:DATA_B forKey:@"DATA_B"];
        [ud synchronize];
    }
    
    [self initTable];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return DATA_D.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BmiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bmiCell"];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [cell.dateL setText:[DATA_D objectAtIndex:indexPath.row]];
    [cell.bmiL setText:[DATA_B objectAtIndex:indexPath.row]];

    return cell;
}


@end
