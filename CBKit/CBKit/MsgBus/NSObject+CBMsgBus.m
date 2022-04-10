//
//  NSObject+CBMsgBus.m
//  CBKit
//
//  Created by 李笑清 on 2020/6/27.
//  Copyright © 2020 李笑清. All rights reserved.
//

#import "NSObject+CBMsgBus.h"
#import "CBMsgBus.h"

@implementation NSObject (CBMsgBus)

- (BOOL)msgbus_subscribeProtocol:(Protocol *)protocol{
    return [[CBMsgBus sharedInstance] subscribe:self forProtocol:protocol];
}

- (void)msgBus_cancelSubscribeProtocol:(Protocol *)protocol{
    [[CBMsgBus sharedInstance] cancelSubscribe:self forProtocol:protocol];
}

- (void)msgbus_dispatchProtocol:(Protocol *)protocol selector:(SEL)sel,... NS_REQUIRES_NIL_TERMINATION {
    va_list arguments;
    va_start(arguments,sel);
    [[CBMsgBus sharedInstance] dispatchProtocol:protocol selector:sel arguments:arguments];
    va_end(arguments);
}

- (void)msgbus_dispatchProtocol:(Protocol *)protocol selector:(SEL)sel arguments:(va_list)arguments{
    [[CBMsgBus sharedInstance] dispatchProtocol:protocol selector:sel arguments:arguments];
}

@end
