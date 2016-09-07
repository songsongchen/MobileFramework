//
//  UITextField+Calculate.h

//

#import <UIKit/UIKit.h>

@interface UILabel (Utility)

+ (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font withMaxWidth:(CGFloat)maxWidth withMaxHeight:(CGFloat)maxHeight withSingleRowHeight:(CGFloat)rowHeight;

+ (void)multipleFontStyleLable:(UILabel *)label withContentString:(NSString *)contentString withRange:(NSRange)range withTextColor:(UIColor *)color withFont:(UIFont *)font;

@end
