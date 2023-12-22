//
//  JMKlineRootModel.h
//  ghchat
//
//  Created by fargowealth on 2021/10/26.
//

#import <Foundation/Foundation.h>
#import <math.h>
#import "JMKlineModel.h"

typedef NS_ENUM(NSInteger, JMKlineIncicator) {
    JMKlineIncicatorMA = 100,        // MA线
    JMKlineIncicatorEMA,        // EMA线
    JMKlineIncicatorBOLL,       // BOLL线
    JMKlineIncicatorMACD = 104,   //MACD线
    JMKlineIncicatorKDJ,        // KDJ线
    JMKlineIncicatorRSI,         // RSI
    JMKlineIncicatorWR,         // WR
    
};

NS_ASSUME_NONNULL_BEGIN

@interface JMKlineRootModel : NSObject

/**
 * 烛图数据
 */
+ (instancetype) objectWithArray:(NSArray *)arr;

/**
 * 分时数据
 * arr                        数据源
 * closingPrice         收盘价
 */
+ (instancetype) objectTimeSharWithArray:(NSArray *)arr
                            ClosingPrice:(NSNumber *)closingPrice;

@property (nonatomic, copy) NSArray<JMKlineModel *> *models;

- (void)calculateIndicators:(JMKlineIncicator)key;

- (void)calculateNeedDrawTimeModel;

-(void)appendData:(NSArray *)arr;

@end

NS_ASSUME_NONNULL_END
