//
//  JMCandlestickChartView.h
//  JMQuotesComponets_Example
//
//  Created by fargowealth on 2023/5/30.
//  Copyright © 2023 liyunlong1512. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JMKlineConstant.h"

NS_ASSUME_NONNULL_BEGIN

/// 烛图
@interface JMCandlestickChartView : UIView

/** 数据 */
@property(nonatomic, strong) JMKlineRootModel *rootModel;

@property (nonatomic) Class <JMPainterProtocol> linePainter;
@property (nonatomic) Class <JMPainterProtocol> indicator1Painter;

/** 当前价格 */
@property (nonatomic, assign) CGFloat currentPrice;

/** K线图类型 */
@property (nonatomic, assign) KLineChartType kLineChartType;

/** 是否更新数据(切换K线类型) */
@property (nonatomic, assign) BOOL isInitialization;

/** 加载更多loading */
@property(nonatomic,assign) BOOL reloading;

/** 是否暂停 */
@property (nonatomic, assign) BOOL isSuspend;

/** 重绘 */
- (void)reDraw;

@end

NS_ASSUME_NONNULL_END
