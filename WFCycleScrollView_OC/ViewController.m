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
    [images addObject:@"http://www.elitesigner.com/uploads/201607223182aYS1j5dDyO.jpg"];
    [images addObject:@"http://www.elitesigner.com/uploads/201607229453F3uNXfwoHh.jpg"];
    [images addObject:@"http://www.elitesigner.com/uploads/2016072225269kDF8KyPol.jpg"];
    [images addObject:@"http://www.elitesigner.com/uploads/201702148432iLmzFaIryk.jpg"];
    [images addObject:@"http://www.elitesigner.com/uploads/201702147155MDu2g81Itr.jpg"];
    [images addObject:@"http://www.elitesigner.com/uploads/201612303144yupcjf6vla.jpg"];
    
    
    cycleScroll = [[WFCycleScrollView alloc] initWithContentSize:CGSizeMake(ScreenWidth, ScreenWidth*2/3)];
    cycleScroll.delegate = self;
    cycleScroll.dataSource = self;
    cycleScroll.pageControlShowStyle = UIPageControlShowStyleCenter;
    cycleScroll.timeInterval = 6;
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
    [view setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:images[index]]]]];
    
    return view;
}

#pragma WFCycleScrollViewDelegate
- (void)didClickPage:(WFCycleScrollView *)scView index:(NSInteger)index {
    NSLog(@"==>%ld",index);
}




@end
