//
//  JMTimelinePainter.m
//  ghchat
//
//  Created by fargowealth on 2021/10/26.
//

#import "JMTimelinePainter.h"
#import "JMKlineGlobalVariable.h"
#import "UIColor+JMColor.h"
#import "JMChatManager.h"

@implementation JMTimelinePainter

+ (JMMinMaxModel *)getMinMaxValue:(NSArray <JMKlineModel *> *)data {
    if(!data) {
        return [JMMinMaxModel new];
    }
    __block CGFloat minAssert = 999999999999.f;
    __block CGFloat maxAssert = 0.f;
    [data enumerateObjectsUsingBlock:^(JMKlineModel * _Nonnull m, NSUInteger idx, BOOL * _Nonnull stop) {
        maxAssert = MAX(maxAssert, m.Close.floatValue);
        minAssert = MIN(minAssert, m.Close.floatValue);
    }];
    return [JMMinMaxModel modelWithMin:minAssert max:maxAssert];
}

+ (void)drawToLayer:(CALayer *)layer
               area:(CGRect)area
             models:(NSArray <JMKlineModel *> *)models
             minMax: (JMMinMaxModel *)minMaxModel
     KLineChartType:(KLineChartType)kLineChartType
       CurrentPrice:(CGFloat)currentPrice {
    
    if(!models) {
        return;
    }
    CGFloat maxH = CGRectGetHeight(area);
    CGFloat unitValue = maxH/minMaxModel.distance;

    __block CGPoint pointStart, pointEnd;
    JMTimelinePainter *sublayer = [[JMTimelinePainter alloc] init];
    sublayer.frame = area;
    UIBezierPath *path1 = [UIBezierPath bezierPath];
    [models enumerateObjectsUsingBlock:^(JMKlineModel * _Nonnull m, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat w = [JMKlineGlobalVariable kLineWidth];
        CGFloat x = idx * (w + [JMKlineGlobalVariable kLineGap]);
        CGPoint point1 = CGPointMake(x+w/2, maxH - (m.Close.floatValue - minMaxModel.min)*unitValue);
        if (idx == 0) {
            [path1 moveToPoint:point1];
            pointStart = point1;
        } else {
            [path1 addLineToPoint:point1];
        }
        if (idx == models.count - 1) {
            pointEnd = point1;
        }
    }];

    // 画线
    {
        CAShapeLayer *l = [CAShapeLayer layer];
        l.path = path1.CGPath;
        l.lineWidth = JMKlineLineWidth;
        l.strokeColor = UIColor.timeLineLineColor.CGColor;
        l.fillColor =   [UIColor clearColor].CGColor;
        [sublayer addSublayer:l];
    }
    [layer addSublayer:sublayer];

    // 绘制纯色背景
//    CAShapeLayer *maskLayer = [CAShapeLayer layer];
//    {
//        UIBezierPath *path2 = [path1 copy];
//        [path2 addLineToPoint:CGPointMake(pointEnd.x, maxH)];
//        [path2 addLineToPoint: CGPointMake(pointStart.x, maxH)];
//        [path2 closePath];
//        maskLayer.path = path2.CGPath;
//        maskLayer.frame = area;
//        maskLayer.fillColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.7 alpha:0.5].CGColor;
//        [layer addSublayer:maskLayer];
//    }

    // 渐变背景色
    {
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        UIBezierPath *path2 = [path1 copy];
        [path2 addLineToPoint:CGPointMake(pointEnd.x, maxH)];
        [path2 addLineToPoint: CGPointMake(pointStart.x, maxH)];
        [path2 closePath];
        maskLayer.path = path2.CGPath;
        CAGradientLayer *bgLayer = [CAGradientLayer layer];
        bgLayer.frame = area;
        bgLayer.colors = @[(id)[UIColor colorWithRed:0.3 green:0.3 blue:0.7 alpha:0.5].CGColor, (id)UIColor.clearColor.CGColor];
        bgLayer.locations = @[@0.3, @0.9];
        bgLayer.mask = maskLayer;
        [layer addSublayer:bgLayer];
    }
    
}

@end
