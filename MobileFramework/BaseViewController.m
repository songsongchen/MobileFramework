//
//  BaseController.m
//  LoveFreshBeenT
//
//  Created by chenjs on 16/3/13.
//  Copyright © 2016年 songChen. All rights reserved.
//

#import "BaseViewController.h"

#define KTag 8898

@implementation BaseViewController

- (void)dealloc {

    DEBUG_LOG(@"%@ delloc",NSStringFromClass([self class]));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = UIColorFromRGB(0xffffff);
    [self topView];
    
    if (self.navigationController.viewControllers.count > 1) {
        [self addBackBtn];
        [_backBtn setTitleColor:UIColorFromRGB(0xb4b4b5) forState:UIControlStateHighlighted];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
}

#pragma mark - Status Bar 状态栏

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationNone;
}

#pragma mark - use system nav bar

- (UINavigationItem *)navigationItem {
    UINavigationItem *item = self.navigationController.navigationBar.topItem;
    if (item) {
        return item;
    } else {
        return [super navigationItem];
    }
}

#pragma mark - 自定义导航栏
- (UIView *)topView {
    if (!_topView) {
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, deviceWidth, topBarHeight)];
        [self.view addSubview:topView];
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, -GAP20, deviceWidth, topBarHeight + GAP20)];
        bgView.backgroundColor = UIColorFromRGB(0xfdcf0b);
        bgView.tag = KTag;
        [topView addSubview:bgView];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.frame = CGRectMake(44, (topView.height - topBarHeight) / 2, deviceWidth - 88, topBarHeight);
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont fontWithName:FONTSTYLEBOLD size:17];
        titleLabel.textColor = UIColorFromRGB(0xffffff);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [topView addSubview:titleLabel];
        
        _titleLabel = titleLabel;
        _topView = topView;
    }
    return _topView;

}

- (UIView *)topBgView {
    return [self.topView viewWithTag:KTag];
}
//返回按钮
- (void)addBackBtn {
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(4, 0, 44, 44);
    [backBtn setImage:[UIImage imageNamed:@"v2_goback"] forState:UIControlStateNormal];
//    [backBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 5, 10, 20);
    [backBtn addTarget:self action:@selector(backBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:backBtn];
    _backBtn = backBtn;
}

- (void)backBtnPressed:(id)sender {

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 创建导航上左右按钮

- (UIButton *)customRightTextBtn:(NSString *)text action:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(deviceWidth - 4 - 44, 0, 44, 44);
    btn.titleLabel.font = [UIFont fontWithName:FONTSTYLE size:16];
    CGSize size = MB_TEXTSIZE(text, btn.titleLabel.font);
    btn.width = MAX(44, 16 + ceilf(size.width));
    btn.left = deviceWidth - 4 - btn.width;
    [btn setTitle:text forState:UIControlStateNormal];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:btn];
    return btn;
}

- (UIButton *)customRightImgBtn:(UIImage *)img1 img2:(UIImage *)img2 action:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(deviceWidth - 4 - 44, 0, 44, 44);
    [btn setImage:img1 forState:UIControlStateNormal];
    [btn setImage:img2 forState:UIControlStateHighlighted];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:btn];
    return btn;
}

- (UIButton *)customLeftImgBtn:(UIImage *)img1 img2:(UIImage *)img2 action:(SEL)action {
    // 调用right方法，然后把按钮的坐标改下
    UIButton *btn = [self customRightImgBtn:img1 img2:img2 action:action];
    btn.left = 4;
    return btn;
}

- (UIButton *)customLeftTextBtn:(NSString *)text action:(SEL)action {
    UIButton *btn = [self customRightTextBtn:text action:action];
    btn.left = 4;
    return btn;
}

- (void)scrollToTop:(BOOL)enabled {
    
    
}

#pragma mark - 自定义显示效果

- (UIView *)shownMaskView {
    if (!_shownMaskView) {
        _shownMaskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, deviceWidth, deviceHeight)];
        _shownMaskView.backgroundColor = HexGRAY(0x0, 255);
    }
    return _shownMaskView;
}

#pragma mark - 出现方式
- (CGPoint)startPoint {
    CGPoint pt;
    switch (self.shownDirection) {
        case ShowViewControllerDirection_BottomTop:
            pt = CGPointMake(0, deviceHeight);
            break;
            
        case ShowViewControllerDirection_RightLeft:
            pt = CGPointMake(deviceWidth, 0);
            break;
            
        case ShowViewControllerDirection_TopBottom:
            pt = CGPointMake(0, -deviceHeight);
            break;
            
        default:
            pt = CGPointMake(-deviceWidth, 0);
            break;
    }
    return pt;
}

/**
 * 把self显示到某个视图控制器
 */
- (void)showInViewController:(UIViewController *)vc direction:(ShowViewControllerDirection)direction {
    __weak UIViewController *parentVC = vc;
    self.shownDirection = direction;
    
    // 加半透明层
    [parentVC.view addSubview:self.shownMaskView];
    self.shownMaskView.alpha = 0;
    // 加到父视图控制器
    [parentVC addChildViewController:self];
    [parentVC.view addSubview:self.view];
    // 设置view的开始位置
    CGPoint pt = [self startPoint];
    self.view.left = pt.x;
    self.view.top = pt.y;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.view.left = 0;
        self.view.top = 0;
        self.shownMaskView.alpha = 0.5;
    }                completion:^(BOOL finished) {
        [parentVC didMoveToParentViewController:self];
    }];
}

/**
 * 隐藏
 */
- (void)hide {
    CGPoint pt = [self startPoint];
    [self willMoveToParentViewController:nil];
    [UIView animateWithDuration:0.25 animations:^{
        // 隐藏时的结束位置，即为开始位置
        self.view.left = pt.x;
        self.view.top = pt.y;
        self.shownMaskView.alpha = 0;
    }                completion:^(BOOL finished) {
        [self.shownMaskView removeFromSuperview];
        self.shownMaskView = nil;
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}

- (void)pushController:(UIViewController *)controller {
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - cell展示效果
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
////    设置cell的显示动画为3D缩放
////xy方向缩放的初始值为0.1
//    cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1);
//    //设置动画时间为0.25秒,xy方向缩放的最终值为1
//    [UIView animateWithDuration:0.8 animations:^{
//        cell.layer.transform = CATransform3DMakeScale(1, 1, 1);
//    }];
//}

@end
