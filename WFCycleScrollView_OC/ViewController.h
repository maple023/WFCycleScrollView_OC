//
//  ViewController.h
//  WFCycleScrollView_OC
//
//  Created by chenmengjing on 2017/3/23.
//  Copyright © 2017年 honggu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WFCycleScrollView.h"

@interface ViewController : UIViewController<WFCycleScrollViewDelegate,WFCycleScrollViewDataSource> {
    WFCycleScrollView *cycleScroll;
    
    NSMutableArray *images;
}


@end

