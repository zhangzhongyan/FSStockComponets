//
//  FSStockDetailInfoModel.h
//  FSStockComponets
//
//  Created by 张忠燕 on 2023/12/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 股票信息Model
@interface FSStockDetailInfoModel : NSObject

/** 标题 */
@property (nonatomic, copy) NSString *titleStr;

/** 描述 */
@property (nonatomic, copy) NSString *describeStr;

/** 内容 */
@property (nonatomic, copy) NSString *contentStr;

/** 颜色 */
@property (nonatomic, strong) UIColor *myColor;

/** 股票代码 */
@property (nonatomic, copy) NSString *assetId;
/** 股票名称 */
@property (nonatomic, copy) NSString *name;
/** 现价 */
@property (nonatomic, copy) NSString *price;
/** 涨跌额 */
@property (nonatomic, copy) NSString *change;
/** 开盘价 */
@property (nonatomic, copy) NSString *open;
/** 昨收价 */
@property (nonatomic, copy) NSString *preClose;
/** 最高价 */
@property (nonatomic, copy) NSString *high;
/** 最低价 */
@property (nonatomic, copy) NSString *low;
/** 成交量 */
@property (nonatomic, copy) NSString *volume;
/** 成交额 */
@property (nonatomic, copy) NSString *turnover;
/** 涨跌幅 */
@property (nonatomic, copy) NSString *changePct;
/** 市盈率 ttm */
@property (nonatomic, copy) NSString *ttmPe;
/** 市盈(静) */
@property (nonatomic, copy) NSString *pe;
/** 52周高 */
@property (nonatomic, copy) NSString *week52High;
/** 52周低 */
@property (nonatomic, copy) NSString *week52Low;
/** <#注释#> */
@property (nonatomic, copy) NSString *hisHigh;
/** <#注释#> */
@property (nonatomic, copy) NSString *hisLow;
/** 均价 */
@property (nonatomic, copy) NSString *avgPrice;
/** 换手率 */
@property (nonatomic, copy) NSString *turnRate;
/** 市净率 */
@property (nonatomic, copy) NSString *pb;
/** 量比 */
@property (nonatomic, copy) NSString *volRate;
/** <#注释#> */
@property (nonatomic, copy) NSString *commitTee;
/** 收益 */
@property (nonatomic, copy) NSString *epsp;
/** 总市值 */
@property (nonatomic, copy) NSString *totalVal;
/** 振幅 */
@property (nonatomic, copy) NSString *ampLiTude;
/** 流通股本 */
@property (nonatomic, copy) NSString *flshr;
/** 总股本 */
@property (nonatomic, copy) NSString *total;
/** 交易状态 */
@property(nonatomic, assign) NSInteger status;
/** 时间戳 */
@property (nonatomic, copy) NSString *ts;
/** 每手 */
@property (nonatomic, copy) NSString *lotSize;
/** <#注释#> */
@property (nonatomic, copy) NSString *bid1;
/** <#注释#> */
@property (nonatomic, copy) NSString *bidQty1;
/** <#注释#> */
@property (nonatomic, copy) NSString *ask1;
/** <#注释#> */
@property (nonatomic, copy) NSString *askQty1;
/** 股息 */
@property (nonatomic, copy) NSString *ttmDps;
/** 股息率 */
@property (nonatomic, copy) NSString *dpsRate;
/** <#注释#> */
@property(nonatomic, assign) BOOL isShortSell;
/** <#注释#> */
@property (nonatomic, copy) NSString *type;
/** <#注释#> */
@property (nonatomic, copy) NSString *brokerQueue;
/** 流通市值 */
@property (nonatomic, copy) NSString *fmktVal;

/** 市场类型 */
@property (nonatomic, copy) NSString *marketType;

/** 美股全天交易状态，166, 返回格式数组1|0|0,依次顺序是盘前，盘后，盘中的状态，其中1表示交易中，0表示非交易时间 */
@property (nonatomic, copy) NSString *usTradeStatus;

/** 盘中状态值: 盘前0 盘后1 盘中2 */
@property(nonatomic, copy) NSString *threeMarketStatus;

@end

NS_ASSUME_NONNULL_END
