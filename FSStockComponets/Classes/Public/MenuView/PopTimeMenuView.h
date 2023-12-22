//
//  PopTimeMenuView.h
//  JMQuotesComponets
//
//  Created by fargowealth on 2023/7/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PopTimeMenuViewDelegate <NSObject>

/**
 *  K线时间选择回调
 *  index: 时间周期
 *  标题
 */
- (void)popTimeMenuViewTimeSelectionWithIndex:(NSInteger)index
                                        Title:(NSString *)title;

/**
 *  K线权重选择回调
 *  type: 权重 F: 前复权 B: 后复权 N: 除权
 */
- (void)popTimeMenuViewWeightsSelectionWithIndex:(NSInteger)index
                                           Title:(NSString *)title;

@end

@interface PopTimeMenuView : UIView

/**
 * 类型
 * 0. 时间
 * 1. 复权
 */
@property(nonatomic, assign) NSInteger type;

/** 选中title */
@property (nonatomic, strong) NSString *selectionTitle;

@property (nonatomic, weak) id<PopTimeMenuViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
