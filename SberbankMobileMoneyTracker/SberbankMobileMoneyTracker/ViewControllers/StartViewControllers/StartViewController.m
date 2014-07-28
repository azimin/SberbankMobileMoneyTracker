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
#import "NewExpenseViewController.h"
#import "ExpenseViewController.h"

@interface StartViewController () <MainViewNavigationDelegat, CirclesViewDelegat, CalendarViewDelegat>

@property (nonatomic) CirclesView *circlesView;
@property (nonatomic) Circle *circleButton;
@property (nonatomic) CalendarView *calendar;
@property (nonatomic) CirclesView *calendarCirclesView;

@property (nonatomic) NSArray *currentViewValues;
@property (nonatomic) NSArray *currentViewInfos;

@property (nonatomic) NSInteger currentIndex;

@property (nonatomic) BOOL isColorTableOpen;
@property (nonatomic) BOOL shouldLoadBubbles;

@end

@implementation StartViewController

- (void)viewWillAppear:(BOOL)animated
{
    if (self.currentIndex == 1) {
        [self updateData];
    }
}

- (void)viewDidLoad {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDataBase) name:@"UpdateBase" object:nil];
    
    [super viewDidLoad];
    self.currentViewValues = @[@(0), @(0), @(0), @(0)];
    
    MainViewNavigation *mainNavigation = [[MainViewNavigation alloc] initWithTitles:@[@"Week", @"Day"] selectedIndex:0 andDelegat:self];
    [self.view insertSubview:mainNavigation atIndex:0];
    
    [self updateDataBase];
}

- (void)updateDataBase
{
    self.shouldLoadBubbles = false;
    [[MoneyTrackerServerManager sharedInstance] fetchAllStatisticWithSuccess:^(NSArray *resultStatistic) {
        self.shouldLoadBubbles = true;
        [self updateData];
        [self updateCirclesViewOnThisView];
    } failure:^(NSError *error) {
        self.shouldLoadBubbles = true;
    }];
}

- (void)updateData
{
    NSArray *arr = [[CoreDataManager sharedInstance].expensesWithDayMove objectForKey:@(0)];
    if (arr) {
        NSArray *sArr = [[CoreDataManager sharedInstance] sortDictsByNameWithDefaultKeys:arr];
        NSMutableArray *mArr = [NSMutableArray array];
        for (NSDictionary *dic in sArr) {
            [mArr addObject:@([[dic objectForKey:@"value"] floatValue])];
        }
        
        self.currentViewInfos = sArr;
        self.currentViewValues = mArr;
    }
    
    [self updateCirclesViewOnThisView];
}

- (void)updateCirclesViewOnThisView
{
    if ( !self.shouldLoadBubbles ) {
        return;
    }
    
    [self.circlesView removeFromSuperview];
    self.circlesView = [[CirclesView alloc] initWithValues:self.currentViewValues andFrame:CGRectMake(0, 122, 320, 285)];
    self.circlesView.delegate = self;
    [self.view addSubview:self.circlesView];
}

- (void)buttonClicked
{
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    effectView.frame = [UIScreen mainScreen].bounds;
    effectView.userInteractionEnabled = false;
    [self.view addSubview:effectView];
    
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 0);
    [self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:YES];
    [self.view addSubview:effectView];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    [effectView removeFromSuperview];
    UIGraphicsEndImageContext();
    
    NewExpenseViewController *newExpenseViewController = [[NewExpenseViewController alloc] initWithNibName:@"NewExpenseViewController" bundle:nil];
    newExpenseViewController.backgroundImage = image;
    [self presentViewController:newExpenseViewController animated:YES completion:nil];
}

- (void)createCircleButton
{
    self.circleButton = [[Circle alloc] initWithRadius:40 andCenter:CGPointMake(self.view.frame.size.width / 2, 482)];
    self.circleButton.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.circleButton];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_add_new_transaction"]];
    imgView.frame = self.circleButton.bounds;
    [self.circleButton addSubview:imgView];
    self.circleButton.color = [UIColor colorWithHexString:@"555555"];
    [self.circleButton addTarget:self action:@selector(buttonClicked)];
}

- (void)mainNavigation:(MainViewNavigation *)mainNavigation scrollToIndex:(NSInteger)index
{
    BOOL comeFromLeft = true;
    if (self.currentIndex > index)
        comeFromLeft = false;
    
    self.currentIndex = index;
    
    NSMutableArray *valuesArray = [NSMutableArray array];
    for (NSInteger index = 0; index < 7; index ++)
    {
        NSMutableArray *values = [NSMutableArray array];
        for (NSInteger index = 0; index < 4; index ++) {
            [values addObject:@(arc4random() % 100)];
        }
        
        [valuesArray addObject:values];
    }
    
    if (index != 0 && self.calendar) {
        
        [self.calendarCirclesView removeFromSuperview];
        
        CGFloat directipn = 1;
        if (comeFromLeft) {
            directipn = -1;
        }
        [UIView animateWithDuration:0.3 animations:^{
            self.calendar.center = CGPointMake(self.view.center.x + directipn * 320, self.view.center.y - 100);
        } completion:^(BOOL finished) {
            [self.calendar removeFromSuperview];
            self.calendar = nil;
        }];
    }
    
    if (index == 1) {
        
       
        
        [self.circleButton removeFromSuperview];
        
        [self createCircleButton];
        
        [self updateData];
        
        self.circleButton.center = CGPointMake(self.view.center.x, self.view.frame.size.height + 100);
        [UIView animateWithDuration:0.2 animations:^{
            self.circleButton.center = CGPointMake(self.view.center.x, self.view.frame.size.height - 70);
        }];
        
    } else if (index == 0) {
        if (self.circlesView) {
            
            [UIView animateWithDuration:0.2 animations:^{
                self.circlesView.center = CGPointMake(self.view.center.x + 320, self.circlesView.center.y);
                self.circleButton.center = CGPointMake(self.view.center.x, self.view.frame.size.height + 100);
            } completion:^(BOOL finished) {
                if ( self.currentIndex != 3 ) {
                    [self.circlesView removeFromSuperview];
                    self.circlesView = nil;
                    [self.circleButton removeFromSuperview];
                    self.circleButton = nil;
                }
                
            }];
        }
    }
    
    if (index == 0 && !self.calendar) {
        
        CGFloat directipn = 1;
        if (comeFromLeft) {
            directipn = -1;
        }
        
        
        self.calendar = [[CalendarView alloc] initWithDays:@[@(27), @(28), @(29), @(30), @(31), @(1), @(2)] andArrayOfValues:valuesArray];
        self.calendar.delegate = self;
        self.calendar.center = CGPointMake(self.view.center.x - directipn * 320, self.view.center.y - 100);
        [self.view addSubview:self.calendar];
        
        [UIView animateWithDuration:0.3 animations:^{
            self.calendar.center = CGPointMake(self.view.center.x, self.view.center.y - 100);
        }];
    }
}

#pragma mark - Circle View Delegat

- (void)circlesView:(CirclesView *)circlesView didSelectCircle:(Circle *)circle
{
    Circle *newCircle = [circle copy];
    
    if (circlesView.tagPlus == 10) {
        newCircle.center = CGPointMake(newCircle.center.x, newCircle.center.y + [UIScreen mainScreen].bounds.size.height - 280);
        [self.view addSubview:newCircle];
    } else {
        [self.circlesView addSubview:newCircle];
    }
    
    newCircle.layer.zPosition = 1.1;
    [newCircle removeText];
    [newCircle changeRadius:600 withDuration:0.6 andBounce:YES];
    [self performSelector:@selector(openTableWithCircleView:) withObject:newCircle afterDelay:0.3];
    self.isColorTableOpen = TRUE;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)openTableWithCircleView:(Circle*)circle
{
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 0);
    [self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    ExpenseViewController *newExpenseViewController = [[ExpenseViewController alloc] initWithNibName:@"ExpenseViewController" bundle:nil];
    newExpenseViewController.bgImage = image;
    if (self.currentViewInfos.count > circle.tagPlus && self.currentViewInfos[circle.tagPlus][@"expenses"]) {
        newExpenseViewController.infos = self.currentViewInfos[circle.tagPlus][@"expenses"];
    }
    [self presentViewController:newExpenseViewController animated:NO completion:^{
        [circle removeFromSuperview];
        self.isColorTableOpen = FALSE;
        [self setNeedsStatusBarAppearanceUpdate];
    }];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    if ( self.isColorTableOpen ) {
        return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleDefault;
}


#pragma mark - CalendarViewDelegat

- (void)changeDownCirclesWithValues:(NSArray*)values andInfos:(NSArray*)infos {
    if ( !values ) {
        values = self.currentViewValues;
    }
    
    if ( !infos ) {
        infos = self.currentViewInfos;
    } else {
        self.currentViewInfos = infos;
    }
    
    if ( infos.count != 4 ) {
        infos = @[@[], @[], @[], @[]];
    }
    
    [self.calendarCirclesView removeFromSuperview];
    self.calendarCirclesView = [[CirclesView alloc] initWithValues:values andFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 280, 320, 260)];
    self.calendarCirclesView.delegate = self;
    self.calendarCirclesView.tagPlus = 10;
    [self.view addSubview:self.calendarCirclesView];
}


@end
