//
//  JMQuotationListModel.h
//  JMQuotesComponets_Example
//
//  Created by fargowealth on 2023/5/29.
//  Copyright © 2023 liyunlong1512. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuotationConstant.h"

NS_ASSUME_NONNULL_BEGIN

@interface JMQuotationListModel : NSObject

/** 股票名称 */
@property (nonatomic, copy) NSString *name;

/** 股票代码 */
@property (nonatomic, copy) NSString *assetId;

/** 现价 */
@property (nonatomic, copy) NSString *price;

/** 涨跌幅 */
@property (nonatomic, copy) NSString *changePct;

/** 涨跌额 */
@property (nonatomic, copy) NSString *change;

/** 股票类型 */
@property(nonatomic, assign) StockMarketType  stockMarketType;

@end

NS_ASSUME_NONNULL_END
