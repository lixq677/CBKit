//
//  UIColor+LXUnitls.h
//  LXCommonKit
//
//  Created by 李笑清 on 2020/6/11.
//  Copyright © 2020 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (LXUnitls)

+ (UIColor *)colorWithRGBString:(NSString *)rgbString;//示例：rgba(123,120,100,1.0f)

+ (NSString *)stringFromColor:(UIColor *)color;//UIColor转换成NSString

- (NSString *)getColorString;

+ (UIColor *)colorWithZYString: (NSString *)stringToConvert;//NSString转换成UIColor

+ (UIColor *)transformFromColor:(UIColor*)fromColor toColor:(UIColor *)toColor progress:(CGFloat)progress;//求当前颜色和color1之间的过渡色，percent是百分比

- (UIColor *)colorWithAlpha:(CGFloat)alpha;

- (BOOL)isEqualToColor:(UIColor *)color;


//重新设置alpha值
- (UIColor *)setAlpha:(CGFloat)alpha;

- (UIColor *)reverseColor;//获取反颜色。

- (BOOL)isDarkGrayColor;//是否是深色

@end

static inline UIColor * HexRGB(int rgbValue,float alv){
    if (@available(iOS 10.0, *)) {
        return [UIColor colorWithDisplayP3Red:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alv/1.0];
    } else {
        return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alv/1.0];

    }
}

static inline UIColor * ColorRGBA(float r, float g, float b,float a){
    if (@available(iOS 10.0, *)) {
        return [UIColor colorWithDisplayP3Red:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:(a)];
    }else{
        return [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:(a)];
    }
}

NS_ASSUME_NONNULL_END
