//
//
//

#import "BaseParaManager.h"


@implementation BaseParaManager {

}
// 工厂方法
+ (BaseParaManager *)sharedInstance {
    // 单例全局对象
    static BaseParaManager *baseParaManager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        baseParaManager = [[BaseParaManager alloc] init];
    });
    return baseParaManager;
}

@end