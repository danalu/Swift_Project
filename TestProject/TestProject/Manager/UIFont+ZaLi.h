//
//  UIFont+ZaLi.h
//  EYEE
//
//  Created by dana_lu on 15/10/15.
//  Copyright © 2015年 zali. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger,ZLAutoFontType) {
    ZLAutoFontType_22,   // 主标题
    ZLAutoFontType_20,    // 副标题
    ZLAutoFontType_16,    // 文本内容
    ZLAutoFontType_14     // 文本注释
};

typedef NS_OPTIONS(NSUInteger, PingFangType) {
    PingFangType_Ultralight,
    PingFangType_Regular,
    PingFangType_Semibold,
    PingFangType_Thin,
    PingFangType_Light,
    PingFangType_Medium
};

@interface UIFont (ZaLi)

///*
// *  获取app通用的字体规格中的一种
// */
//+ (UIFont*)getCommonFontWithFontType:(ZLFontType)fontType;
//
//
//
///** 获取自适应字体 */
//+ (UIFont *)fontWithType:(ZLAutoFontType)type isBold:(BOOL)isBold;

+ (UIFont *)HKWithType:(PingFangType)type size:(CGFloat)size;
+ (UIFont *)SCWithType:(PingFangType)type size:(CGFloat)size;
+ (UIFont *)TCWithType:(PingFangType)type size:(CGFloat)size;

@end
