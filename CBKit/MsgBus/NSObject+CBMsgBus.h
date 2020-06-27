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


/// 订阅协议
/// @param protocol <#protocol description#>
- (BOOL)msgbus_subscribeProtocol:(Protocol *)protocol;

@end

NS_ASSUME_NONNULL_END
