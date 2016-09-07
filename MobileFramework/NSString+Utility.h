//
//  NSString+Utility.h

//

#import <Foundation/Foundation.h>
#import "UtilContant.h"

/*
 * NSString扩展类
 */
@interface NSString (Utility)

// 检测是否为合法字符串
+ (BOOL)isLegal:(NSString *)str;

// 去除前后空格，空行
+ (NSString *)trim:(NSString *)str;

// 转换字符串，过滤nil为@""
+ (NSString *)transString:(NSString *)str;

// 转换性别 none male female
+ (NSString *)translateSex:(NSString *)sex;

// 转换排队号
+ (NSString *)translateQueueNumber:(NSInteger)queueNumber;

// 本地日期和时间
- (NSDate *)localDateTime;

// 本地日期
- (NSDate *)localDate;

// 时分秒时间
- (NSDate *)localTime;

// 判断是否为IP地址
- (BOOL)isIpAddress;

// 判断是否为手机号码
- (BOOL)checkMobile;

// 判断是否为座机号码
- (BOOL)checkTel;

// 秒转日期
- (NSDate *)dateFromMilliseconds;

// 字符串宽度
- (NSInteger)widthWithFont:(UIFont *)font;

// 字符串拼音首字母（包括汉字,每个汉字取首字母）
+ (NSString *)firstLettersWithTitle:(NSString *)title;
// 字符串首字母（包括汉字,只取第一个汉字的首字母）
+ (NSString *)firstLetterWithTitle:(NSString *)title;

// MD5加密
- (NSString *)md5FromString;
// 子字符串的起始下标
- (NSInteger)indexOfSubString:(NSString *)aString;
// 获取请求参数格式
- (NSString *)reqestFormatString;
// 电话隐藏格式
- (NSString *)phoneHideString;

/**  Return the char value at the specified index. */
- (unichar) charAt:(int)index;
/**
* Compares two strings lexicographically.
* the value 0 if the argument string is equal to this string;
* a value less than 0 if this string is lexicographically less than the string argument;
* and a value greater than 0 if this string is lexicographically greater than the string argument.
*/
- (int) compareTo:(NSString*) anotherString;
- (int) compareToIgnoreCase:(NSString*) str;
- (BOOL) contains:(NSString*) str;
- (BOOL) startsWith:(NSString*)prefix;
- (BOOL) endsWith:(NSString*)suffix;
- (BOOL) equals:(NSString*) anotherString;
- (BOOL) equalsIgnoreCase:(NSString*) anotherString;
- (int) indexOfChar:(unichar)ch;
- (int) indexOfChar:(unichar)ch fromIndex:(int)index;
- (int) indexOfString:(NSString*)str;
- (int) indexOfString:(NSString*)str fromIndex:(int)index;
- (int) lastIndexOfChar:(unichar)ch;
- (int) lastIndexOfChar:(unichar)ch fromIndex:(int)index;
- (int) lastIndexOfString:(NSString*)str;
- (int) lastIndexOfString:(NSString*)str fromIndex:(int)index;
- (NSString *) substringFromIndex:(int)beginIndex toIndex:(int)endIndex;
- (NSString *) toLowerCase;
- (NSString *) toUpperCase;
- (NSString *) trim;
- (NSString *) replaceAll:(NSString*)origin with:(NSString*)replacement;
- (NSArray *) split:(NSString*) separator;

- (NSString *)trimWhitespace;

- (CGSize)labelSizeWithFont:(CGFloat)fontSize labelWidth:(CGFloat)width;

- (NSString *)SSJKStringValue;

- (BOOL)hasTextValue;

- (NSString *)handleNumber;

+ (NSString *)uuid;

+(NSString *) jsonStringWithDictionary:(NSDictionary *)dictionary;

+(NSString *) jsonStringWithArray:(NSArray *)array;

+(NSString *) jsonStringWithString:(NSString *) string;

+(NSString *) jsonStringWithObject:(id) object;

+ (NSString *)formatePrice:(CGFloat)price;

- (NSObject *)safeNullValue;

//前面加统一的￥
- (NSString *)capationY;
//过滤掉上面那个￥
- (NSString *)fliterY;
//纯数字
- (NSString *)pureNumer;

+ (BOOL)isValidatIP:(NSString *)ipAddress;

@end

//设置对象nsstring类型的成员 值为value
#define SetObjectMemberValue(obj, mem, value) \
if ([value isKindOfClass:[NSString class]] && [NSString isLegal:value]) {\
obj.mem = value;\
}
