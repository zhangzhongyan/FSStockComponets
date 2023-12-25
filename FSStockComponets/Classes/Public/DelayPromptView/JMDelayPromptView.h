//
//  JMDelayPromptView.h
//  JMQuotesComponets_Example
//
//  Created by fargowealth on 2023/5/29.
//  Copyright © 2023 liyunlong1512. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DelayPromptViewDelegate <NSObject>

/** 关闭延时行情提示 */
- (void)closePrompt;

@end

@interface JMDelayPromptView : UIView

@property (nonatomic, weak) id<DelayPromptViewDelegate> delegate;

+ (CGFloat)viewHeight;

@end

NS_ASSUME_NONNULL_END
