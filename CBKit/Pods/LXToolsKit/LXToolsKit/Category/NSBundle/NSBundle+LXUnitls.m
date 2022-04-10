//
//  NSBundle+LXUnitls.m
//  LXToolsKit
//
//  Created by 李笑清 on 2020/6/24.
//  Copyright © 2020 李笑清. All rights reserved.
//

#import "NSBundle+LXUnitls.h"

@implementation NSBundle (LXUnitls)

+ (NSBundle *)bundleWithBundleName:(NSString *)bundleName{
    if (!bundleName) {
        return [NSBundle mainBundle];
    }
    NSString *bundlePath = [NSBundle mainBundle].bundlePath;
    bundlePath = [NSString stringWithFormat:@"%@/%@.bundle",bundlePath,bundleName];
    NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"file://%@",bundlePath] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    NSBundle *bundle =[NSBundle bundleWithURL:url];
    return bundle;
}


+ (NSString *)localizedStringForKey:(NSString *)key inBundle:(NSBundle *)bundle{
    if (bundle == nil) {
        return [[NSBundle mainBundle] localizedStringForKey:key value:nil table:nil];
    }else{
        if (!bundle.loaded) {
            [bundle load];
        }
        return [bundle localizedStringForKey:key value:nil table:nil];
    }
}


@end
