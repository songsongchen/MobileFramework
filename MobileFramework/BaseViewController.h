//
//  BaseController.h
//  LoveFreshBeenT
//
//  Created by chenjs on 16/3/13.
//  Copyright © 2016年 songChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LFTabbarController;

/**
  * 作为所有视图控制器的基类
 */
@interface BaseViewController : UIViewController {
    UIView *_topView;
}

/**
 * 如果该视图控制器加入了TabBarViewController，则可获取对应的TabBarViewController
 */

@property (nonatomic, weak) LFTabbarController *tabController;

@property (nonatomic, retain) UIView *topView;

@property (nonatomic, retain, readonly) UIView *topBgView;

@property (nonatomic, retain) UILabel *titleLabel;

@property (nonatomic, retain) UIButton *backBtn;

//返回按钮
- (void)addBackBtn;
//返回方法
- (void)backBtnPressed:(id)sender;

//按钮及方法
- (UIButton *)customRightTextBtn:(NSString *)text action:(SEL)action;
- (UIButton *)customLeftTextBtn:(NSString *)text action:(SEL)action;

- (UIButton *)customRightImgBtn:(UIImage *)img1 img2:(UIImage *)img2 action:(SEL)action;
- (UIButton *)customLeftImgBtn:(UIImage *)img1 img2:(UIImage *)img2 action:(SEL)action;

//滚动
- (void)scrollToTop:(BOOL)enabled;

#pragma mark - 自定义显示效果

// 显示时需要的maskView
@property (nonatomic, strong) UIView *shownMaskView;
// 记住显示的方向，隐藏的时候需要用
@property (nonatomic, assign) ShowViewControllerDirection shownDirection;

/**
 * 把self显示到某个视图控制器
 */
- (void)showInViewController:(UIViewController *)vc direction:(ShowViewControllerDirection)direction;

/**
 * 隐藏
 */
- (void)hide;

- (void)pushController:(UIViewController *)controller;



@end
