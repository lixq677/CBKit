//
//  CBRouter.m
//  CBKit
//
//  Created by 李笑清 on 2020/6/27.
//  Copyright © 2020 李笑清. All rights reserved.
//

#import "CBRouter.h"
#import <MGJRouter/MGJRouter.h>

@implementation CBRouter

+ (void)registerURLPattern:(NSString *)URLPattern toHandler:(void(^)(NSString *URL,NSDictionary *parameters))handler{
    void(^mgjHandler)(NSDictionary *params) = ^(NSDictionary *params){
        NSString *url = [params objectForKey:MGJRouterParameterURL];
        NSDictionary *parameters = [params objectForKey:MGJRouterParameterUserInfo];
        handler(url,parameters);
    };
    [MGJRouter registerURLPattern:URLPattern toHandler:mgjHandler];
}

+ (void)registerURLPattern:(NSString *)URLPattern toObjectHandler:(id (^)(NSString *URL,NSDictionary *parameters))handler{
    id(^mgjHandler)(NSDictionary *params) = ^id(NSDictionary *params){
        NSString *url = [params objectForKey:MGJRouterParameterURL];
        NSDictionary *parameters = [params objectForKey:MGJRouterParameterUserInfo];
        return handler(url,parameters);
    };
    [MGJRouter registerURLPattern:URLPattern toObjectHandler:mgjHandler];
}

+ (void)deregisterURLPattern:(NSString *)URLPattern{
    [MGJRouter deregisterURLPattern:URLPattern];
}

+ (void)openURL:(NSString *)URL{
    [self openURL:URL params:nil completion:nil];
}

+ (void)openURL:(NSString *)URL completion:(void (^)(id result))completion{
    [self openURL:URL params:nil completion:completion];
}

+ (void)openURL:(NSString *)URL params:(NSDictionary *)params{
    [self openURL:URL params:params completion:nil];
}

+ (void)openURL:(NSString *)URL params:(NSDictionary *)params completion:(void (^)(id result))completion{
    if ([self canOpenURL:URL]) {
        [MGJRouter openURL:URL withUserInfo:params completion:completion];
    }else{
        //打开网页
    }
}

+ (id)objectForURL:(NSString *)URL{
    return [MGJRouter objectForURL:URL];
}

+ (id)objectForURL:(NSString *)URL withUserInfo:(NSDictionary *)userInfo{
    return [MGJRouter objectForURL:URL withUserInfo:userInfo];
}

+ (BOOL)canOpenURL:(NSString *)URL{
    return [MGJRouter canOpenURL:URL];
}
+ (BOOL)canOpenURL:(NSString *)URL matchExactly:(BOOL)exactly{
    return [MGJRouter canOpenURL:URL matchExactly:exactly];
}

+ (NSString *)generateURLWithPattern:(NSString *)pattern parameters:(NSArray *)parameters{
    return [MGJRouter generateURLWithPattern:pattern parameters:parameters];
}

@end
