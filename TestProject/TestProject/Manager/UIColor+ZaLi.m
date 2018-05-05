//
//  UIColor+ZaLi.m
//  EYEE
//
//  Created by dana_lu on 15/10/14.
//  Copyright © 2015年 zali. All rights reserved.
//

#import "UIColor+ZaLi.h"

@implementation UIColor (ZaLi)

+ (UIColor*)getCommonColorWithColorType:(ZLColorType)colorType {
    return [self getCommonColorWithColorType:colorType alpha:1.0];
}

+ (UIColor*)getCommonColorWithColorType:(ZLColorType)colorType alpha:(CGFloat)alpha {
    NSArray *colors = @[@"333333",@"ffc700",@"666666",@"fde334",@"a46a9c",@"4da568",@"f09739",@"10569b",@"f2f2f2",@"ffffff",@"e2e2e2",@"da1b22",@"af3c03",@"0b1926",@"999999",@"ee696e",@"f7b336",@"4f4f4f",@"f5f4f5",@"cbcbcb",@"0ebd06",@"ce6060",@"4aabc0",@"cccccc", @"dbdbdb",@"eeeeee",@"ffc700",@"FFC21B",@"f9f9f9",@"000000",@"f2bd00",@"3898c2",@"e26868",@"fafafa",@"328fc5",@"e61818",@"e6cb5b",@"d99485",@"4db6ca",@"141414",@"8e8e8e",@"f7f7f7"];
    NSString *colorHexString = colors[colorType > colors.count ? 0 : colorType];
    return [self colorWithHexString:colorHexString];
}


+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha {
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
    CGFloat red, blue, green;
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 1];
            green = [self colorComponentFrom: colorString start: 1 length: 1];
            blue  = [self colorComponentFrom: colorString start: 2 length: 1];
            break;
        case 4: // #ARGB
            alpha = [self colorComponentFrom: colorString start: 0 length: 1];
            red   = [self colorComponentFrom: colorString start: 1 length: 1];
            green = [self colorComponentFrom: colorString start: 2 length: 1];
            blue  = [self colorComponentFrom: colorString start: 3 length: 1];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 2];
            green = [self colorComponentFrom: colorString start: 2 length: 2];
            blue  = [self colorComponentFrom: colorString start: 4 length: 2];
            break;
        case 8: // #AARRGGBB
            alpha = [self colorComponentFrom: colorString start: 0 length: 2];
            red   = [self colorComponentFrom: colorString start: 2 length: 2];
            green = [self colorComponentFrom: colorString start: 4 length: 2];
            blue  = [self colorComponentFrom: colorString start: 6 length: 2];
            break;
        default:
            [NSException raise:@"Invalid color value" format: @"Color value %@ is invalid.  It should be a hex value of the form #RBG, #ARGB, #RRGGBB, or #AARRGGBB", hexString];
            break;
    }
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
}


+ (CGFloat) colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length {
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}


+ (UIColor *)randomColor {
    CGFloat r = arc4random_uniform(256)/256.0;
    CGFloat g = arc4random_uniform(256)/256.0;
    CGFloat b = arc4random_uniform(256)/256.0;
    return [UIColor colorWithRed:r green:g blue:b alpha:1];
}

@end
