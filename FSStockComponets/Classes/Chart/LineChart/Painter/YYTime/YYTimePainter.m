//
//  YYTimePainter.m
//  YYKline
//
//  Copyright © 2019 WillkYang. All rights reserved.
//

#import "YYTimePainter.h"
#import "YYKlineGlobalVariable.h"
#import "QuotationConstant.h"
//#import "NSDate+Extension.h"
#import "JMChatManager.h"

@implementation YYTimePainter

// 五日线时间轴
+ (void)drawToLayer:(CALayer *)layer area:(CGRect)area models:(NSArray<YYKlineModel *> *)models minMax:(YYMinMaxModel *)minMaxModel close:(CGFloat)close price:(CGFloat)price {
    CGFloat maxH = CGRectGetHeight(area);
    if (maxH <= 0) {
        return;
    }
    
    YYTimePainter *sublayer = [[YYTimePainter alloc] init];
    sublayer.backgroundColor = UIColor.backgroundColor.CGColor;
    sublayer.frame = area;
    [layer addSublayer:sublayer];
    
    CGFloat w = [YYKlineGlobalVariable kLineWidth];
    __block  NSDate * lastDate = nil;
    
    [models enumerateObjectsUsingBlock:^(YYKlineModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat x = idx * (w + [YYKlineGlobalVariable kLineGap]);
        CGFloat y = (maxH - [UIFont systemFontOfSize:8.f].lineHeight)/2.f;
        CATextLayer *textLayer = [CATextLayer layer];
        if (lastDate) {
            if ((lastDate.month != obj.date.month) || (lastDate.month ==obj.date.month && obj.date.day != lastDate.day)) {
                textLayer.string = obj.V_MMdd;
            }
        }else{
            textLayer.string = obj.V_MMdd;
        }
        lastDate = obj.date;
        if (!textLayer.string) {
            return;
        }
        textLayer.alignmentMode = kCAAlignmentLeft;
        textLayer.fontSize = 8.f;
        textLayer.foregroundColor = UIColor.grayColor.CGColor;
        textLayer.frame = CGRectMake(x, y, 45, [UIFont systemFontOfSize:8.f].lineHeight);
        textLayer.contentsScale = UIScreen.mainScreen.scale;
        [sublayer addSublayer:textLayer];
    }];
}

// 分时图时间轴
+ (void)drawToLayer2:(CALayer *)layer area:(CGRect)area models:(NSArray<YYKlineModel *> *)models minMax:(YYMinMaxModel *)minMaxModel close:(CGFloat)close price:(CGFloat)price {

    CGFloat maxH = CGRectGetHeight(area);
    if (maxH <= 0) {
        return;
    }
    
    YYTimePainter *sublayer = [[YYTimePainter alloc] init];
    sublayer.backgroundColor = UIColor.backgroundColor.CGColor;
    sublayer.frame = area;
    [layer addSublayer:sublayer];
    

    CGFloat width = 50;
    CGFloat fontSize = 9.f;
    
    NSArray * timeArr = [[JMChatManager sharedInstance] timeLineBottomArr];
    if (timeArr.count == 3) {
        
        {
            CGFloat x = 0;
            CGFloat y = (maxH - [UIFont systemFontOfSize:fontSize].lineHeight)/2.f;
            CATextLayer *textLayer = [CATextLayer layer];
            textLayer.string = timeArr[0];
            textLayer.alignmentMode = kCAAlignmentLeft;
            textLayer.fontSize = fontSize;
            textLayer.foregroundColor = UIColor.secondaryTextColor.CGColor;
            textLayer.frame = CGRectMake(x, y, width, [UIFont systemFontOfSize:fontSize].lineHeight);
            textLayer.contentsScale = UIScreen.mainScreen.scale;
            [sublayer addSublayer:textLayer];
        }
        
        {
            CGFloat Offset = [[JMChatManager sharedInstance] timeLineBottomOffset];
//            CGFloat x = (CGRectGetWidth(area)-10)*Offset-width/2;
            CGFloat x = CGRectGetWidth(area)*Offset;
            CGFloat y = (maxH - [UIFont systemFontOfSize:fontSize].lineHeight)/2.f;
            CATextLayer *textLayer = [CATextLayer layer];
            textLayer.string = timeArr[1];
            textLayer.alignmentMode = kCAAlignmentCenter;
            textLayer.fontSize = fontSize;
            textLayer.foregroundColor = UIColor.secondaryTextColor.CGColor;
            textLayer.frame = CGRectMake(x, y, width, [UIFont systemFontOfSize:fontSize].lineHeight);
            textLayer.contentsScale = UIScreen.mainScreen.scale;
            [sublayer addSublayer:textLayer];
        }
        
        
        {
//            CGFloat x = CGRectGetWidth(area)-width-10;
            CGFloat x = CGRectGetWidth(area)-width;
            CGFloat y = (maxH - [UIFont systemFontOfSize:fontSize].lineHeight)/2.f;
            CATextLayer *textLayer = [CATextLayer layer];
            textLayer.string = timeArr[2];
            textLayer.alignmentMode = kCAAlignmentRight;
            textLayer.fontSize = fontSize;
            textLayer.foregroundColor = UIColor.secondaryTextColor.CGColor;
            textLayer.frame = CGRectMake(x, y, width, [UIFont systemFontOfSize:fontSize].lineHeight);
            textLayer.contentsScale = UIScreen.mainScreen.scale;
            [sublayer addSublayer:textLayer];
        }
        
//            CGFloat w = [YYKlineGlobalVariable kLineWidth];
//            __block  NSDate * lastDate = nil;
//            NSInteger midIndex = floor(models.count/2);
        
//        [models enumerateObjectsUsingBlock:^(YYKlineModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//
//             if (idx == 0 || (idx == (models.count-1)) || idx == midIndex) {
//
//             }else{
//                return;
//            }
//
//            CGFloat x = idx * (w + [YYKlineGlobalVariable kLineGap]);
//            if (idx == (models.count-1)) {
//                x = x-width/2;
//            }
//            CGFloat y = (maxH - [UIFont systemFontOfSize:8.f].lineHeight)/2.f;
//            CATextLayer *textLayer = [CATextLayer layer];
//            textLayer.string = obj.V_HHMM;
//            lastDate = obj.date;
//            textLayer.alignmentMode = kCAAlignmentCenter;
//            textLayer.fontSize = 8.f;
//            textLayer.foregroundColor = UIColor.closeLineColor.CGColor;
//            x = x-width/2;
//            if (x<0) {
//                x=0;
//            }
//            textLayer.frame = CGRectMake(x, y, width, [UIFont systemFontOfSize:8.f].lineHeight);
//            textLayer.contentsScale = UIScreen.mainScreen.scale;
//            [sublayer addSublayer:textLayer];
//        }];
    }

}

// 日K、周K，月K，年K、时间轴
+ (void)drawToLayer3:(CALayer *)layer area:(CGRect)area models:(NSArray<YYKlineModel *> *)models minMax:(YYMinMaxModel *)minMaxModel close:(CGFloat)close price:(CGFloat)price {
    CGFloat maxH = CGRectGetHeight(area);
    if (maxH <= 0) {
        return;
    }
    
    YYTimePainter *sublayer = [[YYTimePainter alloc] init];
    sublayer.backgroundColor = UIColor.backgroundColor.CGColor;
    sublayer.frame = area;
    [layer addSublayer:sublayer];
    
    CGFloat w = [YYKlineGlobalVariable kLineWidth];
    __block  NSDate * lastDate = nil;
    NSInteger midIndex = floor(models.count/2);
    CGFloat width = 45;
    __block   CGFloat lastX = -1;
    [models enumerateObjectsUsingBlock:^(YYKlineModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
      
         if (idx == 0 || (idx == (models.count-1)) || idx == midIndex) {
         }else{
            return;
        }

        CGFloat x = idx * (w + [YYKlineGlobalVariable kLineGap]);
        if (idx == (models.count-1)) {
            x = x-width/2;
        }
        CGFloat y = (maxH - [UIFont systemFontOfSize:8.f].lineHeight)/2.f;
        CATextLayer *textLayer = [CATextLayer layer];
        textLayer.string = obj.V_yyyyMMdd;
        lastDate = obj.date;
        textLayer.alignmentMode = kCAAlignmentCenter;
        textLayer.fontSize = 8.f;
        textLayer.foregroundColor = UIColor.closeLineColor.CGColor;
        x = x-width/2;
        if (x<0) {
            x=0;
        }
        if (x>lastX) {
            lastX = x+width;
        }else{
            return;
        }
        textLayer.frame = CGRectMake(x, y, width, [UIFont systemFontOfSize:8.f].lineHeight);
        textLayer.contentsScale = UIScreen.mainScreen.scale;
        [sublayer addSublayer:textLayer];
    }];
}

// 分钟K线时间轴
+ (void)drawToLayer4:(CALayer *)layer area:(CGRect)area models:(NSArray<YYKlineModel *> *)models minMax:(YYMinMaxModel *)minMaxModel close:(CGFloat)close price:(CGFloat)price {
    CGFloat maxH = CGRectGetHeight(area);
    if (maxH <= 0) {
        return;
    }
    
    YYTimePainter *sublayer = [[YYTimePainter alloc] init];
    sublayer.backgroundColor = UIColor.backgroundColor.CGColor;
    sublayer.frame = area;
    [layer addSublayer:sublayer];
    
    CGFloat w = [YYKlineGlobalVariable kLineWidth];
    __block  NSDate * lastDate = nil;
//    NSInteger midIndex = floor(models.count/2);
    CGFloat width = 45;
    __block   CGFloat lastX = -1;
    [models enumerateObjectsUsingBlock:^(YYKlineModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
      
//         if (idx == 0 || (idx == (models.count-1)) || idx == midIndex) {
//         }else{
//            return;
//        }

        CGFloat x = idx * (w + [YYKlineGlobalVariable kLineGap]);
        if (idx == (models.count-1)) {
            x = x-width/2;
        }
        
        NSString * mm = obj.V_MM;
        if ([@"00" isEqualToString:mm] || [@"30" isEqualToString:mm]) {
            if ([@"16:00" isEqualToString:obj.V_HHMM]) {
                mm = obj.V_MMddHHMM;
            }else{
                mm = obj.V_HHMM;
            }
        }else{
            return;
        }
        
        CGFloat y = (maxH - [UIFont systemFontOfSize:8.f].lineHeight)/2.f;
        CATextLayer *textLayer = [CATextLayer layer];
        textLayer.string = mm;
        lastDate = obj.date;
        textLayer.alignmentMode = kCAAlignmentCenter;
        textLayer.fontSize = 8.f;
        textLayer.foregroundColor = UIColor.closeLineColor.CGColor;
        x = x-width/2;
        if (x<0) {
            x=0;
        }
        if (x>lastX) {
            lastX = x+width;
        }else{
            return;
        }
        textLayer.frame = CGRectMake(x, y, width, [UIFont systemFontOfSize:8.f].lineHeight);
        textLayer.contentsScale = UIScreen.mainScreen.scale;
        [sublayer addSublayer:textLayer];
    }];
}


@end
