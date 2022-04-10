//
//  CBServiceDescription.h
//  CBKit
//
//  Created by 李笑清 on 2020/6/29.
//  Copyright © 2020 李笑清. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CBService <NSObject>

@optional


/**
 * 创建服务即将完成。
 */
- (void)willCreate;


/**
 * 创建服务完成。
 */
- (void)didCreate;


/**
 *服务起动
 */
- (void)didStart;


/**
 * 服务将要销毁。
 */
- (void)willDestroy;

@end


@interface CBServiceDescription : NSObject

/// 协议
@property (nonatomic,strong)Protocol *protocol;

//是否延迟加载
@property (nonatomic,assign)BOOL lazyLoading;


/// 服务对象
@property (nonatomic,strong)Class impCls;


// 表示服务是否可以回收,默认是可以回收
@property (nonatomic,assign)BOOL canRecycle;

@end

NS_ASSUME_NONNULL_END
