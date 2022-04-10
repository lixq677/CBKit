//
//  UIImage+LXUnitls.h
//  LXCommonKit
//
//  Created by 李笑清 on 2020/6/11.
//  Copyright © 2020 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    UIImageGrayLevelTypeHalfGray    = 0,
    UIImageGrayLevelTypeGrayLevel   = 1,
    UIImageGrayLevelTypeDarkBrown   = 2,
    UIImageGrayLevelTypeInverse     = 3
} UIImageGrayLevelType;

typedef NS_ENUM(NSInteger,LXImageType) {
    LXImageTypeNone,
    LXImageTypeJpg,
    LXImageTypePng,
    LXImageTypeGif,
    LXImageTypeTiff,
    LXImageTypeWebP,
};


@interface UIImage (LXUnitls)

///缩放图片
+(UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

///剪切
+(UIImage*)imageWithImage:(UIImage*)image cutToRect:(CGRect)newRect;

///等比缩放
+(UIImage*)imageWithImage:(UIImage *)image ratioToSize:(CGSize)newSize;

//压缩
+(UIImage *)compressImage:(UIImage *)image toMaxFileSize:(NSInteger)maxFileSize;

///添加圆角
+(UIImage*)imageWithImage:(UIImage*)image roundRect:(CGSize)size;

///按最短边 等比压缩
+(UIImage*)imageWithImage:(UIImage *)image ratioCompressToSize:(CGSize)newSize;

+(UIImage *)imageWithData2:(NSData *)data scale:(CGFloat)scale;


// 图片处理 0 半灰色  1 灰度   2 深棕色    3 反色
+(UIImage*)imageWithImage:(UIImage*)image grayLevelType:(UIImageGrayLevelType)type;

//色值 变暗多少 0.0 - 1.0
+(UIImage*)imageWithImage:(UIImage*)image darkValue:(float)darkValue;


/// 根据颜色生成图片
/// @param color <#color description#>
+ (UIImage*)imageWithColor: (UIColor*) color;

/**
*  设置图片透明度
* @param alpha 透明度
* @param image 图片
*/
+(UIImage *)imageByApplyingAlpha:(CGFloat )alpha  image:(UIImage*)image;

//通过名字获取图片并添加透明度
+ (UIImage *)imageNamed:(NSString *)name alpha:(CGFloat)alpha;

//给图片剪裁成圆型图片
- (UIImage *)circleImage;

+ (LXImageType)imageTypeFromData:(NSData *)data;

// 视图生成图片
+ (UIImage *)snapshotSingleView:(UIView *)view;

/**
 *  根据图片url获取网络图片尺寸
 */
+ (CGSize)getImageSizeWithURL:(id)URL;


/*!
 *
 *  @brief 使图片压缩后刚好小于指定大小
 *
 *
 *  @return data对象
 */
//图片质量压缩到某一范围内，如果后面用到多，可以抽成分类或者工具类,这里压缩递减比二分的运行时间长，二分可以限制下限。
- (NSData *)compressQualityWithMaxLength:(NSInteger)maxLength;


/**
 在模块内查找UIImage的方法
*/
+ (UIImage *)imageWithName:(NSString *)imageName inBundle:(NSBundle *)bundle;



/// 国际化策略，跟据国际化选择相应的图片
/// @param imageName <#imageName description#>
/// @param bundle <#bundle description#>
+ (UIImage *)localizedImageNamed:(NSString *)imageName inBundle:(NSBundle *)bundle;


@end

/*
 * 宏函数，获取图片，用于组件中的图片查找,
 */
#define LXImageNamed(imageName)\
({\
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];\
    UIImage *image = [UIImage imageNamed:imageName inBundle:bundle];\
    image;\
})

/*
* 宏函数，获取图片，用于组件中的图片查找，会自动跟据语言查找对应的图片
*/
#define LXLocalizedImageNamed(imageName)\
({\
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];\
    UIImage *image = [UIImage localizedImageNamed:imageName inBundle:bundle];\
    image;\
})

NS_ASSUME_NONNULL_END
