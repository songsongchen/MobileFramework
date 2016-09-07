//
// Created by Mac on 14-9-23.

//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface UIButton (EnlargeEdge)
- (void)setEnlargeEdge:(CGFloat) size;
- (void)setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left;
- (void)titleUpImageDown:(float)spacing;
- (void)vcenterImageAndTitle:(float)spacing;
@end