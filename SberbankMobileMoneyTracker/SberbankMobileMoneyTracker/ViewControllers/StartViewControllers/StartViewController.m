//
//  StartViewController.m
//  SberbankMobileMoneyTracker
//
//  Created by Alex Zimin on 26/07/14.
//  Copyright (c) 2014 Empatika. All rights reserved.
//

#import "StartViewController.h"
#import "CirclesView.h"

@interface StartViewController ()

@property (nonatomic) CirclesView *circlesView;

@end

@implementation StartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.circlesView removeFromSuperview];
    
    self.circlesView = [[CirclesView alloc] initWithValues:@[@(10), @(20), @(40), @(5)] andFrame:CGRectMake(0, 122, 320, 285)];
    [self.view addSubview:self.circlesView];
}

@end
