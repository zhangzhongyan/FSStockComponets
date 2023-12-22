//
//  JMKlineModel.h
//  ghchat
//
//  Created by fargowealth on 2021/10/26.
//

#import <Foundation/Foundation.h>
#import "JMIndicatorModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JMKlineModel : NSObject

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, weak) JMKlineModel *PrevModel;

@property (nonatomic, strong) NSNumber *Timestamp; // 时间
@property (nonatomic, strong) NSNumber *Open; // 开盘价
@property (nonatomic, strong) NSNumber *Close; // 收盘价
@property (nonatomic, strong) NSNumber *High; // 最高价
@property (nonatomic, strong) NSNumber *Low; // 最低价
@property (nonatomic, strong) NSNumber *Volume; // 成交量
@property (nonatomic, strong) NSNumber *Turnover; // 成交额
@property (nonatomic, strong) NSNumber *avgPrice; //均价
@property (nonatomic, strong) NSNumber *yesterdayClose; //昨收

@property (nonatomic, strong) JMMACDModel *MACD;
@property (nonatomic, strong) JMKDJModel *KDJ;
@property (nonatomic, strong) JMMAModel *MA;
@property (nonatomic, strong) JMEMAModel *EMA;
@property (nonatomic, strong) JMRSIModel *RSI;
@property (nonatomic, strong) JMBOLLModel *BOLL;
@property (nonatomic, strong) JMWRModel *WR;

@property (nonatomic, assign) BOOL isUp;
@property (nonatomic, assign) BOOL isDrawTime;

@property (nonatomic, copy) NSString *V_Date; // YYYY-MM-dd HH:mm
@property (nonatomic, copy) NSString *V_YYYYMMDD; // YYYY-MM-dd
@property (nonatomic, copy) NSString *V_YYYYMM; // YYYY-MM
@property (nonatomic, copy) NSString *V_MMDD; // MM-dd
@property (nonatomic, copy) NSString *V_MMDDHHMM; // MM-dd HH:mm
@property (nonatomic, copy) NSString *V_HHMM; // HH:mm
@property (nonatomic, copy) NSString *V_MM; // mm

@property (nonatomic, copy) NSAttributedString *V_Price;
@property (nonatomic, copy) NSAttributedString *V_MA;
@property (nonatomic, copy) NSAttributedString *V_EMA;
@property (nonatomic, copy) NSAttributedString *V_BOLL;
@property (nonatomic, copy) NSAttributedString *V_Volume;
@property (nonatomic, copy) NSAttributedString *V_MACD;
@property (nonatomic, copy) NSAttributedString *V_KDJ;
@property (nonatomic, copy) NSAttributedString *V_WR;
@property (nonatomic, copy) NSAttributedString *V_RSI;



@end

NS_ASSUME_NONNULL_END
