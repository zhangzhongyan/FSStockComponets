//
//  FSStockDetailVM.m
//  FSStockComponets_Example
//
//  Created by 张忠燕 on 2023/12/26.
//  Copyright © 2023 张忠燕. All rights reserved.
//

#import "FSStockDetailVM.h"

@interface FSStockDetailVM ()

@property (nonatomic, strong, nullable) NSDictionary *handicapRespJson;

@property (nonatomic, strong, nullable) NSDictionary *kLineTimeShareRespJson;

@property (nonatomic, strong, nullable) NSDictionary *kLineFiveDaysRespJson;

@property (nonatomic, strong, nullable) NSDictionary *kLineDaysRespJson;
@property (nonatomic, strong, nullable) NSDictionary *kLineWeeksRespJson;
@property (nonatomic, strong, nullable) NSDictionary *kLineMonthsRespJson;
@property (nonatomic, strong, nullable) NSDictionary *kLineYearsRespJson;
@property (nonatomic, strong, nullable) NSDictionary *kLineMinute1RespJson;
@property (nonatomic, strong, nullable) NSDictionary *kLineMinute5RespJson;
@property (nonatomic, strong, nullable) NSDictionary *kLineMinute15RespJson;
@property (nonatomic, strong, nullable) NSDictionary *kLineMinute30RespJson;
@property (nonatomic, strong, nullable) NSDictionary *kLineMinute60RespJson;

@end

@implementation FSStockDetailVM

#pragma mark - Initialize Methods

- (instancetype)initWithStockModel:(JMQuotationListModel *)stockModel kLineChartType:(EVKLineChartType)kLineChartType kLineWeightType:(EVKLineWeightType)kLineWeightType
{
    self = [super init];
    if (self) {
        _stockModel = stockModel;
        _kLineChartType = kLineChartType;
        _kLineWeightType = kLineWeightType;
    }
    return self;
}


@end
