//
//  YYTimelinePainter.m
//  YYKline
//
//  Copyright © 2019 WillkYang. All rights reserved.
//

#import "YYTimelinePainter.h"
#import "YYKlineGlobalVariable.h"
#import "QuotationConstant.h"
#import "JMChatManager.h"

@implementation YYTimelinePainter

+ (YYMinMaxModel *)getMinMaxValue:(NSArray <YYKlineModel *> *)data {
    if(!data) {
        return [YYMinMaxModel new];
    }
    __block CGFloat minAssert = 999999999999.f;
    __block CGFloat maxAssert = 0.f;
    [data enumerateObjectsUsingBlock:^(YYKlineModel * _Nonnull m, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (m.avgPrice.floatValue > m.Open.floatValue) {
            maxAssert = MAX(maxAssert, m.avgPrice.floatValue);
            minAssert = MIN(minAssert, m.Open.floatValue);
        } else {
            maxAssert = MAX(maxAssert, m.Open.floatValue);
            minAssert = MIN(minAssert, m.avgPrice.floatValue);
        }
    
    }];
    return [YYMinMaxModel modelWithMin:minAssert max:maxAssert];
}

// 分时，五日K线
+ (void)drawToLayer:(CALayer *)layer area:(CGRect)area models:(NSArray <YYKlineModel *> *)models minMax:(YYMinMaxModel *)minMaxModel close:(CGFloat)close price:(CGFloat)price{
    if( CGRectGetHeight(area) < 0) {
        return;
    }
    CGFloat maxH = CGRectGetHeight(area);
    CGFloat unitValue = maxH/minMaxModel.distance;
    if (isinf(unitValue)) {
          unitValue = 0.0001;
    }
    
    __block CGPoint pointStart, pointEnd;
    YYTimelinePainter *sublayer = [[YYTimelinePainter alloc] init];
    sublayer.frame = area;
    UIBezierPath *path1 = [UIBezierPath bezierPath];
    
    // 均价线
    UIBezierPath *avgLinePath = [UIBezierPath bezierPath];
    //生成均线坐标点
    __block CGPoint avgPoint;
    
    [models enumerateObjectsUsingBlock:^(YYKlineModel * _Nonnull m, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat w = [YYKlineGlobalVariable kLineWidth];
        CGFloat x = idx * (w + [YYKlineGlobalVariable kLineGap]);
        
        CGPoint point1 = CGPointMake(x+w/2, maxH - (m.Open.floatValue - minMaxModel.min)*unitValue);
        
        // 美股盘前,未开盘 
        if (minMaxModel.max == minMaxModel.min) {
            point1 = CGPointMake(x + w / 2, maxH / 2);
            avgPoint = CGPointMake(x + w / 2, maxH / 2);
        } else {

            //生成均线坐标点
            if (m.avgPrice.floatValue <= 0) {
                
                if (idx == 0) {
                    avgPoint = point1;
                } else {
                    avgPoint = avgPoint;
                }
                
            } else {

                // 解决均价线绘制超出范围
                CGFloat avgPointH = maxH - (m.avgPrice.floatValue - minMaxModel.min) * unitValue;

                if (avgPointH > maxH) {
                    avgPoint = CGPointMake(x+w/2, maxH);
                } else {
                    avgPoint = CGPointMake(x+w/2, avgPointH);
                }

            }
            
        }
        
        if (idx == 0) {
            
            [path1 moveToPoint:point1];
            [avgLinePath moveToPoint:avgPoint];
            pointStart = point1;
            
        } else {
            
            [path1 addLineToPoint:point1];
            
            if ([JMChatManager sharedInstance].chartType == 4) { //五日线
                // 断开均价线
                if ([m.V_MMdd isEqualToString:m.PrevModel.V_MMdd]) {
                    [avgLinePath addLineToPoint:avgPoint];
                } else {
                    [avgLinePath moveToPoint:avgPoint];
                }
                
            } else {
                [avgLinePath addLineToPoint:avgPoint];
            }
            
        }
    
        if (idx == models.count - 1) {
            pointEnd = point1;
        }
        
    }];
    
    // 画K线
    {
        CAShapeLayer *l = [CAShapeLayer layer];
        l.path = path1.CGPath;
        l.lineWidth = YYKlineLineWidth;
        l.strokeColor = UIColor.timeLineLineColor.CGColor;
        l.fillColor =   [UIColor clearColor].CGColor;
        [sublayer addSublayer:l];
    }
    
    // 画均价线
    {
        CAShapeLayer *avgLineLayer = [CAShapeLayer layer];
        avgLineLayer.path = avgLinePath.CGPath;
        avgLineLayer.lineWidth = YYKlineLineWidth;
        avgLineLayer.strokeColor = UIColor.avgPriceLineColor.CGColor;
        avgLineLayer.fillColor = [UIColor clearColor].CGColor;
        [sublayer addSublayer:avgLineLayer];
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

        CAGradientLayer *gl = [CAGradientLayer layer];
        gl.frame = area;
        gl.startPoint = CGPointMake(0.5, 0);
        gl.endPoint = CGPointMake(0.5, 1.039608359336853);
        gl.colors = @[(__bridge id)[UIColor colorWithRed:15/255.0 green:82/255.0 blue:168/255.0 alpha:0.30].CGColor,(__bridge id)[UIColor colorWithRed:76/255.0 green:156/255.0 blue:239/255.0 alpha:0.00].CGColor];
        gl.locations = @[@(0),@(1.0f)];
        gl.mask = maskLayer;
        [layer addSublayer:gl];
    }
    
    
    
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
            UIColor * color = UIColor.upColor;
            // 区间价格
            NSString * intervalPrice = @"0.000";
           
            {//绘制左轴坐标
                CATextLayer *textLayer = [CATextLayer layer];
                
                // 数据特殊处理
                CGFloat tempPrice = minMaxModel.max-i*unitValuePrice;
//                if (close == price) {
//                    tempPrice = (minMaxModel.max + 0.004) - i * 0.002;
//                }
                
                // 区间价格
                intervalPrice = [NSString stringWithFormat:[JMChatManager sharedInstance].priceFormate,tempPrice];
                textLayer.string = intervalPrice;
                textLayer.alignmentMode = kCAAlignmentLeft;
                textLayer.fontSize = 10.f;

                if (tempPrice > close) {
                    textLayer.foregroundColor = UIColor.upColor.CGColor;
                }else if (tempPrice < close) {
                    textLayer.foregroundColor = UIColor.downColor.CGColor;
                    color = UIColor.downColor;
                } else {
                    textLayer.foregroundColor = UIColor.flatColor.CGColor;
                    color = UIColor.flatColor;
                }
                
                // 价格为0，改变颜色
                if (intervalPrice.doubleValue == 0.000) {
                    textLayer.foregroundColor = UIColor.flatColor.CGColor;
                    color = UIColor.flatColor;
                }

                textLayer.frame = CGRectMake(0, y-[UIFont systemFontOfSize:8.f].lineHeight, YYKlineLinePriceViewWidth, [UIFont systemFontOfSize:10.f].lineHeight);
                textLayer.contentsScale = UIScreen.mainScreen.scale;
                [layer addSublayer:textLayer];
            }

            
            {//绘制右轴坐标 K线图绘制右轴没意义
                CATextLayer *textLayer = [CATextLayer layer];
                // 处理停牌或无数据时异常涨跌幅
                if (intervalPrice.doubleValue == 0.000) {
                    textLayer.string = @"0.00%";
                } else {
                
                    NSString * textStr = [NSString stringWithFormat:@"%.2f%%",((minMaxModel.max-i*unitValuePrice)-close)/close*100];
                    if ([textStr containsString:@"inf%"]) {
                        textStr = @"0.00%";
                    }
                    
                    textLayer.string = textStr;
                }
                textLayer.alignmentMode = kCAAlignmentRight;
                textLayer.fontSize = 10.f;
                textLayer.foregroundColor = color.CGColor;
                textLayer.frame = CGRectMake(xEnd-YYKlineLinePriceViewWidth, y-[UIFont systemFontOfSize:10.f].lineHeight, YYKlineLinePriceViewWidth, [UIFont systemFontOfSize:10.f].lineHeight);
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
            
            // 美股盘前,未开盘
            if (minMaxModel.max == minMaxModel.min) {
                y = maxH / 2;
            }
            
            [path  moveToPoint:CGPointMake(xStart, y)];
            [path addLineToPoint:CGPointMake(xEnd, y)];
            
            sublayer.lineWidth = 0.8;
            sublayer.strokeColor =  UIColor.priceLineColor.CGColor;
            sublayer.path = path.CGPath;
            sublayer.contentsScale = UIScreen.mainScreen.scale;
            [sublayer setLineDashPattern:@[@5,@5]];
            sublayer.fillColor = nil;
            [layer addSublayer:sublayer];
        }

        
    }
    
    //绘制昨收
    {
  
        if(minMaxModel.min <= close && close <= minMaxModel.max){
            
            CAShapeLayer *sublayer = [[CAShapeLayer alloc] init];
            sublayer.frame = area;
            UIBezierPath *path = [UIBezierPath bezierPath];
            CGFloat   xStart = area.origin.x;
            CGFloat     xEnd = CGRectGetWidth(area);
            
            CGFloat y =  maxH - (close - minMaxModel.min) * unitValue;
            
            // 美股盘前,未开盘
            if (minMaxModel.max == minMaxModel.min) {
                y = maxH / 2;
            }
            
            [path  moveToPoint:CGPointMake(xStart, y)];
            [path addLineToPoint:CGPointMake(xEnd, y)];
            
            sublayer.lineWidth = 0.8;
            sublayer.strokeColor =  UIColor.closeLineColor.CGColor;
            sublayer.path = path.CGPath;
            sublayer.contentsScale = UIScreen.mainScreen.scale;
            [sublayer setLineDashPattern:@[@5,@5]];
            sublayer.fillColor = nil;
            [layer addSublayer:sublayer];
        }
 
        
    }
    
    {//呼吸灯
        if (isinf(pointEnd.y) ||  [JMChatManager sharedInstance].isClose) {
            return;
        }
        CALayer *sublayer = [CALayer layer];
        //设置任意位置
        sublayer.frame = CGRectMake(pointEnd.x-4/2, pointEnd.y+area.origin.y-4/2, 4, 4);
        //设置呼吸灯的颜色
        sublayer.backgroundColor = UIColor.timeLineLineColor.CGColor;
        //设置好半径
        sublayer.cornerRadius = 2;
        //给当前图层添加动画组
        [sublayer addAnimation:[self createBreathingLightAnimationWithTime:2] forKey:nil];
        [layer addSublayer:sublayer];
    }
    
    
}

+ (CAAnimationGroup *)createBreathingLightAnimationWithTime:(double)time
{
    //实例化CABasicAnimation
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    //从1开始
    scaleAnimation.fromValue = @1;
    //到3.5
    scaleAnimation.toValue = @3.5;
    //结束后不执行逆动画
    scaleAnimation.autoreverses = NO;
    //无限循环
    scaleAnimation.repeatCount = HUGE_VALF;
    //一次执行time秒
    scaleAnimation.duration = time;
    //结束后从渲染树删除，变回初始状态
    scaleAnimation.removedOnCompletion = YES;
    scaleAnimation.fillMode = kCAFillModeForwards;

    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @1.0;
    opacityAnimation.toValue = @0;
    opacityAnimation.autoreverses = NO;
    opacityAnimation.repeatCount = HUGE_VALF;
    opacityAnimation.duration = time;
    opacityAnimation.removedOnCompletion = YES;
    opacityAnimation.fillMode = kCAFillModeForwards;

    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = time;
    group.autoreverses = NO;
    group.animations = @[scaleAnimation, opacityAnimation];
    group.repeatCount = HUGE_VALF;
    //这里也应该设置removedOnCompletion和fillMode属性，以具体情况而定

    return group;
}

@end
