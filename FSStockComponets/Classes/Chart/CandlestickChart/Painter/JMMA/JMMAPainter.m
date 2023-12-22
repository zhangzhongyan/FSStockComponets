//
//  JMMAPainter.m
//  ghchat
//
//  Created by fargowealth on 2021/10/26.
//

#import "JMMAPainter.h"
#import "JMKlineGlobalVariable.h"
#import "UIColor+JMColor.h"

@implementation JMMAPainter

+ (JMMinMaxModel *)getMinMaxValue:(NSArray <JMKlineModel *> *)data {
    if(!data) {
        return [JMMinMaxModel new];
    }
    __block CGFloat minAssert = 999999999999.f;
    __block CGFloat maxAssert = 0.f;
    [data enumerateObjectsUsingBlock:^(JMKlineModel * _Nonnull m, NSUInteger idx, BOOL * _Nonnull stop) {
        maxAssert = MAX(maxAssert, MAX(m.MA.MA3.floatValue, MAX(m.MA.MA1.floatValue, m.MA.MA2.floatValue)));
        minAssert = MIN(minAssert, MIN(m.MA.MA3.floatValue, MIN(m.MA.MA1.floatValue, m.MA.MA2.floatValue)));
    }];
    return [JMMinMaxModel modelWithMin:minAssert max:maxAssert];
}

+ (void)drawToLayer:(CALayer *)layer area:(CGRect)area models:(NSArray <JMKlineModel *> *)models minMax: (JMMinMaxModel *)minMaxModel {
    if(!models) {
        return;
    }
    CGFloat maxH = CGRectGetHeight(area);
    CGFloat unitValue = maxH/minMaxModel.distance;
    
    // 记录上次的值
    __block CGPoint p1;
    __block CGPoint p2;
    __block CGPoint p3;
    
    JMMAPainter *sublayer = [[JMMAPainter alloc] init];
    sublayer.frame = area;
    UIBezierPath *path1 = [UIBezierPath bezierPath];
    UIBezierPath *path2 = [UIBezierPath bezierPath];
    UIBezierPath *path3 = [UIBezierPath bezierPath];
    UIBezierPath *path4 = [UIBezierPath bezierPath];
    UIBezierPath *path5 = [UIBezierPath bezierPath];
    [models enumerateObjectsUsingBlock:^(JMKlineModel * _Nonnull m, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat w = [JMKlineGlobalVariable kLineWidth];
        CGFloat x = idx * (w + [JMKlineGlobalVariable kLineGap]);
        CGPoint point1 = CGPointMake(x+w/2, maxH - (m.MA.MA1.floatValue - minMaxModel.min)*unitValue);
        CGPoint point2 = CGPointMake(x+w/2, maxH - (m.MA.MA2.floatValue - minMaxModel.min)*unitValue);
        CGPoint point3 = CGPointMake(x+w/2, maxH - (m.MA.MA3.floatValue - minMaxModel.min)*unitValue);
        CGPoint point4 = CGPointMake(x+w/2, maxH - (m.MA.MA4.floatValue - minMaxModel.min)*unitValue);
        CGPoint point5 = CGPointMake(x+w/2, maxH - (m.MA.MA5.floatValue - minMaxModel.min)*unitValue);
        
        // TODO: 处理数据异常
        // fabsf(m.Open.floatValue) <= 0.01 ||
//        if ([m.Open compare:m.Close] == NSOrderedSame
//            && [m.Open compare:m.Low] == NSOrderedSame
//            && [m.Open compare:m.High] == NSOrderedSame) {
//            p1 = CGPointMake(x+w/2, maxH/2);
//            p2 = CGPointMake(x+w/2, maxH/2);
//            p3 = CGPointMake(x+w/2, maxH/2);
//        } else {
//            p1 = point1;
//            p2 = point2;
//            p3 = point3;
//        }
        
//        if (fabsf(m.Open.floatValue) <= 0.01) {
//            point1 = CGPointMake(x+w/2, p1.y);
//            point2 = CGPointMake(x+w/2, p2.y);
//            point3 = CGPointMake(x+w/2, p3.y);
//        }
//        
//        if ([m.Open compare:m.Close] == NSOrderedSame
//            && [m.Open compare:m.Low] == NSOrderedSame
//            && [m.Open compare:m.High] == NSOrderedSame) {
//            point1 = CGPointMake(x+w/2, p1.y);
//            point2 = CGPointMake(x+w/2, p2.y);
//            point3 = CGPointMake(x+w/2, p3.y);
//        }
        
//        if (fabsf(m.Open.floatValue) <= 0.01) {
//            point1 = CGPointMake(x+w/2, maxH/2);
//            point2 = CGPointMake(x+w/2, maxH/2);
//            point3 = CGPointMake(x+w/2, maxH/2);
//        }
//
//        if ([m.Open compare:m.Close] == NSOrderedSame
//            && [m.Open compare:m.Low] == NSOrderedSame
//            && [m.Open compare:m.High] == NSOrderedSame) {
//            point1 = CGPointMake(x+w/2, maxH/2);
//            point2 = CGPointMake(x+w/2, maxH/2);
//            point3 = CGPointMake(x+w/2, maxH/2);
//        }
        
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
        l.lineWidth = JMKlineLineWidth;
        l.strokeColor = [UIColor line1Color].CGColor;
        l.fillColor =   [UIColor clearColor].CGColor;
        [sublayer addSublayer:l];
    }
    {
        CAShapeLayer *l = [CAShapeLayer layer];
        l.path = path2.CGPath;
        l.lineWidth = JMKlineLineWidth;
        l.strokeColor = [UIColor line2Color].CGColor;
        l.fillColor =   [UIColor clearColor].CGColor;
        [sublayer addSublayer:l];
    }
    {
        CAShapeLayer *l = [CAShapeLayer layer];
        l.path = path3.CGPath;
        l.lineWidth = JMKlineLineWidth;
        l.strokeColor = [UIColor line3Color].CGColor;
        l.fillColor =   [UIColor clearColor].CGColor;
        [sublayer addSublayer:l];
    }
    {
        CAShapeLayer *l = [CAShapeLayer layer];
        l.path = path4.CGPath;
        l.lineWidth = JMKlineLineWidth;
        l.strokeColor = [UIColor line4Color].CGColor;
        l.fillColor =   [UIColor clearColor].CGColor;
        [sublayer addSublayer:l];
    }
    {
        CAShapeLayer *l = [CAShapeLayer layer];
        l.path = path5.CGPath;
        l.lineWidth = JMKlineLineWidth;
        l.strokeColor = [UIColor line5Color].CGColor;
        l.fillColor =   [UIColor clearColor].CGColor;
        [sublayer addSublayer:l];
    }
    [layer addSublayer:sublayer];
}

+ (NSAttributedString *)getText:(JMKlineModel *)model {
    return model.V_MA;
}

@end
