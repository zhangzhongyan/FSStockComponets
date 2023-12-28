//
//  YYVolPainter.m
//  YYKline
//
//  Copyright © 2019 WillkYang. All rights reserved.
//

#import "YYVolPainter.h"
#import "YYKlineGlobalVariable.h"
#import "UIColor+JMColor.h"
#import "JMChatManager.h"
//Helper
#import "FSStockComponetsLanguage.h"

@implementation YYVolPainter
+ (YYMinMaxModel *)getMinMaxValue:(NSArray <YYKlineModel *> *)data {
    if(!data) {
        return [YYMinMaxModel new];
    }
    __block CGFloat minAssert = 0.f;
    __block CGFloat maxAssert = 0.f;
    [data enumerateObjectsUsingBlock:^(YYKlineModel * _Nonnull m, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[JMChatManager sharedInstance].market isEqualToString:@"ZH"] && [JMChatManager sharedInstance].isStockIndex) {
            maxAssert = MAX(maxAssert, m.Volume.floatValue);
        } else {
            maxAssert = MAX(maxAssert, [JMChatManager sharedInstance].isStockIndex ? m.Turnover.floatValue : m.Volume.floatValue);
        }
    }];
    return [YYMinMaxModel modelWithMin:minAssert max:maxAssert];
}

// K线成交量
+ (void)drawToLayer:(CALayer *)layer area:(CGRect)area models:(NSArray <YYKlineModel *> *)models minMax: (YYMinMaxModel *)minMaxModel close:(CGFloat)close price:(CGFloat)price{
//    if(!models) {
//        return;
//    }
    CGFloat maxH = CGRectGetHeight(area);
    CGFloat unitValue = maxH/minMaxModel.distance;
    if (isinf(unitValue)) {
        unitValue = 0.0001;
    }
    YYVolPainter *sublayer = [[YYVolPainter alloc] init];
    sublayer.frame = area;
    [models enumerateObjectsUsingBlock:^(YYKlineModel * _Nonnull m, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat w = [YYKlineGlobalVariable kLineWidth];
        CGFloat x = idx * (w + [YYKlineGlobalVariable kLineGap]);
        CGFloat h = fabs(m.Volume.floatValue - minMaxModel.min) * unitValue;
        if (m.Volume.floatValue < minMaxModel.min) {
            return;
        }
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(x, maxH - h, w - [YYKlineGlobalVariable kLineGap], h)];
        CAShapeLayer *l = [CAShapeLayer layer];
        l.path = path.CGPath;
        l.lineWidth = YYKlineLineWidth;
        l.strokeColor = m.isUp ? [UIColor upColor].CGColor : [UIColor downColor].CGColor;
        l.fillColor = m.isUp ? [UIColor upColor].CGColor : [UIColor downColor].CGColor;
        [sublayer addSublayer:l];
    }];
    [layer addSublayer:sublayer];


    
    
    
    {
        CAShapeLayer *sublayer = [[CAShapeLayer alloc] init];
        CGFloat unitValue = maxH/3;
        CGFloat unitValuePrice = (minMaxModel.max - minMaxModel.min)/3;
        UIBezierPath *path = [UIBezierPath bezierPath];
        CGFloat y = area.origin.y;
        CGFloat   xStart = area.origin.x;
        CGFloat   xEnd = CGRectGetWidth(area);
        
        for (int i = 0; i<4; i++) {
            
            {//绘制边框
                [path  moveToPoint:CGPointMake(xStart, y)];
                [path addLineToPoint:CGPointMake(xEnd, y)];
            }
            
            {//绘制左轴坐标
                
                NSString * volumeString = @"";
                CGFloat dif = 1.0f;
                if (minMaxModel.max>100000000) {
                    volumeString = [[JMChatManager sharedInstance].market isEqualToString:@"ZH"] ? FSMacroLanguage(@"亿手") : FSMacroLanguage(@"亿股");
                    dif = 100000000.0f;
                }else if(minMaxModel.max>10000){
                    volumeString = [[JMChatManager sharedInstance].market isEqualToString:@"ZH"] ? FSMacroLanguage(@"万手") : FSMacroLanguage(@"万股");
                    dif = ([FSStockComponetsLanguage isChineseLanguage])? 10000.0f: 1000.0f;
                }
                
                CATextLayer *textLayer = [CATextLayer layer];
                textLayer.string = [NSString stringWithFormat:@"%@  %.3f%@",i==0? FSMacroLanguage(@"成交量(k线)"):@"",(minMaxModel.max-i*unitValuePrice)/dif,i==0?volumeString:@""];
                textLayer.alignmentMode = kCAAlignmentLeft;
                textLayer.fontSize = 8.f;
                textLayer.foregroundColor = [UIColor volWordColor].CGColor;
                textLayer.frame = CGRectMake(0, y-[UIFont systemFontOfSize:8.f].lineHeight, 100, [UIFont systemFontOfSize:8.f].lineHeight);
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
        [layer insertSublayer:sublayer atIndex:0];
    }
    
    

}

// 分时、五日线成交量
+ (void)drawToLayer2:(CALayer *)layer area:(CGRect)area models:(NSArray <YYKlineModel *> *)models minMax: (YYMinMaxModel *)minMaxModel close:(CGFloat)close price:(CGFloat)price{
//    if(!models) {
//        return;
//    }
    CGFloat maxH = CGRectGetHeight(area);
    CGFloat unitValue = maxH/minMaxModel.distance;
    YYVolPainter *sublayer = [[YYVolPainter alloc] init];
    sublayer.frame = area;
    [models enumerateObjectsUsingBlock:^(YYKlineModel * _Nonnull m, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat w = [YYKlineGlobalVariable kLineWidth];
        CGFloat x = idx * (w + [YYKlineGlobalVariable kLineGap]);
//        CGFloat h = fabs(m.Volume.floatValue - minMaxModel.min) * unitValue;
        
        CGFloat h = 0.00;
        
        // 根据市场类型区分指数
        if ([[JMChatManager sharedInstance].market isEqualToString:@"ZH"] && [JMChatManager sharedInstance].isStockIndex) {
            h = fabs(m.Volume.floatValue - minMaxModel.min) * unitValue;
        } else {
            h = fabs(([JMChatManager sharedInstance].isStockIndex ? m.Turnover.floatValue : m.Volume.floatValue) - minMaxModel.min) * unitValue;
        }
        
        if (m.Volume.floatValue < minMaxModel.min) {
            return;
        }
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(x, maxH - h, w - [YYKlineGlobalVariable kLineGap], h)];
        CAShapeLayer *l = [CAShapeLayer layer];
        l.path = path.CGPath;
        l.lineWidth = YYKlineLineWidth;
//        l.strokeColor = m.timeIsUp ? [UIColor upColor].CGColor : [UIColor downColor].CGColor;
//        l.fillColor = m.timeIsUp ? [UIColor upColor].CGColor : [UIColor downColor].CGColor;
        l.strokeColor = m.timeIsUpColor.CGColor;
        l.fillColor = m.timeIsUpColor.CGColor;
        [sublayer addSublayer:l];
    }];
    [layer addSublayer:sublayer];
    
    
    {
        CAShapeLayer *sublayer = [[CAShapeLayer alloc] init];
        CGFloat unitValue = maxH/3;
        CGFloat unitValuePrice = (minMaxModel.max - minMaxModel.min)/3;
        UIBezierPath *path = [UIBezierPath bezierPath];
        CGFloat y = area.origin.y;
        CGFloat   xStart = area.origin.x;
        CGFloat   xEnd = CGRectGetWidth(area);
        
        // 标题
        NSString *volStr = [JMChatManager sharedInstance].isStockIndex ? FSMacroLanguage(@"成交额") : FSMacroLanguage(@"成交量(k线)");
        // 单位
        NSString *unitStr = [JMChatManager sharedInstance].isStockIndex ? @"" : [[JMChatManager sharedInstance].market isEqualToString:@"ZH"] ? FSMacroLanguage(@"手") : FSMacroLanguage(@"股");
        
        // 根据市场类型区分指数
        if ([[JMChatManager sharedInstance].market isEqualToString:@"ZH"] && [JMChatManager sharedInstance].isStockIndex) {
            volStr = FSMacroLanguage(@"成交量(k线)");
            unitStr = FSMacroLanguage(@"手");
        } else {
            volStr = [JMChatManager sharedInstance].isStockIndex ? FSMacroLanguage(@"成交额") : FSMacroLanguage(@"成交量(k线)");
            unitStr = [JMChatManager sharedInstance].isStockIndex ? @"" : [[JMChatManager sharedInstance].market isEqualToString:@"ZH"] ? FSMacroLanguage(@"手") : FSMacroLanguage(@"股");
        }
        
        for (int i = 0; i<4; i++) {
            
            {//绘制边框
                [path  moveToPoint:CGPointMake(xStart, y)];
                [path addLineToPoint:CGPointMake(xEnd, y)];
            }
            
            {//绘制左轴坐标
                
                NSString * volumeString = @"";
                CGFloat dif = 1.0f;
                if (minMaxModel.max>100000000) {
                    volumeString = [NSString stringWithFormat:@"%@%@", FSMacroLanguage(@"亿"), unitStr];
                    dif = 100000000.0f;
                } else if(minMaxModel.max>10000){
                    volumeString = [NSString stringWithFormat:@"%@%@", FSMacroLanguage(@"万"), unitStr];
                    dif = ([FSStockComponetsLanguage isChineseLanguage])? 10000.0f: 1000.0f;
                }
                
                // 向下取整，解决美股成交量有小数位
                CGFloat total = (minMaxModel.max-i*unitValuePrice)/dif;
                if (minMaxModel.max < 10000) {
                    total = floorf(total);
                }
                
                CATextLayer *textLayer = [CATextLayer layer];
                NSString *asdfas = [NSString stringWithFormat:@"%@  %.1f%@",i==0?volStr:@"",total,i==0?volumeString:@""];
                textLayer.string = asdfas;
                textLayer.alignmentMode = kCAAlignmentLeft;
                
                if (i == 0) {
                    textLayer.fontSize = 12.f;
                    textLayer.foregroundColor = UIColor.handicapInfoTextColor.CGColor;
                } else {
                    textLayer.fontSize = 10.f;
                    textLayer.foregroundColor = UIColor.secondaryTextColor.CGColor;
                }
                
                textLayer.frame = CGRectMake(0, y-[UIFont systemFontOfSize:12.f].lineHeight, CGRectGetWidth(area), [UIFont systemFontOfSize:12.f].lineHeight);
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
        [layer insertSublayer:sublayer atIndex:0];
    }

}
@end
