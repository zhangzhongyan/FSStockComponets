//
//  YYCandlePainter.m
//  YYKline
//
//  Copyright © 2019 WillkYang. All rights reserved.
//

#import "YYCandlePainter.h"
#import "YYKlineGlobalVariable.h"
#import "UIColor+JMColor.h"
#import "JMChatManager.h"

@implementation YYCandlePainter

+ (YYMinMaxModel *)getMinMaxValue:(NSArray <YYKlineModel *> *)data {
    if(!data) {
        return [YYMinMaxModel new];
    }
    __block CGFloat minAssert = data[0].Low.floatValue;
    __block CGFloat maxAssert = data[0].High.floatValue;
    [data enumerateObjectsUsingBlock:^(YYKlineModel * _Nonnull m, NSUInteger idx, BOOL * _Nonnull stop) {
        maxAssert = MAX(maxAssert, m.High.floatValue);
        minAssert = MIN(minAssert, m.Low.floatValue);
    }];
    return [YYMinMaxModel modelWithMin:minAssert max:maxAssert];
}

+ (void)drawToLayer:(CALayer *)layer area:(CGRect)area models:(NSArray <YYKlineModel *> *)models minMax: (YYMinMaxModel *)minMaxModel close:(CGFloat)close price:(CGFloat)price{
    //    if(!models) {
    //        return;
    //    }
    CGFloat maxH = CGRectGetHeight(area);
    CGFloat unitValue = maxH/minMaxModel.distance;
    if (isinf(unitValue)) {
        unitValue = 0.0001;
    }
    
    YYCandlePainter *sublayer = [[YYCandlePainter alloc] init];
    sublayer.frame = area;
    sublayer.contentsScale = UIScreen.mainScreen.scale;
    [models enumerateObjectsUsingBlock:^(YYKlineModel * _Nonnull m, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat w = [YYKlineGlobalVariable kLineWidth];
        CGFloat x = idx * (w + [YYKlineGlobalVariable kLineGap]);
        CGFloat centerX = x+w/2.f-[YYKlineGlobalVariable kLineGap]/2.f;
        CGPoint highPoint = CGPointMake(centerX, maxH - (m.High.floatValue - minMaxModel.min)*unitValue);
        CGPoint lowPoint = CGPointMake(centerX, maxH - (m.Low.floatValue - minMaxModel.min)*unitValue);
        
        // 开收
        CGFloat h = fabsf(m.Open.floatValue - m.Close.floatValue) * unitValue;
        CGFloat y =  maxH - (MAX(m.Open.floatValue, m.Close.floatValue) - minMaxModel.min) * unitValue;
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(x, y, w - [YYKlineGlobalVariable kLineGap], h)];
        if(m.Open.floatValue == 0){
            path = [[UIBezierPath alloc] init];
            [path moveToPoint:lowPoint];
            [path addLineToPoint:highPoint];
        }else{
            [path moveToPoint:lowPoint];
            [path addLineToPoint:CGPointMake(centerX, y+h)];
            [path moveToPoint:highPoint];
            [path addLineToPoint:CGPointMake(centerX, y)];
        }
        
        CAShapeLayer *l = [CAShapeLayer layer];
        l.contentsScale = UIScreen.mainScreen.scale;
        l.path = path.CGPath;
        l.lineWidth = YYKlineLineWidth;
        l.strokeColor = m.isUp ? [UIColor upColor].CGColor : [UIColor downColor].CGColor;
        //        l.fillColor =   m.isUp ? [UIColor upColor].CGColor : [UIColor clearColor].CGColor;//红色实心
        l.fillColor =   m.isUp ? [UIColor clearColor].CGColor : [UIColor downColor].CGColor;//绿色实心
        [sublayer addSublayer:l];
        
    }];
    [layer addSublayer:sublayer];
    
    {
        
        CAShapeLayer *sublayer = [[CAShapeLayer alloc] init];
        CGFloat unitValue = maxH/4;
        CGFloat unitValuePrice = (minMaxModel.max - minMaxModel.min)/4;
        if (isinf(unitValuePrice)) {
            unitValuePrice = 0.0001;
        }
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        CGFloat y = area.origin.y;
        CGFloat   xStart = area.origin.x;
        CGFloat     xEnd = CGRectGetWidth(area);
        
        for (int i = 0; i<5; i++) {
            
            {//绘制分割线
                [path  moveToPoint:CGPointMake(xStart, y)];
                [path addLineToPoint:CGPointMake(xEnd, y)];
            }
            
            
            {//绘制左轴坐标
                CATextLayer *textLayer = [CATextLayer layer];
                CGFloat tempPrice = minMaxModel.max-i*unitValuePrice;
                textLayer.string = [NSString stringWithFormat:[JMChatManager sharedInstance].priceFormate,tempPrice];
                textLayer.alignmentMode = kCAAlignmentLeft;
                textLayer.fontSize = 8.f;
                if (tempPrice>=close) {
                    textLayer.foregroundColor = UIColor.upColor.CGColor;
                }else{
                    textLayer.foregroundColor = UIColor.downColor.CGColor;
                }
                textLayer.frame = CGRectMake(0, y-[UIFont systemFontOfSize:8.f].lineHeight, YYKlineLinePriceViewWidth, [UIFont systemFontOfSize:8.f].lineHeight);
                textLayer.contentsScale = UIScreen.mainScreen.scale;
                [layer addSublayer:textLayer];
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
            
            sublayer.lineWidth = 0.8;
            sublayer.strokeColor =  UIColor.priceLineColor.CGColor;
            sublayer.path = path.CGPath;
            sublayer.contentsScale = UIScreen.mainScreen.scale;
            [sublayer setLineDashPattern:@[@10,@10]];
            sublayer.fillColor = nil;
            [layer addSublayer:sublayer];
        }
        
        
    }
    
    //绘制昨收
    {
        
        //        if(minMaxModel.min <= close && close <= minMaxModel.max){
        //
        //            CAShapeLayer *sublayer = [[CAShapeLayer alloc] init];
        //            sublayer.frame = area;
        //            UIBezierPath *path = [UIBezierPath bezierPath];
        //            CGFloat   xStart = area.origin.x;
        //            CGFloat     xEnd = CGRectGetWidth(area);
        //
        //            CGFloat y =  maxH - (close - minMaxModel.min) * unitValue;
        //            [path  moveToPoint:CGPointMake(xStart, y)];
        //            [path addLineToPoint:CGPointMake(xEnd, y)];
        //
        //            sublayer.lineWidth = 0.5;
        //            sublayer.strokeColor =  UIColor.closeLineColor.CGColor;
        //            sublayer.path = path.CGPath;
        //            sublayer.contentsScale = UIScreen.mainScreen.scale;
        //            [sublayer setLineDashPattern:@[@10,@10]];
        //            sublayer.fillColor = nil;
        //            [layer addSublayer:sublayer];
        //        }
        
        
    }
    
}

@end
