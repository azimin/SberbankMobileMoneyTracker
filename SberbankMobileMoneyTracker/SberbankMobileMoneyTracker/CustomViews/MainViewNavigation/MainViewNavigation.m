//
//  MainViewNavigation.m
//  SberbankMobileMoneyTracker
//
//  Created by Alex Zimin on 26/07/14.
//  Copyright (c) 2014 Empatika. All rights reserved.
//

#import "MainViewNavigation.h"
#import "InfiniteScrollView.h"

@interface MainViewNavigation () <UIScrollViewDelegate>

@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) UIButton *leftArrowButton;
@property (nonatomic) UIButton *rightArrowButton;

@end

@implementation MainViewNavigation

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (instancetype)initWithTitles: (NSArray*)titles
                 selectedIndex: (NSInteger)index
                    andDelegat: (id <MainViewNavigationDelegat>)delegat
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    
    if ( self ) {
        self.titles = titles;
        self.selectedIndex = index;
        self.delegate = delegat;
        
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit
{
    if (self.titles.count <= 0) {
        return;
    }
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = FALSE;
    self.scrollView.contentSize = CGSizeMake(320 * self.titles.count, 0);
    self.scrollView.contentOffset = CGPointMake(320 * (self.titles.count - 1), 0);
    [self addSubview:self.scrollView];
    
    for (NSInteger index = 0; index < self.titles.count; index ++) {
        [self.scrollView addSubview:[self viewAfterIndex:index]];
    }
    
    UIImageView *leftFog = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, 107, 61)];
    leftFog.image = [UIImage imageNamed:@"img_fog_to_the_left"];
    [self addSubview:leftFog];
    
    UIImageView *rightFog = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width - 107, 40, 107, 61)];
    rightFog.image = [UIImage imageNamed:@"img_fog_to_the_right"];
    [self addSubview:rightFog];
    
    self.leftArrowButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 41, 22, 43)];
    [self.leftArrowButton setImage:[UIImage imageNamed:@"img_arrow_to_the_left"] forState:UIControlStateNormal];
    [self addSubview:self.leftArrowButton];
    
    self.rightArrowButton = [[UIButton alloc] initWithFrame:CGRectMake(283, 41, 22, 43)];
    [self.rightArrowButton setImage:[UIImage imageNamed:@"img_arrow_to_the_right"] forState:UIControlStateNormal];
    self.rightArrowButton.alpha = 0.2;
    [self addSubview:self.rightArrowButton];
}

#pragma mark - Apperance

- (UIView*)viewAfterIndex:(NSInteger)index
{
    UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(320 * index, 8, 320, 102)];
    UILabel *label = [[UILabel alloc] initWithFrame:vi.bounds];
    label.textColor = [UIColor blackColor];
    label.text = self.titles[index];
    label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:28];
    vi.tagPlus = index;
    label.textAlignment = NSTextAlignmentCenter;
    [vi addSubview:label];
    
    return vi;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.leftArrowButton.alpha = 1.0;
    self.rightArrowButton.alpha = 1.0;
    NSInteger index;
    
    if ( scrollView.contentOffset.x < 300 ) {
        index = 0;
        self.leftArrowButton.alpha = 0.2;
    } else if ( scrollView.contentOffset.x > scrollView.contentSize.width - self.bounds.size.width - 300 ) {
        index = self.titles.count - 1;
        self.rightArrowButton.alpha = 0.2;
    } else {
        index = scrollView.contentOffset.x / 320;
    }
    
    if (self.selectedIndex != index) {
        [self.delegate mainNavigation:self scrollToIndex:index];
        self.selectedIndex = index;
    }
}

@end
