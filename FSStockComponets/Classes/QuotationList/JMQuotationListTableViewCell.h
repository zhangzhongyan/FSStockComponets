//
//  JMQuotationListTableViewCell.h
//  JMQuotesComponets_Example
//
//  Created by fargowealth on 2023/5/29.
//  Copyright © 2023 liyunlong1512. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMQuotationListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JMQuotationListTableViewCell : UITableViewCell

/** 股票信息 */
@property (nonatomic,strong) JMQuotationListModel *quotationListModel;

@end

NS_ASSUME_NONNULL_END
