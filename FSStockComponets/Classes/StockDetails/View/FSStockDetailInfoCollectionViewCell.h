//
//  FSStockDetailInfoCollectionViewCell.h
//  JMQuotesComponets_Example
//
//  Created by fargowealth on 2023/5/30.
//  Copyright © 2023 liyunlong1512. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSStockDetailInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FSStockDetailInfoCollectionViewCell : UICollectionViewCell

- (void)setContentWithModel:(FSStockDetailInfoModel *)model indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
