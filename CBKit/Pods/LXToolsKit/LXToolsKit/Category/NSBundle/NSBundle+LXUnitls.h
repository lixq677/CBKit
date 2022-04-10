//
//  NSBundle+LXUnitls.h
//  LXToolsKit
//
//  Created by 李笑清 on 2020/6/24.
//  Copyright © 2020 李笑清. All rights reserved.
//

@import AVKit;

NS_ASSUME_NONNULL_BEGIN

//宏函数，返回对应的本地化字符串
#define LXLocalizedString(string)\
({\
    NSString *resultString = nil;\
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];\
    resultString = [NSBundle localizedStringForKey:string inBundle:bundle];\
    resultString;\
})

@interface NSBundle (LXUnitls)

/// 根据bundle名字获取bundle对象，只能获取mainBundle下的bundle
/// @param bundleName <#bundleName description#>
+ (NSBundle *)bundleWithBundleName:(NSString *)bundleName;

+ (NSString *)localizedStringForKey:(NSString *)key inBundle:(NSBundle *)bundle;

@end

NS_ASSUME_NONNULL_END
