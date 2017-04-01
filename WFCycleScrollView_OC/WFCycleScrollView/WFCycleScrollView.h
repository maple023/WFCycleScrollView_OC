//
//  WFCycleScrollView.h
//  CycleScrollView
//
//  Created by happi on 2017/3/1.
//  Copyright © 2017年 happi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WFCycleScrollView;

typedef enum {
    UIPageControlShowStyleNone,
    UIPageControlShowStyleLeft,
    UIPageControlShowStyleCenter,
    UIPageControlShowStyleRight
}UIPageControlShowStyle;


@protocol WFCycleScrollViewDelegate <NSObject>
@optional
- (void)didClickPage:(WFCycleScrollView *)scView index:(NSInteger)index;
@end

@protocol WFCycleScrollViewDataSource <NSObject>
@required
- (NSInteger)numberOfPages;
- (UIView *)pageAtIndex:(NSInteger)index;
@end


@interface WFCycleScrollView : UIView<UIScrollViewDelegate>

@property (nonatomic, weak)id<WFCycleScrollViewDelegate> delegate;
@property (nonatomic, weak)id<WFCycleScrollViewDataSource> dataSource;
//设置 UIPageControl 显示样式
@property (nonatomic,assign)UIPageControlShowStyle pageControlShowStyle;
//设置自动滚动间隔时间 默认 4s
@property (nonatomic,assign)NSInteger timeInterval;
@property (nonatomic,strong)UIPageControl *pageControl;

//初始化方法指定滚动内容的大小
- (id)initWithContentSize:(CGSize)contentSize;

//刷新数据
- (void)reloadData;


@end

