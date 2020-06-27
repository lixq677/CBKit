//
//  CBMsgBus.m
//  CBKit
//
//  Created by 李笑清 on 2020/6/27.
//  Copyright © 2020 李笑清. All rights reserved.
//

#import "CBMsgBus.h"
#import "CBWeakDelegate.h"

@interface CBMsgBus ()

@property (nonatomic,strong)NSMutableDictionary<NSString *,CBWeakDelegate *> *delegates;

@end

@implementation CBMsgBus

//实现单例
static CBMsgBus *instance = nil;
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}

- (id)copy{
    return instance;
}

- (id)mutableCopy{
    return instance;
}


- (void)subscribe:(id)delg forProtocol:(Protocol *)protocol{
    NSString *key = NSStringFromProtocol(protocol);
    CBWeakDelegate *delegate = [self.delegates objectForKey:key];
    if (delegate == nil) {
        delegate = [[CBWeakDelegate alloc] init];
        [self.delegates setObject:delegate forKey:key];
    }
    [delegate addDelegate:delg];
}



- (void)dispatchProtocol:(Protocol *)protocol selector:(SEL)sel,...NS_REQUIRES_NIL_TERMINATION{
    NSString *key = NSStringFromProtocol(protocol);
    CBWeakDelegate *delegate = [self.delegates objectForKey:key];
    if (delegate == nil) {
        return;
    }
    NSMutableArray<NSInvocation *> *invocations = [NSMutableArray array];
    [delegate enumerateWithBlock:^(id  _Nonnull delegate) {
        if ([delegate respondsToSelector:sel]) {
            NSMethodSignature *signature = [delegate instanceMethodSignatureForSelector:sel];
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
            invocation.target = delegate;
            invocation.selector = sel;
            [invocations addObject:invocation];
        }
    }];
    id eachObject = nil;
    va_list arguments;
    va_start(arguments,sel);
    
    int i = 2;
    while ((eachObject = va_arg(arguments, id))) {
        [invocations enumerateObjectsUsingBlock:^(NSInvocation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj setArgument:(void *)&eachObject atIndex:i];
        }];
        i++;
    }
    va_end(arguments);
}




#pragma mark getter or setter
- (NSMutableDictionary<NSString *,CBWeakDelegate *> *)delegates{
    if (!_delegates) {
        _delegates = [NSMutableDictionary dictionary];
    }
    return _delegates;
}


@end
