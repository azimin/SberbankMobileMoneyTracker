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
@property (nonatomic) NSUInteger currentDayMove;

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
    self.currentDayMove = 0;
    self.infiniteScrollView = [[InfiniteScrollView alloc] initWithVisibleView:[self calendarCellsViewWithDates:self.numbers type:0] dataSource:self];
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

- (UIView*)calendarCellsViewWithDates: (NSArray*)dates
                                 type: (NSInteger)type
{
    NSInteger dayMove = self.currentDayMove;
    dayMove += (type == 1) ? 7 : (type == -1) ? -7 : 0;
    NSLog(@"%i", dayMove);
    UIView *calendarCellsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
    calendarCellsView.dates = dates;
    
    NSMutableArray *cells = [NSMutableArray array];
    
    
    for (NSInteger index = 0; index < 7; index ++) {
        NSArray *values = @[];
        NSString *day = @"-";
        
        NSArray *arr = [[CoreDataManager sharedInstance].expensesWithDayMove objectForKey:@(dayMove + index)];
        NSMutableArray *mArr = [NSMutableArray array];
        
        NSArray *sArr = [NSMutableArray array];
        
        if (arr) {
            sArr = [[CoreDataManager sharedInstance] sortDictsByNameWithDefaultKeys:arr];
            for (NSDictionary *dic in sArr) {
                [mArr addObject:@([[dic objectForKey:@"value"] floatValue])];
            }
        }
    
        values = mArr;
        
        if (index < dates.count) {
            day = [dates[index] stringValue];
        }
        
        CalendarCell *cell = [[CalendarCell alloc] initWithDayString:day andValues:values];
        cell.tagPlus = index;
        cell.delegate = self;
        cell.info = sArr;
        cell.center = CGPointMake(23 + 45 * index, cell.frame.size.height / 2);
        [calendarCellsView addSubview:cell];
        [cells addObject:cell];
        
        
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
    [self.delegate changeDownCirclesWithValues:nil andInfos:nil];
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
    [self.delegate changeDownCirclesWithValues:calendarCell.values andInfos:calendarCell.info];
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

BOOL firstNextAppear = TRUE;
BOOL firstPrevAppear = TRUE;

- (UIView *)infiniteScrollView:(InfiniteScrollView *)scrollView loadNextViewAfterView:(UIView *)currentView
{
    if (firstNextAppear) {
        firstNextAppear = FALSE;
    } else {
        self.currentDayMove += 7;
    }
    
    return [self calendarCellsViewWithDates:[self calculateDatesAfter:currentView.dates] type:1];
}

- (UIView *)infiniteScrollView:(InfiniteScrollView *)scrollView loadPreviousViewAfterView:(UIView *)currentView
{
    if (firstPrevAppear) {
        firstPrevAppear = FALSE;
    } else {
        self.currentDayMove -= 7;
    }
    
    UIView *vi = [self calendarCellsViewWithDates:[self calculateDatesBefore:currentView.dates] type:-1];
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
