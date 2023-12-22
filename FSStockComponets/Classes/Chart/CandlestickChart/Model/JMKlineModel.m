//
//  JMKlineModel.m
//  ghchat
//
//  Created by fargowealth on 2021/10/26.
//

#import "JMKlineModel.h"
#import "UIColor+JMColor.h"
#import "JMChatManager.h"

@implementation JMKlineModel

- (NSString *)V_Date {
    if (!_V_Date) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:_Timestamp.doubleValue];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        // 设置时区为香港时区
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Hong_Kong"];
        [formatter setTimeZone:timeZone];
        formatter.dateFormat = @"yyyy/MM/dd HH:mm";
        NSString *dateStr = [formatter stringFromDate:date];
        _V_Date = dateStr;
    }
    return _V_Date;
}

- (NSString *)V_YYYYMMDD {
    if (!_V_YYYYMMDD) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:_Timestamp.doubleValue];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        // 设置时区为香港时区
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Hong_Kong"];
        [formatter setTimeZone:timeZone];
        formatter.dateFormat = @"yyyy/MM/dd";
        NSString *dateStr = [formatter stringFromDate:date];
        _V_YYYYMMDD = dateStr;
    }
    return _V_YYYYMMDD;
}

- (NSString *)V_YYYYMM {
    if (!_V_YYYYMM) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:_Timestamp.doubleValue];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        // 设置时区为香港时区
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Hong_Kong"];
        [formatter setTimeZone:timeZone];
        formatter.dateFormat = @"yyyy/MM";
        NSString *dateStr = [formatter stringFromDate:date];
        _V_YYYYMM = dateStr;
    }
    return _V_YYYYMM;
}

- (NSString *)V_MMDD {
    if (!_V_MMDD) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:_Timestamp.doubleValue];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        // 设置时区为香港时区
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Hong_Kong"];
        [formatter setTimeZone:timeZone];
        formatter.dateFormat = @"MM/dd";
        NSString *dateStr = [formatter stringFromDate:date];
        _V_MMDD = dateStr;
    }
    return _V_MMDD;
}

- (NSString *)V_MMDDHHMM {
    if (!_V_MMDDHHMM) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:_Timestamp.doubleValue];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        // 设置时区为香港时区
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Hong_Kong"];
        [formatter setTimeZone:timeZone];
        formatter.dateFormat = @"MM/dd HH:mm";
        NSString *dateStr = [formatter stringFromDate:date];
        _V_MMDDHHMM = dateStr;
    }
    return _V_MMDDHHMM;
}

- (NSString *)V_HHMM {
    if (!_V_HHMM) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:_Timestamp.doubleValue];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        // 设置时区为香港时区
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Hong_Kong"];
        [formatter setTimeZone:timeZone];
        formatter.dateFormat = @"HH:mm";
        NSString *dateStr = [formatter stringFromDate:date];
        _V_HHMM = dateStr;
    }
    return _V_HHMM;
}

- (NSString *)V_MM {
    if (!_V_MM) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:_Timestamp.doubleValue];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        // 设置时区为香港时区
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Hong_Kong"];
        [formatter setTimeZone:timeZone];
        formatter.dateFormat = @"mm";
        NSString *dateStr = [formatter stringFromDate:date];
        _V_MM = dateStr;
    }
    return _V_MM;
}

- (NSAttributedString *)V_Price {
    if (!_V_Price) {
        _V_Price = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@  开：%.3f  高：%.3f 低：%.3f  收：%.3f ", self.V_Date, self.Open.floatValue, self.High.floatValue, self.Low.floatValue, self.Close.floatValue] attributes:@{
            NSForegroundColorAttributeName: [UIColor grayColor],
        }];
    }
    return _V_Price;
}

- (NSAttributedString *)V_MA {
    if (!_V_MA) {
//        NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@  开：%.3f  高：%.3f 低：%.3f  收：%.3f ", self.V_Date, self.Open.floatValue, self.High.floatValue, self.Low.floatValue, self.Close.floatValue] attributes:@{
//            NSForegroundColorAttributeName: [UIColor grayColor],
//        }];
        
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"" attributes:@{
            NSForegroundColorAttributeName: [UIColor grayColor],
        }];
        NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"MA5:%.3f ",self.MA.MA1.floatValue] attributes:@{
            NSForegroundColorAttributeName: [UIColor line1Color],
        }];
        NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"MA10:%.3f ",self.MA.MA2.floatValue] attributes:@{
            NSForegroundColorAttributeName: [UIColor line2Color],
        }];
        NSAttributedString *str3 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"MA20:%.3f ",self.MA.MA3.floatValue] attributes:@{
            NSForegroundColorAttributeName: [UIColor line3Color],
        }];
        NSAttributedString *str4 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"MA30:%.3f ",self.MA.MA4.floatValue] attributes:@{
            NSForegroundColorAttributeName: [UIColor line4Color],
        }];
        NSAttributedString *str5 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"MA60:%.3f ",self.MA.MA5.floatValue] attributes:@{
            NSForegroundColorAttributeName: [UIColor line5Color],
        }];
        NSMutableAttributedString *mStr = [[NSMutableAttributedString alloc] initWithAttributedString:str];
        [mStr appendAttributedString:str1];
        [mStr appendAttributedString:str2];
        [mStr appendAttributedString:str3];
        [mStr appendAttributedString:str4];
        [mStr appendAttributedString:str5];
        _V_MA = [mStr copy];
    }
    return _V_MA;
}

- (NSAttributedString *)V_EMA {
    if (!_V_EMA) {
//        NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@  开：%.3f  高：%.3f 低：%.3f  收：%.3f ", self.V_Date, self.Open.floatValue, self.High.floatValue, self.Low.floatValue, self.Close.floatValue] attributes:@{
//            NSForegroundColorAttributeName: [UIColor grayColor],
//        }];
        NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:@"" attributes:@{
            NSForegroundColorAttributeName: [UIColor grayColor],
        }];
        NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" EMA7：%.3f ",self.EMA.EMA1.floatValue] attributes:@{
            NSForegroundColorAttributeName: [UIColor line1Color],
        }];
        NSAttributedString *str3 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" EMA30：%.3f ",self.EMA.EMA2.floatValue] attributes:@{
            NSForegroundColorAttributeName: [UIColor line2Color],
        }];
        NSMutableAttributedString *mStr = [[NSMutableAttributedString alloc] initWithAttributedString:str1];
        [mStr appendAttributedString:str2];
        [mStr appendAttributedString:str3];
        _V_EMA = [mStr copy];
    }
    return _V_EMA;
}

- (NSAttributedString *)V_BOLL {
    if (!_V_BOLL) {
//        NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@  开：%.3f  高：%.3f 低：%.3f  收：%.3f ", self.V_Date, self.Open.floatValue, self.High.floatValue, self.Low.floatValue, self.Close.floatValue] attributes:@{
//            NSForegroundColorAttributeName: [UIColor grayColor],
//        }];
        NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:@"" attributes:@{
            NSForegroundColorAttributeName: [UIColor grayColor],
        }];
        NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" UP：%.3f ",self.BOLL.UP.floatValue] attributes:@{
            NSForegroundColorAttributeName: [UIColor line1Color],
        }];
        NSAttributedString *str3 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" MID：%.3f ",self.BOLL.MID.floatValue] attributes:@{
            NSForegroundColorAttributeName: [UIColor line2Color],
        }];
        NSAttributedString *str4 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" LOW：%.3f ",self.BOLL.LOW.floatValue] attributes:@{
            NSForegroundColorAttributeName: [UIColor line3Color],
        }];
        NSMutableAttributedString *mStr = [[NSMutableAttributedString alloc] initWithAttributedString:str1];
        [mStr appendAttributedString:str2];
        [mStr appendAttributedString:str3];
        [mStr appendAttributedString:str4];
        _V_BOLL = [mStr copy];
    }
    return _V_BOLL;
}

- (NSAttributedString *)V_Volume {
    if (!_V_Volume) {
        _V_Volume = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" 成交量：%.0f", self.Volume.floatValue] attributes:@{
            NSForegroundColorAttributeName: [UIColor grayColor],
        }];
    }
    return _V_Volume;
}

- (NSAttributedString *)V_MACD {
    if (!_V_MACD) {
        NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:@" MACD(12,26,9)：" attributes:@{
            NSForegroundColorAttributeName: [UIColor grayColor],
        }];
        NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" DIFF：%.4f ",self.MACD.DIFF.floatValue] attributes:@{
            NSForegroundColorAttributeName: [UIColor line1Color],
        }];
        NSAttributedString *str3 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" DEA：%.4f ",self.MACD.DEA.floatValue] attributes:@{
            NSForegroundColorAttributeName: [UIColor line2Color],
        }];
        NSAttributedString *str4 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" MACD：%.4f ",self.MACD.MACD.floatValue] attributes:@{
            NSForegroundColorAttributeName: self.MACD.MACD.floatValue < 0 ? UIColor.upColor : UIColor.downColor,
        }];
        
        NSMutableAttributedString *mStr = [[NSMutableAttributedString alloc] initWithAttributedString:str1];
        [mStr appendAttributedString:str2];
        [mStr appendAttributedString:str3];
        [mStr appendAttributedString:str4];
        _V_MACD = [mStr copy];
    }
    return _V_MACD;
}

- (NSAttributedString *)V_KDJ {
    if (!_V_KDJ) {
        NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:@" KDJ(9,3,3)：" attributes:@{
            NSForegroundColorAttributeName: [UIColor grayColor],
        }];
        NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" K：%.3f ",self.KDJ.K.floatValue] attributes:@{
            NSForegroundColorAttributeName: UIColor.line1Color,
        }];
        NSAttributedString *str3 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" D：%.3f ",self.KDJ.D.floatValue] attributes:@{
            NSForegroundColorAttributeName: UIColor.line2Color,
        }];
        NSAttributedString *str4 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" J：%.3f ",self.KDJ.J.floatValue] attributes:@{
            NSForegroundColorAttributeName: UIColor.line3Color,
        }];
        NSMutableAttributedString *mStr = [[NSMutableAttributedString alloc] initWithAttributedString:str1];
        [mStr appendAttributedString:str2];
        [mStr appendAttributedString:str3];
        [mStr appendAttributedString:str4];
        _V_KDJ = [mStr copy];
    }
    return _V_KDJ;
}

- (NSAttributedString *)V_RSI {
    if (!_V_RSI) {
        NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:@" RSI(6,12,24)：" attributes:@{
            NSForegroundColorAttributeName: [UIColor grayColor],
        }];
        NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" RSI6：%.3f ",self.RSI.RSI1.floatValue] attributes:@{
            NSForegroundColorAttributeName: UIColor.line1Color,
        }];
        NSAttributedString *str3 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" RSI12：%.3f ",self.RSI.RSI2.floatValue] attributes:@{
            NSForegroundColorAttributeName: UIColor.line2Color,
        }];
        NSAttributedString *str4 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" RSI24：%.3f ",self.RSI.RSI3.floatValue] attributes:@{
            NSForegroundColorAttributeName: UIColor.line3Color,
        }];
        NSMutableAttributedString *mStr = [[NSMutableAttributedString alloc] initWithAttributedString:str1];
        [mStr appendAttributedString:str2];
        [mStr appendAttributedString:str3];
        [mStr appendAttributedString:str4];
        _V_RSI = [mStr copy];
    }
    return _V_RSI;
}

- (NSAttributedString *)V_WR {
    if (!_V_WR) {
        NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:@" WR(6,10)：" attributes:@{
            NSForegroundColorAttributeName: [UIColor grayColor],
        }];
        NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" WR6：%.3f ",self.WR.WR1.floatValue] attributes:@{
            NSForegroundColorAttributeName: UIColor.line1Color,
        }];
        NSAttributedString *str3 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" WR10：%.3f ",self.WR.WR2.floatValue] attributes:@{
            NSForegroundColorAttributeName: UIColor.line2Color,
        }];
        NSMutableAttributedString *mStr = [[NSMutableAttributedString alloc] initWithAttributedString:str1];
        [mStr appendAttributedString:str2];
        [mStr appendAttributedString:str3];
        _V_WR = [mStr copy];
    }
    return _V_WR;
}

- (BOOL)isUp {
    
    if ([JMChatManager sharedInstance].chartType >= 9) {
        if (self.Close.floatValue == self.PrevModel.Close.floatValue) {
            return YES;
        } else if (self.Close.floatValue > self.PrevModel.Close.floatValue) {
            return YES;
        } else {
            return NO;
        }
    } else {
        if (self.Close.floatValue == self.Open.floatValue) {
            return YES;
        } else if (self.Close.floatValue > self.Open.floatValue) {
            return YES;
        } else {
            return NO;
        }
    }
}



#pragma mark — 计算

/** 二类通证兑换一类通证(默认截取保留2位小数)
 * twoToken             二类通证
 * deductionRate    兑换比例
 */
- (NSString *)calculateTwoTokenConvertOneTokenWithTwoToken:(NSNumber *)twoToken
                                             DeductionRate:(NSNumber *)deductionRate {

    NSDecimalNumber *twoTokenNumber = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@", twoToken]];

    NSDecimalNumber *deductionRateNumber = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@", deductionRate]];

    NSDecimalNumberHandler *handler = [[NSDecimalNumberHandler alloc] initWithRoundingMode:NSRoundDown scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];

    return [[twoTokenNumber decimalNumberByDividingBy:deductionRateNumber withBehavior:handler] stringValue];

}

@end
