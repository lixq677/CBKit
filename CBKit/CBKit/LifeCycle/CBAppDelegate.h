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

@protocol CBApplicationDelegate <UIApplicationDelegate>

@optional

- (void)application:(UIApplication *)application beforeDidFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

- (void)application:(UIApplication *)application afterDidFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

@end


@interface CBAppDelegate : UIResponder <CBApplicationDelegate, UNUserNotificationCenterDelegate>


/// 所有子类的window都是同一个window，由launch页生成
@property (nonatomic,strong)UIWindow *window;

+ (BOOL)isLauncher;

@end


/// 获取显示的Window
UIWindow *CBWindow(void);

NS_ASSUME_NONNULL_END
