//
//  UIImage+Utility.m
//

#import "UIImage+Utility.h"
#import "UtilContant.h"

static CGContextRef CreateRGBABitmapContext(CGImageRef inImage) {
    CGContextRef context = NULL;
    CGColorSpaceRef colorSpace;
    void *bitmapData; //内存空间的指针，该内存空间的大小等于图像使用RGB通道所占用的字节数。
    int bitmapByteCount;
    int bitmapBytesPerRow;
    size_t pixelsWide = CGImageGetWidth(inImage); //获取横向的像素点的个数
    size_t pixelsHigh = CGImageGetHeight(inImage);  //获取纵向的像素点的个数
    bitmapBytesPerRow = (pixelsWide * 4); //每一行的像素点占用的字节数，每个像素点的ARGB四个通道各占8个bit(0-255)的空间
    bitmapByteCount = (bitmapBytesPerRow * pixelsHigh); //计算整张图占用的字节数

    colorSpace = CGColorSpaceCreateDeviceRGB();//创建依赖于设备的RGB通道
    //分配足够容纳图片字节数的内存空间
    bitmapData = malloc(bitmapByteCount);
    //创建CoreGraphic的图形上下文，该上下文描述了bitmaData指向的内存空间需要绘制的图像的一些绘制参数
    context = CGBitmapContextCreate(bitmapData,
            pixelsWide,
            pixelsHigh,
            8,
            bitmapBytesPerRow,
            colorSpace,
            kCGImageAlphaPremultipliedLast | kCGBitmapByteOrderDefault);
    //Core Foundation中通过含有Create、Alloc的方法名字创建的指针，需要使用CFRelease()函数释放
    CGColorSpaceRelease(colorSpace);
    return context;
}

@implementation UIImage (Utility)

// 创建指定颜色指定大小的图片
+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size {
    UIImage * img = nil;
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

// 获取图片的像素值
- (unsigned char *)pixelData {
    CGImageRef img = [self CGImage];
    CGSize size = self.size;
    CGContextRef cgctx = CreateRGBABitmapContext(img);
    if (cgctx == NULL)
        return NULL;
    CGRect rect = {{0, 0}, {size.width, size.height}};
    CGContextDrawImage(cgctx, rect, img);
    unsigned char *data = CGBitmapContextGetData(cgctx);
    CGContextRelease(cgctx);
    return data;
}

+ (UIImage *)imageWithMyName:(NSString *)name {
    //删除无用的。
    return [UIImage imageNamed:name];
}

#pragma mark  create ColorImage

+ (UIImage *)imageFromColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);

    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth,
        float ovalHeight) {
    float fw, fh;

    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }

    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth(rect) / ovalWidth;
    fh = CGRectGetHeight(rect) / ovalHeight;

    CGContextMoveToPoint(context, fw, fh / 2);  // Start at lower right corner
    CGContextAddArcToPoint(context, fw, fh, fw / 2, fh, 1);  // Top right corner
    CGContextAddArcToPoint(context, 0, fh, 0, fh / 2, 1); // Top left corner
    CGContextAddArcToPoint(context, 0, 0, fw / 2, 0, 1); // Lower left corner
    CGContextAddArcToPoint(context, fw, 0, fw, fh / 2, 1); // Back to lower right

    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

//将图片转换为圆角图
+ (id)createRoundedRectImage:(UIImage *)image size:(CGSize)size radius:(NSInteger)radius {
    // the size of CGContextRef
    CGFloat w = size.width;
    CGFloat h = size.height;

    UIImage * img = image;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGRect rect = CGRectMake(0, 0, w, h);

    CGContextBeginPath(context);
    addRoundedRectToPath(context, rect, radius, radius);
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    img = [UIImage imageWithCGImage:imageMasked];

    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageMasked);

    return img;
}

- (UIEdgeInsets)getImageUIEdgeInsets {
    CGFloat hInset = floorf(self.size.width / 2);
    CGFloat vInset = floorf(self.size.height / 2);
    UIEdgeInsets insets = UIEdgeInsetsMake(vInset, hInset, vInset, hInset);
    return insets;
}

/**
* 用作图片拉伸
*/
- (UIImage *)getImageResize {
    return [self resizableImageWithCapInsets:[self getImageUIEdgeInsets]];
}

/**
* 截屏
*/
+ (NSString *)screenViewToImage:(UIView *)pageView tradeUUID:(NSString *)tradeUUID {
    UIGraphicsBeginImageContextWithOptions(pageView.bounds.size, NO, 0);
    [pageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * uiImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString * filePath = [paths[0] stringByAppendingPathComponent:[NSString stringWithFormat:@"trade_%@.png", tradeUUID]];
    // 保存文件的名称
    if ([UIImagePNGRepresentation(uiImage) writeToFile:filePath atomically:YES]) {
        DEBUG_LOG(@"%@",filePath);
        return filePath;
    }
    return nil;
}

+ (UIImage *)tradeImageView:(NSString *)tradeUUID {
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString * filePath = [paths[0] stringByAppendingPathComponent:[NSString stringWithFormat:@"trade_%@.png", tradeUUID]];
    return [UIImage imageWithContentsOfFile:filePath];
}

/**
* 移除无用的图片
*/
+ (void)removeTradeImage:(NSString *)tradeUUID {
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString * filePath = [paths[0] stringByAppendingPathComponent:[NSString stringWithFormat:@"trade_%@.png", tradeUUID]];
    NSError * error;
    if ([[NSFileManager defaultManager] removeItemAtPath:filePath error:&error]) {
        DEBUG_LOG(@"%@",@"Delete Unuse Image");
    } else {
        DEBUG_LOG(@"%@",error);
    }
}

/**
* 从本地读取大图片
*/
+ (UIImage *)imageWithBundle:(NSString *)imageName type:(NSString *)type {

    if (!imageName || !type)return [UIImage imageNamed:@"defalutImage"];

    NSBundle *mainBundle = [NSBundle mainBundle];
    NSFileManager *manager = [NSFileManager defaultManager];
    //1.过滤掉（.png .jpg @2x）
    NSString * fileName = [[[imageName stringByReplacingOccurrencesOfString:@".png" withString:@""] stringByReplacingOccurrencesOfString:@".jpg" withString:@""] stringByReplacingOccurrencesOfString:@"@2x" withString:@""];
    //2.判断是否存在1倍和2倍图
    NSString * px1imagepath = [mainBundle pathForResource:fileName ofType:type];
    NSString * px2imagepath = [mainBundle pathForResource:[NSString stringWithFormat:@"%@@2x", imageName] ofType:type];
    BOOL exist1px = [manager fileExistsAtPath:px1imagepath];
    BOOL exist2px = [manager fileExistsAtPath:px2imagepath];
    //3.返回所需图片
    //高清屏时，有2倍反2倍,没2倍反1倍。非高清屏时有1倍反1倍，没1倍，反2倍
    if (isRetina) {
        return [[UIImage alloc] initWithContentsOfFile:exist2px ? px2imagepath : px1imagepath];
    } else {
        return [[UIImage alloc] initWithContentsOfFile:exist1px ? px1imagepath : px2imagepath];
    }
}

/**
* 用完就释放掉，不缓存图
*/
+ (UIImage *)imageNamed:(NSString *)name type:(NSString *)type {
    return [UIImage imageWithBundle:name type:type];
}

- (UIImage *)roundedImage {
    return [self roundedImageWithSize:CGSizeMake(self.size.width, self.size.height)];
}

- (UIImage *)roundedImageWithSize:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();

    [self drawInRect:rect];

    CGContextAddRect(context, rect);
    CGContextAddEllipseInRect(context, rect);
    CGContextEOClip(context);
    CGContextClearRect(context, rect);

    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return newImage;
}


@end
