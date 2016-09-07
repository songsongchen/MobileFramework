//
//  RootNavigationController.h
//  MobileFramework
//
//  Created by chenjs on 16/9/7.
//  Copyright © 2016年 songChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootTabbarController.h"

@interface RootNavigationController : UINavigationController

+ (instancetype)shareInstance;

@property (nonatomic, readonly) RootTabbarController *tabBarcontroller;

/**
 * 跳转到Tabbar的某个页面
 */
- (void)jumpToTabbarIndex:(NSInteger)index;

@end
