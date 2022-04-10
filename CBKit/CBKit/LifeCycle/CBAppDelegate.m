//
//  CBAppDelegate.m
//  CBKit
//
//  Created by 李笑清 on 2020/6/27.
//  Copyright © 2020 李笑清. All rights reserved.
//

#import "CBAppDelegate.h"
#import "CBAppDelegateManager.h"


@interface CBAppDelegate  ()

@end

@implementation CBAppDelegate

+ (BOOL)isLauncher{
    return NO;
}

- (UIWindow *)window{
    return [[CBAppDelegateManager sharedInstance] window];
}

- (void)setWindow:(UIWindow *)window{
    if ([[self class] isLauncher]) {
        [[CBAppDelegateManager sharedInstance] setWindow:window];
    }else{
        NSAssert(NO, @"非launcher 页面不能设置window");
    };
}

@end

UIWindow *CBWindow(){
    return [[CBAppDelegateManager sharedInstance] window];
}
