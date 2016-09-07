//
//  UIView+Tips.m

//

#import "UIView+Tips.h"

@implementation UIView (Tips)

- (void)showLoadingView:(BOOL)disableTouch {
    [self showLoadingView:nil disableTouch:disableTouch];
}

- (void)showLoadingView:(NSString *)text disableTouch:(BOOL)disableTouch {
    // 先隐藏可能的警告视图
    MBProgressHUD *warningHud = (MBProgressHUD *)[self viewWithTag:kWarningViewTag];
    if (warningHud) {
        [warningHud hide:NO];
    }
    
    MBProgressHUD *hud = (MBProgressHUD *)[self viewWithTag:kLoadingViewTag];
    if (!hud) {
        // 新创建一个视图
        hud = [[MBProgressHUD alloc] initWithView:self];
        hud.tag = kLoadingViewTag;
        hud.userInteractionEnabled = disableTouch;
        hud.removeFromSuperViewOnHide = YES;
        hud.labelText = text;
        [self addSubview:hud];

        [hud show:YES];
    } else {
        // 修改原来的文本和点击状态
        hud.labelText = text;
        hud.userInteractionEnabled = disableTouch;
    }
}

- (void)hideLoadingView {
    MBProgressHUD *hud = (MBProgressHUD *) [self viewWithTag:kLoadingViewTag];
    if (hud) {
        [hud hide:YES];
    }
}

- (void)showAlertHud:(NSString *)imageName text:(NSString *)text {
    // 先隐藏可能的loading视图
    MBProgressHUD *warningHud = (MBProgressHUD *)[self viewWithTag:kLoadingViewTag];
    if (warningHud) {
        [warningHud hide:NO];
    }
    
    MBProgressHUD *hud = (MBProgressHUD *)[self viewWithTag:kWarningViewTag];
    BOOL shouldShow = !hud;
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self];
        hud.tag = kWarningViewTag;
        hud.userInteractionEnabled = NO;
        hud.removeFromSuperViewOnHide = YES;
        [self addSubview:hud];
    } else {
        hud.userInteractionEnabled = NO;
    }

    if (imageName.length > 0) {
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        hud.mode = MBProgressHUDModeCustomView;
    } else {
        hud.mode = MBProgressHUDModeText;
    }

    CGSize size = MB_TEXTSIZE(text, hud.labelFont);
    if (size.width >= (deviceWidth - 4 * hud.margin) - 20) {
        hud.labelText = nil;
        hud.detailsLabelText = text;
    } else {
        hud.labelText = text;
        hud.detailsLabelText = nil;
    }

    if (shouldShow) {
        [hud show:YES];
    }

    [hud hide:YES afterDelay:2];
}

- (void)showErrorText:(NSString *)text {
    [self showAlertHud:@"alert_error_icon" text:text];
}

- (void)showSuccessText:(NSString *)text {
    [self showAlertHud:@"alert_success_icon" text:text];
}

- (void)showWarningText:(NSString *)text {
    [self showAlertHud:nil text:text];
}

@end
