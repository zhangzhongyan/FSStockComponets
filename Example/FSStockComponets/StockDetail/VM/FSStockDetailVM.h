//
//  FSStockDetailVM.h
//  FSStockComponets_Example
//
//  Created by 张忠燕 on 2023/12/26.
//  Copyright © 2023 张忠燕. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FSStockComponets/JMQuotationListModel.h>
#import "FSStockDetailToolBarVM.h"
#import <FSStockComponets/FSStockDetailDefine.h>

NS_ASSUME_NONNULL_BEGIN

@interface FSStockDetailVM : NSObject

@property (nonatomic, assign) BOOL allowLoadMore;

@property (nonatomic, assign) FSKLineChartType kLineChartType;

@property (nonatomic, assign) FSKLineWeightType kLineWeightType;

@property (nonatomic, strong) JMQuotationListModel *stockModel;

@property (nonatomic, strong) FSStockDetailToolBarVM *toolBarVM;

- (instancetype)initWithStockModel:(JMQuotationListModel *)stockModel kLineChartType:(FSKLineChartType)kLineChartType kLineWeightType:(FSKLineWeightType)kLineWeightType;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

- (NSDictionary *)handicapJson;

- (NSDictionary *)kLineJson;

- (BOOL)canHandleHoldingView;

- (NSString *)currentWeightText;

@end

NS_ASSUME_NONNULL_END
