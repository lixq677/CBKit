//
//  UIView+LXFrame.h
//  LXCommonKit
//
//  Created by 李笑清 on 2020/6/11.
//  Copyright © 2020 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (LXFrame)


@property (nonatomic, assign) CGFloat left;     // x轴最小值（原点）

@property (nonatomic, assign) CGFloat x;        // x轴最小值（原点）

@property (nonatomic, assign) CGFloat top;      // y轴最小值（原点）

@property (nonatomic, assign) CGFloat y;        // y轴最小值（原点）

@property (nonatomic, assign) CGFloat right;    // x轴最大值

@property (nonatomic, assign) CGFloat bottom;   // y轴最大值

@property (nonatomic, assign) CGFloat width;    // 宽

@property (nonatomic, assign) CGFloat height;   // 高

@property (nonatomic, assign) CGSize size;      // 宽高size

@property (nonatomic, assign) CGPoint origin;

@property (nonatomic, assign) CGFloat centerX;  // x中心点(相对父视图的坐标)

@property (nonatomic, assign) CGFloat centerY;  // y中心点(相对父视图的坐标)

@property (nonatomic, assign) CGFloat middleX;  // x中心点(相对于自己的坐标)

@property (nonatomic, assign) CGFloat middleY;  // y中心点(相对于自己的坐标)

@property (nonatomic, assign) CGPoint middle;   // 中心点(相对于自己的坐标)

@end

NS_ASSUME_NONNULL_END
