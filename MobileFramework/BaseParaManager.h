//
//
//

#import <Foundation/Foundation.h>

/**
 * 基础参数设置
 */
@interface BaseParaManager : NSObject

+ (BaseParaManager *)sharedInstance;

@property(nonatomic, assign) NSTimeInterval timeInterval; //服务器时间与本地时间差值
@property(nonatomic, assign) NSInteger  fixSyncDate;      //同步服务器上几天的数据

@property(nonatomic, assign) double currentBattery;       //当前系统电量

@end