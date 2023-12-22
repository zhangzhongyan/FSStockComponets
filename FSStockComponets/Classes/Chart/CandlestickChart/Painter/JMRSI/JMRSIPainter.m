//
//  JMRSIPainter.m
//  ghchat
//
//  Created by fargowealth on 2021/10/26.
//

#import "JMRSIPainter.h"
#import "JMKlineGlobalVariable.h"
#import "UIColor+JMColor.h"

@implementation JMRSIPainter

+ (JMMinMaxModel *)getMinMaxValue:(NSArray <JMKlineModel *> *)data {
    if(!data) {
        return [JMMinMaxModel new];
    }
    __block CGFloat minAssert = 999999999999.f;
    __block CGFloat maxAssert = 0.f;
    [data enumerateObjectsUsingBlock:^(JMKlineModel * _Nonnull m, NSUInteger idx, BOOL * _Nonnull stop) {
        maxAssert = MAX(maxAssert, MAX(m.RSI.RSI3.floatValue, MAX(m.RSI.RSI1.floatValue, m.RSI.RSI2.floatValue)));
        minAssert = MIN(minAssert, MIN(m.RSI.RSI3.floatValue, MIN(m.RSI.RSI1.floatValue, m.RSI.RSI2.floatValue)));
    }];
    return [JMMinMaxModel modelWithMin:minAssert max:maxAssert];
}

+ (void)drawToLayer:(CALayer *)layer area:(CGRect)area models:(NSArray <JMKlineModel *> *)models minMax: (JMMinMaxModel *)minMaxModel {
    if(!models) {
        return;
    }
    CGFloat maxH = CGRectGetHeight(area);
    CGFloat unitValue = maxH/minMaxModel.distance;
    
    JMRSIPainter *sublayer = [[JMRSIPainter alloc] init];
    sublayer.frame = area;
    UIBezierPath *path1 = [UIBezierPath bezierPath];
    UIBezierPath *path2 = [UIBezierPath bezierPath];
    UIBezierPath *path3 = [UIBezierPath bezierPath];
    [models enumerateObjectsUsingBlock:^(JMKlineModel * _Nonnull m, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat w = [JMKlineGlobalVariable kLineWidth];
        CGFloat x = idx * (w + [JMKlineGlobalVariable kLineGap]);
        CGPoint point1 = CGPointMake(x+w/2, maxH - (m.RSI.RSI1.floatValue - minMaxModel.min)*unitValue);
        CGPoint point2 = CGPointMake(x+w/2, maxH - (m.RSI.RSI2.floatValue - minMaxModel.min)*unitValue);
        CGPoint point3 = CGPointMake(x+w/2, maxH - (m.RSI.RSI3.floatValue - minMaxModel.min)*unitValue);
        if (idx == 0) {
            [path1 moveToPoint:point1];
            [path2 moveToPoint:point2];
            [path3 moveToPoint:point3];
        } else {
            [path1 addLineToPoint:point1];
            [path2 addLineToPoint:point2];
            [path3 addLineToPoint:point3];
        }
    }];
    
    {
        CAShapeLayer *l = [CAShapeLayer layer];
        l.path = path1.CGPath;
        l.lineWidth = JMKlineLineWidth;
        l.strokeColor = UIColor.line1Color.CGColor;
        l.fillColor =   [UIColor clearColor].CGColor;
        [sublayer addSublayer:l];
    }
    {
        CAShapeLayer *l = [CAShapeLayer layer];
        l.path = path2.CGPath;
        l.lineWidth = JMKlineLineWidth;
        l.strokeColor = UIColor.line2Color.CGColor;
        l.fillColor =   [UIColor clearColor].CGColor;
        [sublayer addSublayer:l];
    }
    {
        CAShapeLayer *l = [CAShapeLayer layer];
        l.path = path3.CGPath;
        l.lineWidth = JMKlineLineWidth;
        l.strokeColor = UIColor.line3Color.CGColor;
        l.fillColor =   [UIColor clearColor].CGColor;
        [sublayer addSublayer:l];
    }
    [layer addSublayer:sublayer];
}

+ (NSAttributedString *)getText:(JMKlineModel *)model {
    return model.V_RSI;
}

@end
