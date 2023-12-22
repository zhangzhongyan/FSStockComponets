//
//  JMLineChartView.h
//  JMQuotesComponets_Example
//
//  Created by fargowealth on 2023/5/30.
//  Copyright © 2023 liyunlong1512. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YYKlineConstant.h"
#import "QuotationConstant.h"

NS_ASSUME_NONNULL_BEGIN

/// 分时图/五日图
@interface JMLineChartView : UIView

/** 数据 */
@property(nonatomic, strong) YYKlineRootModel *rootModel;

@property (nonatomic) Class <YYPainterProtocol> linePainter;

@property (nonatomic) Class <YYPainterProtocol> indicator1Painter;

/** 主图类型 */
@property (nonatomic, assign) KlineType centerViewType;

/** 收盘价 */
@property (nonatomic, assign) CGFloat close;

/** 现价 */
@property (nonatomic, assign) CGFloat price;

/** 分时线需要传总共多少个点 */
@property (nonatomic, assign) CGFloat pointCount;

/** 对方传过来的图表标识 */
@property (nonatomic, assign) NSInteger chartType;

/** 重绘 */
- (void)reDraw;

@end

NS_ASSUME_NONNULL_END
