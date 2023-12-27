//
//  FSStockDetailInfoViewModel.h
//  JMQuotesComponets
//
//  Created by fargowealth on 2023/5/31.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JMStockInfoModel.h"
#import "QuotationConstant.h"

NS_ASSUME_NONNULL_BEGIN

@interface FSStockDetailInfoViewModel : NSObject

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

NS_ASSUME_NONNULL_END
