//
//  CBMsgBus.h
//  CBKit
//
//  Created by 李笑清 on 2020/6/27.
//  Copyright © 2020 李笑清. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBMsgBus : NSObject

+ (instancetype)sharedInstance;

/// 订阅某个协议的消息
/// @param delg 订阅者
/// @param protocol 协议
- (void)subscribe:(id)delg forProtocol:(Protocol *)protocol;


/// 向消息总线 分发某协议的消息
/// @param protocol 协议
/// @param sel 通过协议中的某个函数进行分发，不定参数传值
- (void)dispatchProtocol:(Protocol *)protocol selector:(SEL)sel,... NS_REQUIRES_NIL_TERMINATION ;

@end

NS_ASSUME_NONNULL_END
