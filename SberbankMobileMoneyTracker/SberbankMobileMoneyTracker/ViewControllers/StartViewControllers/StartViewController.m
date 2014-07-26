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
#import "CalendarView.h"
#import "MainViewNavigation.h"

@interface StartViewController () <MainViewNavigationDelegat>

@property (nonatomic) CirclesView *circlesView;
@property (nonatomic) Circle *circleButton;
@property (nonatomic) CalendarView *calendar;

@end

@implementation StartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.circlesView = [[CirclesView alloc] initWithValues:@[@(10), @(20), @(40), @(5)] andFrame:CGRectMake(0, 122, 320, 285)];
    [self.view addSubview:self.circlesView];
    
    self.circleButton = [[Circle alloc] initWithRadius:40 andCenter:CGPointMake(self.view.frame.size.width / 2, 482)];
    self.circleButton.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.circleButton];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_add_new_transaction"]];
    imgView.frame = self.circleButton.bounds;
    [self.circleButton addSubview:imgView];
    self.circleButton.color = [UIColor colorWithHexString:@"555555"];
    [self.circleButton addTarget:self action:@selector(buttonClicked)];
    
    MainViewNavigation *mainNavigation = [[MainViewNavigation alloc] initWithTitles:@[@"Year", @"Month", @"Week", @"Day"] selectedIndex:0 andDelegat:self];
    [self.view insertSubview:mainNavigation atIndex:0];
}

- (void)buttonClicked
{
    /*[self.circlesView removeFromSuperview];
    
    self.circlesView = [[CirclesView alloc] initWithValues:@[@(10), @(20), @(40), @(5)] andFrame:CGRectMake(0, 122, 320, 285)];
    [self.view addSubview:self.circlesView];*/
}

- (void)mainNavigation:(MainViewNavigation *)mainNavigation scrollToIndex:(NSInteger)index
{
    NSMutableArray *valuesArray = [NSMutableArray array];
    for (NSInteger index = 0; index < 7; index ++)
    {
        NSMutableArray *values = [NSMutableArray array];
        for (NSInteger index = 0; index < 4; index ++) {
            [values addObject:@(arc4random() % 100)];
        }
        
        [valuesArray addObject:values];
    }
    
    if (index > 2 && self.calendar) {
        [UIView animateWithDuration:0.3 animations:^{
            self.calendar.center = CGPointMake(self.view.center.x - 320, self.view.center.y - 100);
        } completion:^(BOOL finished) {
            [self.calendar removeFromSuperview];
            self.calendar = nil;
        }];
    }
    
    if (index == 3) {
        [self.circlesView removeFromSuperview];
        
        self.circlesView = [[CirclesView alloc] initWithValues:@[@(10), @(20), @(40), @(5)] andFrame:CGRectMake(0, 122, 320, 285)];
        
        [self.view addSubview:self.circlesView];
    } else {
        if (self.circlesView) {
            [UIView animateWithDuration:0.3 animations:^{
                self.circlesView.center = CGPointMake(self.view.center.x + 320, self.circlesView.center.y);
            } completion:^(BOOL finished) {
                [self.circlesView removeFromSuperview];
                self.circlesView = nil;
            }];
        }
    }
    
    if (index <= 2 && !self.calendar) {
        self.calendar = [[CalendarView alloc] initWithDays:@[@(10), @(11), @(12), @(13), @(14), @(15), @(16)] andArrayOfValues:valuesArray];
        self.calendar.center = CGPointMake(self.view.center.x - 320, self.view.center.y - 100);
        [self.view addSubview:self.calendar];
        
        [UIView animateWithDuration:0.3 animations:^{
            self.calendar.center = CGPointMake(self.view.center.x, self.view.center.y - 100);
        }];
    }
}

@end
