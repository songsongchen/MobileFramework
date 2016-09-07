//
//  UITextField+Calculate.m

//

#import "UILabel+Utility.h"

@implementation UILabel (Utility)


+ (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font withMaxWidth:(CGFloat)maxWidth withMaxHeight:(CGFloat)maxHeight withSingleRowHeight:(CGFloat)rowHeight {
    if ([string length] == 0) {
        return CGSizeMake(0, 0);
    }
    NSString * content = string;

    CGSize fontsize = CGSizeMake(maxWidth, maxHeight);
    CGSize labContentSize = CGSizeZero;

    NSDictionary * attrb = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    labContentSize = [content boundingRectWithSize:fontsize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrb context:nil].size;

    if (labContentSize.height < rowHeight) {
        labContentSize = CGSizeMake(labContentSize.width, rowHeight);
    }

    return labContentSize;
}

+ (void)multipleFontStyleLable:(UILabel *)label withContentString:(NSString *)contentString withRange:(NSRange)range withTextColor:(UIColor *)color withFont:(UIFont *)font {
    if (label != nil) {

        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:contentString];
        if (color != nil) {
            [str addAttribute:NSForegroundColorAttributeName value:color range:range];
        }
        if (font != nil) {
            [str addAttribute:NSFontAttributeName value:font range:range];
        }
        label.attributedText = str;
    }
}


@end
