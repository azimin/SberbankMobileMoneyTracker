//
//  TodayViewController.m
//  SberbankMobileMoneyTrackerToday
//
//  Created by Alex Zimin on 27/07/14.
//  Copyright (c) 2014 Empatika. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "CirclesView.h"

@interface TodayViewController () <NCWidgetProviding>

@property (nonatomic) CirclesView *circlesView;

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.preferredContentSize = CGSizeMake(320, 300);
    
    
    [self widgetPerformUpdateWithCompletionHandler:^(NCUpdateResult result) {
        self.circlesView = [[CirclesView alloc] initWithValues:@[@(8314), @(13662), @(28231), @(13034)] andFrame:CGRectMake(-20, -10, 280, 285)];
        self.circlesView.userInteractionEnabled = false;
        // self.circlesView.delegate = self;
        [self.view addSubview:self.circlesView];
        // Do any additional setup after loading the view from its nib.
        UIButton *but = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
        [but addTarget:self action:@selector(showAnimation:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:but];
        
    }];
}

- (IBAction)showAnimation:(id)sender {
    [self.circlesView removeFromSuperview];
    self.circlesView = [[CirclesView alloc] initWithValues:@[@(10), @(20), @(40), @(5)] andFrame:CGRectMake(-20, -10, 280, 285)];
    self.circlesView.userInteractionEnabled = false;
    // self.circlesView.delegate = self;
    [self.view addSubview:self.circlesView];
    
    NSString *stringURL = @"sberbank://today";
    NSURL *url = [NSURL URLWithString:stringURL];
    
    [self.extensionContext openURL:url completionHandler:^(BOOL success) {
        NSLog(@"Swan");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    completionHandler(NCUpdateResultNewData);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

@end
