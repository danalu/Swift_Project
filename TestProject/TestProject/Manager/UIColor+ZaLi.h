//
//  UIColor+ZaLi.h
//  EYEE
//
//  Created by dana_lu on 15/10/14.
//  Copyright © 2015年 zali. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,ZLColorType) {
    ColorMainType, //#333333
    ColorBlueType,   //#2bc0f3
    ColorGrayType,  //#666666
    ColorYellowType, //#fde334
    ColorPurpleType, //#a46a9c
    ColorGreenType, //4da568
    ColorOrangeType, //#f09739
    ColorDarkBlueType, //#10569b
    ColorBaseType, //#f2f2f2
    ColorWhiteType, //#ffffff
    ColorLightGrayType, //#e2e2e2
    ColorRedType,   //#da1b22
    ColorOldRedType, //#af3c03
    ColorBlackType, //#0b1926
    ColorMiddleGrayType, //#999999
    colorRoseRed, // #ee696e
    ColorOrange, // #f7b336
    ColorGrayWhiteType,//#4f4f4f
    ColorLineGrayType, //#f5f4f5
    ColorSmallGrayType, //#cbcbcb
    ColorShoeGreenType, //#0ebd06
    ColorLimitRedType,  //#ce6060
    ColorLimitBlueType,  //#4aabc0
    ColorDetailGrayType,  //#cccccc
    ColorTimeGrayType,   //#dbdbdb
    ColorEEEEEEType,     // #eeeeee
    ColorOrderYellowType,  // #ffc700
    ColorYelloBgType, //FFC21B
    ColorF9F9F9Type,  // f9f9f9
    Color000000Type,   // 000000
    ColorF2BD00Type,    // f2bd00
    Color3898C2Type,   // 3898c2
    ColorE26868Type,     // e26868
    ColorFAFAFAType,     // fafafa
    Color328FC5Type,     //328FC5
    ColorE61818Type,     // e61818
    ColorE6CB5BType,    //e6cb5b 黄色
    ColorD99485Type,     //d99485 红色
    Color4DB6CAType,      // 4db6ca 海水蓝
    Color141414Type,       // 141414 .. 黑色
    Color8E8E8EType,     // 8e8e8e
    ColorF7F7F7Type      // f7f7f7
} ;  //通用颜色类型

@interface UIColor (ZaLi)

/*
 *  16进制颜色值
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString;

/*
 *  获取app主要配色中的某一种颜色值.
 */
+ (UIColor*)getCommonColorWithColorType:(ZLColorType)colorType;

+ (UIColor*)getCommonColorWithColorType:(ZLColorType)colorType alpha:(CGFloat)alpha;

+ (UIColor *)randomColor;

@end
