#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "CBKit.h"
#import "CBAppDelegate.h"
#import "CBAppDelegateManager.h"

FOUNDATION_EXPORT double CBKitVersionNumber;
FOUNDATION_EXPORT const unsigned char CBKitVersionString[];

