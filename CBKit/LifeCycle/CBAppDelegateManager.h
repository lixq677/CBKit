//
//  CBAppDelegateManager.h
//  CBKit
//
//  AppDelegate 由CBAppDelegateManager 掌管
//
//  Created by 李笑清 on 2020/6/27.
//  Copyright © 2020 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBAppDelegateManager : UIResponder <UIApplicationDelegate, UNUserNotificationCenterDelegate>

+ (instancetype)sharedInstance;

- (void)addDelegate:(id<UIApplicationDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
