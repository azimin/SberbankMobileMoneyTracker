//
//  StartViewController.m
//  SberbankMobileMoneyTracker
//
//  Created by Alex Zimin on 26/07/14.
//  Copyright (c) 2014 Empatika. All rights reserved.
//

#import "StartViewController.h"
#import "CirclesView.h"
#import "Circle.h"

@interface StartViewController ()

@property (nonatomic) CirclesView *circlesView;

@end

@implementation StartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.circlesView removeFromSuperview];
    
    self.circlesView = [[CirclesView alloc] initWithValues:@[@(10), @(20), @(40), @(5)] andFrame:CGRectMake(0, 122, 320, 285)];
    [self.view addSubview:self.circlesView];
    
    Circle *circle = [[Circle alloc] initWithRadius:40 andCenter:CGPointMake(self.view.frame.size.width / 2, 482)];
    circle.backgroundColor = [UIColor clearColor];
    [self.view addSubview:circle];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_add_new_transaction"]];
    imgView.frame = circle.bounds;
    [circle addSubview:imgView];
    circle.color = [UIColor colorWithHexString:@"555555"];
    [circle addTarget:self action:@selector(buttonClicked)];
}

- (void)buttonClicked
{
    NSLog(@"Swag");
}

@end
