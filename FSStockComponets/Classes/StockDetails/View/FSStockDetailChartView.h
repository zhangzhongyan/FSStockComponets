//
//  FSStockDetailChartView.h
//  JMQuotesComponets_Example
//
//  Created by fargowealth on 2023/5/30.
//  Copyright © 2023 liyunlong1512. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSStockDetailDefine.h"
#import "FSStockDetailChartViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FSStockDetailChartViewDelegate <NSObject>

/**
 *  K线时间选择回调
 *  index: 时间周期
 */
- (void)KLineTimeSelectionWithIndex:(NSInteger)index;

/**
 *  K线权重选择回调
 *  type: 权重 F: 前复权 B: 后复权 N: 除权
 */
- (void)KLineWeightsSelectionWithType:(NSString *)type;

@end

@interface FSStockDetailChartView : UIView

/** 数据源 */
@property (nonatomic, strong) NSDictionary *dataSource;

@property (nonatomic, weak) id<FSStockDetailChartViewDelegate> delegate;

/** 是否展开 */
@property(nonatomic, assign) BOOL isExpand;

/** 是否关闭延时提示 */
@property(nonatomic, assign) BOOL isClosePrompt;

/** 高度 */
@property(nonatomic, assign) CGFloat originY;

@end

NS_ASSUME_NONNULL_END
