//
//  FSStockDetailInfoViewModel.m
//  JMQuotesComponets
//
//  Created by fargowealth on 2023/5/31.
//

#import "FSStockDetailInfoViewModel.h"
//Helper
#import "UIColor+JMColor.h"
#import "FSStockComponetsLanguage.h"

@implementation FSStockDetailInfoViewModel

- (instancetype)initWithModel:(FSStockDetailInfoModel *)model {
    if (self = [super init]) {
        
        
        if (model.price == nil && model.change == nil && model.changePct == nil && model.ts == nil && model.marketType == nil) {
            self.price = @"--";
            self.change = @"--";
            self.changePct = @"--";
            self.tradingStatus = @"--";
            self.priceColor = UIColor.flatColor;
            self.changeColor = UIColor.flatColor;
            self.changePctColor = UIColor.flatColor;
            
            NSArray *titleList = @[
                FSMacroLanguage(@"最高"), FSMacroLanguage(@"今开"), FSMacroLanguage(@"成交量"),
                FSMacroLanguage(@"最低"), FSMacroLanguage(@"昨收"), FSMacroLanguage(@"成交额"),
                FSMacroLanguage(@"换手率"), FSMacroLanguage(@"市盈率"), FSMacroLanguage(@"总市值"),
                FSMacroLanguage(@"量比"), FSMacroLanguage(@"市盈"), FSMacroLanguage(@"总股本"),
                FSMacroLanguage(@"收益"), FSMacroLanguage(@"市盈"), FSMacroLanguage(@"流通市值"),
                FSMacroLanguage(@"52周高"), FSMacroLanguage(@"市净率"), FSMacroLanguage(@"流通股本"),
                FSMacroLanguage(@"52周低"), FSMacroLanguage(@"均价"), FSMacroLanguage(@"振幅"),
                FSMacroLanguage(@"股息率"), FSMacroLanguage(@"股息"), FSMacroLanguage(@"每手"),
            ];
            
            NSArray *describeList = @[
                @"", @"", @"",
                @"", @"", @"",
                @"", @"TTM", @"",
                @"", FSMacroLanguage(@"动"), @"",
                @"", FSMacroLanguage(@"静"), @"",
                @"", @"", @"",
                @"", @"", @"",
                @"", @"", @"",
            ];
            
            NSArray *contentList = @[
                @"--", @"--", @"--",
                @"--", @"--", @"--",
                @"--", @"--", @"--",
                @"--", @"--", @"--",
                @"--", @"--", @"--",
                @"--", @"--", @"--",
                @"--", @"--", @"--",
                @"--", @"--", @"--",
            ];
            
            NSArray *colorList = @[
                UIColor.handicapInfoTextColor, UIColor.handicapInfoTextColor, UIColor.handicapInfoTextColor,
                UIColor.handicapInfoTextColor, UIColor.handicapInfoTextColor, UIColor.handicapInfoTextColor,
                UIColor.handicapInfoTextColor, UIColor.handicapInfoTextColor, UIColor.handicapInfoTextColor,
                UIColor.handicapInfoTextColor, UIColor.handicapInfoTextColor, UIColor.handicapInfoTextColor,
                UIColor.handicapInfoTextColor, UIColor.handicapInfoTextColor, UIColor.handicapInfoTextColor,
                UIColor.handicapInfoTextColor, UIColor.handicapInfoTextColor, UIColor.handicapInfoTextColor,
                UIColor.handicapInfoTextColor, UIColor.handicapInfoTextColor, UIColor.handicapInfoTextColor,
                UIColor.handicapInfoTextColor, UIColor.handicapInfoTextColor, UIColor.handicapInfoTextColor,
            ];
            
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [titleList enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                FSStockDetailInfoModel *model = [[FSStockDetailInfoModel alloc] init];
                model.titleStr = titleList[idx];
                model.describeStr = describeList[idx];
                model.contentStr = contentList[idx];
                model.myColor = colorList[idx];
                [array addObject:model];
            }];
            
            self.handicapInfoList = array;
            
        } else {
            
            self.price = model.price == nil ? @"--" : model.price;
            
            NSString *changeStr = model.change;
            NSString *changePctStr = [self getPercentageUnitWithNumStr:model.changePct];
            
            if ([model.changePct floatValue]  == 0.00){
                self.priceColor = UIColor.flatColor;
                self.changeColor = UIColor.flatColor;
                self.changePctColor = UIColor.flatColor;
            } else {
                if ([model.changePct hasPrefix:@"-"]) {
                    self.priceColor = UIColor.downColor;
                    self.changeColor = UIColor.downColor;
                    self.changePctColor = UIColor.downColor;
                } else {
                    
                    changeStr = [NSString stringWithFormat:@"+%@", model.change];
                    changePctStr = [NSString stringWithFormat:@"+%@", [self getPercentageUnitWithNumStr:model.changePct]];
                    
                    self.priceColor = UIColor.upColor;
                    self.changeColor = UIColor.upColor;
                    self.changePctColor = UIColor.upColor;
                }
            }
        
            self.change = changeStr;
            self.changePct = changePctStr;
            
            self.tradingStatus = [self getTradingStatusWithStatus:model.status Timestamp:model.ts Market:model.marketType];
            
            NSString *type = model.marketType;
            if ([type isEqualToString:@"HK"]) {
                self.stockMarketType = StockMarketType_HK;
            } else if ([type isEqualToString:@"US"]) {
                self.stockMarketType = StockMarketType_US;
            } else if ([type isEqualToString:@"SZ"]) {
                self.stockMarketType = StockMarketType_SZ;
            } else if ([type isEqualToString:@"SH"]) {
                self.stockMarketType = StockMarketType_SH;
            }
            
            
            NSArray *titleList = @[
                FSMacroLanguage(@"最高"), FSMacroLanguage(@"今开"), FSMacroLanguage(@"成交量"),
                FSMacroLanguage(@"最低"), FSMacroLanguage(@"昨收"), FSMacroLanguage(@"成交额"),
                FSMacroLanguage(@"换手率"), FSMacroLanguage(@"市盈率"), FSMacroLanguage(@"总市值"),
                FSMacroLanguage(@"量比"), FSMacroLanguage(@"市盈"), FSMacroLanguage(@"总股本"),
                FSMacroLanguage(@"收益"), FSMacroLanguage(@"市盈"), FSMacroLanguage(@"流通市值"),
                FSMacroLanguage(@"52周高"), FSMacroLanguage(@"市净率"), FSMacroLanguage(@"流通股本"),
                FSMacroLanguage(@"52周低"), FSMacroLanguage(@"均价"), FSMacroLanguage(@"振幅"),
                FSMacroLanguage(@"股息率"), FSMacroLanguage(@"股息"), FSMacroLanguage(@"每手"),
            ];
            
            NSArray *describeList = @[
                @"", @"", @"",
                @"", @"", @"",
                @"", @"TTM", @"",
                @"", FSMacroLanguage(@"动"), @"",
                @"", FSMacroLanguage(@"静"), @"",
                @"", @"", @"",
                @"", @"", @"",
                @"", @"", @"",
            ];
            
            
            NSMutableArray *contentList = [[NSMutableArray alloc] init];
            // 最高
            [contentList addObject:model.high];
            // 最低
            [contentList addObject:model.open];
            // 成交量
            [contentList addObject:[self getVolumeUnitWithNumStr:model.volume]];
            //最低
            [contentList addObject:model.low];
            //昨收
            [contentList addObject:model.preClose];
            //成交额
            [contentList addObject:[self getVolumeUnitWithNumStr:model.turnover]];
            //换手率
            [contentList addObject:[self getPercentageUnitWithNumStr:model.turnRate]];
            //市盈率
            [contentList addObject:model.ttmPe];
            //总市值
            [contentList addObject:[self getVolumeUnitWithNumStr:model.totalVal]];
            //量比
            [contentList addObject:model.volRate];
            //市盈(动)
            [contentList addObject:model.ttmPe];
            //总股本
            [contentList addObject:[self getVolumeUnitWithNumStr:model.total]];
            //收益
            [contentList addObject:model.epsp];
            //市盈(静)
            [contentList addObject:model.pe];
            //流通市值
            [contentList addObject:[self getVolumeUnitWithNumStr:model.fmktVal]];
            //52周高
            [contentList addObject:model.week52High];
            //市净率
            [contentList addObject:model.pb];
            //流通股本
            [contentList addObject:[self getVolumeUnitWithNumStr:model.flshr]];
            //52周低
            [contentList addObject:model.week52Low];
            //均价
            [contentList addObject:model.avgPrice];
            //振幅
            [contentList addObject:[self getPercentageUnitWithNumStr:model.ampLiTude]];
            //股息率
            [contentList addObject:[self getPercentageUnitWithNumStr:model.dpsRate]];
            //股息
            [contentList addObject:model.ttmDps];
            //每手
            [contentList addObject:[NSString stringWithFormat:@"%@%@",model.lotSize, FSMacroLanguage(@"股(盘口)")]];
            
            NSArray *colorList = @[
                [self getColorByCompareWithStr1:model.high Str2:model.preClose], [self getColorByCompareWithStr1:model.open Str2:model.preClose], UIColor.handicapInfoTextColor,
                [self getColorByCompareWithStr1:model.low Str2:model.preClose], UIColor.handicapInfoTextColor, UIColor.handicapInfoTextColor,
                UIColor.handicapInfoTextColor, UIColor.handicapInfoTextColor, UIColor.handicapInfoTextColor,
                UIColor.handicapInfoTextColor, UIColor.handicapInfoTextColor, UIColor.handicapInfoTextColor,
                UIColor.handicapInfoTextColor, UIColor.handicapInfoTextColor, UIColor.handicapInfoTextColor,
                UIColor.handicapInfoTextColor, UIColor.handicapInfoTextColor, UIColor.handicapInfoTextColor,
                UIColor.handicapInfoTextColor, UIColor.handicapInfoTextColor, UIColor.handicapInfoTextColor,
                UIColor.handicapInfoTextColor, UIColor.handicapInfoTextColor, UIColor.handicapInfoTextColor,
            ];
            
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [titleList enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                FSStockDetailInfoModel *model = [[FSStockDetailInfoModel alloc] init];
                model.titleStr = titleList[idx];
                model.describeStr = describeList[idx];
                model.contentStr = contentList[idx];
                model.myColor = colorList[idx];
                [array addObject:model];
            }];
            
            self.handicapInfoList = array;
            
        }
        
        
    }
    
    return self;
}

/**
 * 获取交易状态
 * status 状态
 * timestamp    时间戳
 * market   市场
 */
- (NSString *)getTradingStatusWithStatus:(NSInteger)status
                               Timestamp:(NSString *)timestamp
                                  Market:(NSString *)market {
    
    NSString *statusStr = [self getTradingStatusText:status];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp.doubleValue / 1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy/MM/dd HH:mm:ss";
    NSString *dateStr = [formatter stringFromDate:date];
    
    NSString *cityStr = [market isEqualToString:@"US"] ? FSMacroLanguage(@"美东时间") : FSMacroLanguage(@"北京时间");
    
    return [NSString stringWithFormat:@"%@ %@ %@", statusStr, dateStr, cityStr];
}

/// 获取交易状态文字
- (NSString *)getTradingStatusText:(NSInteger)status {
    switch (status) {
        case 0:
            return FSMacroLanguage(@"正常");
        case 1:
            return FSMacroLanguage(@"涨停");
        case 2:
            return FSMacroLanguage(@"跌停");
        case 3:
            return FSMacroLanguage(@"停牌");
        case 4:
            return FSMacroLanguage(@"退市");
        case 5:
            return FSMacroLanguage(@"待上市");
        case 6:
            return FSMacroLanguage(@"未开盘");
        case 7:
            return FSMacroLanguage(@"交易中");
        case 8:
            return FSMacroLanguage(@"已收盘");
        case 9:
            return FSMacroLanguage(@"竞价中");
        case 10:
            return FSMacroLanguage(@"午间休市");
        case 11:
            return FSMacroLanguage(@"暗盘交易中");
        case 12:
            return FSMacroLanguage(@"暗盘已收盘");
        case 13:
            return FSMacroLanguage(@"现场竞价中");
        case 14:
            return FSMacroLanguage(@"熔断");
        case 15:
            return FSMacroLanguage(@"上市首日未开盘");
        case 16:
            return FSMacroLanguage(@"收盘竞价中");
        case 17:
            return FSMacroLanguage(@"等待开盘");
        case 18:
            return @"--";
        case 19:
            return FSMacroLanguage(@"终止交易");
        case 20:
            return FSMacroLanguage(@"等待上市");
        default:
            return @"";
    }
}

/**
 * 获取两个参数比较的颜色
 * str1     开
 * str2     收
 */
- (UIColor *)getColorByCompareWithStr1:(NSString *)str1
                                  Str2:(NSString *)str2 {
    
    NSComparisonResult result = [str1 compare:str2];

    if (result == NSOrderedAscending) {
        return UIColor.downColor;
    } else if (result == NSOrderedDescending) {
        return UIColor.upColor;
    } else {
        return UIColor.handicapInfoTextColor;
    }
    
}

/**
 * 获取成交量单位
 */
- (NSString *)getVolumeUnitWithNumStr:(NSString *)numStr{
    CGFloat number1 = numStr.floatValue;
    
    NSNumber *number = [NSNumber numberWithDouble:numStr.doubleValue];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.maximumFractionDigits = 2;
    formatter.minimumFractionDigits = 0;
    formatter.roundingMode = NSNumberFormatterRoundFloor;
    
    NSString * text = @"";
    if(number1 >= 1e12){
        text = [NSString stringWithFormat:@"%@%@", [formatter stringFromNumber:@(number.doubleValue/1e12)], FSMacroLanguage(@"万亿")];
    } else if (number1 >= 1e8) {
        text = [NSString stringWithFormat:@"%@%@", [formatter stringFromNumber:@(number.doubleValue/1e8)], FSMacroLanguage(@"亿")];
    } else if (number1 >= 1e4) {
        number = [FSStockComponetsLanguage isChineseLanguage]? number: @(number.doubleValue * 10);
        text = [NSString stringWithFormat:@"%@万", [formatter stringFromNumber:@(number.doubleValue/1e4)], FSMacroLanguage(@"万")];
    } else {
        text = [NSString stringWithFormat:@"%@", [formatter stringFromNumber:@(number.doubleValue)]];
    }
    return text;
}

/**
 * 获取百分比单位
 */
- (NSString *)getPercentageUnitWithNumStr:(NSString *)numStr{
    return [NSString stringWithFormat:@"%.2f%%",numStr.floatValue * 100];
}

@end


