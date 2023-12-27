//
//  FSStockDetailChartViewModel.h
//  FSStockComponets
//
//  Created by 张忠燕 on 2023/12/27.
//

#import <Foundation/Foundation.h>
#import "FSStockTimeChartModel.h"

NS_ASSUME_NONNULL_BEGIN

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
@property(nonatomic, strong) NSArray<FSStockTimeChartModel *> *timeChartModels;

+ (instancetype) objectWithTimeArray:(NSArray *)arr;

@end

NS_ASSUME_NONNULL_END
