//
//  UIColor+JMColor.m
//  JMQuotesComponets_Example
//
//  Created by fargowealth on 2023/5/29.
//  Copyright © 2023 liyunlong1512. All rights reserved.
//

#import "UIColor+JMColor.h"

@implementation UIColor (JMColor)

+ (UIColor *)colorWithRGBHex:(UInt32)hex {
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}

#pragma mark - 所有图表的背景颜色

+ (UIColor *)backgroundColor {
    return [UIColor colorWithRGBHex:0xFFFFFF];
}

#pragma mark - 股票详情背景色

/**
 *  股票详情背景颜色
 */
+ (UIColor *)stockDetailsBackgroundColor  {
    return [UIColor colorWithRGBHex:0xF5F6FA];
}

#pragma mark - 一级文本色

+ (UIColor *)primaryTextColor {
    return [UIColor colorWithRGBHex:0x13161];
}

#pragma mark - 二级文本色

+ (UIColor *)secondaryTextColor {
    return [UIColor colorWithRGBHex:0x97A3B7];
}

#pragma mark - 盘口信息文本色

+ (UIColor *)handicapInfoTextColor {
    return [UIColor colorWithRGBHex:0x13161B];
}

#pragma mark - 行情列表头部标题颜色

+ (UIColor *)quotesListHeadTitleColor {
    return [UIColor colorWithRGBHex:0x545B66];
}

#pragma mark -  选中颜色

+ (UIColor *)selectedColor {
    return [UIColor colorWithRGBHex:0xE7AD75];
}

#pragma mark - 涨的颜色
/**
 *  涨的颜色
 */
+ (UIColor *)upColor {
    return [UIColor colorWithRGBHex:0xE34D59];
}

#pragma mark - 跌的颜色

+ (UIColor *)downColor {
    return [UIColor colorWithRGBHex:0x078D5C];
}

#pragma mark - 平的颜色

+ (UIColor *)flatColor {
    return [UIColor colorWithRGBHex:0xBCC4D0];
}

#pragma mark - 默认按钮背景色

+ (UIColor *)normalButtonBackgroundColor {
    return [UIColor colorWithRGBHex:0xF3F4F7];
}

#pragma mark - 选中按钮背景色

+ (UIColor *)selectedButtonBackgroundColor {
    return [UIColor colorWithRGBHex:0xFFFFFF];
}

#pragma mark - 延时行情提示view背景

+ (UIColor *)delayPromptViewBackgroundColor {
    return [UIColor colorWithRGBHex:0xFEF6E8];
}

#pragma mark - 延时行情提示文字色
+ (UIColor *)delayPromptTextColor {
    return [UIColor colorWithRGBHex:0xC89851];
}

#pragma mark - 分割线颜色

+ (UIColor *)dividingLineColor {
    return [UIColor colorWithRGBHex:0xEDF2F5];
}

#pragma mark - 辅助线颜色

+ (UIColor *)line1Color {
    return [UIColor colorWithRGBHex:0xFF8148];
}

+ (UIColor *)line2Color {
    return [UIColor colorWithRGBHex:0x40D8FF];
}

+ (UIColor *)line3Color {
    return  [UIColor colorWithRGBHex:0xFF5DFF];
}

+ (UIColor *)line4Color {
    return  [UIColor colorWithRGBHex:0x4187FF];
}

+ (UIColor *)line5Color {
    return  [UIColor colorWithRGBHex:0x14BC7C];
}

#pragma mark 分时线的颜色

+ (UIColor *)timeLineLineColor {
    return [UIColor colorWithRGBHex:0x248AFF];
}

#pragma mark — 均价线颜色

+ (UIColor *)avgPriceLineColor {
    return [UIColor colorWithRGBHex:0xFF782A];
}

#pragma mark - 线框的颜色

+(UIColor*)wireframeColor {
    return [UIColor colorWithRGBHex:0xEBEDF1];
}

#pragma mark - 昨收线颜色

+(UIColor*)closeLineColor {
    return [UIColor colorWithRGBHex:0x959DB7];
}

#pragma mark - 现价线颜色

+(UIColor*)priceLineColor{
    return [UIColor colorWithRGBHex:0xFFB400];
}

#pragma mark - 成交量边框颜色

+(UIColor*)volWordColor {
    return [UIColor colorWithRGBHex:0x262928];
}

#pragma mark 长按时线的颜色

+ (UIColor *)longPressLineColor {
    return [UIColor colorWithRGBHex:0xFFA441];
}

#pragma mark - 长按滑动视图背景色

+(UIColor*)moveViewBgColor {
    return [UIColor colorWithRGBHex:0x2A3047];
}

#pragma mark - 长按滑动视图背景色

+(UIColor*)moveViewBg2Color {
    return [UIColor colorWithRGBHex:0x525A75];
}

#pragma mark - 长按滑动视图背景色

+(UIColor*)moveViewTitleColor {
    return [UIColor colorWithRGBHex:0xBFC7DE];
}

/**
 *  空数据提示文字颜色
 */
+(UIColor*)nullDataTextColor {
    return [UIColor colorWithRGBHex:0xB8C1D4];
}

/**
 *  阴影颜色
 */
+(UIColor*)jmShadowColor {
    return [UIColor colorWithRGBHex:0xA4B2C5];
}

@end
