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

@property (nonatomic, assign) BOOL containHolding;

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
        [self setupData];
    }
    return self;
}

- (void)setupData
{
    
}

#pragma mark - Public Methods

- (NSDictionary *)handicapJson
{
    return self.handicapRespJson ?: @{};
}

- (NSDictionary *)kLineJson
{
    switch (self.kLineChartType) {
        case EVKLineChartTypeBefore:
        case EVKLineChartTypeBetween:
        case EVKLineChartTypeAfter:
        case EVKLineChartTypeMinuteHour:
            return self.kLineTimeShareRespJson ?: @{};
        case EVKLineChartTypeFiveDay:
            return self.kLineFiveDaysRespJson ?: @{};
        case EVKLineChartTypeDayK:
            return self.kLineDaysRespJson ?: @{};
        case EVKLineChartTypeWeekK:
            return self.kLineWeeksRespJson ?: @{};
        case EVKLineChartTypeMonthK:
            return self.kLineMonthsRespJson?: @{};
        case EVKLineChartTypeYearK:
            return self.kLineYearsRespJson?: @{};
        case EVKLineChartTypeOneMinute:
            return self.kLineMinute1RespJson?: @{};
        case EVKLineChartTypefiveMinute:
            return self.kLineMinute5RespJson?: @{};
        case EVKLineChartTypefifteenMinute:
            return self.kLineMinute15RespJson?: @{};
        case EVKLineChartTypethirtyMinute:
            return self.kLineMinute30RespJson?: @{};
        case EVKLineChartTypesixtyMinute:
            return self.kLineMinute60RespJson?: @{};
    }
    
    return @{};
}


- (BOOL)canHandleHoldingView
{
    return self.containHolding;
}

#pragma mark - property

- (FSStockDetailToolBarVM *)toolBarVM {
    if (!_toolBarVM) {
        _toolBarVM = [[FSStockDetailToolBarVM alloc] init];
        _toolBarVM.enquiryRecord = YES;
        _toolBarVM.orderRecord = YES;
        _toolBarVM.addWatch = YES;
        _toolBarVM.enquiry = YES;
        _toolBarVM.order = YES;
    }
    return _toolBarVM;
}

@end
