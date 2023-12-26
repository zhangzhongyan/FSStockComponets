//
//  FSStockDetailCell.h
//  Fargo
//
//  Created by 张忠燕 on 2023/6/12.
//  Copyright © 2023 geekthings. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FSStockComponets/JMStockDetailsView.h>

NS_ASSUME_NONNULL_BEGIN

@interface FSStockDetailCell : UITableViewCell

@property (nonatomic, strong) JMStockDetailsView *stockDetailsView;

@end

NS_ASSUME_NONNULL_END
