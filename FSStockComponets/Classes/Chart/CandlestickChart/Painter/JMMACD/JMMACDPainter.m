//
//  JMMACDPainter.m
//  ghchat
//
//  Created by fargowealth on 2021/10/26.
//

#import "JMMACDPainter.h"
#import "JMKlineGlobalVariable.h"
#import "UIColor+JMColor.h"

@implementation JMMACDPainter

+ (JMMinMaxModel *)getMinMaxValue:(NSArray <JMKlineModel *> *)data {
    if(!data) {
        return [JMMinMaxModel new];
    }
    __block CGFloat maxAssert = 0.f;
    [data enumerateObjectsUsingBlock:^(JMKlineModel * _Nonnull m, NSUInteger idx, BOOL * _Nonnull stop) {
        maxAssert = MAX(maxAssert, MAX(fabsf(m.MACD.DIFF.floatValue), MAX(fabsf(m.MACD.DEA.floatValue), fabsf(m.MACD.MACD.floatValue))));
    }];
    return [JMMinMaxModel modelWithMin:-maxAssert max:maxAssert];
}

+ (void)drawToLayer:(CALayer *)layer area:(CGRect)area models:(NSArray <JMKlineModel *> *)models minMax: (JMMinMaxModel *)minMaxModel {
    if(!models) {
        return;
    }
    CGFloat maxH = CGRectGetHeight(area);
    CGFloat unitValue = maxH/minMaxModel.distance;
    
    JMMACDPainter *sublayer = [[JMMACDPainter alloc] init];
    sublayer.frame = area;
    [layer addSublayer:sublayer];
    
    UIBezierPath *path1 = [UIBezierPath bezierPath];
    UIBezierPath *path2 = [UIBezierPath bezierPath];
    [models enumerateObjectsUsingBlock:^(JMKlineModel * _Nonnull m, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat w = [JMKlineGlobalVariable kLineWidth];
        CGFloat x = idx * (w + [JMKlineGlobalVariable kLineGap]);
        // 开收
        CGFloat h = fabsf(m.MACD.MACD.floatValue) * unitValue;
        CGFloat y = 0.f;
        if (m.MACD.MACD.floatValue > 0) {
            y = maxH - h + minMaxModel.min * unitValue;
        } else {
            y = maxH + minMaxModel.min * unitValue;
        }
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(x, y, w - [JMKlineGlobalVariable kLineGap], h)];
        CAShapeLayer *l = [CAShapeLayer layer];
        l.path = path.CGPath;
        l.lineWidth = JMKlineLineWidth;
        
        l.strokeColor = m.MACD.MACD.floatValue < 0 ? [UIColor upColor].CGColor : [UIColor downColor].CGColor;
        l.fillColor =   m.MACD.MACD.floatValue < 0 ? [UIColor upColor].CGColor : [UIColor downColor].CGColor;
        [sublayer addSublayer:l];
        
        
        CGPoint point1 = CGPointMake(x+w/2, maxH - (m.MACD.DEA.floatValue - minMaxModel.min)*unitValue);
        CGPoint point2 = CGPointMake(x+w/2, maxH - (m.MACD.DIFF.floatValue - minMaxModel.min)*unitValue);
        if (idx == 0) {
            [path1 moveToPoint:point1];
            [path2 moveToPoint:point2];
        } else {
            [path1 addLineToPoint:point1];
            [path2 addLineToPoint:point2];
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
}

+ (NSAttributedString *)getText:(JMKlineModel *)model {
    return model.V_MACD;
}

@end
