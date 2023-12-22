//
//  JMMoveDetailInfoView.m
//  ghchat
//
//  Created by fargowealth on 2021/10/26.
//

#import "JMMoveDetailInfoView.h"
#import "UIColor+JMColor.h"
#import <Masonry/Masonry.h>
//#import "NSDate+Extension.h"
#import "JMChatManager.h"
#import <YYCategories/YYCategories.h>

@interface JMMoveDetailInfoView ()

/** 日期 */
@property (nonatomic, strong) UILabel *dateLab;

/** 开盘价标题 */
@property (nonatomic, strong) UILabel *openPriceTitleLab;

/** 开盘价 */
@property (nonatomic, strong) UILabel *openPriceLab;

/** 收盘价标题 */
@property (nonatomic, strong) UILabel *closPriceTitleLab;

/** 收盘价 */
@property (nonatomic, strong) UILabel *closPriceLab;

/** 最高价标题 */
@property (nonatomic, strong) UILabel *highestPriceTitleLab;

/** 最高价 */
@property (nonatomic, strong) UILabel *highestPriceLab;

/** 最低价标题 */
@property (nonatomic, strong) UILabel *minimumPriceTitleLab;

/** 最低价 */
@property (nonatomic, strong) UILabel *minimumPriceLab;

/** 涨跌额标题 */
@property (nonatomic, strong) UILabel *upAndDownAmountTitleLab;

/** 涨跌额 */
@property (nonatomic, strong) UILabel *upAndDownAmountLab;

/** 涨跌幅标题 */
@property (nonatomic, strong) UILabel *fluctuationRangeTitleLab;

/** 涨跌幅 */
@property (nonatomic, strong) UILabel *fluctuationRangeLab;

/** 成交量标题 */
@property (nonatomic, strong) UILabel *volumeTitleLab;

/** 成交量 */
@property (nonatomic, strong) UILabel *volumeLab;

/** 成交额标题 */
@property (nonatomic, strong) UILabel *turnoverTitleLab;

/** 成交额 */
@property (nonatomic, strong) UILabel *turnoverLab;

@end

@implementation JMMoveDetailInfoView

#pragma mark — life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self createUI];
        [self addBind];
    }
    
    return self;
}

#pragma mark - Delegate

#pragma mark — Private method

- (NSString *)dayFromWeekday:(NSDate *)date {
    switch([date weekday]) {
        case 1:
            return @"周日";
            break;
        case 2:
            return @"周一";
            break;
        case 3:
            return @"周二";
            break;
        case 4:
            return @"周三";
            break;
        case 5:
            return @"周四";
            break;
        case 6:
            return @"周五";
            break;
        case 7:
            return @"周六";
            break;
        default:
            break;
    }
    return @"";
}

/** 获取颜色
 * NewValue             新值
 * OldValue              旧值
 */
- (UIColor *)getReturnValueColorWithNewValue:(CGFloat)newValue
                                    OldValue:(CGFloat )oldValue {
    
    if (newValue == oldValue) { // 平
        return UIColor.handicapInfoTextColor;
    } else if (newValue > oldValue) { // 涨
        return UIColor.upColor;
    } else { // 跌
        return UIColor.downColor;
    }
}

/** 计算成交量和成交额
 * number       数据
 * type            类型 1.成交量 2.成交额
 */
- (NSString *)getCalculateTradingVolumeAndTurnoverWithNumber:(CGFloat)number
                                                        Type:(NSInteger)type {
    
    NSString * text = @"";
    if (number >= 1e8) {
        text = [NSString stringWithFormat:@"%.2f亿", number/1e8];
    } else if (number >= 1e4) {
        text = [NSString stringWithFormat:@"%.2f万", number/1e4];
    } else {
        if (type == 1) {
            text = [NSString stringWithFormat:@"%.0f", number];
        } else {
            text = [NSString stringWithFormat:@"%.2f", number];
        }
    }
    
    return text;
}

#pragma mark — bind

- (void)addBind {
    
}

#pragma mark — UI

- (void)createUI {
    
    // 日期
    [self addSubview:self.dateLab];
    [self.dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).mas_offset(5);
        make.centerX.mas_equalTo(self);
        make.height.mas_offset(13);
    }];
    
    // 开盘价标题
    [self addSubview:self.openPriceTitleLab];
    [self.openPriceTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.dateLab.mas_bottom).mas_offset(2);
        make.left.mas_equalTo(self).mas_offset(2);
        make.height.mas_offset(13);
    }];
    
    // 开盘价
    [self addSubview:self.openPriceLab];
    [self.openPriceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.openPriceTitleLab);
        make.right.mas_equalTo(self.mas_right).mas_offset(-2);
        make.height.mas_offset(13);
    }];
    
    // 最高价标题
    [self addSubview:self.highestPriceTitleLab];
    [self.highestPriceTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.openPriceTitleLab.mas_bottom).mas_offset(2);
        make.left.mas_equalTo(self).mas_offset(2);
        make.height.mas_offset(13);
    }];
    
    // 最高价
    [self addSubview:self.highestPriceLab];
    [self.highestPriceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.highestPriceTitleLab);
        make.right.mas_equalTo(self.mas_right).mas_offset(-2);
        make.height.mas_offset(13);
    }];
    
    // 最低价标题
    [self addSubview:self.minimumPriceTitleLab];
    [self.minimumPriceTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.highestPriceTitleLab.mas_bottom).mas_offset(2);
        make.left.mas_equalTo(self).mas_offset(2);
        make.height.mas_offset(13);
    }];
    
    // 最低价
    [self addSubview:self.minimumPriceLab];
    [self.minimumPriceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.minimumPriceTitleLab);
        make.right.mas_equalTo(self.mas_right).mas_offset(-2);
        make.height.mas_offset(13);
    }];
    
    // 收盘价标题
    [self addSubview:self.closPriceTitleLab];
    [self.closPriceTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.minimumPriceTitleLab.mas_bottom).mas_offset(2);
        make.left.mas_equalTo(self).mas_offset(2);
        make.height.mas_offset(13);
    }];
    
    // 收盘价
    [self addSubview:self.closPriceLab];
    [self.closPriceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.closPriceTitleLab);
        make.right.mas_equalTo(self.mas_right).mas_offset(-2);
        make.height.mas_offset(13);
    }];
    
    // 涨跌额标题
    [self addSubview:self.upAndDownAmountTitleLab];
    [self.upAndDownAmountTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.closPriceTitleLab.mas_bottom).mas_offset(2);
        make.left.mas_equalTo(self).mas_offset(2);
        make.height.mas_offset(13);
    }];
    
    // 涨跌额
    [self addSubview:self.upAndDownAmountLab];
    [self.upAndDownAmountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.upAndDownAmountTitleLab);
        make.right.mas_equalTo(self.mas_right).mas_offset(-2);
        make.height.mas_offset(13);
    }];
    
    // 涨跌幅标题
    [self addSubview:self.fluctuationRangeTitleLab];
    [self.fluctuationRangeTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.upAndDownAmountTitleLab.mas_bottom).mas_offset(2);
        make.left.mas_equalTo(self).mas_offset(2);
        make.height.mas_offset(13);
    }];
    
    // 涨跌幅
    [self addSubview:self.fluctuationRangeLab];
    [self.fluctuationRangeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.fluctuationRangeTitleLab);
        make.right.mas_equalTo(self.mas_right).mas_offset(-2);
        make.height.mas_offset(13);
    }];
    
    // 成交量标题
    [self addSubview:self.volumeTitleLab];
    [self.volumeTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.fluctuationRangeTitleLab.mas_bottom).mas_offset(2);
        make.left.mas_equalTo(self).mas_offset(2);
        make.height.mas_offset(13);
    }];
    
    // 成交量
    [self addSubview:self.volumeLab];
    [self.volumeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.volumeTitleLab);
        make.right.mas_equalTo(self.mas_right).mas_offset(-2);
        make.height.mas_offset(13);
    }];
    
    // 成交额标题
    [self addSubview:self.turnoverTitleLab];
    [self.turnoverTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.volumeTitleLab.mas_bottom).mas_offset(2);
        make.left.mas_equalTo(self).mas_offset(2);
        make.height.mas_offset(13);
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-5);
    }];
    
    // 成交额
    [self addSubview:self.turnoverLab];
    [self.turnoverLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.turnoverTitleLab);
        make.right.mas_equalTo(self.mas_right).mas_offset(-2);
        make.height.mas_offset(13);
    }];
    
}

#pragma mark - setter & getter

- (UILabel *)dateLab {
    if (!_dateLab) {
        _dateLab = [[UILabel alloc] init];
        _dateLab.text = @"--";
        _dateLab.textColor = UIColor.handicapInfoTextColor;
        _dateLab.font = [UIFont systemFontOfSize:10.f];
    }
    return _dateLab;
}

- (UILabel *)openPriceTitleLab {
    if (!_openPriceTitleLab) {
        _openPriceTitleLab = [[UILabel alloc] init];
        _openPriceTitleLab.text = @"开盘";
        _openPriceTitleLab.textColor = UIColor.secondaryTextColor;
        _openPriceTitleLab.font = [UIFont systemFontOfSize:10.f];
    }
    return _openPriceTitleLab;
}

- (UILabel *)openPriceLab {
    if (!_openPriceLab) {
        _openPriceLab = [[UILabel alloc] init];
        _openPriceLab.text = @"--";
        _openPriceLab.textColor = UIColor.handicapInfoTextColor;
        _openPriceLab.font = [UIFont systemFontOfSize:10.f];
    }
    return _openPriceLab;
}

- (UILabel *)closPriceTitleLab {
    if (!_closPriceTitleLab) {
        _closPriceTitleLab = [[UILabel alloc] init];
        _closPriceTitleLab.text = @"收盘";
        _closPriceTitleLab.textColor = UIColor.secondaryTextColor;
        _closPriceTitleLab.font = [UIFont systemFontOfSize:10.f];
    }
    return _closPriceTitleLab;
}

- (UILabel *)closPriceLab {
    if (!_closPriceLab) {
        _closPriceLab = [[UILabel alloc] init];
        _closPriceLab.text = @"--";
        _closPriceLab.textColor = UIColor.handicapInfoTextColor;
        _closPriceLab.font = [UIFont systemFontOfSize:10.f];
    }
    return _closPriceLab;
}

- (UILabel *)highestPriceTitleLab {
    if (!_highestPriceTitleLab) {
        _highestPriceTitleLab = [[UILabel alloc] init];
        _highestPriceTitleLab.text = @"最高";
        _highestPriceTitleLab.textColor = UIColor.secondaryTextColor;
        _highestPriceTitleLab.font = [UIFont systemFontOfSize:10.f];
    }
    return _highestPriceTitleLab;
}

- (UILabel *)highestPriceLab {
    if (!_highestPriceLab) {
        _highestPriceLab = [[UILabel alloc] init];
        _highestPriceLab.text = @"--";
        _highestPriceLab.textColor = UIColor.handicapInfoTextColor;
        _highestPriceLab.font = [UIFont systemFontOfSize:10.f];
    }
    return _highestPriceLab;
}

- (UILabel *)minimumPriceTitleLab {
    if (!_minimumPriceTitleLab) {
        _minimumPriceTitleLab = [[UILabel alloc] init];
        _minimumPriceTitleLab.text = @"最低";
        _minimumPriceTitleLab.textColor = UIColor.secondaryTextColor;
        _minimumPriceTitleLab.font = [UIFont systemFontOfSize:10.f];
    }
    return _minimumPriceTitleLab;
}

- (UILabel *)minimumPriceLab {
    if (!_minimumPriceLab) {
        _minimumPriceLab = [[UILabel alloc] init];
        _minimumPriceLab.text = @"--";
        _minimumPriceLab.textColor = UIColor.handicapInfoTextColor;
        _minimumPriceLab.font = [UIFont systemFontOfSize:10.f];
    }
    return _minimumPriceLab;
}

- (UILabel *)upAndDownAmountTitleLab {
    if (!_upAndDownAmountTitleLab) {
        _upAndDownAmountTitleLab = [[UILabel alloc] init];
        _upAndDownAmountTitleLab.text = @"涨跌额";
        _upAndDownAmountTitleLab.textColor = UIColor.secondaryTextColor;
        _upAndDownAmountTitleLab.font = [UIFont systemFontOfSize:9.f];
    }
    return _upAndDownAmountTitleLab;
}

- (UILabel *)upAndDownAmountLab {
    if (!_upAndDownAmountLab) {
        _upAndDownAmountLab = [[UILabel alloc] init];
        _upAndDownAmountLab.text = @"--";
        _upAndDownAmountLab.textColor = UIColor.handicapInfoTextColor;
        _upAndDownAmountLab.font = [UIFont systemFontOfSize:9.f];
    }
    return _upAndDownAmountLab;
}

- (UILabel *)fluctuationRangeTitleLab {
    if (!_fluctuationRangeTitleLab) {
        _fluctuationRangeTitleLab = [[UILabel alloc] init];
        _fluctuationRangeTitleLab.text = @"涨跌幅";
        _fluctuationRangeTitleLab.textColor = UIColor.secondaryTextColor;
        _fluctuationRangeTitleLab.font = [UIFont systemFontOfSize:9.f];
    }
    return _fluctuationRangeTitleLab;
}

- (UILabel *)fluctuationRangeLab {
    if (!_fluctuationRangeLab) {
        _fluctuationRangeLab = [[UILabel alloc] init];
        _fluctuationRangeLab.text = @"--";
        _fluctuationRangeLab.textColor = UIColor.handicapInfoTextColor;
        _fluctuationRangeLab.font = [UIFont systemFontOfSize:9.f];
    }
    return _fluctuationRangeLab;
}

- (UILabel *)volumeTitleLab {
    if (!_volumeTitleLab) {
        _volumeTitleLab = [[UILabel alloc] init];
        _volumeTitleLab.text = @"成交量";
        _volumeTitleLab.textColor = UIColor.secondaryTextColor;
        _volumeTitleLab.font = [UIFont systemFontOfSize:9.f];
    }
    return _volumeTitleLab;
}

- (UILabel *)volumeLab {
    if (!_volumeLab) {
        _volumeLab = [[UILabel alloc] init];
        _volumeLab.text = @"--";
        _volumeLab.textColor = UIColor.handicapInfoTextColor;
        _volumeLab.font = [UIFont systemFontOfSize:9.f];
    }
    return _volumeLab;
}

- (UILabel *)turnoverTitleLab {
    if (!_turnoverTitleLab) {
        _turnoverTitleLab = [[UILabel alloc] init];
        _turnoverTitleLab.text = @"成交额";
        _turnoverTitleLab.textColor = UIColor.secondaryTextColor;
        _turnoverTitleLab.font = [UIFont systemFontOfSize:9.f];
    }
    return _turnoverTitleLab;
}

- (UILabel *)turnoverLab {
    if (!_turnoverLab) {
        _turnoverLab = [[UILabel alloc] init];
        _turnoverLab.text = @"--";
        _turnoverLab.textColor = UIColor.handicapInfoTextColor;
        _turnoverLab.font = [UIFont systemFontOfSize:9.f];
    }
    return _turnoverLab;
}

#pragma mark — 数据重载

- (void)setChartType:(KLineChartType)chartType {
    _chartType = chartType;
}

- (void)setLineModel:(JMKlineModel *)lineModel {
    _lineModel = lineModel;
    
    // 保留小数点位数
    NSString *format;
    NSString *fformat;
    
    // 判断市场类型，保留小数位
    if ([[JMChatManager sharedInstance].market isEqualToString:@"ZH"]) {
        format = @"%.2f";
        fformat = @"%+0.2f";
    } else {
        format = @"%.3f";
        fformat = @"%+0.3f";
    }
    
    // 上一个交易日收盘价
//    CGFloat preClose = lineModel.PrevModel.Close.floatValue;
    CGFloat preClose = lineModel.yesterdayClose.floatValue;
    
    // 日期
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:lineModel.Timestamp.doubleValue];;
    NSString *ad = [NSString stringWithFormat:@"%@ %@", self.chartType > KLineChartTypeYearK ? lineModel.V_MMDDHHMM : lineModel.V_YYYYMMDD,[self dayFromWeekday:date]];
    self.dateLab.text = ad;
    
    // 开盘价
//    self.openPriceLab.text = [NSString stringWithFormat:format,lineModel.Open.floatValue];
    self.openPriceLab.text = [NSString stringWithFormat:@"%@",lineModel.Open];
    self.openPriceLab.textColor = [self getReturnValueColorWithNewValue:lineModel.Open.floatValue OldValue:lineModel.PrevModel.Close.floatValue];
    
    // 最高价
//    self.highestPriceLab.text = [NSString stringWithFormat:format,lineModel.High.floatValue];
    self.highestPriceLab.text = [NSString stringWithFormat:@"%@",lineModel.High];
    self.highestPriceLab.textColor = [self getReturnValueColorWithNewValue:lineModel.High.floatValue OldValue:lineModel.PrevModel.Close.floatValue];
    
    // 最低价
//    self.minimumPriceLab.text = [NSString stringWithFormat:format,lineModel.Low.floatValue];
    self.minimumPriceLab.text = [NSString stringWithFormat:@"%@",lineModel.Low];
    self.minimumPriceLab.textColor = [self getReturnValueColorWithNewValue:lineModel.Low.floatValue OldValue:lineModel.PrevModel.Close.floatValue];
    
    // 收盘价
//    self.closPriceLab.text = [NSString stringWithFormat:format,lineModel.Close.floatValue];
    self.closPriceLab.text = [NSString stringWithFormat:@"%@",lineModel.Close];
    self.closPriceLab.textColor = [self getReturnValueColorWithNewValue:lineModel.Close.floatValue OldValue:lineModel.PrevModel.Close.floatValue];
    
    
    // 计算涨跌额
    NSString *upAndDownAmountString;
    // 计算涨跌幅
    NSString *changePctString;
    if (preClose > 0) { // 有上个交易日收盘价
        upAndDownAmountString = [NSString stringWithFormat:fformat, lineModel.Close.floatValue - preClose];
        
        changePctString = [NSString stringWithFormat:@"%+0.2f%%", (lineModel.Close.floatValue - preClose) / preClose * 100];
    } else {
        
        upAndDownAmountString = [NSString stringWithFormat:fformat, lineModel.Low.floatValue - lineModel.Open.floatValue];
        
        changePctString = [NSString stringWithFormat:@"%+0.2f%%", (lineModel.Low.floatValue - lineModel.Open.floatValue) / fabs(lineModel.Open.floatValue) * 100];
    }
    
    if ([upAndDownAmountString isEqualToString:@"+inf%"] || [upAndDownAmountString isEqualToString:@"nan%"]) {
        upAndDownAmountString = @"--";
    }
    
    if ([changePctString isEqualToString:@"+inf%"] || [changePctString isEqualToString:@"nan%"]) {
        changePctString = @"--";
    }
    
    // 涨跌额
    // [upAndDownAmountString containsString:@"0.000"]
    if ([[upAndDownAmountString substringFromIndex:1] isEqualToString:@"0.000"] || [[upAndDownAmountString substringFromIndex:1] isEqualToString:@"0.00"]) {
        self.upAndDownAmountLab.text = [[JMChatManager sharedInstance].market isEqualToString:@"ZH"] ? @"0.00" : @"0.000";
        self.upAndDownAmountLab.textColor = UIColor.handicapInfoTextColor;
    } else {
        self.upAndDownAmountLab.text = upAndDownAmountString;
        self.upAndDownAmountLab.textColor = [upAndDownAmountString isEqualToString:@"--"] ? UIColor.handicapInfoTextColor : [upAndDownAmountString containsString:@"+"] ? UIColor.upColor : UIColor.downColor;
    }
    
    // 涨跌幅
    // [changePctString containsString:@"0.00"]
    if ([[changePctString substringFromIndex:1] isEqualToString:@"0.00%"]) {
        self.fluctuationRangeLab.text = @"0.00%";
        self.fluctuationRangeLab.textColor = UIColor.handicapInfoTextColor;
    } else {
        self.fluctuationRangeLab.text = changePctString;
        self.fluctuationRangeLab.textColor = [changePctString isEqualToString:@"--"] ? UIColor.handicapInfoTextColor : [changePctString containsString:@"+"] ? UIColor.upColor : UIColor.downColor;
    }
    
    // 成交量
    NSString *volumeStr = [self getCalculateTradingVolumeAndTurnoverWithNumber:lineModel.Volume.floatValue Type:1];
    self.volumeLab.text = [NSString stringWithFormat:@"%@%@",volumeStr, [[JMChatManager sharedInstance].market isEqualToString:@"ZH"] ? @"手" : @"股"];
    
    // 成交额
    self.turnoverLab.text = [self getCalculateTradingVolumeAndTurnoverWithNumber:lineModel.Turnover.floatValue Type:2];
    
    // TODO: 更新布局
    if ([[JMChatManager sharedInstance].market isEqualToString:@"ZH"] && [JMChatManager sharedInstance].isStockIndex) {
        
        self.turnoverTitleLab.hidden = YES;
        self.turnoverLab.hidden = YES;
        
        // 成交量标题
        [self.volumeTitleLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.fluctuationRangeTitleLab.mas_bottom).mas_offset(2);
            make.left.mas_equalTo(self).mas_offset(2);
            make.height.mas_offset(13);
        }];
        
        // 成交量
        [self.volumeLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.volumeTitleLab);
            make.right.mas_equalTo(self.mas_right).mas_offset(-2);
            make.height.mas_offset(13);
        }];
        
        // 成交额标题
        [self.turnoverTitleLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.volumeTitleLab.mas_bottom);
            make.left.mas_equalTo(self).mas_offset(2);
            make.height.mas_offset(0);
            make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-5);
        }];
        
        // 成交额
        [self.turnoverLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.turnoverTitleLab);
            make.right.mas_equalTo(self.mas_right).mas_offset(-2);
            make.height.mas_offset(0);
        }];
        
    } else if ([JMChatManager sharedInstance].isStockIndex) { // 指数
        
        self.volumeTitleLab.hidden = YES;
        self.volumeLab.hidden = YES;
        
        // 成交量标题
        [self.volumeTitleLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.fluctuationRangeTitleLab.mas_bottom).mas_offset(2);
            make.left.mas_equalTo(self).mas_offset(2);
            make.height.mas_offset(0);
        }];
        
        // 成交量
        [self.volumeLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.volumeTitleLab);
            make.right.mas_equalTo(self.mas_right).mas_offset(-2);
            make.height.mas_offset(0);
        }];
        
        // 成交额标题
        [self.turnoverTitleLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.volumeTitleLab.mas_bottom);
            make.left.mas_equalTo(self).mas_offset(2);
            make.height.mas_offset(13);
            make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-5);
        }];
        
        // 成交额
        [self.turnoverLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.turnoverTitleLab);
            make.right.mas_equalTo(self.mas_right).mas_offset(-2);
            make.height.mas_offset(13);
        }];
        
    } else { // 非指数
        
        self.volumeTitleLab.hidden = NO;
        self.volumeLab.hidden = NO;
        
        // 成交量标题
        [self.volumeTitleLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.fluctuationRangeTitleLab.mas_bottom).mas_offset(2);
            make.left.mas_equalTo(self).mas_offset(2);
            make.height.mas_offset(13);
        }];
        
        // 成交量
        [self.volumeLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.volumeTitleLab);
            make.right.mas_equalTo(self.mas_right).mas_offset(-2);
            make.height.mas_offset(13);
        }];
        
        // 成交额标题
        [self.turnoverTitleLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.volumeTitleLab.mas_bottom).mas_offset(2);
            make.left.mas_equalTo(self).mas_offset(2);
            make.height.mas_offset(13);
            make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-5);
        }];
        
        // 成交额
        [self.turnoverLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.turnoverTitleLab);
            make.right.mas_equalTo(self.mas_right).mas_offset(-2);
            make.height.mas_offset(13);
        }];
        
    }
    
}

@end
