//
//  JMPainterProtocol.h
//  ghchat
//
//  Created by fargowealth on 2021/10/26.
//

#ifndef JMPainterProtocol_h
#define JMPainterProtocol_h

#import "JMMinMaxModel.h"
#import "JMKlineModel.h"
#import "QuotationConstant.h"

@class JMMinMaxModel;

@protocol JMPainterProtocol <NSObject>

@required

// 绘制
+ (void)drawToLayer:(CALayer *)layer area:(CGRect)area models:(NSArray <JMKlineModel *> *)models minMax: (JMMinMaxModel *)minMaxModel;

@optional

/** 绘制
 * layer    图层
 * area     位置
 * models   数据源
 * minMaxModel  大小
 * kLineType    K线图表类型
 * currentPrice 当前价
 */
+ (void)drawToLayer:(CALayer *)layer
               area:(CGRect)area
             models:(NSArray <JMKlineModel *> *)models
             minMax:(JMMinMaxModel *)minMaxModel
     KLineChartType:(KLineChartType)kLineChartType
       CurrentPrice:(CGFloat)currentPrice;

// 获取边界值
+ (JMMinMaxModel *)getMinMaxValue:(NSArray <JMKlineModel *> *)data;

// 获取辅助展示文字
+ (NSAttributedString *)getText:(JMKlineModel *)model;

@end

@protocol JMVerticalTextPainterProtocol <NSObject>

/**
 * 绘制价格Y轴
 */
+ (void)drawPriceToLayer:(CALayer *)layer area:(CGRect)area minMax: (JMMinMaxModel *)minMaxModel;

/**
 * 绘制成交量Y轴
 */
+ (void)drawVolumeToLayer:(CALayer *)layer area:(CGRect)area minMax: (JMMinMaxModel *)minMaxModel;

@end

#endif /* JMPainterProtocol_h */
