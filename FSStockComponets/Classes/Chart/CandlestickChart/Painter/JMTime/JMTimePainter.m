//
//  JMTimePainter.m
//  ghchat
//
//  Created by fargowealth on 2021/10/26.
//

#import "JMTimePainter.h"
#import "JMKlineGlobalVariable.h"
#import "UIColor+JMColor.h"

@implementation JMTimePainter

+ (void)drawToLayer:(CALayer *)layer area:(CGRect)area models:(NSArray<JMKlineModel *> *)models minMax:(JMMinMaxModel *)minMaxModel {
    CGFloat maxH = CGRectGetHeight(area);
    if (maxH <= 0) {
        return;
    }
    
    JMTimePainter *sublayer = [[JMTimePainter alloc] init];
    sublayer.backgroundColor = UIColor.backgroundColor.CGColor;
    sublayer.frame = area;
    [layer addSublayer:sublayer];
    
    CGFloat w = [JMKlineGlobalVariable kLineWidth];
    [models enumerateObjectsUsingBlock:^(JMKlineModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!obj.isDrawTime) {
            return;
        }
        CGFloat x = idx * (w + [JMKlineGlobalVariable kLineGap]);
        CGFloat y = (maxH - [UIFont systemFontOfSize:12.f].lineHeight)/2.f;
        CATextLayer *textLayer = [CATextLayer layer];
        textLayer.string = obj.V_HHMM;
        textLayer.alignmentMode = kCAAlignmentCenter;
        textLayer.fontSize = 12.f;
        textLayer.foregroundColor = UIColor.grayColor.CGColor;
        textLayer.frame = CGRectMake(x-50, y, 100, maxH);
        textLayer.contentsScale = UIScreen.mainScreen.scale;
        [sublayer addSublayer:textLayer];
    }];
}

+ (void)drawToLayer:(CALayer *)layer
               area:(CGRect)area
             models:(NSArray<JMKlineModel *> *)models
             minMax:(JMMinMaxModel *)minMaxModel
     KLineChartType:(KLineChartType)kLineChartType
       CurrentPrice:(CGFloat)currentPrice {
    
    CGFloat maxH = CGRectGetHeight(area);
    if (maxH <= 0) {
        return;
    }
    
    JMTimePainter *sublayer = [[JMTimePainter alloc] init];
//    sublayer.backgroundColor = UIColor.assistBackgroundColor.CGColor;
    sublayer.frame = area;
    [layer addSublayer:sublayer];
    
    CGFloat w = [JMKlineGlobalVariable kLineWidth];
    [models enumerateObjectsUsingBlock:^(JMKlineModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!obj.isDrawTime) {
            return;
        }
        CGFloat x = idx * (w + [JMKlineGlobalVariable kLineGap]);
        CGFloat y = (maxH - [UIFont systemFontOfSize:12.f].lineHeight)/2.f;
        CATextLayer *textLayer = [CATextLayer layer];
        
        switch (kLineChartType) {
            case KLineChartTypeBefore:{
                textLayer.string = obj.V_HHMM;
            }
                break;
            case KLineChartTypeBetween:{
                textLayer.string = obj.V_HHMM;
            }
                break;
            case KLineChartTypeAfter:{
                textLayer.string = obj.V_HHMM;
            }
                break;
            case KLineChartTypeMinuteHour:{
                textLayer.string = obj.V_HHMM;
            }
                break;
            case KLineChartTypeFiveDay:{
                textLayer.string = obj.V_MMDD;
            }
                break;
            case KLineChartTypeDayK:{
                textLayer.string = obj.V_YYYYMMDD;
            }
                break;
            case KLineChartTypeWeekK:{
                textLayer.string = obj.V_YYYYMM;
            }
                break;
            case KLineChartTypeMonthK:{
                textLayer.string = obj.V_YYYYMM;
            }
                break;
            case KLineChartTypeYearK:{
                textLayer.string = obj.V_YYYYMM;
            }
                break;
            default:{
                textLayer.string = obj.V_MMDDHHMM;
            }
                break;
        }
        
        textLayer.alignmentMode = kCAAlignmentCenter;
        textLayer.fontSize = 8.f;
        textLayer.foregroundColor = UIColor.handicapInfoTextColor.CGColor;
        textLayer.frame = CGRectMake(x-50, y, 100, maxH);
        textLayer.contentsScale = UIScreen.mainScreen.scale;
        [sublayer addSublayer:textLayer];
    }];
    
}


@end
