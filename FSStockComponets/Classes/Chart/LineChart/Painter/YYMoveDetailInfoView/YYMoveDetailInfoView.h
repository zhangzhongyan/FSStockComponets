//
//  YYMoveDetailInfoView.h
//  ghchat
//
//  Created by fargowealth on 2021/10/28.
//

#import <UIKit/UIKit.h>
#import "YYKlineModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YYMoveDetailInfoView : UIView

/** 数据源 */
@property (nonatomic, copy) YYKlineModel *lineModel;

@end

NS_ASSUME_NONNULL_END
