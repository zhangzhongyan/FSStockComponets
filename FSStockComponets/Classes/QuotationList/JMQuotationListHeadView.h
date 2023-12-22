//
//  JMQuotationListHeadView.h
//  JMQuotesComponets_Example
//
//  Created by fargowealth on 2023/5/29.
//  Copyright © 2023 liyunlong1512. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol QuotationListHeadViewDelegate <NSObject>

/** 分类选择下标 */
- (void)quotationListHeadViewWithSelectionIndex:(NSInteger)index;

@end

@interface JMQuotationListHeadView : UIView

@property (nonatomic, weak) id<QuotationListHeadViewDelegate> delegate;

/** 这种选中Tab */
- (void)setSelectionTabIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
