//
//  CalendarCell.m
//  SberbankMobileMoneyTracker
//
//  Created by Alex Zimin on 26/07/14.
//  Copyright (c) 2014 Empatika. All rights reserved.
//

#import "CalendarCell.h"
#import "Circle.h"

@interface CalendarCell ()

@property (nonatomic) UILabel *dayLabel;
@property (nonatomic) NSArray *arrayOfCircles;
@property (nonatomic) UIImageView *selectedBubble;

@end

@implementation CalendarCell

- (id)copyWithZone:(NSZone *)zone
{
    CalendarCell *another = [[CalendarCell alloc] initWithDayString:self.dayString andValues:self.values];
    another.tagPlus = self.tagPlus;
    
    return another;
}

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:CalendarCell.calendarCellFrame];
    
    if (self) {
        self.dayString = @"-";
        self.values = @[];
        
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithDayString: (NSString*)dayString
                        andValues: (NSArray*)valus
{
    self = [super initWithFrame:CalendarCell.calendarCellFrame];
    
    if ( self ) {
        self.dayString = dayString;
        self.values = valus;
        
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit
{
    if ( [self allEqualZero:self.values] ) {
        self.values = @[];
    }
    
    self.selected = NO;
    // Day label
    self.dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 36)];
    self.dayLabel.textAlignment = NSTextAlignmentCenter;
    self.dayLabel.text = self.dayString;
    self.dayLabel.textColor = [UIColor darkGrayColor];
    [self addSubview: self.dayLabel];
    
    self.arrayOfCircles = @[];
    NSArray *arrOfSizes = [self circleSizes:YES];
    
    if ( self.values.count != arrOfSizes.count ) {
        arrOfSizes = [self circleSizes:NO];
    }
    
    NSArray *sortedValues = [self.values sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        CGFloat firstValue = [obj1 floatValue];
        CGFloat secondValuer = [obj2 floatValue];
        
        if (firstValue > secondValuer)
            return NSOrderedAscending;
        else if (firstValue < secondValuer)
            return NSOrderedDescending;
        
        return NSOrderedSame;
    }];
    
    NSMutableArray *circles = [NSMutableArray array];
    
    // Add circles
    for (NSInteger i = 0; i < arrOfSizes.count; i ++) {
        NSInteger index;
        if (self.values.count <= i) {
            index = 3;
        } else {
            index = [sortedValues indexOfObject:self.values[i]];
            if ([self.values[i] floatValue] == 0) {
                index = 3;
            }
        }
        
        Circle *circle = [[Circle alloc] initWithRadius: [arrOfSizes[index] floatValue]
                                              andCenter: CGPointMake(self.frame.size.width / 2,
                                                                     56 + 40 * i)];
        circle.backgroundColor = UIColor.circleColors[i];
        [self addSubview:circle];
        [circles addObject:circle];
    }
    
    self.arrayOfCircles = circles;
    
    // Add button
    UIButton *but = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height / 2 + 25)];
    [but addTarget:self action:@selector(selectCell:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:but];
}

- (BOOL)allEqualZero:(NSArray*)arr
{
    for (NSNumber *num in arr) {
        if ([num floatValue] != 0) {
            return FALSE;;
        }
    }
    
    return TRUE;
}

#pragma mark - Getters

+ (CGRect)calendarCellFrame
{
    return CGRectMake(0, 0, 45, 190);
}

- (NSArray*)circleSizes:(BOOL)withValues
{
    if (!withValues) {
        return @[@(4),
                 @(4),
                 @(4),
                 @(4)];
    }
    
    return @[@(10),
             @(8),
             @(6),
             @(4)];
}

#pragma mark - Select

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    
    if ( !selected )
    {
        self.dayLabel.textColor = [UIColor darkGrayColor];
        [self.selectedBubble removeFromSuperview];
        self.selectedBubble = nil;
        
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        return;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[NSNotificationCenter defaultCenter] postNotificationName: kNotificationCalendarCellDidSelect
                                                        object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(deselectCell:)
                                                 name: kNotificationCalendarCellDidSelect
                                               object: nil];
    
    self.selectedBubble = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_bubble_calendar"]];
    self.selectedBubble.frame = CGRectMake(0, 0, 34, 34);
    self.selectedBubble.center = CGPointMake(self.dayLabel.center.x + 0.5, self.dayLabel.center.y + 2.5);
    [self insertSubview:self.selectedBubble belowSubview:self.dayLabel];
    self.dayLabel.textColor = [UIColor whiteColor];
    
    for (Circle *circle in self.arrayOfCircles) {
        [circle bounceAppearWithDuration:0.6];
    }
}

#pragma mark - Actions
     
- (IBAction)deselectCell:(id)sender
{
    self.selected = FALSE;
}

- (IBAction)selectCell:(id)sender
{
    if ( !self.selected ) {
        self.selected = TRUE;
        
        if ( [self.delegate respondsToSelector:@selector(calendarCellDidSelect:)] ) {
            [self.delegate calendarCellDidSelect:self];
        }
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
