//
//  FSStockDetailInfoViewModel.m
//  JMQuotesComponets
//
//  Created by fargowealth on 2023/5/31.
//

#import "FSStockDetailInfoViewModel.h"
#import "UIColor+JMColor.h"

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
                @"最高", @"今开", @"成交量",
                @"最低", @"昨收", @"成交额",
                @"换手率", @"市盈率", @"总市值",
                @"量比", @"市盈", @"总股本",
                @"收益", @"市盈", @"流通市值",
                @"52周高", @"市净率", @"流通股本",
                @"52周低", @"均价", @"振幅",
                @"股息率", @"股息", @"每手",
            ];
            
            NSArray *describeList = @[
                @"", @"", @"",
                @"", @"", @"",
                @"", @"TTM", @"",
                @"", @"动", @"",
                @"", @"静", @"",
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
                @"最高", @"今开", @"成交量",
                @"最低", @"昨收", @"成交额",
                @"换手率", @"市盈率", @"总市值",
                @"量比", @"市盈", @"总股本",
                @"收益", @"市盈", @"流通市值",
                @"52周高", @"市净率", @"流通股本",
                @"52周低", @"均价", @"振幅",
                @"股息率", @"股息", @"每手",
            ];
            
            NSArray *describeList = @[
                @"", @"", @"",
                @"", @"", @"",
                @"", @"TTM", @"",
                @"", @"动", @"",
                @"", @"静", @"",
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
            [contentList addObject:[NSString stringWithFormat:@"%@股",model.lotSize]];
            
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
    
    NSString *cityStr = [market isEqualToString:@"US"] ? @"美东时间" : @"北京时间";
    
    return [NSString stringWithFormat:@"%@ %@ %@", statusStr, dateStr, cityStr];
}

/// 获取交易状态文字
- (NSString *)getTradingStatusText:(NSInteger)status {
    switch (status) {
        case 0:
            return @"正常";
        case 1:
            return @"涨停";
        case 2:
            return @"跌停";
        case 3:
            return @"停牌";
        case 4:
            return @"退市";
        case 5:
            return @"待上市";
        case 6:
            return @"未开盘";
        case 7:
            return @"交易中";
        case 8:
            return @"已收盘";
        case 9:
            return @"竞价中";
        case 10:
            return @"午间休市";
        case 11:
            return @"暗盘交易中";
        case 12:
            return @"暗盘已收盘";
        case 13:
            return @"现场竞价中";
        case 14:
            return @"熔断";
        case 15:
            return @"上市首日未开盘";
        case 16:
            return @"收盘竞价中";
        case 17:
            return @"等待开盘";
        case 18:
            return @"--";
        case 19:
            return @"终止交易";
        case 20:
            return @"等待上市";
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
        text = [NSString stringWithFormat:@"%@万亿", [formatter stringFromNumber:@(number.doubleValue/1e12)]];
    } else if (number1 >= 1e8) {
        text = [NSString stringWithFormat:@"%@亿", [formatter stringFromNumber:@(number.doubleValue/1e8)]];
    } else if (number1 >= 1e4) {
        text = [NSString stringWithFormat:@"%@万", [formatter stringFromNumber:@(number.doubleValue/1e4)]];
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


