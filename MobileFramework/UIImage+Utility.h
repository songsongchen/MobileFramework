//
//  UIImage+Utility.h


#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

/*
 * UIImage扩展类
 */
@interface UIImage (Utility)
// 创建指定颜色指定大小的图片
+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size;
/**
 *  根据bundle来生成图片
 *
 *  @param name  图片的名字
 *
 *  @return 返回图片对象
 */
+ (UIImage *)imageWithMyName:(NSString *)name;

+ (UIImage *)imageFromColor:(UIColor *)color size:(CGSize)size;

+ (id)createRoundedRectImage:(UIImage *)image size:(CGSize)size radius:(NSInteger)radius;

+ (NSString *)screenViewToImage:(UIView *)pageView tradeUUID:(NSString *)tradeUUID;

+ (UIImage *)tradeImageView:(NSString *)tradeUUID;

+ (void)removeTradeImage:(NSString *)tradeUUID;

+ (UIImage *)imageWithBundle:(NSString *)imageName type:(NSString *)type;

+ (UIImage *)imageNamed:(NSString *)name type:(NSString *)type;

- (UIImage *)roundedImage;

- (UIEdgeInsets)getImageUIEdgeInsets;

- (UIImage *)getImageResize;

- (UIImage *)screenViewToImage:(UIView *)pageView;

// 获取图片的像素值
- (unsigned char *)pixelData;

@end
