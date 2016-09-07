
#define UIColorFromRGBA(rgbValue, a) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]
#define UIColorFromRGB(rgbValue)  UIColorFromRGBA(rgbValue,1.0)

#define currentSysVersion [[[UIDevice currentDevice] systemVersion] floatValue]
//isRetina
#define isRetina [UIScreen mainScreen].scale == 2.0

//所有线的高度或者宽度
#define gLineWidthOrHeight  isRetina? 0.5f :1.0f

#ifdef DEBUG
#define DEBUG_LOG(format, ...) NSLog((@"%@(%d)%s:\n" format), [[NSString stringWithCString:__FILE__ encoding:NSASCIIStringEncoding] lastPathComponent], __LINE__, __FUNCTION__, ##__VA_ARGS__)
#else
#define DEBUG_LOG(format, ...)
#endif
#define WHERE DEBUG_LOG(@"WHERE");
#define SSJKString(a) (a) ? [(a) description] : @""
#define kRMB @"￥"
#define kString_Null                        @"null"
#define kString_Null_IOS                    @"(null)"

#define WeakSelf __weak typeof(self) weakSelf = self;

