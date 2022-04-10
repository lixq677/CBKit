//
//  UIColor+LXUnitls.m
//  LXCommonKit
//
//  Created by 李笑清 on 2020/6/11.
//  Copyright © 2020 李笑清. All rights reserved.
//

#import "UIColor+LXUnitls.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation UIColor (LXUnitls)

+(NSString *)stringFromColor:(UIColor *)color{
    const CGFloat *cs=CGColorGetComponents(color.CGColor);
    NSString *r = [NSString stringWithFormat:@"%@",[[self class] toHex:cs[0]*255]];
    NSString *g = [NSString stringWithFormat:@"%@",[[self class] toHex:cs[1]*255]];
    NSString *b = [NSString stringWithFormat:@"%@",[[self class] toHex:cs[2]*255]];
    return [NSString stringWithFormat:@"#%@%@%@",r,g,b];
}

+(NSString *)toHex:(int)tmpid{
    NSString *endtmp=@"";
    NSString *nLetterValue;
    NSString *nStrat;
    int ttmpig=tmpid%16;
    int tmp=tmpid/16;
    switch (ttmpig)
    {
        case 10:
            nLetterValue =@"A";break;
        case 11:
            nLetterValue =@"B";break;
        case 12:
            nLetterValue =@"C";break;
        case 13:
            nLetterValue =@"D";break;
        case 14:
            nLetterValue =@"E";break;
        case 15:
            nLetterValue =@"F";break;
        default:nLetterValue=[[NSString alloc]initWithFormat:@"%i",ttmpig];
            
    }
    switch (tmp)
    {
        case 10:
            nStrat =@"A";break;
        case 11:
            nStrat =@"B";break;
        case 12:
            nStrat =@"C";break;
        case 13:
            nStrat =@"D";break;
        case 14:
            nStrat =@"E";break;
        case 15:
            nStrat =@"F";break;
        default:nStrat=[[NSString alloc]initWithFormat:@"%i",tmp];
            
    }
    endtmp=[[NSString alloc]initWithFormat:@"%@%@",nStrat,nLetterValue];
    return endtmp;
}


#define DEFAULT_VOID_COLOR [UIColor greenColor]
+ (UIColor *) colorWithZYString: (NSString *) stringToConvert{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];//字符串处理
    //例子，stringToConvert #ffffff
    if ([cString length] < 6)
        return DEFAULT_VOID_COLOR;//如果非十六进制，返回白色
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];//去掉头
    if ([cString length] != 6)//去头非十六进制，返回白色
        return DEFAULT_VOID_COLOR;
    //分别取RGB的值
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    unsigned int r, g, b;
    //NSScanner把扫描出的制定的字符串转换成Int类型
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    //转换为UIColor
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

-(NSString *)getColorString{
    return [[self class]stringFromColor:self];
}

-(BOOL)isEqualToColor:(UIColor *)color{
    NSString *str1 = [[self class]stringFromColor:self];
    NSString *str2 = [[self class]stringFromColor:color];
    return [str1 isEqualToString:str2];
}


- (UIColor *)colorWithAlpha:(CGFloat)alpha
{
    CGFloat red     = 0.0;
    CGFloat green   = 0.0;
    CGFloat blue    = 0.0;
    CGFloat alph    = 0.0;
    [self getRed:&red green:&green blue:&blue alpha:&alph];
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

//重新设置alpha值
- (UIColor *)setAlpha:(CGFloat)alpha{
    const CGFloat *components = CGColorGetComponents(self.CGColor);
    CGFloat red,green,blue;
    red = components[0];
    green = components[1];
    blue = components[2];
    
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (BOOL)isDarkGrayColor{
    const CGFloat *components = CGColorGetComponents(self.CGColor);
    CGFloat red,green,blue;
    red = components[0];
    green = components[1];
    blue = components[2];
    
    if (red != green || red != blue || blue != green) {
        return NO;
    }
    
    BOOL res = red < 0.5 && green < 0.5 && blue < 0.5;
    
    return res;
}

+ (UIColor *)colorWithRGBString:(NSString *)rgbString{
    
    if (![[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"rgba\\(\\d{1,3},\\d{1,3},\\d{1,3},\\d|\\d\\.\\d\\)"] evaluateWithObject:rgbString]){
        return nil;
    }
    
    NSRange st1 = [rgbString rangeOfString:@"("];
    NSRange st2 = [rgbString rangeOfString:@")"];
    
    if ([[rgbString lowercaseString] hasPrefix:@"rgba"] && st1.location != NSNotFound && st2.location != NSNotFound) {
        NSString *contentString = [rgbString substringWithRange:NSMakeRange(st1.location+st1.length, st2.location - st2.length - st1.location)];
        
        NSArray *comp = [contentString componentsSeparatedByString:@","];
        
        if (comp.count != 4) {
            return nil;
        }
        
        CGFloat r = [comp[0] floatValue] / 255.0f;
        CGFloat g = [comp[1] floatValue] / 255.0f;
        CGFloat b = [comp[2] floatValue] / 255.0f;
        CGFloat a = [comp[3] floatValue] / 255.0f;
        
        return [UIColor colorWithRed:r green:g blue:b alpha:a];
        
        
    }
    
    return nil;
}

+ (UIColor *)transformFromColor:(UIColor*)fromColor toColor:(UIColor *)toColor progress:(CGFloat)progress{
    
    progress = progress >= 1 ? 1 : progress;
    progress = progress <= 0 ? 0 : progress;
    
    const CGFloat * fromeComponents = CGColorGetComponents(fromColor.CGColor);
    const CGFloat * toComponents = CGColorGetComponents(toColor.CGColor);
    
    size_t  fromColorNumber = CGColorGetNumberOfComponents(fromColor.CGColor);
    size_t  toColorNumber = CGColorGetNumberOfComponents(toColor.CGColor);
    
    if (fromColorNumber == 2) {
        CGFloat white = fromeComponents[0];
        fromColor = [UIColor colorWithRed:white green:white blue:white alpha:1];
        fromeComponents = CGColorGetComponents(fromColor.CGColor);
    }
    
    if (toColorNumber == 2) {
        CGFloat white = toComponents[0];
        toColor = [UIColor colorWithRed:white green:white blue:white alpha:1];
        toComponents = CGColorGetComponents(toColor.CGColor);
    }
    
    CGFloat r = fromeComponents[0]*(1 - progress) + toComponents[0]*progress;
    CGFloat g = fromeComponents[1]*(1 - progress) + toComponents[1]*progress;
    CGFloat b = fromeComponents[2]*(1 - progress) + toComponents[2]*progress;
    
    return [UIColor colorWithRed:r green:g blue:b alpha:1];
}

- (UIColor *)reverseColor{
    const CGFloat *components = CGColorGetComponents(self.CGColor);
    CGFloat red,green,blue,alpha;
    red = components[0];
    green = components[1];
    blue = components[2];
    alpha = components[3];
    
    return [UIColor colorWithRed:1 - red green:1 - green blue:1 - blue alpha:alpha];
    
}


@end
