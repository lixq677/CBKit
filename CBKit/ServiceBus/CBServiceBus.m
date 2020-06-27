//
//  CBServiceBus.m
//  CBKit
//
//  Created by 李笑清 on 2020/6/27.
//  Copyright © 2020 李笑清. All rights reserved.
//

#import "CBServiceBus.h"

@interface CBServiceBus ()

@property (nonatomic,strong)NSMutableDictionary<NSString *,Class> *services;

@end

@implementation CBServiceBus

//实现单例
static CBServiceBus *instance = nil;
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


#pragma mark private methods

- (void)registerClass:(Class)cls forProtocol:(Protocol *)protocol{
    [self.services setObject:cls forKey:NSStringFromProtocol(protocol)];
}

- (void)unregisterProtocol:(Protocol *)protocol{
    [self.services removeObjectForKey:NSStringFromProtocol(protocol)];
}

- (Class)classForProtocol:(Protocol *)protocol{
    return [self.services objectForKey:NSStringFromProtocol(protocol)];
}


#pragma mark getter or setter
- (NSMutableDictionary<NSString *,Class> *)services{
    if (!_services) {
        _services = [NSMutableDictionary dictionary];
    }
    return _services;
}

@end
