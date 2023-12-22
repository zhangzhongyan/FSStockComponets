//
//  JMHandicapInfoCollectionViewCell.h
//  JMQuotesComponets_Example
//
//  Created by fargowealth on 2023/5/30.
//  Copyright © 2023 liyunlong1512. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMStockInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JMHandicapInfoCollectionViewCell : UICollectionViewCell

/** 盘口信息 */
@property (nonatomic, strong) JMStockInfoModel *model;

@end

NS_ASSUME_NONNULL_END
