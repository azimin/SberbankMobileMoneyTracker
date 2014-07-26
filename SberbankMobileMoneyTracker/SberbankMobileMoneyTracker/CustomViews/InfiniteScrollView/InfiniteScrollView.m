//
//  InfiniteScrollView.m
//  SberbankMobileMoneyTracker
//
//  Created by Ivan Oschepkov on 26.07.14.
//  Copyright (c) 2014 Empatika. All rights reserved.
//

#import "InfiniteScrollView.h"

@interface InfiniteScrollView () <UIScrollViewDelegate>
@property (strong, nonatomic) NSMutableArray *itemsView;
@property (weak, nonatomic) id<InfiniteScrollViewDataSource> infiniteDataSource;
@end

@implementation InfiniteScrollView

-(instancetype)initWithVisibleView:(UIView *)view dataSource:(id<InfiniteScrollViewDataSource>)source;{
    self.delegate = self;
    self.pagingEnabled = YES;
    self = [super initWithFrame:CGRectMake(0, 0, 320, 568)];
    self.infiniteDataSource = source;
    self.showsHorizontalScrollIndicator = NO;
    self.contentSize = CGSizeMake(960, 416);
    [self scrollRectToVisible:CGRectMake(320, 0, 320, 568) animated:NO];
    
    self.itemsView = [[NSMutableArray alloc] init];
    [self.itemsView addObject:view];
    if(self.infiniteDataSource){
        [self.itemsView insertObject:[self.infiniteDataSource infiniteScrollView:self loadPreviousViewAfterView:view] atIndex:0];
        [self.itemsView addObject:[self.infiniteDataSource infiniteScrollView:self loadNextViewAfterView:view]];
    }
    
    [self addSubview:self.itemsView[0]];
    [self addSubview:self.itemsView[1]];
    [self addSubview:self.itemsView[2]];
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //right
    if(scrollView.contentOffset.x > scrollView.frame.size.width){
        int lastIndex = (int)[self.itemsView count] - 1;
        [self.itemsView[0] removeFromSuperview];
        for(int i = 0; i < lastIndex; i++)
            self.itemsView[i] = self.itemsView[i + 1];
        
        UIView *newView = [self.infiniteDataSource infiniteScrollView:self loadNextViewAfterView:self.itemsView[1]];
        self.itemsView[lastIndex] = newView;
        [self addSubview:newView];
    }
    
    //left
    if(scrollView.contentOffset.x < scrollView.frame.size.width){
        int lastIndex = (int)[self.itemsView count] - 1;
        [self.itemsView[lastIndex] removeFromSuperview];
        for(int i = lastIndex; i > 0; i--)
            self.itemsView[i] = self.itemsView[i - 1];
        
        UIView *newView = [self.infiniteDataSource infiniteScrollView:self loadPreviousViewAfterView:self.itemsView[1]];
        self.itemsView[0] = newView;
        [self addSubview:newView];
    }
    [self changeContentFrames];
    [self scrollRectToVisible:CGRectMake(320, 0, 320, 568) animated:NO];
}

-(void)changeContentFrames{
    CGRect rect = ((UIView *)self.itemsView[0]).frame;
    rect.origin.x = 0;
    ((UIView *)self.itemsView[0]).frame = rect;
    
    rect = ((UIView *)self.itemsView[1]).frame;
    rect.origin.x = 320;
    ((UIView *)self.itemsView[1]).frame = rect;
    
    rect = ((UIView *)self.itemsView[2]).frame;
    rect.origin.x = 640;
    ((UIView *)self.itemsView[2]).frame = rect;
}

@end
