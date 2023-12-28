//
//  JMVerticalTextPainter.m
//  ghchat
//
//  Created by fargowealth on 2021/10/26.
//

#import "JMVerticalTextPainter.h"
#import "JMKlineGlobalVariable.h"
#import "UIColor+JMColor.h"
#import "JMChatManager.h"
//Helper
#import "FSStockUnitUtils.h"
#import "NSBundle+FSStockComponents.h"

@implementation JMVerticalTextPainter

/**
 * 绘制价格Y轴
 */
+ (void)drawPriceToLayer:(CALayer *)layer area:(CGRect)area minMax: (JMMinMaxModel *)minMaxModel {
    
    CGFloat maxH = CGRectGetHeight(area);
    
    // 数字40只是一个magic数字，没啥特殊意义
    NSInteger count = maxH/35;
    count++;

    if (maxH <= 0) {
        return;
    }

    if (count <= 1) {
        return;
    }

    JMVerticalTextPainter *sublayer = [[JMVerticalTextPainter alloc] init];
    sublayer.frame = area;
    [layer addSublayer:sublayer];

    CGFloat lineH = [UIFont systemFontOfSize:10.f].lineHeight;
    CGFloat textGap = (maxH - lineH)/(count-1);
    CGFloat decimalGap = minMaxModel.distance / (count-1);

    for (int i = 0; i < count; i++) {
        CATextLayer *layer = [CATextLayer layer];
        CGFloat number = minMaxModel.max - i * decimalGap;
        layer.string = [FSStockUnitUtils readbleKLineVerticalUnitWithNumber:number];
//        layer.alignmentMode = kCAAlignmentCenter;
        layer.fontSize = 10.f;
        layer.foregroundColor = UIColor.secondaryTextColor.CGColor;
        layer.frame = CGRectMake(0, i*textGap, CGRectGetWidth(area), lineH);
        layer.contentsScale = UIScreen.mainScreen.scale;
        [sublayer addSublayer:layer];
    }
}

/**
 * 绘制成交量Y轴
 */
+ (void)drawVolumeToLayer:(CALayer *)layer area:(CGRect)area minMax: (JMMinMaxModel *)minMaxModel {
    CGFloat maxH = CGRectGetHeight(area);
    
    // 数字40只是一个magic数字，没啥特殊意义
    NSInteger count = maxH/30;
    count++;
    
    if (maxH <= 0) {
        return;
    }
    
    if (count <= 1) {
        return;
    }

    JMVerticalTextPainter *sublayer = [[JMVerticalTextPainter alloc] init];
    sublayer.frame = area;
    [layer addSublayer:sublayer];
    
    CGFloat lineH = [UIFont systemFontOfSize:12.f].lineHeight;
    CGFloat textGap = (maxH - lineH)/(count-1);
    CGFloat decimalGap = minMaxModel.distance / (count-1);
    
    // 标题
    NSString *volStr = [JMChatManager sharedInstance].isStockIndex ? FSLanguage(@"成交额") : FSLanguage(@"成交量(k线)");
    // 单位
    NSString *unitStr = [JMChatManager sharedInstance].isStockIndex ? @"" : [[JMChatManager sharedInstance].market isEqualToString:@"ZH"] ? FSLanguage(@"手") : FSLanguage(@"股");
    
    // 根据市场类型区分指数
    if ([[JMChatManager sharedInstance].market isEqualToString:@"ZH"] && [JMChatManager sharedInstance].isStockIndex) {
        volStr = FSLanguage(@"成交量(k线)");
        unitStr = FSLanguage(@"手");
    } else {
        volStr = [JMChatManager sharedInstance].isStockIndex ? FSLanguage(@"成交额")  : FSLanguage(@"成交量(k线)");
        unitStr = [JMChatManager sharedInstance].isStockIndex ? @"" : [[JMChatManager sharedInstance].market isEqualToString:@"ZH"] ? FSLanguage(@"手") : FSLanguage(@"股");
    }
    
    for (int i = 0; i < count; i++) {
        CATextLayer *layer = [CATextLayer layer];
        CGFloat number = minMaxModel.max - i * decimalGap;
        NSString * text = @"";
        
        if (number >= 1e8) {
            text = [NSString stringWithFormat:@"%.2f%@", number/1e8, FSLanguage(@"亿")];
        } else if (number >= 1e4) {
            number = ([NSBundle fsStockUI_isChineseLanguage])? number * 10: number;
            text = [NSString stringWithFormat:@"%.2f%@", number/1e4, FSLanguage(@"万")];
        } else if (number >= 10) {
            text = [NSString stringWithFormat:@"%.2f", number];
        } else {
            // 最后一个元素不做展示
            if (i != count - 1) {
                text = [NSString stringWithFormat:@"%.3f", number];
            }
        }
        
        // 第一个元素做特殊处理
        if (i == 0) {
            layer.string = [NSString stringWithFormat:@"%@ %@%@", volStr, text, unitStr];
            layer.fontSize = 12;
            layer.foregroundColor = UIColor.handicapInfoTextColor.CGColor;
        } else {
            layer.string = text;
            layer.fontSize = 10.f;
            layer.foregroundColor = UIColor.secondaryTextColor.CGColor;
        }
        
        layer.frame = CGRectMake(0, i*textGap, CGRectGetWidth(area), lineH);
        layer.contentsScale = UIScreen.mainScreen.scale;
        [sublayer addSublayer:layer];
    }
    
}

@end
