//
//  ViewController.m
//  WFCycleScrollView_OC
//
//  Created by chenmengjing on 2017/3/23.
//  Copyright © 2017年 honggu. All rights reserved.
//

#import "ViewController.h"


#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController () 

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    images = [[NSMutableArray alloc] initWithCapacity:5];
    [images addObject:[UIImage imageNamed:@"001.jpg"]];
    [images addObject:[UIImage imageNamed:@"002.jpg"]];
    [images addObject:[UIImage imageNamed:@"003.jpg"]];
    [images addObject:[UIImage imageNamed:@"004.jpg"]];
    [images addObject:[UIImage imageNamed:@"005.jpg"]];
    
    cycleScroll = [[WFCycleScrollView alloc] initWithContentSize:CGSizeMake(ScreenWidth, ScreenWidth*2/3)];
    cycleScroll.delegate = self;
    cycleScroll.dataSource = self;
    cycleScroll.pageControlShowStyle = UIPageControlShowStyleCenter;
    cycleScroll.timeInterval = 2;
    cycleScroll.pageControl.pageIndicatorTintColor = [UIColor redColor];
    cycleScroll.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    [self.view addSubview:cycleScroll];
    [cycleScroll reloadData];
    
    cycleScroll.translatesAutoresizingMaskIntoConstraints = NO;
    NSMutableArray *tmpConstraints = [[NSMutableArray alloc] initWithCapacity:0];
    [tmpConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-0-[cycleScroll]-0-|"] options:0 metrics:nil views:NSDictionaryOfVariableBindings(cycleScroll)]];
    [tmpConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-0-[cycleScroll(%f)]",ScreenWidth*2/3] options:0 metrics:nil views:NSDictionaryOfVariableBindings(cycleScroll)]];
    [self.view addConstraints:tmpConstraints];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma WFCycleScrollViewDatasource

- (NSInteger)numberOfPages {
    return images.count;
}

- (UIView *)pageAtIndex:(NSInteger)index {
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, cycleScroll.frame.size.height)];
    view.contentMode = UIViewContentModeScaleAspectFill;
    view.clipsToBounds = YES;
    [view setImage:images[index]];
    
    return view;
}

#pragma WFCycleScrollViewDelegate
- (void)didClickPage:(WFCycleScrollView *)scView index:(NSInteger)index {
    NSLog(@"==>%ld",index);
}




@end
