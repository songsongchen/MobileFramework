//
//  RootNavigationController.m
//  MobileFramework
//
//  Created by chenjs on 16/9/7.
//  Copyright © 2016年 songChen. All rights reserved.
//

#import "RootNavigationController.h"

@interface RootNavigationController ()

@end

@implementation RootNavigationController

+ (instancetype)shareInstance {
    
    static RootNavigationController *controller = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        controller = [[RootNavigationController alloc] init];
    });
    return controller;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setNavigationController];
    }
    return self;
}

- (void)setNavigationController {
    
    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0xfdcf0b)]; //导航背景色
    [[UINavigationBar appearance] setTintColor:[UIColor purpleColor]];//左右字体颜色
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor grayColor]}];//中间字体颜色
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarHidden = YES;//隐藏系统
    //默认就进入首页
    RootTabbarController *tabBarcontroll = [[RootTabbarController alloc] init];
    self.viewControllers = @[tabBarcontroll];
    
}

- (RootTabbarController *)tabBarcontroller {
    
    if (self.viewControllers.count > 0) {
        UIViewController *controller = self.viewControllers[0];
        if ([controller isKindOfClass:[RootTabbarController class]]) {
            return (RootTabbarController *)controller;
        }
        
    }
    
    return nil;
}

/**
 * 跳转到Tabbar的某个页面
 */
- (void)jumpToTabbarIndex:(NSInteger)index {
    [self popToRootViewControllerAnimated:NO];
    self.tabBarcontroller.selectedIndex = index;
}

@end
