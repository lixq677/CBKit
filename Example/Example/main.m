//
//  main.m
//  Example
//
//  Created by 李笑清 on 2020/6/27.
//  Copyright © 2020 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CBAppDelegateManager.h>

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([CBAppDelegateManager class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
