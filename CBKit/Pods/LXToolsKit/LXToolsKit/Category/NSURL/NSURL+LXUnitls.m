//
//  NSURL+LXUnitls.m
//  LXCommonKit
//
//  Created by 李笑清 on 2020/6/11.
//  Copyright © 2020 李笑清. All rights reserved.
//

#import "NSURL+LXUnitls.h"

@implementation NSURL (LXUnitls)

- (NSDictionary *)params{
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    //传入url创建url组件类
    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:self.absoluteString];
    //回调遍历所有参数，添加入字典
    [urlComponents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [parm setObject:obj.value forKey:obj.name];
    }];
    return parm;
}

@end
