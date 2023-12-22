//
//  FSStockListCellCell.h
//  FSStockComponets_Example
//
//  Created by 张忠燕 on 2023/12/22.
//  Copyright © 2023 张忠燕. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FSStockComponets/JMQuotationListView.h>

NS_ASSUME_NONNULL_BEGIN

@interface FSStockListCell : UITableViewCell

@property (nonatomic, strong) JMQuotationListView *quotationListView;

@end

NS_ASSUME_NONNULL_END
