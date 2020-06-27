//
//  CBAppDelegate.h
//  CBKit
//
//  Created by 李笑清 on 2020/6/27.
//  Copyright © 2020 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>

NS_ASSUME_NONNULL_BEGIN

// 模块service调用优先级
typedef NS_ENUM(NSUInteger,CBAppDelegatePriority) {
    CBAppDelegatePriorityPriorityVeryLow = 0, // 最低
    CBAppDelegatePriorityPriorityLow,
    CBAppDelegatePriorityPriorityMedium,
    CBAppDelegatePriorityPriorityHigh,
    CBAppDelegatePriorityPriorityVeryHigh,    // 最高
};


@interface CBAppDelegate : UIResponder <UIApplicationDelegate, UNUserNotificationCenterDelegate>

/// 注册AppDelegate
+ (void)registerAppDelegate;

/// AppDelegate调用优先级
- (CBAppDelegatePriority)priority;


@end

NS_ASSUME_NONNULL_END
