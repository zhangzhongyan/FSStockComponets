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

- (instancetype)initWithStockModel:(JMQuotationListModel *)stockModel kLineChartType:(FSKLineChartType)kLineChartType kLineWeightType:(EVKLineWeightType)kLineWeightType
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

#pragma mark - Private Methods

- (void)setupData
{
    NSDictionary *jsonListDict = [FSStockDetailVM jsonObjectWithResource:@"handicapRespJson" type:@"json"];
    NSArray *result = [jsonListDict objectForKey:@"result"];
    self.handicapRespJson = [result.firstObject isKindOfClass:NSDictionary.class]? result.firstObject: @{};
    
    
    NSDictionary *kLineTimeShareRespJson = [FSStockDetailVM jsonObjectWithResource:@"kLineTimeShareRespJson" type:@"json"];
    self.kLineTimeShareRespJson = [kLineTimeShareRespJson isKindOfClass:NSDictionary.class]? kLineTimeShareRespJson: @{};

    NSDictionary *kLineFiveDaysRespJson = [FSStockDetailVM jsonObjectWithResource:@"kLineFiveDaysRespJson" type:@"json"];
    self.kLineFiveDaysRespJson = [kLineFiveDaysRespJson isKindOfClass:NSDictionary.class]? kLineFiveDaysRespJson: @{};
    
    NSDictionary *kLineDaysRespJson = [FSStockDetailVM jsonObjectWithResource:@"kLineDaysRespJson" type:@"json"];
    self.kLineFiveDaysRespJson = [kLineDaysRespJson isKindOfClass:NSDictionary.class]? kLineDaysRespJson: @{};

    NSDictionary *kLineWeeksRespJson = [FSStockDetailVM jsonObjectWithResource:@"kLineWeeksRespJson" type:@"json"];
    self.kLineWeeksRespJson = [kLineWeeksRespJson isKindOfClass:NSDictionary.class]? kLineWeeksRespJson: @{};
    
    NSDictionary *kLineMonthsRespJson = [FSStockDetailVM jsonObjectWithResource:@"kLineMonthsRespJson" type:@"json"];
    self.kLineMonthsRespJson = [kLineMonthsRespJson isKindOfClass:NSDictionary.class]? kLineMonthsRespJson: @{};

    NSDictionary *kLineYearsRespJson = [FSStockDetailVM jsonObjectWithResource:@"kLineYearsRespJson" type:@"json"];
    self.kLineYearsRespJson = [kLineYearsRespJson isKindOfClass:NSDictionary.class]? kLineYearsRespJson: @{};

    NSDictionary *kLineMinute1RespJson = [FSStockDetailVM jsonObjectWithResource:@"kLineMinute1RespJson" type:@"json"];
    self.kLineMinute1RespJson = [kLineMinute1RespJson isKindOfClass:NSDictionary.class]? kLineMinute1RespJson: @{};

    NSDictionary *kLineMinute5RespJson = [FSStockDetailVM jsonObjectWithResource:@"kLineMinute5RespJson" type:@"json"];
    self.kLineMinute5RespJson = [kLineMinute5RespJson isKindOfClass:NSDictionary.class]? kLineMinute5RespJson: @{};

    NSDictionary *kLineMinute15RespJson = [FSStockDetailVM jsonObjectWithResource:@"kLineMinute15RespJson" type:@"json"];
    self.kLineMinute15RespJson = [kLineMinute15RespJson isKindOfClass:NSDictionary.class]? kLineMinute15RespJson: @{};

    NSDictionary *kLineMinute30RespJson = [FSStockDetailVM jsonObjectWithResource:@"kLineMinute30RespJson" type:@"json"];
    self.kLineMinute30RespJson = [kLineMinute30RespJson isKindOfClass:NSDictionary.class]? kLineMinute30RespJson: @{};

    NSDictionary *kLineMinute60RespJson = [FSStockDetailVM jsonObjectWithResource:@"kLineMinute60RespJson" type:@"json"];
    self.kLineMinute60RespJson = [kLineMinute60RespJson isKindOfClass:NSDictionary.class]? kLineMinute60RespJson: @{};
}

+ (nullable id)jsonObjectWithResource:(NSString *)resource type:(NSString *)type
{
    // 获取 JSON 文件的路径
    NSString *path = [[NSBundle mainBundle] pathForResource:resource ofType:type];
    // 读取 JSON 文件数据
    NSData *data = [NSData dataWithContentsOfFile:path];
    // 将 JSON 数据转换为 Objective-C 对象
    NSError *error = nil;
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    return jsonObject;
}

#pragma mark - Public Methods

- (NSDictionary *)handicapJson
{
    return self.handicapRespJson ?: @{};
}

- (NSDictionary *)kLineJson
{
    switch (self.kLineChartType) {
        case FSKLineChartTypeBefore:
        case FSKLineChartTypeBetween:
        case FSKLineChartTypeAfter:
        case FSKLineChartTypeMinuteHour:
            return self.kLineTimeShareRespJson ?: @{};
        case FSKLineChartTypeFiveDay:
            return self.kLineFiveDaysRespJson ?: @{};
        case FSKLineChartTypeDayK:
            return self.kLineDaysRespJson ?: @{};
        case FSKLineChartTypeWeekK:
            return self.kLineWeeksRespJson ?: @{};
        case FSKLineChartTypeMonthK:
            return self.kLineMonthsRespJson?: @{};
        case FSKLineChartTypeYearK:
            return self.kLineYearsRespJson?: @{};
        case FSKLineChartTypeOneMinute:
            return self.kLineMinute1RespJson?: @{};
        case FSKLineChartTypefiveMinute:
            return self.kLineMinute5RespJson?: @{};
        case FSKLineChartTypefifteenMinute:
            return self.kLineMinute15RespJson?: @{};
        case FSKLineChartTypethirtyMinute:
            return self.kLineMinute30RespJson?: @{};
        case FSKLineChartTypesixtyMinute:
            return self.kLineMinute60RespJson?: @{};
    }
    
    return @{};
}


- (BOOL)canHandleHoldingView
{
    return self.containHolding;
}

- (NSString *)currentWeightText
{
    switch (self.kLineWeightType) {
        case EVKLineWeightTypeBack: {
            return @"B";
        }
        case EVKLineWeightTypeFront: {
            return @"F";
        }
        case EVKLineWeightTypeNote: {
            return @"N";
        }
    }
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
