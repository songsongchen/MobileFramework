//  UIMobileFramework
//
//  Created by chenjs on 16/3/10.
//  Copyright © 2016年 songChen. All rights reserved.
//

#import "BaseUIView.h"

@implementation BaseUIView {

}
- (void)dealloc {
    DEBUG_LOG(@"%@ dealloc", NSStringFromClass([self class]));
}
@end

@implementation BaseUITableViewCell

- (void)dealloc {
    DEBUG_LOG(@"%@ dealloc", NSStringFromClass([self class]));
}

@end

@implementation BaseUICollectionViewCell

- (void)dealloc {
    DEBUG_LOG(@"%@ dealloc", NSStringFromClass([self class]));
}

@end