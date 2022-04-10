//
//  CBKit.h
//  CBKit
//
//  Created by 李笑清 on 2020/6/27.
//  Copyright © 2020 李笑清. All rights reserved.
//

#import <Foundation/Foundation.h>

//! Project version number for CBKit.
FOUNDATION_EXPORT double CBKitVersionNumber;

//! Project version string for CBKit.
FOUNDATION_EXPORT const unsigned char CBKitVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <CBKit/PublicHeader.h>

/*######生命周期管理########*/

/*APP 代理 作为分模块代理的父类*/
#import "CBAppDelegate.h"
/*接收APPDelegate 功能，由CBAppDelegateManager的代为管理，实现生命周期的管控*/
#import "CBAppDelegateManager.h"


/*#######URL总线######*/
#import "CBRouter.h"

/*#######消息总线######*/
#import "CBMsgBus.h"
#import "NSObject+CBMsgBus.h"

/*#######调度中心######*/
#import "CBContext.h"
#import "CBServiceDescription.h"
#import "CBApplicationDescription.h"

