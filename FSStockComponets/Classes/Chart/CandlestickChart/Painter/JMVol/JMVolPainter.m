//
//  JMVolPainter.m
//  ghchat
//
//  Created by fargowealth on 2021/10/26.
//

#import "JMVolPainter.h"
#import "JMKlineGlobalVariable.h"
#import "UIColor+JMColor.h"
#import "JMChatManager.h"

@implementation JMVolPainter

+ (JMMinMaxModel *)getMinMaxValue:(NSArray <JMKlineModel *> *)data {
    if(!data) {
        return [JMMinMaxModel new];
    }
    __block CGFloat minAssert = 0.f;
    __block CGFloat maxAssert = 0.f;
    [data enumerateObjectsUsingBlock:^(JMKlineModel * _Nonnull m, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[JMChatManager sharedInstance].market isEqualToString:@"ZH"] && [JMChatManager sharedInstance].isStockIndex) {
            maxAssert = MAX(maxAssert, m.Volume.floatValue);
        } else {
            maxAssert = MAX(maxAssert, [JMChatManager sharedInstance].isStockIndex ? m.Turnover.floatValue : m.Volume.floatValue);
        }
    }];
    return [JMMinMaxModel modelWithMin:minAssert max:maxAssert];
}

+ (void)drawToLayer:(CALayer *)layer area:(CGRect)area models:(NSArray <JMKlineModel *> *)models minMax: (JMMinMaxModel *)minMaxModel {
    if(!models) {
        return;
    }
    CGFloat maxH = CGRectGetHeight(area);
    CGFloat unitValue = maxH/minMaxModel.distance;
    
    // 绘制背景分割线
    {
        CAShapeLayer *sublayer = [[CAShapeLayer alloc] init];
        CGFloat unitValue = maxH/3;
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        CGFloat y = area.origin.y;
        CGFloat xStart = area.origin.x;
        CGFloat xEnd = CGRectGetWidth(area);
        
        for (int i = 0; i<3; i++) {
            
            {//绘制分割线
                [path moveToPoint:CGPointMake(xStart, y)];
                [path addLineToPoint:CGPointMake(xEnd, y)];
            }
            y+=unitValue;
            
        }
        sublayer.lineWidth = 0.5;
        sublayer.strokeColor =  UIColor.wireframeColor.CGColor;
        sublayer.path = path.CGPath;
        sublayer.contentsScale = UIScreen.mainScreen.scale;
        sublayer.fillColor = nil;
        [layer addSublayer:sublayer];
    }

    // K线柱颜色
    __block UIColor *kStrokeColor = [UIColor upColor];
    __block UIColor *kFillColor = [UIColor clearColor];
    __block UIColor *kColor = [UIColor upColor];
    
    JMVolPainter *sublayer = [[JMVolPainter alloc] init];
    sublayer.frame = area;
    [models enumerateObjectsUsingBlock:^(JMKlineModel * _Nonnull m, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat w = [JMKlineGlobalVariable kLineWidth];
        CGFloat x = idx * (w + [JMKlineGlobalVariable kLineGap]);
        CGFloat h = 0.00;
        
        // 根据市场类型区分指数
        if ([[JMChatManager sharedInstance].market isEqualToString:@"ZH"] && [JMChatManager sharedInstance].isStockIndex) {
            h = fabs(m.Volume.floatValue - minMaxModel.min) * unitValue;
        } else {
            h = fabs(([JMChatManager sharedInstance].isStockIndex ? m.Turnover.floatValue : m.Volume.floatValue) - minMaxModel.min) * unitValue;
        }
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(x, maxH - h, w - [JMKlineGlobalVariable kLineGap], h)];
        CAShapeLayer *l = [CAShapeLayer layer];
        l.path = path.CGPath;
        l.lineWidth = JMKlineLineWidth;
        
        /// 分钟线烛图颜色
        if ([JMChatManager sharedInstance].chartType >= 9) {
            
            if ([m.PrevModel.Close compare:m.Close] == NSOrderedSame) {
                kStrokeColor = kColor;
                kFillColor = kColor;
            } else {
                kStrokeColor = m.isUp ? [UIColor upColor] : [UIColor downColor];
                kFillColor = m.isUp ? [UIColor clearColor] : [UIColor downColor];
                kColor = kStrokeColor;
            }
            
        } else {
            kStrokeColor = m.isUp ? [UIColor upColor] : [UIColor downColor];
            kFillColor = m.isUp ? [UIColor clearColor] : [UIColor downColor];
        }
        
        if (h > 0) {
            l.strokeColor = kStrokeColor.CGColor;
            l.fillColor = kFillColor.CGColor;
        } else {
            l.strokeColor = [UIColor clearColor].CGColor;
            l.fillColor = [UIColor clearColor].CGColor;
        }
        [sublayer addSublayer:l];
    }];
    [layer addSublayer:sublayer];
}

@end
