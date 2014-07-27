//
//  CalendarView.m
//  SberbankMobileMoneyTracker
//
//  Created by Alex Zimin on 26/07/14.
//  Copyright (c) 2014 Empatika. All rights reserved.
//

#import "CalendarView.h"
#import "CalendarCell.h"
#import "CirclesView.h"
#import "InfiniteScrollView.h"

@interface CalendarView () <CalendarCellDelegat, InfiniteScrollViewDataSource>

@property (nonatomic) UIImageView *triangleIndicator;
@property (nonatomic) NSArray *cellsArray;
@property (nonatomic) InfiniteScrollView *infiniteScrollView;

@end

@implementation CalendarView

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:CalendarView.calendarFrame];
    
    if (self) {
        self.numbers = @[];
        self.arrayOfValues = @[];
        self.selectedIndex = 0;
        
        [self commonInit];
    }
    
    return self;
}

- (instancetype)initWithDays: (NSArray*)numbers
            andArrayOfValues: (NSArray*)arrayOfValues
{
    self = [super initWithFrame:CalendarView.calendarFrame];
    
    if (self) {
        self.numbers = numbers;
        self.arrayOfValues = arrayOfValues;
        self.selectedIndex = 0;
        
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit
{
    self.infiniteScrollView = [[InfiniteScrollView alloc] initWithVisibleView:[self calendarCellsViewWithDates:self.numbers] dataSource:self];
 //   self.infiniteScrollView.contentOffset = CGPointMake(self.infiniteScrollView.contentOffset.x + 320, self.infiniteScrollView.contentOffset.y);
    [self addSubview:self.infiniteScrollView];
    //[self addSubview:[self calendarCellsView]];
    
    self.triangleIndicator = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"img_calendar_selected_triangle"] imageWithOverlayColor:[UIColor mainGreyColor]]];
    self.triangleIndicator.frame = CGRectMake(0, 200, 28, 14);
    [self addSubview:self.triangleIndicator];
    
    UIView *seperator = [[UIView alloc] initWithFrame:CGRectMake(0, 200, 320, 1)];
    seperator.backgroundColor = [UIColor mainGreyColor];
    [self addSubview:seperator];
    
    [self infiniteScrollView:self.infiniteScrollView presentView:self.infiniteScrollView.currentView];
    self.selectedIndex = 0;
}

- (UIView*)calendarCellsViewWithDates:(NSArray*)dates
{
    UIView *calendarCellsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
    calendarCellsView.dates = dates;
    
    NSMutableArray *cells = [NSMutableArray array];
    
    NSMutableArray *valuesArray = [NSMutableArray array];
    for (NSInteger index = 0; index < 7; index ++)
    {
        NSMutableArray *values = [NSMutableArray array];
        for (NSInteger index = 0; index < 4; index ++) {
            [values addObject:@(arc4random() % 100)];
        }
        
        if (index == 5) {
            [valuesArray addObject:@[]];
        } else {
            [valuesArray addObject:values];
        }
        
        
    }
    self.arrayOfValues = valuesArray;
    
    for (NSInteger index = 0; index < 7; index ++) {
        NSArray *values = @[];
        NSString *day = @"-";
        
        if (index < self.arrayOfValues.count) {
            values = self.arrayOfValues[index];
        }
        
        if (index < dates.count) {
            day = [dates[index] stringValue];
        }
        
        CalendarCell *cell = [[CalendarCell alloc] initWithDayString:day andValues:values];
        cell.tagPlus = index;
        cell.delegate = self;
        cell.center = CGPointMake(23 + 45 * index, cell.frame.size.height / 2);
        [calendarCellsView addSubview:cell];
        [cells addObject:cell];
        
        if (index == 6) {
            continue;
        }
        
        if (index == 0) {
        //    [cell selectCell:nil];
        }
        
        UIView *seperator = [[UIView alloc] initWithFrame:CGRectMake(cell.frame.origin.x + cell.frame.size.width, 36, 1, cell.frame.size.height - 36)];
        seperator.backgroundColor = [UIColor mainGreyColor];
        [calendarCellsView addSubview:seperator];
    }
    
    self.cellsArray = cells;
    return calendarCellsView;
}

- (void)setDelegate:(id<CalendarViewDelegat>)delegate
{
    _delegate = delegate;
    [self.delegate changeDownCirclesWithValues:self.arrayOfValues[self.selectedIndex]];
}

#pragma mark - Getters

+ (CGRect)calendarFrame
{
    return CGRectMake(0, 0, 320, 195);
}

#pragma mark - Setters

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    
    if ( self.cellsArray.count > selectedIndex ) {
        UIView *cell = self.cellsArray[selectedIndex];
        [self scrollTriagnleToSelecetedCellWidth:cell.center.x WithAnimation:YES];
    }
}

#pragma mark - CalendarCellDelegat

- (void)calendarCellDidSelect:(CalendarCell *)calendarCell
{
    self.selectedIndex = calendarCell.tagPlus;
    [self.delegate changeDownCirclesWithValues:self.arrayOfValues[calendarCell.tagPlus]];
}

#pragma mark - Animation

- (void)scrollTriagnleToSelecetedCellWidth: (CGFloat)width
                             WithAnimation: (BOOL)animated
{
    CGFloat duration = (animated) ? 0.4 : 0.0;
    CGFloat triangleIndicatorHeightPosition = self.triangleIndicator.center.y;
    CGFloat triangleIndicatorWidthPosition = self.triangleIndicator.center.x;
    CGFloat delta = (triangleIndicatorWidthPosition - width) / 10;
    self.triangleIndicator.center = CGPointMake(width, triangleIndicatorHeightPosition);
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:duration];
    [CATransaction setAnimationTimingFunction:[[CAMediaTimingFunction alloc] initWithControlPoints:0.4 :0.0 :0.2 :1.0]];
    
    CAKeyframeAnimation *boundsOvershootAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(triangleIndicatorWidthPosition,
                                  triangleIndicatorHeightPosition)];
    [path addLineToPoint:CGPointMake(width + delta * 2,
                                     triangleIndicatorHeightPosition)];
    [path addLineToPoint:CGPointMake(width - delta,
                                     triangleIndicatorHeightPosition)];
    [path addLineToPoint:CGPointMake(width,
                                     triangleIndicatorHeightPosition)];
    
    boundsOvershootAnimation.path = path.CGPath;
    
    NSArray *times = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0f],
                      [NSNumber numberWithFloat:0.5f],
                      [NSNumber numberWithFloat:0.9f],
                      [NSNumber numberWithFloat:1.0f], nil];
    [boundsOvershootAnimation setKeyTimes:times];
    
    
    NSArray *timingFunctions = [NSArray arrayWithObjects:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                nil];
    [boundsOvershootAnimation setTimingFunctions:timingFunctions];
    boundsOvershootAnimation.fillMode = kCAFillModeForwards;
    boundsOvershootAnimation.removedOnCompletion = NO;
    
    [self.triangleIndicator.layer addAnimation:boundsOvershootAnimation forKey:boundsOvershootAnimation.keyPath];
    
    [CATransaction commit];
}

- (UIView *)infiniteScrollView:(InfiniteScrollView *)scrollView loadNextViewAfterView:(UIView *)currentView
{
    return [self calendarCellsViewWithDates:[self calculateDatesAfter:currentView.dates]];
}

- (UIView *)infiniteScrollView:(InfiniteScrollView *)scrollView loadPreviousViewAfterView:(UIView *)currentView
{
    UIView *vi = [self calendarCellsViewWithDates:[self calculateDatesBefore:currentView.dates]];
    NSLog(@"%@", vi.dates);
    return vi;
}

- (void)infiniteScrollView:(InfiniteScrollView *)scrollView presentView:(UIView *)currentView
{
    for (UIView *vi in currentView.subviews) {
        if ([vi isKindOfClass:[CalendarCell class]]) {
            CalendarCell *cell = (CalendarCell*)vi;
            if (cell.tagPlus == 0) {
                [cell selectCell:nil];
                return;
            }
            
        }
    }
}

- (NSArray*)calculateDatesBefore:(NSArray*)dates
{
    NSMutableArray *arr = [NSMutableArray array];
    NSInteger firstDate = [dates[0] intValue];
    for (int i = 0; i < 7; i++) {
        if (firstDate - i - 1 < 1) {
            [arr insertObject:@(30 + firstDate - i - 1) atIndex:0];
        } else {
            [arr insertObject:@(firstDate - i - 1) atIndex:0];
        }
    }
    
    return arr;
}

- (NSArray*)calculateDatesAfter:(NSArray*)dates
{
    NSMutableArray *arr = [NSMutableArray array];
    NSInteger lastDate = [dates.lastObject intValue];
    for (int i = 0; i < 7; i++) {
        if (lastDate + i + 1 > 30) {
            [arr addObject:@(lastDate + i + 1 - 30)];
        } else {
            [arr addObject:@(lastDate + i + 1)];
        }
    }
    
    return arr;
}


@end
