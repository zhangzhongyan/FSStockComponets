//
//  FSStockDetailView.h
//  JMQuotesComponets_Example
//
//  Created by fargowealth on 2023/5/30.
//  Copyright © 2023 liyunlong1512. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSStockDetailDefine.h"
#import "FSStockDetailInfoViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FSStockDetailViewDelegate <NSObject>

/// k线类型
@property (readonly, nonatomic, assign, getter = theKLineChartType) FSKLineChartType kLineChartType;

/**
 *  K线时间选择回调
 *  index: 时间周期 0.盘前 1.盘中 2.盘后 3.分时 4.五日 5.日K 6.周K 7.月K 8.年K 9.1分 10.5分 11.15分 12.30分 13.60分
 *  type: 接口需要                                                           5.D 6.W 7.M 8.Y 9.Minute1 10.Minute5 11.Minute15 12.Minute30 13.Minute60
 */
- (void)KLineTimeSelectionWithIndex:(NSInteger)index
                               Type:(NSString *)type;

/**
 *  K线权重选择回调
 *  type: 权重 F: 前复权 B: 后复权 N: 除权
 */
- (void)KLineWeightsSelectionWithType:(NSString *)type;

/**
 *  获取更多K线数据
 *  timestamp:  时间戳
 */
- (void)GetMoreKLineDataWithTimestamp:(NSString *)timestamp;

@end

@interface FSStockDetailView : UIView

@property (nonatomic, weak) id<FSStockDetailViewDelegate> delegate;


/**
 *  初始化设置数据
 *  handicapJson 盘口数据
 *  kLineJson       K线数据
 *  chartType        K线tab类型  港股默认:3 美股默认:2
 */
- (void)setDataWithHandicapJson:(NSDictionary *)handicapJson
                      KLineJson:(NSDictionary *)kLineJson
                      ChartTyep:(NSInteger)chartType;

/**
 *  更新K线数据
 *  json            数据
 *  chartType   K线tab类型
 *  weights       复权类型
 *  more           是否数据加载更多
 */
- (void)updateKLineDataWithJson:(NSDictionary *)json
                      ChartTyep:(NSInteger)chartType
                        Weights:(NSString *)weights
                           More:(BOOL)more;

/**
 *  MQTT数据
 */
- (void)setMQTTDataWithJson:(NSDictionary *)json;

@end

NS_ASSUME_NONNULL_END
