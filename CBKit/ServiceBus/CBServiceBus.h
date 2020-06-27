//
//  CBServiceBus.h
//  CBKit
//
//  Created by 李笑清 on 2020/6/27.
//  Copyright © 2020 李笑清. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBServiceBus : NSObject

+ (instancetype)sharedInstance;

/// 通过协议获取服务类
/// @param protocol <#protocol description#>
- (Class)classForProtocol:(Protocol *)protocol;


/// 注册服务，注册后服务可以被他人引用
/// @param cls <#cls description#>
/// @param protocol <#protocol description#>
- (void)registerClass:(Class)cls forProtocol:(Protocol *)protocol;


/// 取消注册，取消注册后，服务不再公开
/// @param protocol <#protocol description#>
- (void)unregisterProtocol:(Protocol *)protocol;

@end

NS_ASSUME_NONNULL_END
