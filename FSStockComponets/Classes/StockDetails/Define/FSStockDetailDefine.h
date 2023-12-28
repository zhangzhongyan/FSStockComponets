//
//  FSStockDetailDefine.h
//  FSStockComponets
//
//  Created by 张忠燕 on 2023/12/27.
//

#ifndef FSStockDetailDefine_h
#define FSStockDetailDefine_h

// K线图类型
typedef NS_ENUM(NSInteger, FSKLineChartType) {
    /** 盘前 */
    FSKLineChartTypeBefore = 0,
    /** 盘后 */
    FSKLineChartTypeAfter,
    /** 盘中 */
    FSKLineChartTypeBetween,
    /** 分时 */
    FSKLineChartTypeMinuteHour,
    /** 五日 */
    FSKLineChartTypeFiveDay,
    /** 日K */
    FSKLineChartTypeDayK,
    /** 周K */
    FSKLineChartTypeWeekK,
    /** 月K */
    FSKLineChartTypeMonthK,
    /** 年K */
    FSKLineChartTypeYearK,
    /** 1分 */
    FSKLineChartTypeOneMinute,
    /** 5分 */
    FSKLineChartTypefiveMinute,
    /** 15分 */
    FSKLineChartTypefifteenMinute,
    /** 30分 */
    FSKLineChartTypethirtyMinute,
    /** 60分 */
    FSKLineChartTypesixtyMinute,
};


// K线图类型
typedef NS_ENUM(NSInteger, FSKLineWeightType) {
    /** F: 前复权  */
    FSKLineWeightTypeFront = 0,
    /** B: 后复权 */
    FSKLineWeightTypeBack,
    /**  N: 除权 */
    FSKLineWeightTypeNote,
};

#endif /* FSStockDetailDefine_h */
