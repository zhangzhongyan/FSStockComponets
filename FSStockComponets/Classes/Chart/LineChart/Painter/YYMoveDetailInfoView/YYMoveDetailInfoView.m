//
//  YYMoveDetailInfoView.m
//  ghchat
//
//  Created by fargowealth on 2021/10/28.
//

#import "YYMoveDetailInfoView.h"
#import "QuotationConstant.h"
#import "JMChatManager.h"
//Helper
#import "FSStockComponetsLanguage.h"
#import "FSStockUnitUtils.h"

@interface YYMoveDetailInfoView ()

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

@implementation YYMoveDetailInfoView


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
    if (type == 1) {
        return [FSStockUnitUtils readbleVolumeWithNumber:number];
    } else {
        return [FSStockUnitUtils readbleDealAmoutWithNumber:number];
    }
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
    
    // 收盘价标题
    [self addSubview:self.closPriceTitleLab];
    [self.closPriceTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.openPriceTitleLab.mas_bottom).mas_offset(2);
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
        _openPriceTitleLab.text = FSMacroLanguage(@"价格");
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
        _closPriceTitleLab.text = FSMacroLanguage(@"均价");
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

- (UILabel *)upAndDownAmountTitleLab {
    if (!_upAndDownAmountTitleLab) {
        _upAndDownAmountTitleLab = [[UILabel alloc] init];
        _upAndDownAmountTitleLab.text = FSMacroLanguage(@"涨跌额");
        _upAndDownAmountTitleLab.textColor = UIColor.secondaryTextColor;
        _upAndDownAmountTitleLab.font = [UIFont systemFontOfSize:10.f];
    }
    return _upAndDownAmountTitleLab;
}

- (UILabel *)upAndDownAmountLab {
    if (!_upAndDownAmountLab) {
        _upAndDownAmountLab = [[UILabel alloc] init];
        _upAndDownAmountLab.text = @"--";
        _upAndDownAmountLab.textColor = UIColor.handicapInfoTextColor;
        _upAndDownAmountLab.font = [UIFont systemFontOfSize:10.f];
    }
    return _upAndDownAmountLab;
}

- (UILabel *)fluctuationRangeTitleLab {
    if (!_fluctuationRangeTitleLab) {
        _fluctuationRangeTitleLab = [[UILabel alloc] init];
        _fluctuationRangeTitleLab.text = FSMacroLanguage(@"涨跌幅");
        _fluctuationRangeTitleLab.textColor = UIColor.secondaryTextColor;
        _fluctuationRangeTitleLab.font = [UIFont systemFontOfSize:10.f];
    }
    return _fluctuationRangeTitleLab;
}

- (UILabel *)fluctuationRangeLab {
    if (!_fluctuationRangeLab) {
        _fluctuationRangeLab = [[UILabel alloc] init];
        _fluctuationRangeLab.text = @"--";
        _fluctuationRangeLab.textColor = UIColor.handicapInfoTextColor;
        _fluctuationRangeLab.font = [UIFont systemFontOfSize:10.f];
    }
    return _fluctuationRangeLab;
}

- (UILabel *)volumeTitleLab {
    if (!_volumeTitleLab) {
        _volumeTitleLab = [[UILabel alloc] init];
        _volumeTitleLab.text = FSMacroLanguage(@"成交量");
        _volumeTitleLab.textColor = UIColor.secondaryTextColor;
        _volumeTitleLab.font = [UIFont systemFontOfSize:10.f];
    }
    return _volumeTitleLab;
}

- (UILabel *)volumeLab {
    if (!_volumeLab) {
        _volumeLab = [[UILabel alloc] init];
        _volumeLab.text = @"--";
        _volumeLab.textColor = UIColor.handicapInfoTextColor;
        _volumeLab.font = [UIFont systemFontOfSize:10.f];
    }
    return _volumeLab;
}

- (UILabel *)turnoverTitleLab {
    if (!_turnoverTitleLab) {
        _turnoverTitleLab = [[UILabel alloc] init];
        _turnoverTitleLab.text = FSMacroLanguage(@"成交额");
        _turnoverTitleLab.textColor = UIColor.secondaryTextColor;
        _turnoverTitleLab.font = [UIFont systemFontOfSize:10.f];
    }
    return _turnoverTitleLab;
}

- (UILabel *)turnoverLab {
    if (!_turnoverLab) {
        _turnoverLab = [[UILabel alloc] init];
        _turnoverLab.text = @"--";
        _turnoverLab.textColor = UIColor.handicapInfoTextColor;
        _turnoverLab.font = [UIFont systemFontOfSize:10.f];
    }
    return _turnoverLab;
}

#pragma mark — 数据重载

- (void)setLineModel:(YYKlineModel *)lineModel {
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
    CGFloat preClose = lineModel.Close.floatValue;
//    CGFloat preClose = lineModel.yesterdayClose.floatValue;
    
    // 日期
    self.dateLab.text = lineModel.V_Date;
    
    // 开盘价
//    self.openPriceLab.text = [NSString stringWithFormat:format,lineModel.Open.floatValue];
    self.openPriceLab.text = [NSString stringWithFormat:@"%@",lineModel.Open];
    self.openPriceLab.textColor = [self getReturnValueColorWithNewValue:lineModel.Open.floatValue OldValue:preClose];
    
    // 均价
//    self.closPriceLab.text = [NSString stringWithFormat:format,lineModel.avgPrice.floatValue];
    self.closPriceLab.text = [NSString stringWithFormat:@"%@",lineModel.avgPrice];
    self.closPriceLab.textColor = [self getReturnValueColorWithNewValue:lineModel.avgPrice.floatValue OldValue:preClose];
    
    
    // 计算涨跌额
    NSString *upAndDownAmountString;
    // 计算涨跌幅
    NSString *changePctString;
    if (preClose > 0) { // 有上个交易日收盘价
        upAndDownAmountString = [NSString stringWithFormat:fformat, lineModel.Open.floatValue - preClose];
        
        changePctString = [NSString stringWithFormat:@"%+0.2f%%", (lineModel.Open.floatValue - preClose) / preClose * 100];
    } else {
        // TODO: 待优化
        upAndDownAmountString = [NSString stringWithFormat:fformat, lineModel.Low.floatValue - lineModel.Open.floatValue];
        
        changePctString = [NSString stringWithFormat:@"%+0.2f%%", (lineModel.Low.floatValue - lineModel.Open.floatValue) / fabs(lineModel.Open.floatValue) * 100];
    }
    
    // 涨跌额
    // [upAndDownAmountString containsString:@"0.000"]
    if ([[upAndDownAmountString substringFromIndex:1] isEqualToString:@"0.000"] || [[upAndDownAmountString substringFromIndex:1] isEqualToString:@"0.00"]) {
        self.upAndDownAmountLab.text = [[JMChatManager sharedInstance].market isEqualToString:@"ZH"] ? @"0.00" : @"0.000";
        self.upAndDownAmountLab.textColor = UIColor.handicapInfoTextColor;
    } else {
        self.upAndDownAmountLab.text = upAndDownAmountString;
        self.upAndDownAmountLab.textColor = [upAndDownAmountString containsString:@"+"] ? UIColor.upColor : UIColor.downColor;
    }
    
    // 涨跌幅
    // [changePctString containsString:@"0.00"]
    if ([[changePctString substringFromIndex:1] isEqualToString:@"0.00%"]) {
        self.fluctuationRangeLab.text = @"0.00%";
        self.fluctuationRangeLab.textColor = UIColor.handicapInfoTextColor;
    } else {
        self.fluctuationRangeLab.text = changePctString;
        self.fluctuationRangeLab.textColor = [changePctString containsString:@"+"] ? UIColor.upColor : UIColor.downColor;
    }
    
    // 成交量
    NSString *volumeStr = [self getCalculateTradingVolumeAndTurnoverWithNumber:lineModel.Volume.floatValue Type:1];
    self.volumeLab.text = [NSString stringWithFormat:@"%@%@",volumeStr, [[JMChatManager sharedInstance].market isEqualToString:@"ZH"] ? FSMacroLanguage(@"手") : FSMacroLanguage(@"股")];
    
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
