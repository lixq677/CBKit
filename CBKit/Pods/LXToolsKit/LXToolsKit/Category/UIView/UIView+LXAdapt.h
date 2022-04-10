//
//  UIView+LXAdapt.h
//  LXCommonKit
//
//  Created by 李笑清 on 2020/6/11.
//  Copyright © 2020 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LXAdaptScreenWidthType) {
    LXAdaptScreenWidthTypeNone = 0,
    LXAdaptScreenWidthTypeConstraint = 1<<0, /**< 对约束的constant等比例 */
    LXAdaptScreenWidthTypeFontSize = 1<<1, /**< 对字体等比例 */
    LXAdaptScreenWidthTypeCornerRadius = 1<<2, /**< 对圆角等比例 */
    LXAdaptScreenWidthTypeAll = 1<<3, /**< 对现有支持的属性等比例 */
};


@interface UIView (LXAdapt)

/**
 遍历当前view对象的subviews和constraints，对目标进行等比例换算
 
 @param type 想要和基准屏幕等比例换算的属性类型
 @param exceptViews 需要对哪些类进行例外
 */
- (void)adaptScreenWidthWithType:(LXAdaptScreenWidthType)type
                     exceptViews:( NSArray<Class> * _Nullable )exceptViews;


@end

NS_ASSUME_NONNULL_END
