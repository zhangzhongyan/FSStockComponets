//
//  JMIndicatorView.h
//  ghchat
//
//  Created by 李云龙 on 2021/10/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 指示器view
@interface JMIndicatorView : UIView

/**
 * 选择指标
 */
@property (nonatomic, copy) void(^SelectionIndicatorsBlock)(NSString *title, NSInteger idx);

@end

NS_ASSUME_NONNULL_END
