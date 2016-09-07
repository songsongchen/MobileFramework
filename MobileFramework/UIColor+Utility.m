//
//  UIColor+Utility.m
//  QunariPhone
//
//  Created by Neo on 11/12/12.
//  Copyright (c) 2012 姜琢. All rights reserved.
//

#import "UIColor+Utility.h"

@implementation UIColor (Utility)

// 十六进制数据转换为颜色
+ (UIColor *)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alpha
{
	return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16)) / 255.0
						   green:((float)((hexValue & 0xFF00) >> 8)) / 255.0
							blue:((float)(hexValue & 0xFF))/255.0
						   alpha:alpha];
}

@end
