//
//  UIColor+Utility.h
//  QunariPhone
//
//  Created by Neo on 11/12/12.
//  Copyright (c) 2012 姜琢. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 * UIColor扩展类
 */
@interface UIColor (Utility)
// 十六进制数据转换为颜色
+ (UIColor *)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alpha;
@end
