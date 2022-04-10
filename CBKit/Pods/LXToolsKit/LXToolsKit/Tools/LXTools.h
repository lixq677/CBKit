//
//  LXUITools.h
//  BNFresh
//
//  Created by 李笑清 on 2020/6/5.
//  Copyright © 2020 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define kScreenHeight           CGRectGetHeight([UIScreen mainScreen].bounds)
#define kScreenWidth            CGRectGetWidth([UIScreen mainScreen].bounds)

//设备是否是手机
//#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

typedef NS_ENUM(int,XKDeviceType) {
    LXDeviceTypeUnknown =   0,//未知
    LXDeviceTypePhone   =   1,//手机
    LXDeviceTypePad     =   2//平板
};


@interface LXTools : NSObject

+(NSString*)createUUID;

/** 读取缓存 */
+(float)readCacheSize;

/** 清除缓存 */
+ (void)clearFile;

/*获取版本号*/
+(NSString*)getAppVersion;

/*获取bundleId*/
+(NSString*)getBundleID;

/*获取app名字*/
+(NSString*)getAppName;

/*获取设备类型*/
+ (XKDeviceType)getCurDevice;

/*系统版本*/
+ (NSString *)getSystemVersion;

/*获取设备型号*/
+ (NSString *)getPlatformString;


@end


/// 冒泡显示文字
/// @param format <#format description#>
void XKShowToast(NSString *format, ...);


/// 冒泡显示文字后回调
/// @param format <#format description#>
void XKShowToastCompletionBlock(void(^completionBlock)(void),NSString *format,...);

//等比放大或缩小，ip6为基准
float scalef(float x);

//等比缩小或放大，size，ip6为基准进行缩放
CGSize scale_size(float width,float height);

CGRect scale_rect(float x,float y, float width,float height);

UIEdgeInsets scale_edgeInsets(float top,float left, float bottom,float right);


// 是否是iPhoneX
 BOOL IS_IPHONEX_SERIES(void);

//是否是iPhone
BOOL IS_IPHONE(void);
//小屏手机
BOOL IS_IPHONE_MIN(void);
//普通手机
BOOL IS_IPHONE_NOMAL(void);
//大屏手机
BOOL IS_IPHONE_MAX(void);

CGFloat SafeTop(void);

CGFloat SafeBottom(void);

//控制器跳转 模态
void LXPresentViewController(UIViewController *controller);

void LXDismissViewController(UIViewController *controller);

//控制器跳转 导航
void LXPushViewController(UIViewController *controller);

//退出
void LXPopViewController(UIViewController *controller);

//控制器跳转  自动分类跳转方式
void LXGotoViewController(UIViewController *controller);

void LXCloseViewController(UIViewController *controller);
NS_ASSUME_NONNULL_END
