//

//

#import "NSDate+Utilities.h"
#import "BaseParaManager.h"

#define D_MINUTE	60
#define D_HOUR		3600
#define D_DAY		86400
#define D_WEEK		604800
#define D_YEAR		31556926

static const unsigned componentFlags = (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit);

@implementation NSDate (Utilities)

// 返回当前线程的日期格式化对象
+ (NSDateFormatter *)dateFormatter {
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    });
    return dateFormatter;
}

// Courtesy of Lukasz Margielewski
// Updated via Holger Haenisch
+ (NSCalendar *)currentCalendar {
    static NSCalendar *sharedCalendar = nil;
    if (!sharedCalendar)
        sharedCalendar = [NSCalendar autoupdatingCurrentCalendar];
    return sharedCalendar;
}

- (NSDate *)localDate {
    //标准的本地时间
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:self];
    NSDate *localeDate = [self dateByAddingTimeInterval:interval];
    return localeDate;
}

- (NSString *)localDateString {
    NSDateFormatter *dateFormatter = [[self class] dateFormatter];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString * result = [dateFormatter stringFromDate:self];
    return result;
}

- (NSString *)localTimeString {
    NSDateFormatter *dateFormatter = [[self class] dateFormatter];
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    NSString * strDate = [dateFormatter stringFromDate:self];

    return strDate;
}

+ (NSDate *)dateWithString:(NSString *)dateStr formatStr:(NSString *)formatStr {
    NSDateFormatter *dateFormatter = [[self class] dateFormatter];
    [dateFormatter setDateFormat:formatStr];
    return [dateFormatter dateFromString:dateStr];
}

/**
* 获取系统的安全时间，与服务器做了比较(校准)
*/
+ (NSDate *)serverSafeDate {
    NSDate *date = [[NSDate alloc] init];
    NSTimeInterval dateTimeInteval = date.timeIntervalSince1970 + [BaseParaManager sharedInstance].timeInterval;
    return [NSDate dateWithTimeIntervalSince1970:dateTimeInteval];
}

+ (instancetype)date {
    //重写本地时间
    return [self serverSafeDate];
}

#pragma mark - Relative Dates

+ (NSDate *)dateWithDaysFromNow:(NSInteger)days {
    // Thanks, Jim Morrison
    return [[NSDate date] dateByAddingDays:days];
}

+ (NSDate *)dateWithDaysBeforeNow:(NSInteger)days {
    // Thanks, Jim Morrison
    return [[NSDate date] dateBySubtractingDays:days];
}

+ (NSDate *)dateTomorrow {
    return [NSDate dateWithDaysFromNow:1];
}

+ (NSDate *)dateYesterday {
    return [NSDate dateWithDaysBeforeNow:1];
}

+ (NSDate *)lastWeekDay {
    return [NSDate dateWithDaysBeforeNow:7];
}

+ (NSDate *)dateWithHoursFromNow:(NSInteger)dHours {
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_HOUR * dHours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

+ (NSDate *)dateWithHoursBeforeNow:(NSInteger)dHours {
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_HOUR * dHours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

+ (NSDate *)dateWithMinutesFromNow:(NSInteger)dMinutes {
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_MINUTE * dMinutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

+ (NSDate *)dateWithMinutesBeforeNow:(NSInteger)dMinutes {
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_MINUTE * dMinutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

#pragma mark - String Properties

// 自1970年以来的秒数
- (NSString *)secondsFrom1970 {
    return [NSString stringWithFormat:@"%.0lf", [self timeIntervalSince1970]];
}

// 自1970年以来的毫秒数
- (NSString *)millisecondsFrom1970 {
    return [NSString stringWithFormat:@"%.0f", [self timeIntervalSince1970] * 1000];
}


- (NSString *)stringWithFormat:(NSString *)format {
    NSDateFormatter *formatter = [[self class] dateFormatter];
    formatter.dateFormat = format;
    return [formatter stringFromDate:self];
}

- (NSString *)stringWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle {
    NSDateFormatter *formatter = [[self class] dateFormatter];
    formatter.dateStyle = dateStyle;
    formatter.timeStyle = timeStyle;
    return [formatter stringFromDate:self];
}

- (NSString *)shortString {
    return [self stringWithDateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
}

- (NSString *)shortTimeString {
    return [self stringWithDateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle];
}

- (NSString *)shortDateString {
    return [self stringWithDateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle];
}

- (NSString *)mediumString {
    return [self stringWithDateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterMediumStyle];
}

- (NSString *)mediumTimeString {
    return [self stringWithDateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterMediumStyle];
}

- (NSString *)mediumDateString {
    return [self stringWithDateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle];
}

- (NSString *)longString {
    return [self stringWithDateStyle:NSDateFormatterLongStyle timeStyle:NSDateFormatterLongStyle];
}

- (NSString *)longTimeString {
    return [self stringWithDateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterLongStyle];
}

- (NSString *)longDateString {
    return [self stringWithDateStyle:NSDateFormatterLongStyle timeStyle:NSDateFormatterNoStyle];
}

- (NSString *)formatTimeStr {
    NSString * str = nil;
    if (self.isToday) {
        NSDate *currentDate = [NSDate date];
        NSTimeInterval seconds = [currentDate timeIntervalSinceDate:self];
        if (seconds < 60) {
            str = @"刚刚";
        } else if (seconds < 60 * 60) {
            str = [NSString stringWithFormat:@"%ld%@", (long) (seconds / 60), @"分钟之前"];
        } else {
            str = [NSString stringWithFormat:@"%@%d%@%d%@", @"今天", self.hour, @"时", self.minute, @"分"];
        }
    } else if (self.isYesterday) {
        str = [NSString stringWithFormat:@"%@%d%@%d%@", @"昨天", self.hour, @"时", self.minute, @"分"];
    } else {
        str = [self stringWithFormat:@"yyyy-MM-dd HH:mm"];
    }
    return str;
}

#pragma mark - Comparing Dates

- (BOOL)isEqualToDateIgnoringTime:(NSDate *)aDate {
    NSDateComponents *components1 = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    NSDateComponents *components2 = [[NSDate currentCalendar] components:componentFlags fromDate:aDate];
    return ((components1.year == components2.year) &&
            (components1.month == components2.month) &&
            (components1.day == components2.day));
}

- (BOOL)isToday {
    return [self isEqualToDateIgnoringTime:[NSDate date]];
}

- (BOOL)isTomorrow {
    return [self isEqualToDateIgnoringTime:[NSDate dateTomorrow]];
}

- (BOOL)isYesterday {
    return [self isEqualToDateIgnoringTime:[NSDate dateYesterday]];
}

- (BOOL) isTheDayBeforeYesterday {
    return [self isEqualToDateIgnoringTime:[NSDate dateWithDaysBeforeNow:2]];
}

// This hard codes the assumption that a week is 7 days
- (BOOL)isSameWeekAsDate:(NSDate *)aDate {
    NSDateComponents *components1 = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    NSDateComponents *components2 = [[NSDate currentCalendar] components:componentFlags fromDate:aDate];

    // Must be same week. 12/31 and 1/1 will both be week "1" if they are in the same week
    if (components1.week != components2.week) return NO;

    // Must have a time interval under 1 week. Thanks @aclark
    return (abs((int) [self timeIntervalSinceDate:aDate]) < D_WEEK);
}

- (BOOL)isThisWeek {
    return [self isSameWeekAsDate:[NSDate date]];
}

- (BOOL)isNextWeek {
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_WEEK;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return [self isSameWeekAsDate:newDate];
}

- (BOOL)isLastWeek {
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_WEEK;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return [self isSameWeekAsDate:newDate];
}

// Thanks, mspasov
- (BOOL)isSameMonthAsDate:(NSDate *)aDate {
    NSDateComponents *components1 = [[NSDate currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:self];
    NSDateComponents *components2 = [[NSDate currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:aDate];
    return ((components1.month == components2.month) &&
            (components1.year == components2.year));
}

- (BOOL)isThisMonth {
    return [self isSameMonthAsDate:[NSDate date]];
}

// Thanks Marcin Krzyzanowski, also for adding/subtracting years and months
- (BOOL)isLastMonth {
    return [self isSameMonthAsDate:[[NSDate date] dateBySubtractingMonths:1]];
}

- (BOOL)isNextMonth {
    return [self isSameMonthAsDate:[[NSDate date] dateByAddingMonths:1]];
}

- (BOOL)isSameYearAsDate:(NSDate *)aDate {
    NSDateComponents *components1 = [[NSDate currentCalendar] components:NSYearCalendarUnit fromDate:self];
    NSDateComponents *components2 = [[NSDate currentCalendar] components:NSYearCalendarUnit fromDate:aDate];
    return (components1.year == components2.year);
}

- (BOOL)isThisYear {
    // Thanks, baspellis
    return [self isSameYearAsDate:[NSDate date]];
}

- (BOOL)isNextYear {
    NSDateComponents *components1 = [[NSDate currentCalendar] components:NSYearCalendarUnit fromDate:self];
    NSDateComponents *components2 = [[NSDate currentCalendar] components:NSYearCalendarUnit fromDate:[NSDate date]];

    return (components1.year == (components2.year + 1));
}

- (BOOL)isLastYear {
    NSDateComponents *components1 = [[NSDate currentCalendar] components:NSYearCalendarUnit fromDate:self];
    NSDateComponents *components2 = [[NSDate currentCalendar] components:NSYearCalendarUnit fromDate:[NSDate date]];

    return (components1.year == (components2.year - 1));
}

- (BOOL)isEarlierThanDate:(NSDate *)aDate {
    return ([self compare:aDate] == NSOrderedAscending);
}

- (BOOL)isLaterThanDate:(NSDate *)aDate {
    return ([self compare:aDate] == NSOrderedDescending);
}

// Thanks, markrickert
- (BOOL)isInFuture {
    return ([self isLaterThanDate:[NSDate date]]);
}

// Thanks, markrickert
- (BOOL)isInPast {
    return ([self isEarlierThanDate:[NSDate date]]);
}


#pragma mark - Roles

- (BOOL)isTypicallyWeekend {
    NSDateComponents *components = [[NSDate currentCalendar] components:NSWeekdayCalendarUnit fromDate:self];
    return (components.weekday == 1) ||
            (components.weekday == 7);
}

- (BOOL)isTypicallyWorkday {
    return ![self isTypicallyWeekend];
}

#pragma mark - Adjusting Dates

// Thaks, rsjohnson
- (NSDate *)dateByAddingYears:(NSInteger)dYears {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setYear:dYears];
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

- (NSDate *)dateBySubtractingYears:(NSInteger)dYears {
    return [self dateByAddingYears:-dYears];
}

- (NSDate *)dateByAddingMonths:(NSInteger)dMonths {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setMonth:dMonths];
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

- (NSDate *)dateBySubtractingMonths:(NSInteger)dMonths {
    return [self dateByAddingMonths:-dMonths];
}

// Courtesy of dedan who mentions issues with Daylight Savings
- (NSDate *)dateByAddingDays:(NSInteger)dDays {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:dDays];
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

- (NSDate *)dateBySubtractingDays:(NSInteger)dDays {
    return [self dateByAddingDays:(dDays * -1)];
}

- (NSDate *)dateByAddingHours:(NSInteger)dHours {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_HOUR * dHours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *)dateBySubtractingHours:(NSInteger)dHours {
    return [self dateByAddingHours:(dHours * -1)];
}

- (NSDate *)dateByAddingMinutes:(NSInteger)dMinutes {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_MINUTE * dMinutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *)dateBySubtractingMinutes:(NSInteger)dMinutes {
    return [self dateByAddingMinutes:(dMinutes * -1)];
}

- (NSDateComponents *)componentsWithOffsetFromDate:(NSDate *)aDate {
    NSDateComponents *dTime = [[NSDate currentCalendar] components:componentFlags fromDate:aDate toDate:self options:0];
    return dTime;
}

#pragma mark - Extremes

- (NSDate *)dateAtStartOfDay {
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    return [[NSDate currentCalendar] dateFromComponents:components];
}

// Thanks gsempe & mteece
- (NSDate *)dateAtEndOfDay {
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    components.hour = 23; // Thanks Aleksey Kononov
    components.minute = 59;
    components.second = 59;
    return [[NSDate currentCalendar] dateFromComponents:components];
}

#pragma mark - Retrieving Intervals

- (NSInteger)minutesAfterDate:(NSDate *)aDate {
    NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
    return (NSInteger) (ti / D_MINUTE);
}

- (NSInteger)minutesBeforeDate:(NSDate *)aDate {
    NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
    return (NSInteger) (ti / D_MINUTE);
}

- (NSInteger)hoursAfterDate:(NSDate *)aDate {
    NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
    return (NSInteger) (ti / D_HOUR);
}

- (NSInteger)hoursBeforeDate:(NSDate *)aDate {
    NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
    return (NSInteger) (ti / D_HOUR);
}

- (NSInteger)daysAfterDate:(NSDate *)aDate {
    NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
    return (NSInteger) (ti / D_DAY);
}

- (NSInteger)daysBeforeDate:(NSDate *)aDate {
    NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
    return (NSInteger) (ti / D_DAY);
}

// Thanks, dmitrydims
// I have not yet thoroughly tested this
- (NSInteger)distanceInDaysToDate:(NSDate *)anotherDate {
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit fromDate:self toDate:anotherDate options:0];
    return components.day;
}

#pragma mark - Decomposing Dates

- (NSInteger)nearestHour {
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_MINUTE * 30;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    NSDateComponents *components = [[NSDate currentCalendar] components:NSHourCalendarUnit fromDate:newDate];
    return components.hour;
}

- (NSInteger)hour {
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.hour;
}

- (NSInteger)minute {
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.minute;
}

- (NSInteger)seconds {
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.second;
}

- (NSInteger)day {
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.day;
}

- (NSInteger)month {
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.month;
}

- (NSInteger)week {
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.week;
}

- (NSInteger)weekday {
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.weekday;
}

- (NSInteger)nthWeekday // e.g. 2nd Tuesday of the month is 2
{
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.weekdayOrdinal;
}

- (NSInteger)year {
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.year;
}

- (NSString *)localDateTime {
    NSDateFormatter *dateFormatter = [[self class] dateFormatter];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * result = [dateFormatter stringFromDate:self];
    return result;
}

@end