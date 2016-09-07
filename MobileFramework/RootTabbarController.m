//
//  LFTabbarController.m
//  LoveFreshBeenT
//
//  Created by chenjs on 16/3/13.
//  Copyright © 2016年 songChen. All rights reserved.
//

#import "RootTabbarController.h"

#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "FourthViewController.h"

#define kTabBtnTag 100

@implementation RootTabbarController {

    UIView *_tabBar;
    NSMutableArray *_tabBtnArray;

}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _selectedIndex = -1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTabBar];
    [self initViewControllers];
    self.selectedIndex = 0;
}

- (UIView *)topView {
    return nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.swipeBackEnabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.swipeBackEnabled = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ViewController Transition

- (void)removeViewController:(UIViewController *)controller {
    [controller willMoveToParentViewController:nil];
    [controller.view removeFromSuperview];
    [controller removeFromParentViewController];
}

- (void)addViewController {
    UIViewController *controller = _viewControllers[_selectedIndex];
    [self addChildViewController:controller];
    [self.view insertSubview:controller.view atIndex:0];
    controller.view.top = 0;
    [controller didMoveToParentViewController:self];
}

#pragma mark - property

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    NSInteger oldIndex = _selectedIndex;
    _selectedIndex = selectedIndex;
    // 修改按钮状态
    for (NSInteger i = 0; i < [self tabNum]; i++) {
        UIButton *btn = (UIButton *) [_tabBar viewWithTag:i + kTabBtnTag];
        btn.selected = i == _selectedIndex;
    }
    // 切换视图
    if (oldIndex >= 0) {
        [self removeViewController:_viewControllers[oldIndex]];
    }
    [self addViewController];
}

- (UIViewController *)selectedViewController {
    return _viewControllers[_selectedIndex];
}

//返回tabBar个数
- (NSInteger)tabNum {
    return 4;
}
//返回tabBar默认图片
- (NSArray *)tabIconNames {
    return @[@"v2_home",@"v2_order",@"shopCart",@"v2_my"];
}
//返回tabBar选择图片
- (NSArray *)tabIconNames2 {
    return @[@"v2_home_r",@"v2_order_r",@"shopCart_r",@"v2_my_r"];
}
//返回tabBar文字
- (NSArray *)tabTitles {
    return @[@"首页",@"推荐",@"购物车",@"我的"];
}

//返回控制器
- (NSArray *)tabViewControllers {
    return @[[[FirstViewController alloc]init],
             [[SecondViewController alloc] init],
             [[ThirdViewController alloc] init],
             [[FourthViewController alloc] init]];
}

#pragma mark - view

- (void)initTabBar {
    
    if (!_tabBar) {
        _tabBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height - tabBarHeight, self.view.width, tabBarHeight)];
        _tabBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        _tabBar.backgroundColor = HexGRAY(0xEA, 255);
        
        NSInteger tabNum = [self tabNum];
        NSArray *iconNames = [self tabIconNames];
        NSArray *iconNames2 = [self tabIconNames2];
        NSArray *titles = [self tabTitles];
        
        for (NSInteger i = 0; i < tabNum; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(i * deviceWidth / tabNum, 2, deviceWidth / tabNum, tabBarHeight - 2);
            [btn setImage:[UIImage imageNamed:iconNames[i]] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:iconNames2[i]] forState:UIControlStateHighlighted];
            [btn setImage:[UIImage imageNamed:iconNames2[i]] forState:UIControlStateSelected];
            [btn setTitleColor:HexRGBA(0x595757, 255) forState:UIControlStateNormal];
//            [btn setTitleColor:HexRGBA(0x3FC7F6, 255) forState:UIControlStateHighlighted];
//            [btn setTitleColor:HexRGBA(0x3FC7F6, 255) forState:UIControlStateSelected];
            btn.titleLabel.font = [UIFont fontWithName:FONTSTYLE size:11];
            [btn setTitle:titles[i] forState:UIControlStateNormal];
            [btn vcenterImageAndTitle:3];
            [btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = i + kTabBtnTag;
            [_tabBar addSubview:btn];
        }
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, deviceWidth, 0.5)];
        lineView.backgroundColor = HexGRAY(0xDC, 255);
        [_tabBar addSubview:lineView];
        [self.view addSubview:_tabBar];
    }
}

//当前控制器
- (void)initViewControllers {
    self.viewControllers = [self tabViewControllers];
    // 赋值TabController
    for (BaseViewController *controller in self.viewControllers) {
        controller.tabController = self;
    }
    
}

- (void)btnPressed:(UIButton *)sender {
    NSInteger index = sender.tag - kTabBtnTag;
    if (_selectedIndex != index) {
        self.selectedIndex = index;
    } else {
    
    }

}

@end

