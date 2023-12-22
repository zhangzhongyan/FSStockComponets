//
//  YYMAPainter.m
//  YYKline
//
//  Copyright © 2019 WillkYang. All rights reserved.
//

#import "YYMAPainter.h"
#import "YYKlineGlobalVariable.h"
#import "UIColor+JMColor.h"

@implementation YYMAPainter

+ (YYMinMaxModel *)getMinMaxValue:(NSArray <YYKlineModel *> *)data {
    if(!data) {
        return [YYMinMaxModel new];
    }
    __block CGFloat minAssert = 999999999999.f;
    __block CGFloat maxAssert = 0.f;
    [data enumerateObjectsUsingBlock:^(YYKlineModel * _Nonnull m, NSUInteger idx, BOOL * _Nonnull stop) {
        maxAssert = MAX(maxAssert, MAX(m.MA.MA3.floatValue, MAX(m.MA.MA1.floatValue, m.MA.MA2.floatValue)));
        maxAssert = MAX(maxAssert, MAX(m.MA.MA4.floatValue,m.MA.MA5.floatValue));
        minAssert = MIN(minAssert, MIN(m.MA.MA3.floatValue, MIN(m.MA.MA1.floatValue, m.MA.MA2.floatValue)));
        minAssert = MIN(minAssert, MIN(m.MA.MA4.floatValue,m.MA.MA5.floatValue));
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
    
    YYMAPainter *sublayer = [[YYMAPainter alloc] init];
    sublayer.frame = area;
    UIBezierPath *path1 = [UIBezierPath bezierPath];
    UIBezierPath *path2 = [UIBezierPath bezierPath];
    UIBezierPath *path3 = [UIBezierPath bezierPath];
    UIBezierPath *path4 = [UIBezierPath bezierPath];
    UIBezierPath *path5 = [UIBezierPath bezierPath];
    [models enumerateObjectsUsingBlock:^(YYKlineModel * _Nonnull m, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat w = [YYKlineGlobalVariable kLineWidth];
        CGFloat x = idx * (w + [YYKlineGlobalVariable kLineGap]);
        CGPoint point1 = CGPointMake(x+w/2, maxH - (m.MA.MA1.floatValue - minMaxModel.min)*unitValue);
        CGPoint point2 = CGPointMake(x+w/2, maxH - (m.MA.MA2.floatValue - minMaxModel.min)*unitValue);
        CGPoint point3 = CGPointMake(x+w/2, maxH - (m.MA.MA3.floatValue - minMaxModel.min)*unitValue);
        CGPoint point4 = CGPointMake(x+w/2, maxH - (m.MA.MA4.floatValue - minMaxModel.min)*unitValue);
        CGPoint point5 = CGPointMake(x+w/2, maxH - (m.MA.MA5.floatValue - minMaxModel.min)*unitValue);
        if (idx == 0) {
            [path1 moveToPoint:point1];
            [path2 moveToPoint:point2];
            [path3 moveToPoint:point3];
            [path4 moveToPoint:point4];
            [path5 moveToPoint:point5];
        } else {
            [path1 addLineToPoint:point1];
            [path2 addLineToPoint:point2];
            [path3 addLineToPoint:point3];
            [path4 addLineToPoint:point4];
            [path5 addLineToPoint:point5];
        }
    }];
    
    {
        CAShapeLayer *l = [CAShapeLayer layer];
        l.path = path1.CGPath;
        l.lineWidth = YYKlineLineWidth;
        l.strokeColor = [UIColor line1Color].CGColor;
        l.fillColor =   [UIColor clearColor].CGColor;
        [sublayer addSublayer:l];
    }
    {
        CAShapeLayer *l = [CAShapeLayer layer];
        l.path = path2.CGPath;
        l.lineWidth = YYKlineLineWidth;
        l.strokeColor = [UIColor line2Color].CGColor;
        l.fillColor =   [UIColor clearColor].CGColor;
        [sublayer addSublayer:l];
    }
    {
        CAShapeLayer *l = [CAShapeLayer layer];
        l.path = path3.CGPath;
        l.lineWidth = YYKlineLineWidth;
        l.strokeColor = [UIColor line3Color].CGColor;
        l.fillColor =   [UIColor clearColor].CGColor;
        [sublayer addSublayer:l];
    }
    
    {
        CAShapeLayer *l = [CAShapeLayer layer];
        l.path = path4.CGPath;
        l.lineWidth = YYKlineLineWidth;
        l.strokeColor = [UIColor line4Color].CGColor;
        l.fillColor =   [UIColor clearColor].CGColor;
        [sublayer addSublayer:l];
    }
    
    {
        CAShapeLayer *l = [CAShapeLayer layer];
        l.path = path5.CGPath;
        l.lineWidth = YYKlineLineWidth;
        l.strokeColor = [UIColor line5Color].CGColor;
        l.fillColor =   [UIColor clearColor].CGColor;
        [sublayer addSublayer:l];
    }
    [layer addSublayer:sublayer];
}

+ (NSAttributedString *)getText:(YYKlineModel *)model {
    return model.V_MA;
}

@end
