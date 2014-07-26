//
//  StatisticViewController.m
//  SberbankMobileMoneyTracker
//
//  Created by Alex Zimin on 26/07/14.
//  Copyright (c) 2014 Empatika. All rights reserved.
//

#import "StatisticViewController.h"
#import "Circle.h"
#import "CalendarView.h"

#import "CoreDataManager.h"

@interface StatisticViewController ()

@property (nonatomic) Circle *circle;

@end

@implementation StatisticViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.circle  = [[Circle alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    self.circle.backgroundColor = [UIColor colorWithHexString:@"ca4e4e"];
    
    /*CalendarCell *cell = [[CalendarCell alloc] initWithDayString:@"12" andValues:@[@(10), @(20), @(12), @(5)]];
    cell.center = CGPointMake(100, 150);
    [self.view addSubview:cell];
    
    cell = [[CalendarCell alloc] initWithDayString:@"13" andValues:@[@(40), @(20), @(12), @(15)]];
    cell.center = CGPointMake(140, 150);
    [self.view addSubview:cell];*/
    NSMutableArray *valuesArray = [NSMutableArray array];
    for (NSInteger index = 0; index < 7; index ++)
    {
        NSMutableArray *values = [NSMutableArray array];
        for (NSInteger index = 0; index < 4; index ++) {
            [values addObject:@(arc4random() % 100)];
        }
        
        [valuesArray addObject:values];
    }
    
    CalendarView *calendar = [[CalendarView alloc] initWithDays:@[@(10), @(11), @(12), @(13), @(14), @(15), @(16)] andArrayOfValues:valuesArray];
    calendar.center = CGPointMake(calendar.center.x, calendar.center.y + 100);
    [self.view addSubview:calendar];
    
    //[self.view addSubview:self.circle];
    
    [self performSelector:@selector(animationGo) withObject:nil afterDelay:1.0];
    
    [[CoreDataManager sharedInstance] addExpenses:15.f toCategory:@"Home" atDate:[NSDate date]];
    NSArray *statistic = [[CoreDataManager sharedInstance] fetchExpensesStatistic];
}

- (void)animationGo
{
    [self.circle changeRadius:60 withDuration:0.6 andBounce:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
