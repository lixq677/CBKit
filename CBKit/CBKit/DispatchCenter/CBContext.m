//
//  CBContext.m
//  CBKit
//
//  Created by 李笑清 on 2020/6/29.
//  Copyright © 2020 李笑清. All rights reserved.
//

#import "CBContext.h"
#import "CBAppDelegate.h"
#import "CBRouter.h"

@import UIKit;

@interface CBContext ()

@property (nonatomic,strong)NSMutableDictionary<NSString *,CBServiceDescription *> *serviceDescs;

@property (nonatomic,strong)NSMutableDictionary<NSString *, id> *services;

@property (nonatomic,strong)NSMutableDictionary<NSString *, CBApplicationDescription *> *appDescriptions;

@end

@implementation CBContext

//实现单例
static CBContext *instance = nil;
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


- (BOOL)registerService:(CBServiceDescription *)serviceDescription{
    if (serviceDescription == nil) {
        return NO;
    }
    if (serviceDescription.protocol == nil) {
        return NO;
    }
    if (serviceDescription.impCls == NULL) {
        return NO;
    }
    if ([serviceDescription.impCls conformsToProtocol:serviceDescription.protocol] == NO || [serviceDescription.impCls conformsToProtocol:@protocol(CBService)] == NO) {
        return NO;
    }
    if ([self.serviceDescs objectForKey:NSStringFromProtocol(serviceDescription.protocol)]) {
        return NO;
    }
    [self.serviceDescs setObject:serviceDescription forKey:NSStringFromProtocol(serviceDescription.protocol)];
    if (serviceDescription.lazyLoading == NO) {
        id serviceImp = [[serviceDescription.impCls alloc] init];
        if ([serviceImp respondsToSelector:@selector(willCreate)]) {
            [serviceImp willCreate];
        }
        [self.services setObject:serviceImp forKey:NSStringFromProtocol(serviceDescription.protocol)];
        
        if ([serviceImp respondsToSelector:@selector(didCreate)]) {
            [serviceImp didCreate];
        }
        
        if ([serviceImp respondsToSelector:@selector(didStart)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [serviceImp didStart];
            });
        }

    }
    return YES;
}

- (void)unregisterServiceByProtocol:(Protocol *)protocol{
    if (protocol == nil) {
        return;
    }
    NSString *key = NSStringFromProtocol(protocol);
    CBServiceDescription *serviceDesc = [self.serviceDescs objectForKey:key];
    if (serviceDesc == nil) {
        return;
    }
    id<CBService> serviceImp = [self.services objectForKey:key];
    if (serviceImp) {
        if ([serviceImp respondsToSelector:@selector(willDestroy)]) {
            [serviceImp willDestroy];
        }
        [self.services removeObjectForKey:key];
    }
    [self.serviceDescs removeObjectForKey:key];
}



- (BOOL)recycleServiceByProtocol:(Protocol *)protocol{
    if (protocol == nil) {
        return NO;
    }
    NSString *key = NSStringFromProtocol(protocol);
    CBServiceDescription *desc = [self.serviceDescs objectForKey:key];
    if (desc.canRecycle == NO) {
        return NO;
    }
    id<CBService> serviceImp = [self.services objectForKey:key];
    if (serviceImp) {
        if ([serviceImp respondsToSelector:@selector(willDestroy)]) {
            [serviceImp willDestroy];
        }
        [self.services removeObjectForKey:key];
    }
    return YES;
}


- (id)findServiceByProtocol:(Protocol *)protocol{
    if (protocol == nil) {
        return nil;
    }
    NSString *key = NSStringFromProtocol(protocol);
    id<CBService> serviceImp = [self.services objectForKey:key];
    if (serviceImp) {
        return serviceImp;
    }
    CBServiceDescription *desc = [self.serviceDescs objectForKey:key];
    if (desc == nil) {
        return nil;
    }else{
        id serviceImp = [[desc.impCls alloc] init];
        if ([serviceImp respondsToSelector:@selector(willCreate)]) {
            [serviceImp willCreate];
        }
        [self.services setObject:serviceImp forKey:NSStringFromProtocol(desc.protocol)];
        if ([serviceImp respondsToSelector:@selector(didCreate)]) {
            [serviceImp didCreate];
        }
        if ([serviceImp respondsToSelector:@selector(didStart)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [serviceImp didStart];
            });
        }
        return serviceImp;
    }
}

- (BOOL)isExistServiceByProtocol:(Protocol *)protocol{
    NSString *key = NSStringFromProtocol(protocol);
    CBServiceDescription *desc = [self.serviceDescs objectForKey:key];
    return desc != nil;
}

- (BOOL)isStartServiceByProtocol:(Protocol *)protocol{
    NSString *key = NSStringFromProtocol(protocol);
    id<CBService> serviceImp = [self.services objectForKey:key];
    return serviceImp != nil;
}

- (BOOL)startApplication:(CBApplicationDescription *)applicationDescription animated:(BOOL)animated{
    if (applicationDescription.appName == nil) {
        return NO;
    }
    
    if (applicationDescription.routerLauncer == nil) {
        return NO;
    }
    
    if ([self.appDescriptions objectForKey:applicationDescription.appName]) {
        return NO;
    }
    
    if (applicationDescription.appDelegate != NULL) {
        if ([applicationDescription.appDelegate isKindOfClass:[CBAppDelegate class]] == NO) {
            return NO;
        }
    }
    
    id appDelegate = [[applicationDescription.appDelegate alloc] init];
    if ([appDelegate respondsToSelector:@selector(application:beforeDidFinishLaunchingWithOptions:)]) {
        [appDelegate application:[UIApplication sharedApplication] beforeDidFinishLaunchingWithOptions:@{}];
    }
    
    //跳转
    [CBRouter openURL:applicationDescription.routerLauncer params:applicationDescription.params];
    
    
    if ([appDelegate respondsToSelector:@selector(application:afterDidFinishLaunchingWithOptions:)]) {
        [appDelegate application:[UIApplication sharedApplication] afterDidFinishLaunchingWithOptions:@{}];
    }
    return YES;
}


- (NSMutableDictionary<NSString *,CBServiceDescription *> *)serviceDescs{
    if (!_serviceDescs) {
        _serviceDescs = [NSMutableDictionary dictionary];
    }
    return _serviceDescs;
}

- (NSMutableDictionary<NSString *, id> *)services{
    if (!_services) {
        _services = [NSMutableDictionary dictionary];
    }
    return _services;
}


@end

CBContext *CBContextGet(void){
    return [CBContext sharedInstance];
}

id CBContextGetService(Protocol *protocol){
    CBContext *context = CBContextGet();
    return [context findServiceByProtocol:protocol];
}
