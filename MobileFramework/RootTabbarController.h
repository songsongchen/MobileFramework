//
//  LFTabbarController.h
//  LoveFreshBeenT
//
//  Created by chenjs on 16/3/13.
//  Copyright © 2016年 songChen. All rights reserved.
//

#import "BaseViewController.h"

@interface RootTabbarController : BaseViewController

@property (nonatomic, copy) NSArray *viewControllers;//视图数组

@property (nonatomic, assign) NSInteger selectedIndex;//下标

@property (nonatomic, readonly) UIViewController *selectViewController;//选择的视图

@end
