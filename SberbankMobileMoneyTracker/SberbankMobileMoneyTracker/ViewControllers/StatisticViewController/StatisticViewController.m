//
//  StatisticViewController.m
//  SberbankMobileMoneyTracker
//
//  Created by Alex Zimin on 26/07/14.
//  Copyright (c) 2014 Empatika. All rights reserved.
//

#import "StatisticViewController.h"
#import "Circle.h"

@interface StatisticViewController ()

@property (nonatomic) Circle *circle;

@end

@implementation StatisticViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.circle = [[Circle alloc] initWithRadius: 40
                                          andCenter: CGPointMake(100, 100)];
    self.circle.backgroundColor = [UIColor colorWithHexString:@"ca4e4e"];
    
    [self.view addSubview:self.circle];
    
    [self performSelector:@selector(animationGo) withObject:nil afterDelay:1.0];
}

- (void)animationGo
{
    [self.circle changeRadius:60 withDuration:0.6 andBounce:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
