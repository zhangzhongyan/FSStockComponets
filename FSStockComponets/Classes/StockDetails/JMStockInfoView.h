//
//  JMStockInfoView.h
//  JMQuotesComponets_Example
//
//  Created by fargowealth on 2023/5/30.
//  Copyright © 2023 liyunlong1512. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMStockInfoViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol StockInfoViewDelegate <NSObject>

/**
 * 是否展开
 */
- (void)setIsExpand:(BOOL)isExpand;

@end


@interface JMStockInfoView : UIView

/** 盘口信息 */
@property (nonatomic, strong) JMStockInfoViewModel *stockInfoViewModel;

@property (nonatomic, weak) id<StockInfoViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
