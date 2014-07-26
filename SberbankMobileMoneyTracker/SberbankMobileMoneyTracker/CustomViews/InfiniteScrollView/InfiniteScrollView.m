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

- (instancetype)initWithVisibleView:(UIView *)view dataSource:(id<InfiniteScrollViewDataSource>)source;{
    self.delegate = self;
    self.pagingEnabled = YES;
    self = [super initWithFrame:CGRectMake(0, 0, 320, 568)];
    self.infiniteDataSource = source;
    self.showsHorizontalScrollIndicator = NO;
    self.contentSize = CGSizeMake(960, 416);
    [self scrollRectToVisible:CGRectMake(320, 0, 320, 568) animated:NO];
    
    self.itemsView = [[NSMutableArray alloc] init];
    [self.itemsView addObject:view];
    if (self.infiniteDataSource) {
        UIView *vi = [self.infiniteDataSource infiniteScrollView:self loadPreviousViewAfterView:view];
        
        if (vi) {
            [self.itemsView insertObject:vi atIndex:0];
        }
        
        vi = [self.infiniteDataSource infiniteScrollView:self loadNextViewAfterView:view];
        
        if (vi) {
            [self.itemsView addObject:vi];
        }
    }
    
    for (UIView *vi in self.itemsView) {
        [self addSubview:vi];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    BOOL isEnd = FALSE;
    
    //right
    if ( scrollView.contentOffset.x > scrollView.frame.size.width ) {
        UIView *newView = [self.infiniteDataSource infiniteScrollView:self loadNextViewAfterView:self.itemsView[1]];
        if ( !newView ) {
            isEnd = TRUE;
        } else {
            int lastIndex = (int)[self.itemsView count] - 1;
            
            [self.itemsView[0] removeFromSuperview];
            for(int i = 0; i < lastIndex; i++)
                self.itemsView[i] = self.itemsView[i + 1];
            
            self.itemsView[lastIndex] = newView;
            [self addSubview:newView];
        }
    }
    
    //left
    if ( scrollView.contentOffset.x < scrollView.frame.size.width ) {
        UIView *newView = [self.infiniteDataSource infiniteScrollView:self loadPreviousViewAfterView:self.itemsView[1]];
        if ( !newView ) {
            isEnd = TRUE;
        } else {
            int lastIndex = (int)[self.itemsView count] - 1;
            [self.itemsView[lastIndex] removeFromSuperview];
            for(int i = lastIndex; i > 0; i--)
                self.itemsView[i] = self.itemsView[i - 1];
            
            self.itemsView[0] = newView;
            [self addSubview:newView];
        }
    }
    
    if ( !isEnd ) {
        [self changeContentFrames];
        [self scrollRectToVisible:CGRectMake(320, 0, 320, 568) animated:NO];
    }
    
}

- (void)changeContentFrames{
    CGRect rect;
    
    if (self.itemsView.count > 0) {
        CGRect rect = ((UIView *)self.itemsView[0]).frame;
        rect.origin.x = 0;
        ((UIView *)self.itemsView[0]).frame = rect;
    }
    
    if (self.itemsView.count > 1) {
        rect = ((UIView *)self.itemsView[1]).frame;
        rect.origin.x = 320;
        ((UIView *)self.itemsView[1]).frame = rect;
    }
    
    if (self.itemsView.count > 2) {
        rect = ((UIView *)self.itemsView[2]).frame;
        rect.origin.x = 640;
        ((UIView *)self.itemsView[2]).frame = rect;
    }
    
    
}

@end
