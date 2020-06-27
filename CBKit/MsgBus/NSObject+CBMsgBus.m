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
    if ([self conformsToProtocol:protocol]) {
        [[CBMsgBus sharedInstance] subscribe:self forProtocol:protocol];
        return YES;
    }else{
        NSLog(@"订阅协议失败");
        return NO;
    }
}

@end
