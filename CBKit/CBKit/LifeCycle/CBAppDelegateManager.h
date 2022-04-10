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
#import "CBAppDelegate.h"

NS_ASSUME_NONNULL_BEGIN
@interface CBAppDelegateManager : UIResponder <UIApplicationDelegate, UNUserNotificationCenterDelegate>

@property (nullable,nonatomic,strong)UIWindow *window;

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
