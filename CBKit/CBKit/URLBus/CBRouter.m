//
//  CBRouter.m
//  CBKit
//
//  Created by 李笑清 on 2020/6/27.
//  Copyright © 2020 李笑清. All rights reserved.
//

#import "CBRouter.h"
#import <MGJRouter/MGJRouter.h>

NSString *CBRouterParameterKey = @"CBRouterParameterKey";

@implementation CBRouterManager

static CBRouterManager *instance = nil;
+ (instancetype)defaultManager{
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

@end


@implementation CBRouter

+ (void)registerURLPattern:(NSString *)URLPattern toHandler:(void(^)(NSString *URL,NSDictionary *parameters))handler{
    void(^mgjHandler)(NSDictionary *params) = ^(NSDictionary *params){
        NSString *url = [params objectForKey:MGJRouterParameterURL];
        id userInfo = [params objectForKey:MGJRouterParameterUserInfo];
        void (^completion)(id result) = [params objectForKey:MGJRouterParameterCompletion];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:params];
        [parameters removeObjectForKey:MGJRouterParameterURL];
        [parameters removeObjectForKey:MGJRouterParameterUserInfo];
        [parameters removeObjectForKey:MGJRouterParameterCompletion];
        if (userInfo != nil) {
            if ([userInfo isKindOfClass:NSDictionary.class]) {
                [parameters addEntriesFromDictionary:userInfo];
            }else{
                [parameters setObject:userInfo forKey:CBRouterParameterKey];
            }
        }
        if (handler) {
            handler(url,parameters);
        }
        if (completion) {
            completion(nil);
        }
    };
    [MGJRouter registerURLPattern:URLPattern toHandler:mgjHandler];
}

+ (void)registerURLPattern:(NSString *)URLPattern toObjectHandler:(id (^)(NSString *URL,NSDictionary *parameters))handler{
    id(^mgjHandler)(NSDictionary *params) = ^id(NSDictionary *params){
        NSString *url = [params objectForKey:MGJRouterParameterURL];
        NSDictionary *userInfo = [params objectForKey:MGJRouterParameterUserInfo];
        void (^completion)(id result) = [params objectForKey:MGJRouterParameterCompletion];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:params];
        [parameters removeObjectForKey:MGJRouterParameterURL];
        [parameters removeObjectForKey:MGJRouterParameterUserInfo];
        [parameters removeObjectForKey:MGJRouterParameterCompletion];
        if (userInfo != nil) {
            if ([userInfo isKindOfClass:NSDictionary.class]) {
                [parameters addEntriesFromDictionary:userInfo];
            }else{
                [parameters setObject:userInfo forKey:CBRouterParameterKey];
            }
        }
        id result = nil;
        if(handler){
            result = handler(url,parameters);
        }
        if (completion) {
            completion(result);
        }
        return result;
    };
    [MGJRouter registerURLPattern:URLPattern toObjectHandler:mgjHandler];
}

+ (void)deregisterURLPattern:(NSString *)URLPattern{
    if(![URLPattern isKindOfClass:NSString.class] || URLPattern.length == 0)return;
    [MGJRouter deregisterURLPattern:URLPattern];
}

+ (void)openURL:(NSString *)URL{
    [self openURL:URL params:nil completion:nil];
}

+ (void)openURL:(NSString *)URL completion:(void (^)(id result))completion{
    [self openURL:URL params:nil completion:completion];
}


+ (void)openURL:(NSString *)URL params:(id)params{
    [self openURL:URL params:params completion:nil];
}

+ (void)openURL:(NSString *)URL params:(id)params completion:(void (^)(id result))completion{
    if(![URL isKindOfClass:NSString.class] || URL.length == 0)return;
    if ([[CBRouterManager defaultManager].delegate respondsToSelector:@selector(willOpenURLPattern:params:)]) {
        BOOL flag = [[CBRouterManager defaultManager].delegate willOpenURLPattern:URL params:params];
        if (flag == NO) return;
    }

    if ([self canOpenURL:URL]) {
        if (params == nil || [params isKindOfClass:NSDictionary.class]) {
            [MGJRouter openURL:URL withUserInfo:params completion:completion];
        }else{
            [MGJRouter openURL:URL withUserInfo:@{CBRouterParameterKey:params} completion:completion];
        }
        
    }else{
        if ([[CBRouterManager defaultManager].delegate respondsToSelector:@selector(failedOpenURLPattern:params:)]) {
            [[CBRouterManager defaultManager].delegate failedOpenURLPattern:URL params:params];
        }
    }
}



+ (id)objectForURL:(NSString *)URL{
    if(![URL isKindOfClass:NSString.class] || URL.length == 0)nil;
    return [MGJRouter objectForURL:URL];
}

+ (id)objectForURL:(NSString *)URL withUserInfo:(NSDictionary *)userInfo{
    if(![URL isKindOfClass:NSString.class] || URL.length == 0)nil;
    return [MGJRouter objectForURL:URL withUserInfo:userInfo];
}

+ (BOOL)canOpenURL:(NSString *)URL{
    if(![URL isKindOfClass:NSString.class] || URL.length == 0)NO;
    return [MGJRouter canOpenURL:URL];
}
+ (BOOL)canOpenURL:(NSString *)URL matchExactly:(BOOL)exactly{
    if(![URL isKindOfClass:NSString.class] || URL.length == 0)NO;
    return [MGJRouter canOpenURL:URL matchExactly:exactly];
}

+ (NSString *)generateURLWithPattern:(NSString *)pattern parameters:(NSArray *)parameters{
    if(![pattern isKindOfClass:NSString.class] || pattern.length == 0)nil;
    return [MGJRouter generateURLWithPattern:pattern parameters:parameters];
}

@end
