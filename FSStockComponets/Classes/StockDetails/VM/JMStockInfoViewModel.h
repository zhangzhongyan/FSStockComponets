//
//  JMStockInfoViewModel.h
//  JMQuotesComponets
//
//  Created by fargowealth on 2023/5/31.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JMStockInfoModel.h"
#import "QuotationConstant.h"

NS_ASSUME_NONNULL_BEGIN

@interface JMStockInfoViewModel : NSObject

/** 价格 */
@property (nonatomic, copy) NSString *price;

/** 价格颜色 */
@property (nonatomic, strong) UIColor *priceColor;

/** 涨跌额 */
@property (nonatomic, copy) NSString *change;

/** 涨跌额颜色 */
@property (nonatomic, strong) UIColor *changeColor;

/** 涨跌幅 */
@property (nonatomic, copy) NSString *changePct;

/** 涨跌幅颜色 */
@property (nonatomic, strong) UIColor *changePctColor;

/** 交易状态 */
@property (nonatomic, copy) NSString *tradingStatus;

/** 盘口信息标题 */
@property (nonatomic, strong) NSArray *handicapInfoList;

/** 股票类型 */
@property(nonatomic, assign) StockMarketType  stockMarketType;

//初始化方法
- (instancetype)initWithModel:(JMStockInfoModel *)model;

@end

/// 中间层view
@interface FSStockDetailChartViewModel : NSObject

/** 股票代码 */
@property (nonatomic, copy) NSString *assetID;

/** K线图类型 */
@property(nonatomic, assign) NSInteger chatType;

/** 收盘价 */
@property (nonatomic, strong) NSNumber *close;

/** 是否收盘 */
@property(nonatomic, assign) BOOL isClose;

/** 市场类型 */
@property (nonatomic, copy) NSString *marketType;

/** 价格 */
@property (nonatomic, strong) NSNumber *price;

/** 分时数据 */
@property(nonatomic, strong) NSArray<JMTimeChartModel *> *timeChartModels;

+ (instancetype) objectWithTimeArray:(NSArray *)arr;

@end

NS_ASSUME_NONNULL_END
