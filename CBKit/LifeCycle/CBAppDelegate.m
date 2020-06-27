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


+ (void)registerAppDelegate{
    id<UIApplicationDelegate> delegate = [[self alloc] init];
    [[CBAppDelegateManager sharedInstance] addDelegate:delegate];
}

- (CBAppDelegatePriority)priority{
    return CBAppDelegatePriorityPriorityMedium;
}

@end
