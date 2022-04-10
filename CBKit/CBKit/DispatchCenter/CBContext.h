//
//  CBContext.h
//  CBKit
//
//  Created by 李笑清 on 2020/6/29.
//  Copyright © 2020 李笑清. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CBServiceDescription.h"
#import "CBApplicationDescription.h"

NS_ASSUME_NONNULL_BEGIN


@interface CBContext : NSObject

// 根据指定的名称查到一个服务
- (id)findServiceByProtocol:(Protocol *)protocol;

// 注册一个服务
- (BOOL)registerService:(CBServiceDescription *)serviceDescription;

// 注销一个已存在的服务
- (void)unregisterServiceByProtocol:(Protocol *)protocol;

//回收一个服务，主要是回收服务的资源，回收后，仍可以找到相应服务并提供服务；
- (BOOL)recycleServiceByProtocol:(Protocol *)protocol;


//判断服务是否存在
- (BOOL)isExistServiceByProtocol:(Protocol *)protocol;

//判断服务是否启动
- (BOOL)isStartServiceByProtocol:(Protocol *)protocol;

// 根据指定的名称启动一个微应用 暂时不使用微应用调度
//- (BOOL)startApplication:(CBApplicationDescription *)applicationDescription animated:(BOOL)animated;

@end

CBContext *CBContextGet(void);


/// 获取service
/// @param protocol <#protocol description#>
id CBContextGetService(Protocol *protocol);

NS_ASSUME_NONNULL_END
