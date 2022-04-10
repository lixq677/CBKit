//
//  CBMsgBus.m
//  CBKit
//
//  Created by 李笑清 on 2020/6/27.
//  Copyright © 2020 李笑清. All rights reserved.
//

#import "CBMsgBus.h"
#import "CBWeakDelegate.h"
//#include <stdarg.h>

@import UIKit;

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


- (BOOL)subscribe:(id)delg forProtocol:(Protocol *)protocol{
    if (delg == nil ||  [delg conformsToProtocol:protocol] == NO){
        return NO;
    }
    NSString *key = NSStringFromProtocol(protocol);
    CBWeakDelegate *delegate = [self.delegates objectForKey:key];
    if (delegate == nil) {
        delegate = [[CBWeakDelegate alloc] init];
        [self.delegates setObject:delegate forKey:key];
    }
    [delegate addDelegate:delg];
    
    NSMutableArray<NSString *> *keys = [NSMutableArray array];
    [self.delegates enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, CBWeakDelegate * _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj.count == 0) {
            [keys addObject:key];
        }
    }];
    [keys enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.delegates removeObjectForKey:obj];
    }];
    return YES;
}

- (void)cancelSubscribe:(id)delg forProtocol:(Protocol *)protocol{
    if (delg == nil)return;
    NSString *key = NSStringFromProtocol(protocol);
    CBWeakDelegate *delegate = [self.delegates objectForKey:key];
    if (delegate) {
        [delegate removeDelegate:delg];
    }
    if(delegate.count == 0){
        [self.delegates removeObjectForKey:key];
    }
}



- (void)dispatchProtocol:(Protocol *)protocol selector:(SEL)sel,...NS_REQUIRES_NIL_TERMINATION{
    va_list argList;
    va_start(argList, sel);
    [self dispatchProtocol:protocol selector:sel arguments:argList];
    va_end(argList);
}

- (void)dispatchProtocol:(Protocol *)protocol selector:(SEL)sel arguments:(va_list)arguments{
    NSString *key = NSStringFromProtocol(protocol);
    CBWeakDelegate *delegate = [self.delegates objectForKey:key];
    if (delegate == nil) {
        return;
    }
    NSMutableArray<NSInvocation *> *invocations = [NSMutableArray array];
    [delegate enumerateUsingBlock:^(id  _Nonnull delegate) {
        NSMethodSignature *signature = [delegate methodSignatureForSelector:sel];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        invocation.target = delegate;
        invocation.selector = sel;
//        va_list argList;
//        va_copy(argList,arguments);
//        [self invocation:invocation setArgument:argList];
//        va_end(argList);
        [invocations addObject:invocation];

    } respond:sel];
    
    /*设置参数*/
    [self invocations:invocations setArgument:arguments];
    
    [invocations enumerateObjectsUsingBlock:^(NSInvocation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj invoke];
    }];
}


- (void)invocations:(NSArray<NSInvocation *> *)invocations setArgument:(va_list)arguments{
    NSInvocation *invocation = [invocations firstObject];
    NSMethodSignature *signature = [invocation methodSignature];
    NSUInteger count = [signature numberOfArguments];
    if (count <= 2) return;
    int i = 2;
    do{
        const char *type = [signature getArgumentTypeAtIndex:i];
        if ((strcmp(type, @encode(double)) == 0) || (strcmp(type, @encode(float)) == 0)){
            double temp = va_arg(arguments, double);
            [invocations enumerateObjectsUsingBlock:^(NSInvocation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [obj setArgument:(void *)&temp atIndex:i];
            }];

        }else if ((strcmp(type, @encode(unsigned int)) == 0) || (strcmp(type, @encode(unsigned char)) == 0) || (strcmp(type, @encode(unsigned short)) == 0)){
            unsigned int temp = (unsigned int)va_arg(arguments, unsigned int);
            [invocations enumerateObjectsUsingBlock:^(NSInvocation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [obj setArgument:(void *)&temp atIndex:i];
            }];

        }else if ((strcmp(type, @encode(int)) == 0) || (strcmp(type, @encode(short)) == 0) || (strcmp(type, @encode(char)) == 0) || (strcmp(type, @encode(bool)) == 0) || (strcmp(type, @encode(BOOL)) == 0)){
            int temp = va_arg(arguments, int);
            [invocations enumerateObjectsUsingBlock:^(NSInvocation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [obj setArgument:(void *)&temp atIndex:i];
            }];
        }else if (strcmp(type, @encode(long)) == 0){
            long temp = va_arg(arguments, long);
            [invocations enumerateObjectsUsingBlock:^(NSInvocation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [obj setArgument:(void *)&temp atIndex:i];
            }];
        }else if (strcmp(type, @encode(unsigned long)) == 0){
            unsigned long temp = (unsigned long)va_arg(arguments, unsigned long);
            [invocations enumerateObjectsUsingBlock:^(NSInvocation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [obj setArgument:(void *)&temp atIndex:i];
            }];
        }else if (strcmp(type, @encode(long long)) == 0){
            long long temp = va_arg(arguments, long long);
            [invocations enumerateObjectsUsingBlock:^(NSInvocation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [obj setArgument:(void *)&temp atIndex:i];
            }];
        }else if (strcmp(type, @encode(unsigned long long)) == 0){
            unsigned long long temp = (unsigned long long)va_arg(arguments, unsigned long long);
            [invocations enumerateObjectsUsingBlock:^(NSInvocation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [obj setArgument:(void *)&temp atIndex:i];
            }];
        }else if (strcmp(type, @encode(SEL)) == 0){
            SEL temp = va_arg(arguments, SEL);
            if (temp){
                [invocations enumerateObjectsUsingBlock:^(NSInvocation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [obj setArgument:(void *)&temp atIndex:i];
                }];
            }
        }else if (strcmp(type, @encode(IMP)) == 0){
            IMP temp = va_arg(arguments, IMP);
            if (temp){
                [invocations enumerateObjectsUsingBlock:^(NSInvocation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [obj setArgument:(void *)&temp atIndex:i];
                }];
            }
        }else if (strcmp(type, @encode(Class)) == 0){
            Class temp = va_arg(arguments, Class);
            if (temp){
                [invocations enumerateObjectsUsingBlock:^(NSInvocation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [obj setArgument:(void *)&temp atIndex:i];
                }];
            }
        }else if (strncmp(type, "@", 1) == 0){
            id temp = va_arg(arguments, id);
            if (temp){
                [invocations enumerateObjectsUsingBlock:^(NSInvocation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [obj setArgument:(void *)&temp atIndex:i];
                }];
            }
        }else if (strncmp(type, "{", 1) == 0){
            if (strcmp(type, @encode(CGPoint)) == 0){
                CGPoint temp = (CGPoint)va_arg(arguments, CGPoint);
                [invocations enumerateObjectsUsingBlock:^(NSInvocation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [obj setArgument:(void *)&temp atIndex:i];
                }];
            } else if (strcmp(type, @encode(CGSize)) == 0){
                CGSize temp = (CGSize)va_arg(arguments, CGSize);
                [invocations enumerateObjectsUsingBlock:^(NSInvocation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [obj setArgument:(void *)&temp atIndex:i];
                }];
            }else if (strcmp(type, @encode(UIEdgeInsets)) == 0){
                UIEdgeInsets temp = (UIEdgeInsets)va_arg(arguments, UIEdgeInsets);
                [invocations enumerateObjectsUsingBlock:^(NSInvocation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [obj setArgument:(void *)&temp atIndex:i];
                }];
            }else if (strcmp(type, @encode(CGRect)) == 0){
                CGRect temp = (CGRect)va_arg(arguments, CGRect);
                [invocations enumerateObjectsUsingBlock:^(NSInvocation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [obj setArgument:(void *)&temp atIndex:i];
                }];
            }else if (strcmp(type, @encode(NSRange)) == 0){
                NSRange temp = (NSRange)va_arg(arguments, NSRange);
                [invocations enumerateObjectsUsingBlock:^(NSInvocation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [obj setArgument:(void *)&temp atIndex:i];
                }];
            }else if (strcmp(type, @encode(CGVector)) == 0){
                CGVector temp = (CGVector)va_arg(arguments, CGVector);
                [invocations enumerateObjectsUsingBlock:^(NSInvocation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [obj setArgument:(void *)&temp atIndex:i];
                }];
            }else if (strcmp(type, @encode(UIOffset)) == 0){
                UIOffset temp = (UIOffset)va_arg(arguments, UIOffset);
                [invocations enumerateObjectsUsingBlock:^(NSInvocation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [obj setArgument:(void *)&temp atIndex:i];
                }];
            }else if (strcmp(type, @encode(CGAffineTransform)) == 0){
                CGAffineTransform temp = (CGAffineTransform)va_arg(arguments, CGAffineTransform);
                [invocations enumerateObjectsUsingBlock:^(NSInvocation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [obj setArgument:(void *)&temp atIndex:i];
                }];
            }else{
                do {
                    if (@available(iOS 11.0, *)) {
                        if (strcmp(type, @encode(NSDirectionalEdgeInsets)) == 0){
                            NSDirectionalEdgeInsets temp = (NSDirectionalEdgeInsets)va_arg(arguments, NSDirectionalEdgeInsets);
                            [invocations enumerateObjectsUsingBlock:^(NSInvocation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                [obj setArgument:(void *)&temp atIndex:i];
                            }];
                            break;
                        }
                    }
                    id obj = va_arg(arguments, id);
                    NSValue *value = (NSValue *)obj;
                    void *temp = alloca(sizeof(void *));
                    if (temp != NULL){
                        [value getValue:temp];
                        [invocations enumerateObjectsUsingBlock:^(NSInvocation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            [obj setArgument:(void *)&temp atIndex:i];
                        }];
                    }
                } while (0);
                
            }
    }else{
            void *temp = va_arg(arguments, void *);
            if (temp){
                [invocations enumerateObjectsUsingBlock:^(NSInvocation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [obj setArgument:(void *)&temp atIndex:i];
                }];
            }
        }
        ++i;
    } while(i < count);
}


#pragma mark getter or setter
- (NSMutableDictionary<NSString *,CBWeakDelegate *> *)delegates{
    if (!_delegates) {
        _delegates = [NSMutableDictionary dictionary];
    }
    return _delegates;
}


@end
