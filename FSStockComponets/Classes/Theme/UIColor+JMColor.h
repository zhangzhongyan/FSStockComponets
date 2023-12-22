//
//  UIColor+JMColor.h
//  JMQuotesComponets_Example
//
//  Created by fargowealth on 2023/5/29.
//  Copyright © 2023 liyunlong1512. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (JMColor)

/**
 *  所有图表的背景颜色
 */
+ (UIColor *)backgroundColor;

/**
 *  股票详情背景颜色
 */
+ (UIColor *)stockDetailsBackgroundColor;

/**
 *  一级文本色
 */
+ (UIColor *)primaryTextColor;

/**
 *  二级文本色
 */
+ (UIColor *)secondaryTextColor;

/**
 *  盘口信息文本色
 */
+ (UIColor *)handicapInfoTextColor;

/**
 *  行情列表 头部标题颜色
 */
+ (UIColor *)quotesListHeadTitleColor;

/**
 *  选中颜色
 */
+ (UIColor *)selectedColor;

/**
 *  涨的颜色
 */
+ (UIColor *)upColor;

/**
 *  跌的颜色
 */
+ (UIColor *)downColor;

/**
 *  平的颜色
 */
+ (UIColor *)flatColor;


/**
 *  默认按钮背景色
 */
+ (UIColor *)normalButtonBackgroundColor;

/**
 *  选中按钮背景色
 */
+ (UIColor *)selectedButtonBackgroundColor;

/**
 *  延时行情提示view背景色
 */
+ (UIColor *)delayPromptViewBackgroundColor;

/**
 *  延时行情提示文字色
 */
+ (UIColor *)delayPromptTextColor;

/**
 *  分割线颜色
 */
+ (UIColor *)dividingLineColor;

/**
 *  辅助线颜色1
 */
+ (UIColor *)line1Color;

/**
 *  辅助线颜色2
 */
+ (UIColor *)line2Color;

/**
 *  辅助线颜色3
 */
+ (UIColor *)line3Color;

/**
 *  辅助线颜色4
 */
+ (UIColor *)line4Color;

/**
 *  辅助线颜色5
 */
+ (UIColor *)line5Color;

/**
 *  分时线的颜色
 */
+ (UIColor *)timeLineLineColor;

/**
 * 均价线颜色
 */
+ (UIColor *)avgPriceLineColor;

/**
 * 线框的颜色
 */
+(UIColor*)wireframeColor;

/**
 * 昨收线颜色
 */
+(UIColor*)closeLineColor;


/**
 * 现价线颜色
 */
+(UIColor*)priceLineColor;

/**
 * 成交量边框颜色
 */
+(UIColor*)volWordColor;

/**
 *  长按时线的颜色
 */
+ (UIColor *)longPressLineColor;

/**
 *  长按滑动视图背景色
 */
+(UIColor*)moveViewBgColor;

/**
 *  横竖坐标背景色
 */
+(UIColor*)moveViewBg2Color;

/**
 *  长按滑动视图背景色
 */
+(UIColor*)moveViewTitleColor;

/**
 *  空数据提示文字颜色
 */
+(UIColor*)nullDataTextColor;

/**
 *  阴影颜色
 */
+(UIColor*)jmShadowColor;

@end

NS_ASSUME_NONNULL_END
