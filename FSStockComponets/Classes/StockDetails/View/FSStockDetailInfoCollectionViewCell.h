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

typedef NS_ENUM(NSInteger, FSStockDetailInfoCellType) {
    /** 中文款式 */
    FSStockDetailInfoCellTypeChina = 0,
    /** 英文款式 */
    FSStockDetailInfoCellTypeEnglish,
};

@interface FSStockDetailInfoCollectionViewCell : UICollectionViewCell

- (void)setContentWithModel:(FSStockDetailInfoModel *)model indexPath:(NSIndexPath *)indexPath type:(FSStockDetailInfoCellType)type;

+ (NSInteger)columnsCount;

@end

NS_ASSUME_NONNULL_END
