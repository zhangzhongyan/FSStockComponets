//
//  YYWRPainter.m
//  YYKline
//
//  Copyright © 2019 WillkYang. All rights reserved.
//

#import "YYWRPainter.h"
#import "YYKlineGlobalVariable.h"
#import "UIColor+JMColor.h"

@implementation YYWRPainter

+ (YYMinMaxModel *)getMinMaxValue:(NSArray <YYKlineModel *> *)data {
    if(!data) {
        return [YYMinMaxModel new];
    }
    __block CGFloat minAssert = 999999999999.f;
    __block CGFloat maxAssert = 0.f;
    [data enumerateObjectsUsingBlock:^(YYKlineModel * _Nonnull m, NSUInteger idx, BOOL * _Nonnull stop) {
        maxAssert = MAX(maxAssert, MAX(m.WR.WR1.floatValue, m.WR.WR2.floatValue));
        minAssert = MIN(minAssert, MIN(m.WR.WR1.floatValue, m.WR.WR2.floatValue));
    }];
    return [YYMinMaxModel modelWithMin:minAssert max:maxAssert];
}

+ (void)drawToLayer:(CALayer *)layer area:(CGRect)area models:(NSArray <YYKlineModel *> *)models minMax: (YYMinMaxModel *)minMaxModel close:(CGFloat)close price:(CGFloat)price{
    if(!models) {
        return;
    }
    CGFloat maxH = CGRectGetHeight(area);
    CGFloat unitValue = maxH/minMaxModel.distance;
    if (isinf(unitValue)) {
        unitValue = 0.0001;
    }
    
    YYWRPainter *sublayer = [[YYWRPainter alloc] init];
    sublayer.frame = area;
    UIBezierPath *path1 = [UIBezierPath bezierPath];
    UIBezierPath *path2 = [UIBezierPath bezierPath];
    [models enumerateObjectsUsingBlock:^(YYKlineModel * _Nonnull m, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat w = [YYKlineGlobalVariable kLineWidth];
        CGFloat x = idx * (w + [YYKlineGlobalVariable kLineGap]);
        CGPoint point1 = CGPointMake(x+w/2, maxH - (m.WR.WR1.floatValue - minMaxModel.min)*unitValue);
        CGPoint point2 = CGPointMake(x+w/2, maxH - (m.WR.WR2.floatValue - minMaxModel.min)*unitValue);
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
        l.lineWidth = YYKlineLineWidth;
        l.strokeColor = UIColor.line1Color.CGColor;
        l.fillColor =   [UIColor clearColor].CGColor;
        [sublayer addSublayer:l];
    }
    {
        CAShapeLayer *l = [CAShapeLayer layer];
        l.path = path2.CGPath;
        l.lineWidth = YYKlineLineWidth;
        l.strokeColor = UIColor.line2Color.CGColor;
        l.fillColor =   [UIColor clearColor].CGColor;
        [sublayer addSublayer:l];
    }
    [layer addSublayer:sublayer];
}

+ (NSAttributedString *)getText:(YYKlineModel *)model {
    return model.V_WR;
}

@end
