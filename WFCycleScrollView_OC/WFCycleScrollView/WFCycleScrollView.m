//
//  WFCycleScrollView.m
//  CycleScrollView
//
//  Created by happi on 2017/3/1.
//  Copyright © 2017年 happi. All rights reserved.
//

#import "WFCycleScrollView.h"

@interface WFCycleScrollView() {
    CGFloat contentWidth;
    CGFloat contentHeight;
    NSInteger totalPages;
    NSInteger currentPage;
    
    UIScrollView *_scrollView;
    NSMutableArray *curViews;
    NSTimer *timer;
}

@end

@implementation WFCycleScrollView

- (id)initWithContentSize:(CGSize)contentSize {
    self = [super init];
    if (self) {
        [self initWithData:contentSize];
        [self initWithView];
    }
    return self;
}

//初始化数据
- (void)initWithData:(CGSize)contentSize{
    self.pageControlShowStyle = UIPageControlShowStyleNone;
    contentWidth = contentSize.width;
    contentHeight = contentSize.height;
    totalPages = 0;
    currentPage = 0;
    _timeInterval = 4;
}
//初始化视图
- (void)initWithView {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.delegate = self;
    [_scrollView setContentSize:CGSizeMake(contentWidth * 3, 0)];
    [_scrollView setShowsHorizontalScrollIndicator:NO];
    [_scrollView setShowsVerticalScrollIndicator:NO];
    [_scrollView setContentOffset:CGPointMake(contentWidth, 0)];
    _scrollView.pagingEnabled = YES;
    _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_scrollView];
    
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.userInteractionEnabled = NO;
    _pageControl.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_pageControl];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_pageControl attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    NSMutableArray *tmpConstraints = [[NSMutableArray alloc] initWithCapacity:0];
    [tmpConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_pageControl]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_pageControl)]];
    
    [tmpConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-0-[_scrollView(%f)]",contentHeight] options:0 metrics:nil views:NSDictionaryOfVariableBindings(_scrollView)]];
    [tmpConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-0-[_scrollView(%f)]",contentWidth] options:0 metrics:nil views:NSDictionaryOfVariableBindings(_scrollView)]];
    
    [self addConstraints:tmpConstraints];
}

- (void)setPageControlShowStyle:(UIPageControlShowStyle)pageControlShowStyle {
    _pageControlShowStyle = pageControlShowStyle;
    if (pageControlShowStyle == UIPageControlShowStyleNone) {
        [_pageControl setHidden:YES];
        return;
    }
    
    [_pageControl setHidden:NO];
    if (pageControlShowStyle == UIPageControlShowStyleLeft) {
        NSMutableArray *tmpConstraints = [[NSMutableArray alloc] initWithCapacity:0];
        [tmpConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_pageControl]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_pageControl)]];
        [tmpConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_pageControl]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_pageControl)]];
        [self addConstraints:tmpConstraints];
    } else if (pageControlShowStyle == UIPageControlShowStyleCenter) {
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_pageControl attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        NSMutableArray *tmpConstraints = [[NSMutableArray alloc] initWithCapacity:0];
        [tmpConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_pageControl]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_pageControl)]];
        [self addConstraints:tmpConstraints];
    } else if (pageControlShowStyle == UIPageControlShowStyleRight) {
        NSMutableArray *tmpConstraints = [[NSMutableArray alloc] initWithCapacity:0];
        [tmpConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_pageControl]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_pageControl)]];
        [tmpConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_pageControl]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_pageControl)]];
        [self addConstraints:tmpConstraints];
    }
}





- (void)reloadData {
    
    //关闭定时器
    [timer invalidate];
    if (![_dataSource respondsToSelector:@selector(numberOfPages)]) {
        NSLog(@"必须实现numberOfPages协议");
        return;
    }
    if (![_dataSource respondsToSelector:@selector(pageAtIndex:)]) {
        NSLog(@"必须实现pageAtIndex:协议");
        return;
    }
    
    //删除子视图
    [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    totalPages = [_dataSource numberOfPages];
    _pageControl.numberOfPages = totalPages;
    currentPage = 0;
    if (totalPages == 0) {
        return;
    }
    
    if (totalPages > 1) {
        timer = [NSTimer scheduledTimerWithTimeInterval:_timeInterval target:self selector:@selector(animalMoveImage) userInfo:nil repeats:YES];
    }
    
    [self loadData];
}

- (void)loadData {
    
    if (totalPages == 0) {
        return;
    }
    _pageControl.currentPage = currentPage;
    NSArray *subViews = _scrollView.subviews;
    if (subViews.count != 0) {
        for (UIView *aView in subViews) {
            [aView removeFromSuperview];
        }
    }
    [self getDisplayImagesWithCurpage:currentPage];
    
    for (int i = 0; i < 3; i++) {
        UIView *v = (UIView *)curViews[i];
        [v setFrame:CGRectMake(0, 0, contentWidth, contentHeight)];
        v.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [v addGestureRecognizer:singleTap];
        v.frame = CGRectOffset(v.frame, v.frame.size.width * i, 0);
        
        [_scrollView addSubview:v];
    }
    
    [_scrollView setContentOffset:CGPointMake(contentWidth, 0) animated:NO];
    
    if (totalPages > 1) {
        [_scrollView setScrollEnabled:YES];
        if (_pageControlShowStyle != UIPageControlShowStyleNone) {
            [_pageControl setHidden:NO];
        }
    } else {
        [_scrollView setScrollEnabled:NO];
        [_pageControl setHidden:YES];
    }
    
    
}

- (void)getDisplayImagesWithCurpage:(NSInteger)page {
    NSInteger num = currentPage - 1;
    NSInteger pre = [self validPageValue:num];
    
    NSInteger num1 = currentPage + 1;
    NSInteger last = [self validPageValue:num1];
    
    if (curViews == nil || curViews.count <= 0) {
        curViews = [[NSMutableArray alloc] init];
    }
    
    [curViews removeAllObjects];
    [curViews addObject:[_dataSource pageAtIndex:pre]];
    [curViews addObject:[_dataSource pageAtIndex:page]];
    [curViews addObject:[_dataSource pageAtIndex:last]];
}

- (NSInteger)validPageValue:(NSInteger)value {
    if (value == -1) {
        value = totalPages - 1;
    }
    if (value == totalPages) {
        value = 0;
    }
    if (totalPages == 0) {
        value = 0;
    }
    return value;
}

- (void)handleTap:(UITapGestureRecognizer *)tap {
    if ([_delegate respondsToSelector:@selector(didClickPage:index:)]) {
        [_delegate didClickPage:self index:currentPage];
    }
}

#pragma UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat x = _scrollView.contentOffset.x;
    if (x >= (2 * contentWidth)) {
        NSInteger num = currentPage + 1;
        currentPage = [self validPageValue:num];
        [self loadData];
    }
    
    if (x <= 0) {
        NSInteger num = currentPage - 1;
        currentPage = [self validPageValue:num];
        [self loadData];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0) animated:YES];
}

//执行定时器
- (void)animalMoveImage {
    [_scrollView setContentOffset:CGPointMake(contentWidth * 2, 0) animated:YES];
}

- (void)dealloc {
    //关闭定时器
    [timer invalidate];
    timer = nil;
}


@end
