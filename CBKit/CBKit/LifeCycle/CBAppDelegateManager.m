//
//  CBAppDelegateManager.m
//  CBKit
//
//  Created by 李笑清 on 2020/6/27.
//  Copyright © 2020 李笑清. All rights reserved.
//

#import "CBAppDelegateManager.h"
#import <objc/runtime.h>

static NSArray<Class> *findSubClass(Class defaultClass){
    int count = objc_getClassList(NULL,0);
    if (count <= 0) {
        return [NSArray array];
    }
    NSMutableArray *output = [NSMutableArray arrayWithObject:defaultClass];
    Class *classes = (Class *)malloc(sizeof(Class) * count);
    objc_getClassList(classes, count);
    for (int i = 0; i < count; i++) {
        if (defaultClass == class_getSuperclass(classes[i])) {
            [output addObject:classes[i]];
        }
    }
    free(classes);
    return output;
}

static NSArray<Class> *findAppDelegates(){
    static NSArray *delegates = nil;
    if (!delegates) {
        delegates = findSubClass([CBAppDelegate class]);
    }
    return delegates;
}


@interface CBAppDelegateManager ()

@property (nonatomic,strong)NSArray<CBAppDelegate *> *appDelegates;

@end

@implementation CBAppDelegateManager
@synthesize window = _window;

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

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(nullable NSDictionary<UIApplicationLaunchOptionsKey, id> *)launchOptions{
    __block BOOL result = YES;
    [self.appDelegates enumerateObjectsUsingBlock:^(CBAppDelegate * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj respondsToSelector:@selector(application:willFinishLaunchingWithOptions:)]) {
            BOOL state = [obj application:application willFinishLaunchingWithOptions:launchOptions];
            if ([obj.class isLauncher]) {
                 result = state;
             }
        }
    }];
    return result;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(nullable NSDictionary<UIApplicationLaunchOptionsKey, id> *)launchOptions{
    [self.appDelegates enumerateObjectsUsingBlock:^(CBAppDelegate * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj respondsToSelector:@selector(application:beforeDidFinishLaunchingWithOptions:)]) {
            [obj application:application beforeDidFinishLaunchingWithOptions:launchOptions];
        }
    }];
    
    //bootloader
    [self bootloader];
    
    __block BOOL result = YES;
    [self.appDelegates enumerateObjectsUsingBlock:^(CBAppDelegate * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj respondsToSelector:@selector(application:didFinishLaunchingWithOptions:)]) {
            BOOL state = [obj application:application didFinishLaunchingWithOptions:launchOptions];
            if ([[obj class] isLauncher]) {
                result = state;
            }
        }
    }];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.appDelegates enumerateObjectsUsingBlock:^(CBAppDelegate * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj respondsToSelector:@selector(application:afterDidFinishLaunchingWithOptions:)]) {
                [obj application:application afterDidFinishLaunchingWithOptions:launchOptions];
            }
        }];
    });
    return result;
}


- (void)bootloader{
    
}


/*
 * 以下是转发到各模块分支去
 *
 */
#pragma mark - forwarding methods
- (BOOL)respondsToSelector:(SEL)aSelector {
    BOOL superResponds = [super respondsToSelector:aSelector];
    for (CBAppDelegate *delegate in self.appDelegates) {
        if ([delegate respondsToSelector:aSelector]) {
            return YES;
        }
    }
    return superResponds;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *signature = nil;
    for (CBAppDelegate *delegate in self.appDelegates) {
        if ([delegate respondsToSelector:aSelector]) {
            signature = [(NSObject *)delegate methodSignatureForSelector:aSelector];
            break;
        }
    }
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    for (CBAppDelegate *delegate in self.appDelegates) {
        if ([delegate respondsToSelector:anInvocation.selector]) {
            [anInvocation invokeWithTarget:delegate];
        }

    }
}

- (NSArray<CBAppDelegate *> *)appDelegates{
    if (!_appDelegates) {
        NSArray<Class> *modules = findAppDelegates();
        __block int fls = 0;
        NSMutableArray<CBAppDelegate *> *delegates = [NSMutableArray arrayWithCapacity:modules.count];
        [modules enumerateObjectsUsingBlock:^(Class  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CBAppDelegate *delegate = [[[obj class] alloc] init];
            [delegates addObject:delegate];
            if ([obj isLauncher]) {
                fls++;
            }
        }];
        if (fls > 1) {
            NSAssert(NO, @"设置了多个launcher");
        }
        if(fls < 1){
            NSAssert(NO, @"未设置launcher");
        }
        _appDelegates = delegates;
    }
    return _appDelegates;
}

@end



