//
//  NSObject+CBMsgBus.h
//  CBKit
//
//  Created by 李笑清 on 2020/6/27.
//  Copyright © 2020 李笑清. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (CBMsgBus)

/// 分发消息
/// @param protocol 协议
/// @param sel 消息
- (void)msgbus_dispatchProtocol:(Protocol *)protocol selector:(SEL)sel,... NS_REQUIRES_NIL_TERMINATION ;


/// 分发消息
/// @param protocol <#protocol description#>
/// @param sel <#sel description#>
/// @param arguments <#arguments description#>
- (void)msgbus_dispatchProtocol:(Protocol *)protocol selector:(SEL)sel arguments:(va_list)arguments;

/// 订阅协议
/// @param protocol <#protocol description#>
- (BOOL)msgbus_subscribeProtocol:(Protocol *)protocol;


/// 取消订阅协议
/// @param protocol <#protocol description#>
- (void)msgBus_cancelSubscribeProtocol:(Protocol *)protocol;

@end

NS_ASSUME_NONNULL_END
