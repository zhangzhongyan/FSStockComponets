//
//  JMCandlePainter.m
//  ghchat
//
//  Created by fargowealth on 2021/10/26.
//

#import "JMCandlePainter.h"
#import "JMKlineGlobalVariable.h"
#import "NSString+DecimalsCalculation.h"
#import "JMChatManager.h"
#import "UIColor+JMColor.h"

@implementation JMCandlePainter

+ (JMMinMaxModel *)getMinMaxValue:(NSArray <JMKlineModel *> *)data {
    if(!data) {
        return [JMMinMaxModel new];
    }
    __block CGFloat minAssert = data[0].Low.floatValue;
    __block CGFloat maxAssert = data[0].High.floatValue;
    [data enumerateObjectsUsingBlock:^(JMKlineModel * _Nonnull m, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (m.Open.floatValue == m.Close.floatValue && m.Open.floatValue == m.High.floatValue && m.Open.floatValue == m.Low.floatValue) {
            maxAssert = MAX(maxAssert, m.Open.floatValue + 0.004);
            minAssert = MIN(minAssert, m.Open.floatValue - 0.004);
        } else {
            maxAssert = MAX(maxAssert, m.High.floatValue);
            minAssert = MIN(minAssert, m.Low.floatValue);
        }
        
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
    
    // 现价
    CGFloat price = currentPrice;
    
    CGFloat maxH = CGRectGetHeight(area);
    CGFloat unitValue = maxH/minMaxModel.distance;
    
    // 绘制背景分割线
    {
        CAShapeLayer *sublayer = [[CAShapeLayer alloc] init];
//        CGFloat unitValue = maxH/4;
        CGFloat unitValue = (CGRectGetHeight(area) + 15) / 4;
        
        UIBezierPath *path = [UIBezierPath bezierPath];
//        CGFloat y = area.origin.y;
        CGFloat y = area.origin.y - 15;
        CGFloat xStart = area.origin.x;
        CGFloat xEnd = CGRectGetWidth(area);
        
        for (int i = 0; i<5; i++) {
            
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
    
    //绘制现价线
    {
        if(minMaxModel.min <= price && price <= minMaxModel.max){
            
            CAShapeLayer *sublayer = [[CAShapeLayer alloc] init];
            sublayer.frame = area;
            UIBezierPath *path = [UIBezierPath bezierPath];
            CGFloat   xStart = area.origin.x;
            CGFloat     xEnd = CGRectGetWidth(area);
            
            CGFloat y =  maxH - (price - minMaxModel.min) * unitValue;
            [path  moveToPoint:CGPointMake(xStart, y)];
            [path addLineToPoint:CGPointMake(xEnd, y)];
            
            sublayer.lineWidth = 0.8f;
            sublayer.strokeColor =  UIColor.priceLineColor.CGColor;
            sublayer.path = path.CGPath;
            sublayer.contentsScale = UIScreen.mainScreen.scale;
            [sublayer setLineDashPattern:@[@5,@5]];
            sublayer.fillColor = nil;
            [layer addSublayer:sublayer];
        }
    }
    
    // 最高值
    __block CGFloat highValue = 0.00;
    // 是否绘制最高值
    __block BOOL isDrawHigh = NO;
    // 最低值
    __block CGFloat lowValue = 1000000000.00;
    // 是否绘制最低值
    __block BOOL isDrawLow = NO;
    // K线柱颜色
    __block UIColor *kStrokeColor = [UIColor upColor];
    __block UIColor *kFillColor = [UIColor clearColor];
    __block UIColor *kColor = [UIColor upColor];
    
    [models enumerateObjectsUsingBlock:^(JMKlineModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        highValue = highValue > model.High.floatValue ? highValue : model.High.floatValue;
        lowValue = lowValue < model.Low.floatValue ? lowValue : model.Low.floatValue;
    }];
    
    // 绘制K线
    JMCandlePainter *sublayer = [[JMCandlePainter alloc] init];
    sublayer.frame = area;
    sublayer.contentsScale = UIScreen.mainScreen.scale;
    
    [models enumerateObjectsUsingBlock:^(JMKlineModel * _Nonnull m, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGFloat w = [JMKlineGlobalVariable kLineWidth];
        CGFloat x = idx * (w + [JMKlineGlobalVariable kLineGap]);
        CGFloat centerX = x+w/2.f-[JMKlineGlobalVariable kLineGap]/2.f;
        
        CGPoint highPoint = CGPointMake(centerX, maxH - (m.High.floatValue - minMaxModel.min)*unitValue);
        CGPoint lowPoint = CGPointMake(centerX, maxH - (m.Low.floatValue - minMaxModel.min)*unitValue);
        
        // 开收
        CGFloat h = fabsf(m.Open.floatValue - m.Close.floatValue) * unitValue;
        CGFloat y =  maxH - (MAX(m.Open.floatValue, m.Close.floatValue) - minMaxModel.min) * unitValue;
        
        // 上影线
//        CGFloat highPoint_Height = (m.High.floatValue - minMaxModel.min)*unitValue >= maxH ? maxH - y + 20 : (m.High.floatValue - minMaxModel.min)*unitValue;
//        CGPoint highPoint = CGPointMake(centerX, maxH - highPoint_Height);
//        // 下影线
//        CGFloat lowPoint_Height = (m.Low.floatValue - minMaxModel.min)*unitValue > testValue ? testValue : (m.Low.floatValue - minMaxModel.min)*unitValue;
//        CGPoint lowPoint = CGPointMake(centerX, maxH - lowPoint_Height);
        
        // TODO: 处理数据异常
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(x, y, w - [JMKlineGlobalVariable kLineGap],h)];
        
//        if ([m.Open compare:m.Close] == NSOrderedSame
//            && [m.Open compare:m.High] == NSOrderedSame
//            && [m.Open compare:m.Low] == NSOrderedSame) {
//
////            [path addLineToPoint:CGPointMake(centerX, y+h)];
//            [path addLineToPoint:CGPointMake(centerX, y)];
//
//        } else if (fabsf(m.Open.floatValue) <= 0.01) {
////            [path addLineToPoint:CGPointMake(centerX, y+h)];
//            [path addLineToPoint:CGPointMake(centerX, y)];
//        } else if ([m.Open compare:m.Low] == NSOrderedSame && [m.Open compare:m.Close] == NSOrderedSame) {
//
////            [path addLineToPoint:CGPointMake(centerX, y+h)];
//            [path addLineToPoint:CGPointMake(centerX, y)];
//
//        } else {
//            [path moveToPoint:lowPoint];
//            [path addLineToPoint:CGPointMake(centerX, y+h)];
//            [path moveToPoint:highPoint];
//            [path addLineToPoint:CGPointMake(centerX, y)];
//        }
        
        if ([m.Open compare:m.Close] == NSOrderedSame
            && [m.Open compare:m.High] == NSOrderedSame
            && [m.Open compare:m.Low] == NSOrderedSame) {
            [path addLineToPoint:CGPointMake(centerX, y)];
        } else {
            [path moveToPoint:lowPoint];
            [path addLineToPoint:CGPointMake(centerX, y+h)];
            [path moveToPoint:highPoint];
            [path addLineToPoint:CGPointMake(centerX, y)];
        }
        
        /// 分钟线烛图颜色
        if ([JMChatManager sharedInstance].chartType >= 9) {
            
            if ([m.PrevModel.Close compare:m.Close] == NSOrderedSame) {
                kStrokeColor = kColor;
                kFillColor = [UIColor clearColor];
            } else {
                kStrokeColor = m.isUp ? [UIColor upColor] : [UIColor downColor];
                kFillColor = m.isUp ? [UIColor clearColor] : [UIColor downColor];
                kColor = kStrokeColor;
            }
            
        } else {
            kStrokeColor = m.isUp ? [UIColor upColor] : [UIColor downColor];
            kFillColor = m.isUp ? [UIColor clearColor] : [UIColor downColor];
        }
        
        CAShapeLayer *l = [CAShapeLayer layer];
        l.contentsScale = UIScreen.mainScreen.scale;
        l.path = path.CGPath;
        l.lineWidth = JMKlineLineWidth;
        l.strokeColor = kStrokeColor.CGColor;
        l.fillColor = kFillColor.CGColor; //绿色实心
        [sublayer addSublayer:l];
        
        
        // 绘制最高价标注
        if (m.High.floatValue == highValue && !isDrawHigh) {
        
            // 改变状态
            isDrawHigh = YES;
            // 坐标
            CGRect rect;
            // 价格
            NSString *highPrice;
            // y
            CGFloat yY = y + 10;
//            if (h >= 15.0) {
//                yY = h;
                yY = highPoint.y + 25;
//            }
            
            // 获取距离屏幕边缘位置，改变展示方向
            if (x < JMKlineMainViewWidth) {
//                rect = CGRectMake(x - 5, y + 10, 50, 10);
                rect = CGRectMake(x - 5, yY, 50, 10);
                highPrice = [NSString stringWithFormat:@"— %.3f",m.High.doubleValue];
            } else {
//                rect = CGRectMake(x - 45, y + 10, 50, 10);
                rect = CGRectMake(x - 45, yY, 50, 10);
                highPrice = [NSString stringWithFormat:@"%.3f —",m.High.doubleValue];
            }
            
            // 处理NaN
            if (isnan(rect.origin.y)) {
                return;
            }
            
            CATextLayer *textLayer = [CATextLayer layer];
            textLayer.frame = rect;
            textLayer.string = highPrice;
            // 文字的前景色和背景色
            textLayer.foregroundColor = [UIColor whiteColor].CGColor; //用于渲染接收文本的颜色。
            // 文字超出视图边界裁剪
            textLayer.wrapped = YES;
            // 文字的字体
            textLayer.fontSize = 8.f;
            // 文字居中
            textLayer.alignmentMode = kCAAlignmentCenter;
            // 适应屏幕的Retina分辨率,防止像素画导致模糊
            textLayer.contentsScale = [UIScreen mainScreen].scale;
            [layer addSublayer:textLayer];
        }
        
        // 绘制最低价标注
        if (m.Low.floatValue == lowValue && !isDrawLow) {
        
            // 改变状态
            isDrawLow = YES;
            // 坐标
            CGRect rect;
            // 价格
            NSString *lowPrice;
            
            // 获取距离屏幕边缘位置，改变展示方向
            if (x < JMKlineMainViewWidth) {
//                rect = CGRectMake(x - 5, maxH - (m.Low.floatValue - minMaxModel.min)*unitValue + 12, 50, 10);
                rect = CGRectMake(x - 5, maxH - (m.Low.floatValue - minMaxModel.min)*unitValue + 30, 50, 10);
                lowPrice = [NSString stringWithFormat:@"— %.3f",m.Low.doubleValue];
            } else {
//                rect = CGRectMake(x - 45, maxH - (m.Low.floatValue - minMaxModel.min)*unitValue + 12, 50, 10);
                rect = CGRectMake(x - 45, maxH - (m.Low.floatValue - minMaxModel.min)*unitValue + 30, 50, 10);
                lowPrice = [NSString stringWithFormat:@"%.3f —",m.Low.doubleValue];
            }
            
            // 处理NaN
            if (isnan(rect.origin.y)) {
                return;
            }
            
            CATextLayer *textLayer = [CATextLayer layer];
            textLayer.frame = rect;
            textLayer.string = lowPrice;
            // 文字的前景色和背景色
            textLayer.foregroundColor = [UIColor whiteColor].CGColor; //用于渲染接收文本的颜色。
            // 文字超出视图边界裁剪
            textLayer.wrapped = YES;
            // 文字的字体
            textLayer.fontSize = 8.f;
            // 文字居中
            textLayer.alignmentMode = kCAAlignmentCenter;
            // 适应屏幕的Retina分辨率,防止像素画导致模糊
            textLayer.contentsScale = [UIScreen mainScreen].scale;
            [layer addSublayer:textLayer];
        }

    }];
    
    [layer addSublayer:sublayer];
    
}

@end
