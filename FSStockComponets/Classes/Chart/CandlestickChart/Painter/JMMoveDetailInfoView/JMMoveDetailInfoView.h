//
//  JMMoveDetailInfoView.h
//  ghchat
//
//  Created by fargowealth on 2021/10/26.
//

#import <UIKit/UIKit.h>
#import "JMKlineModel.h"
#import "QuotationConstant.h"

NS_ASSUME_NONNULL_BEGIN

// 移动详细信息view
@interface JMMoveDetailInfoView : UIView

/** K线类型 */
@property (nonatomic, assign) KLineChartType chartType;

/** 数据源 */
@property (nonatomic, copy) JMKlineModel *lineModel;

@end

NS_ASSUME_NONNULL_END
