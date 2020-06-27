//
//  CBAppDelegateManager.m
//  CBKit
//
//  Created by 李笑清 on 2020/6/27.
//  Copyright © 2020 李笑清. All rights reserved.
//

#import "CBAppDelegateManager.h"

@interface CBAppDelegateManager ()

@property (nonatomic,strong)NSMutableArray<id<UIApplicationDelegate>> *modules;

@end

@implementation CBAppDelegateManager


//实现单例接管APP Delegate
static CBAppDelegateManager *instance = nil;
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


/*
 * 以下是转发到各模块分支去
 *
 */
#pragma mark - forwarding methods
- (BOOL)respondsToSelector:(SEL)aSelector {
    BOOL superResponds = [super respondsToSelector:aSelector];
    for (id<UIApplicationDelegate> module in self.modules) {
        if ([module respondsToSelector:aSelector]) {
            if (superResponds) {
                NSLog(@"%s 需要默认实现的方法:%@", __PRETTY_FUNCTION__, NSStringFromSelector(aSelector));
            }
            return YES;
        }
    }
    return superResponds;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *signature;
    for (id<UIApplicationDelegate> module in self.modules) {
        if ([module respondsToSelector:aSelector]) {
            signature = [(NSObject *)module methodSignatureForSelector:aSelector];
            break;
        }
    }
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    for (id<UIApplicationDelegate> module in self.modules) {
        if ([module respondsToSelector:anInvocation.selector]) {
            [anInvocation invokeWithTarget:module];
        }
    }
}




- (void)addDelegate:(id<UIApplicationDelegate>)delegate{
    if ([self.modules containsObject:delegate]) {
        return;
    }
    [self.modules addObject:delegate];
    [self.modules sortUsingDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"priority" ascending:NO]]];
}


- (NSMutableArray<id<UIApplicationDelegate>> *)modules{
    if (!_modules) {
        _modules = [NSMutableArray array];
    }
    return _modules;
}

@end
