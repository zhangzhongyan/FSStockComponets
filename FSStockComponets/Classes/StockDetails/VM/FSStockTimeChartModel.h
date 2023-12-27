//
//  FSStockTimeChartModel.h
//  FSStockComponets
//
//  Created by 张忠燕 on 2023/12/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 分时数据Model
@interface FSStockTimeChartModel : NSObject

/** 索引 */
@property(nonatomic, assign) NSInteger index;
/** 资产ID */
@property (nonatomic, strong) NSString *assetID;
/** 推送时间 */
@property (nonatomic, strong) NSNumber *pushTime;
/** 现价 */
@property (nonatomic, strong) NSNumber *currentPrice;
/** 均价 */
@property (nonatomic, strong) NSNumber *averagePrice;
/** 昨收价 */
@property (nonatomic, strong) NSNumber *yesterdayClosePrice;
/** 分钟成交量 */
@property (nonatomic, strong) NSNumber *minuteVolume;
/** 分钟成交额 */
@property (nonatomic, strong) NSNumber *minuteTurnover;
/** 是否加入到5日分时 */
@property (nonatomic, assign) BOOL addTo5DaysTimeSharing;
/** 今开 */
@property (nonatomic, strong) NSNumber *todayOpenPrice;


@end

NS_ASSUME_NONNULL_END
