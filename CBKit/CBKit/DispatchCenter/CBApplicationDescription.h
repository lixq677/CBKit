//
//  CBApplicationDescription.h
//  CBKit
//
//  Created by 李笑清 on 2020/6/29.
//  Copyright © 2020 李笑清. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBApplicationDescription : NSObject

/// 微应用名称，独一无二,为key
@property (nonatomic,copy)NSString *appName;

//加载首页
@property (nonatomic,copy)NSString *routerLauncer;

//预启动的跳转页面
@property (nonatomic,copy)NSString *toUrl;

/// app delegate
@property (nonatomic,strong)Class appDelegate;

/// 传递参数
@property (nonatomic,strong)NSDictionary *params;

/// 是否是APP启动的launcer
@property (nonatomic,assign,getter=isLauncer)BOOL launcer;

@end

NS_ASSUME_NONNULL_END
