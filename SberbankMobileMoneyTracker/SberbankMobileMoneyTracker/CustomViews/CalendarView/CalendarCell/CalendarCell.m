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

@end

@implementation CalendarCell

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
    self.selected = NO;
    // Day label
    self.dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 36)];
    self.dayLabel.textAlignment = NSTextAlignmentCenter;
    self.dayLabel.text = self.dayString;
    self.dayLabel.textColor = [UIColor darkGrayColor];
    [self addSubview: self.dayLabel];
    
    self.arrayOfCircles = @[];
    NSArray *arrOfSizes = self.circleSizes;
    
    if ( self.values.count != arrOfSizes.count ) {
        return;
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
        NSInteger index = [sortedValues indexOfObject:self.values[i]];
        Circle *circle = [[Circle alloc] initWithRadius: [arrOfSizes[index] floatValue]
                                              andCenter: CGPointMake(self.frame.size.width / 2,
                                                                     56 + 40 * i)];
        circle.backgroundColor = UIColor.circleColors[i];
        [self addSubview:circle];
        [circles addObject:circle];
    }
    
    self.arrayOfCircles = circles;
    
    // Add button
    UIButton *but = [[UIButton alloc] initWithFrame:self.bounds];
    [but addTarget:self action:@selector(selectCell:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:but];
}

#pragma mark - Getters

+ (CGRect)calendarCellFrame
{
    return CGRectMake(0, 0, 45, 175);
}

- (NSArray*)circleSizes
{
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
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName: kNotificationCalendarCellDidSelect
                                                        object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(deselectCell:)
                                                 name: kNotificationCalendarCellDidSelect
                                               object: nil];
    
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
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
