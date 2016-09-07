//
//  UIView+Utility.h
//  QunariPhone
//
//  Created by Neo on 11/12/12.
//  Copyright (c) 2012 姜琢. All rights reserved.
//

#import <UIKit/UIKit.h>

extern const CGFloat fontHeight_iPhone[];
extern const CGFloat fontHeight_iPad[];

#define FH_1(a) fontHeight_iPhone[(a)-8]
#define FH_2(a) fontHeight_iPad[(a)-8]

/**
 * UIView扩展类
 */
@interface UIView (Addition)

@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;

@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat left;

@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat right;

@end
