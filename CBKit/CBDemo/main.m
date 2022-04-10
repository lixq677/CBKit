//
//  main.m
//  CBDemo
//
//  Created by 李笑清 on 2020/7/8.
//  Copyright © 2020 李笑清. All rights reserved.
//

#import <CBKit/CBKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([CBAppDelegateManager class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
