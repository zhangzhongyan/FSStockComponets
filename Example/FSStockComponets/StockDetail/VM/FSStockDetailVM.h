//
//  FSStockDetailVM.h
//  FSStockComponets_Example
//
//  Created by 张忠燕 on 2023/12/26.
//  Copyright © 2023 张忠燕. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FSStockComponets/JMQuotationListModel.h>
#import "FSStockDetailToolBarVM.h"

NS_ASSUME_NONNULL_BEGIN

// K线图类型
typedef NS_ENUM(NSInteger, EVKLineChartType) {
    /** 盘前 */
    EVKLineChartTypeBefore = 0,
    /** 盘后 */
    EVKLineChartTypeAfter,
    /** 盘中 */
    EVKLineChartTypeBetween,
    /** 分时 */
    EVKLineChartTypeMinuteHour,
    /** 五日 */
    EVKLineChartTypeFiveDay,
    /** 日K */
    EVKLineChartTypeDayK,
    /** 周K */
    EVKLineChartTypeWeekK,
    /** 月K */
    EVKLineChartTypeMonthK,
    /** 年K */
    EVKLineChartTypeYearK,
    /** 1分 */
    EVKLineChartTypeOneMinute,
    /** 5分 */
    EVKLineChartTypefiveMinute,
    /** 15分 */
    EVKLineChartTypefifteenMinute,
    /** 30分 */
    EVKLineChartTypethirtyMinute,
    /** 60分 */
    EVKLineChartTypesixtyMinute,
};

// K线图类型
typedef NS_ENUM(NSInteger, EVKLineWeightType) {
    /** F: 前复权  */
    EVKLineWeightTypeFront = 0,
    /** B: 后复权 */
    EVKLineWeightTypeBack,
    /**  N: 除权 */
    EVKLineWeightTypeNote,
};

@interface FSStockDetailVM : NSObject

@property (nonatomic, assign) BOOL allowLoadMore;

@property (nonatomic, assign) EVKLineChartType kLineChartType;

@property (nonatomic, assign) EVKLineWeightType kLineWeightType;

@property (nonatomic, strong) JMQuotationListModel *stockModel;

@property (nonatomic, strong) FSStockDetailToolBarVM *toolBarVM;

- (instancetype)initWithStockModel:(JMQuotationListModel *)stockModel kLineChartType:(EVKLineChartType)kLineChartType kLineWeightType:(EVKLineWeightType)kLineWeightType;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

- (NSDictionary *)handicapJson;

- (NSDictionary *)kLineJson;

- (BOOL)canHandleHoldingView;

@end

NS_ASSUME_NONNULL_END
