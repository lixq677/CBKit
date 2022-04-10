//
//  UIView+LXXib.h
//  LXCommonKit
//
//  Created by 李笑清 on 2020/6/11.
//  Copyright © 2020 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (LXXib)

@property (nonatomic, assign) IBInspectable CGFloat  cornerRadius;

@property (nonatomic, assign) IBInspectable CGFloat  borderWidth;

@property (nonatomic, strong) IBInspectable UIColor  *borderColor;


@end

NS_ASSUME_NONNULL_END
