//
//  UIFont+ZaLi.m
//  EYEE
//
//  Created by dana_lu on 15/10/15.
//  Copyright © 2015年 zali. All rights reserved.
//

#import "UIFont+ZaLi.h"


static CGFloat const plusWidth = 414.0;

@implementation UIFont (ZaLi)

+ (UIFont *)HKWithType:(PingFangType)type size:(CGFloat)size {
    NSString *fontName = @"PingFangHK-Regular";
    switch (type) {
        case PingFangType_Ultralight:
            fontName = @"PingFangHK-Ultralight"; // 超轻
            break;
        case PingFangType_Regular:
            fontName = @"PingFangHK-Regular"; // 常规
            break;
        case PingFangType_Semibold:
            fontName = @"PingFangHK-Semibold"; // 半黑体
            break;
        case PingFangType_Thin:
            fontName = @"PingFangHK-Thin"; // 细体
            break;
        case PingFangType_Light:
            fontName = @"PingFangHK-Light"; // 轻
            break;
        case PingFangType_Medium:
            fontName = @"PingFangHK-Medium"; // 中粗
            break;
        default:
            fontName = @"PingFangHK-Regular";
            break;
    }
    UIFont *font = [UIFont fontWithName:fontName size:size];
    if (font == nil) {
        return [UIFont systemFontOfSize:size];
    }else{
        return font;
    }
}

+ (UIFont *)SCWithType:(PingFangType)type size:(CGFloat)size {
    NSString *fontName = @"PingFangSC-Regular";
    switch (type) {
        case PingFangType_Ultralight:
            fontName = @"PingFangSC-Ultralight"; // 超轻
            break;
        case PingFangType_Regular:
            fontName = @"PingFangSC-Regular"; // 常规
            break;
        case PingFangType_Semibold:
            fontName = @"PingFangSC-Semibold"; // 半黑体
            break;
        case PingFangType_Thin:
            fontName = @"PingFangSC-Thin"; // 细体
            break;
        case PingFangType_Light:
            fontName = @"PingFangSC-Light"; // 轻
            break;
        case PingFangType_Medium:
            fontName = @"PingFangSC-Medium"; // 中粗
            break;
        default:
            fontName = @"PingFangSC-Regular"; // 中粗
            break;
    }
    UIFont *font = [UIFont fontWithName:fontName size:size];
    if (font == nil) {
        return [UIFont systemFontOfSize:size];
    }else{
        return font;
    }
}
+ (UIFont *)TCWithType:(PingFangType)type size:(CGFloat)size {
    NSString *fontName = @"PingFangTC-Regular";
    switch (type) {
        case PingFangType_Ultralight:
            fontName = @"PingFangTC-Ultralight"; // 超轻
            break;
        case PingFangType_Regular:
            fontName = @"PingFangTC-Regular"; // 常规
            break;
        case PingFangType_Semibold:
            fontName = @"PingFangTC-Semibold"; // 半黑体
            break;
        case PingFangType_Thin:
            fontName = @"PingFangTC-Thin"; // 细体
            break;
        case PingFangType_Light:
            fontName = @"PingFangTC-Light"; // 轻
            break;
        case PingFangType_Medium:
            fontName = @"PingFangTC-Medium"; // 中粗
            break;
        default:
            fontName = @"PingFangTC-Regular";
            break;
    }
    UIFont *font = [UIFont fontWithName:fontName size:size];
    if (font == nil) {
        return [UIFont systemFontOfSize:size];
    }else{
        return font;
    }
}

+ (UIFont *)fontWithType:(ZLAutoFontType)type isBold:(BOOL)isBold {
    switch (type) {
        case ZLAutoFontType_22: {
            if (isBold) {
                return [UIFont boldSystemFontOfSize:[self is6Plus] ? 21 : 19];
            }else {
                return [UIFont systemFontOfSize:[self is6Plus] ? 21 : 19];
            }
            break;
        }
        case ZLAutoFontType_20: {
            if (isBold) {
                return [UIFont boldSystemFontOfSize:[self is6Plus] ? 19 : 17];
            }else {
                return [UIFont systemFontOfSize:[self is6Plus] ? 19 : 17];
            }
            break;
        }
        case ZLAutoFontType_16: {
            if (isBold) {
                return [UIFont boldSystemFontOfSize:[self is6Plus] ? 16 : 15];
            }else {
                return [UIFont systemFontOfSize:[self is6Plus] ? 16 : 15];
            }
            break;
        }
        case ZLAutoFontType_14: {
            if (isBold) {
                return [UIFont boldSystemFontOfSize:[self is6Plus] ? 14 : 13];
            }else {
                return [UIFont systemFontOfSize:[self is6Plus] ? 14 : 13];
            }
            break;
        }
    }
    return nil;
    
}

+ (BOOL)is6Plus {
    return [UIScreen mainScreen].bounds.size.width >= plusWidth ? YES : NO;
}


@end
