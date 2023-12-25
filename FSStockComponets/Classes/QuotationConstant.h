//
//  QuotationConstant.h
//  JMQuotesComponets_Example
//
//  Created by fargowealth on 2023/5/29.
//  Copyright © 2023 liyunlong1512. All rights reserved.
//

#ifndef QuotationConstant_h
#define QuotationConstant_h

#pragma mark - 头文件

#import <Masonry/Masonry.h>
#import <YYCategories/YYCategories.h>
#import "UIColor+JMColor.h"

#pragma mark - 设备相关

// 类型相关
#define kIS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define kIS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define kIS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

// 屏幕尺寸相关
#define kSCREEN_WIDTH  ([[UIScreen mainScreen] bounds].size.width)
#define kSCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define kSCREEN_BOUNDS ([[UIScreen mainScreen] bounds])
#define kSCREEN_MAX_LENGTH (MAX(kSCREEN_WIDTH, kSCREEN_HEIGHT))
#define kSCREEN_MIN_LENGTH (MIN(kSCREEN_WIDTH, kSCREEN_HEIGHT))

// 手机类型相关
#define kIS_IPHONE_4_OR_LESS  (kIS_IPHONE && kSCREEN_MAX_LENGTH  < 568.0)
#define kIS_IPHONE_5          (kIS_IPHONE && kSCREEN_MAX_LENGTH == 568.0)
#define kIS_IPHONE_6          (kIS_IPHONE && kSCREEN_MAX_LENGTH == 667.0)
#define kIS_IPHONE_6P         (kIS_IPHONE && kSCREEN_MAX_LENGTH == 736.0)
//#define kIS_IPHONE_X          (kIS_IPHONE && kSCREEN_MAX_LENGTH == 812.0)
#define kIS_IPHONE_X          (kSCREEN_WIDTH >= 375.0f && kSCREEN_HEIGHT >= 812.0f && kIS_IPHONE)
//#define kIS_IPHONE_X          (kSCREEN_WIDTH >= 375.0f && kSCREEN_HEIGHT >= 812.0f)

/*状态栏高度*/
#define kStatusBarHeight (CGFloat)(kIS_IPHONE_X ? (44.0) : (20.0))

/*导航栏高度*/
#define kNavBarHeight (44)

/*状态栏和导航栏总高度*/
#define kNavBarAndStatusBarHeight (CGFloat)(kIS_IPHONE_X ? (88.0) : (64.0))

/*TabBar高度*/
#define kTabBarHeight (CGFloat)(kIS_IPHONE_X ? (49.0 + 34.0) : (49.0))

/*顶部安全区域远离高度*/
#define kTopBarSafeHeight (CGFloat)(kIS_IPHONE_X ? (44.0) : (0))

 /*底部安全区域远离高度*/
#define kBottomSafeHeight (CGFloat)(kIS_IPHONE_X ? (34.0) : (0))

/*iPhoneX的状态栏高度差值*/
#define kTopBarDifHeight (CGFloat)(kIS_IPHONE_X ? (24.0) : (0))

/*导航条和Tabbar总高度*/
#define kNavAndTabHeight (kNavBarAndStatusBarHeight + kTabBarHeight)

/*底部安全区域远离和TabBar总高度*/
#define kTabBarAndBottomSafeHeight (kTabBarHeight + kBottomSafeHeight)

/** 宽系数 */
#define kWidthScale(length) (kSCREEN_WIDTH / 375 * length)

/** 高系数 */
#define kHeightScale(length) (kSCREEN_HEIGHT / (kIS_IPHONE_X ? (812) : (667)) * length)


#pragma mark — 字体配置

#define kFont_Medium(x) [UIFont fontWithName:@"PingFangSC-Medium" size:kWidthScale(x)]
#define kFont_Semibold(x) [UIFont fontWithName:@"PingFangSC-Semibold" size:kWidthScale(x)]
#define kFont_Regular(x) [UIFont fontWithName:@"PingFangSC-Regular" size:kWidthScale(x)]

#pragma mark - 快捷方式

/** 设置图片 */
//#define kImageNamed(__imageName) [UIImage imageNamed:__imageName]

#define kBundle [NSBundle bundleForClass:self.class]
#define kImageNamed(name) [kBundle pathForResource:name ofType:nil inDirectory:@"FSStockComponets.bundle"]

/** 弱引用 */
#define WEAK_SELF(weakSelf)  __weak __typeof(self)weakSelf = self;

#pragma mark - 常量

//市场类型
typedef NS_ENUM(NSInteger, StockMarketType) {
    StockMarketType_HK             = 0, //港股
    StockMarketType_US,                 //美股
    StockMarketType_SH,                 //上证
    StockMarketType_SZ,                 //深证
};

//菜单类型
typedef NS_ENUM(NSInteger, PopMenuType) {
    PopMenuType_time             = 0, //时间
    PopMenuType_Weights,              //权重
};

// Kline种类
typedef NS_ENUM(NSInteger, KlineType) {
    KlineTypeKline = 1, //K线
    KlineTypeTimeLine,  //分时图
    KlineTypeIndicator, //指标
};


// K线图类型
typedef NS_ENUM(NSInteger, KLineChartType) {
    KLineChartTypeBefore = 0, //盘前
    KLineChartTypeAfter,      //盘后
    KLineChartTypeBetween,    //盘中
    KLineChartTypeMinuteHour, //分时
    KLineChartTypeFiveDay,    //五日
    KLineChartTypeDayK,       //日K
    KLineChartTypeWeekK,      //周K
    KLineChartTypeMonthK,     //月K
    KLineChartTypeYearK,      //年K
    KLineChartTypeOneMinute,  //1分
    KLineChartTypefiveMinute,  //5分
    KLineChartTypefifteenMinute,   //15分
    KLineChartTypethirtyMinute,    //30分
    KLineChartTypesixtyMinute,     //60分
};

#pragma mark — 通知名称配置

/** 获取更多数据 */
#define kNoticeName_GetMoreData @"JMGetMoreDataNotification"

/** 加载更多数据 */
#define kNoticeName_LoadMoreData @"JMLoadMoreDataNotification"

#endif /* QuotationConstant_h */
