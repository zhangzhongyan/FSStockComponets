//
//  Y-KlineGroupModel.m
//  YYKline
//
//  Copyright © 2016年 WillkYang. All rights reserved.
//

#import "YYKlineRootModel.h"
#import "YYKlineGlobalVariable.h"

@implementation YYKlineRootModel
+ (instancetype) objectWithArray:(NSArray *)arr {
    NSAssert([arr isKindOfClass:[NSArray class]], @"arr不是一个数组，请检查返回数据类型并手动适配");
    YYKlineRootModel *groupModel = [YYKlineRootModel new];
    NSMutableArray *mArr = @[].mutableCopy;
    NSInteger index = 0;
    for (NSInteger i = [arr count]-1; i>=0; i--) {
        NSArray *item = arr[i];
        YYKlineModel *model = [YYKlineModel new];
        model.index = index;
        model.Timestamp = item[5];
        model.Open = item[0];
        model.High = item[2];
        model.Low = item[3];
        model.Close = item[1];
        model.Volume = item[4];
        model.PrevModel = mArr.lastObject;
        [mArr addObject:model];
        index++;
    }
    groupModel.models = mArr;
    [groupModel calculateIndicators:YYKlineIncicatorMACD];
    [groupModel calculateIndicators:YYKlineIncicatorMA];
    [groupModel calculateIndicators:YYKlineIncicatorKDJ];
    [groupModel calculateIndicators:YYKlineIncicatorRSI];
    [groupModel calculateIndicators:YYKlineIncicatorBOLL];
    [groupModel calculateIndicators:YYKlineIncicatorWR];
    [groupModel calculateIndicators:YYKlineIncicatorEMA];
    [groupModel calculateNeedDrawTimeModel];
    return groupModel;
}
/*
 (
 1660613700000, 时间
 "11.100", 最新价
 "11.100", 均价
 4200, 成交量
 "46658.000", 成交额
 "11.040" 今开
),
 */
+ (instancetype) objectWithTimeArray:(NSArray *)arr close:(NSNumber*)close {
    NSAssert([arr isKindOfClass:[NSArray class]], @"arr不是一个数组，请检查返回数据类型并手动适配");
    YYKlineRootModel *groupModel = [YYKlineRootModel new];
    NSMutableArray *mArr = @[].mutableCopy;
    NSInteger index = 0;
    for (NSInteger i = [arr count]-1; i>=0; i--) {
        NSArray *item = arr[i];
        YYKlineModel *model = [YYKlineModel new];
        model.index = index;
        model.Timestamp = @([item[0] doubleValue]/1000);
        model.Open = item[1];
        model.High = item[1];
        model.Low = item[1];
        model.Close = close;
        model.Volume = item[3];
//        model.Turnover = item[4];
        // 成交额
        NSString *turnoverStr = item[4];
        model.Turnover = [turnoverStr isEqualToString:@""] ? @(0.00) : item[4];
        model.avgPrice = item[2];
        model.PrevModel = mArr.lastObject;
        [mArr addObject:model];
        index++;
    }
    groupModel.models = mArr;
    [groupModel calculateIndicators:YYKlineIncicatorMACD];
    [groupModel calculateIndicators:YYKlineIncicatorMA];
    [groupModel calculateIndicators:YYKlineIncicatorKDJ];
    [groupModel calculateIndicators:YYKlineIncicatorRSI];
    [groupModel calculateIndicators:YYKlineIncicatorBOLL];
    [groupModel calculateIndicators:YYKlineIncicatorWR];
    [groupModel calculateIndicators:YYKlineIncicatorEMA];
    [groupModel calculateNeedDrawTimeModel];
    return groupModel;
}

+ (instancetype) objectWithDataArray:(NSArray *)arr {
    NSAssert([arr isKindOfClass:[NSArray class]], @"arr不是一个数组，请检查返回数据类型并手动适配");
    YYKlineRootModel *groupModel = [YYKlineRootModel new];
    NSMutableArray *mArr = @[].mutableCopy;
    NSInteger index = 0;
    for (NSInteger i = [arr count]-1; i>=0; i--) {
        NSArray *item = arr[i];
        YYKlineModel *model = [YYKlineModel new];
        model.index = index;
        model.Timestamp = @([item[0] doubleValue]/1000);
        model.Open = item[1];
        model.High = item[2];
        model.Low = item[3];
        model.Close = item[4];
        model.Volume = item[6];
        model.PrevModel = mArr.lastObject;
        [mArr addObject:model];
        index++;
    }
    groupModel.models = mArr;
    [groupModel calculateIndicators:YYKlineIncicatorMACD];
    [groupModel calculateIndicators:YYKlineIncicatorMA];
    [groupModel calculateIndicators:YYKlineIncicatorKDJ];
    [groupModel calculateIndicators:YYKlineIncicatorRSI];
    [groupModel calculateIndicators:YYKlineIncicatorBOLL];
    [groupModel calculateIndicators:YYKlineIncicatorWR];
    [groupModel calculateIndicators:YYKlineIncicatorEMA];
    [groupModel calculateNeedDrawTimeModel];
    return groupModel;
}

-(void)appendData:(NSArray *)arr{
    NSAssert([arr isKindOfClass:[NSArray class]], @"arr不是一个数组，请检查返回数据类型并手动适配");
    NSMutableArray *mArr = @[].mutableCopy;
    NSInteger index = 0;
    for (NSInteger i = [arr count]-1; i>=0; i--) {
        NSArray *item = arr[i];
        YYKlineModel *model = [YYKlineModel new];
        model.index = index;
        model.Timestamp = @([item[0] doubleValue]/1000);
        model.Open = item[1];
        model.High = item[2];
        model.Low = item[3];
        model.Close = item[4];
        model.Volume = item[6];
        model.PrevModel = mArr.lastObject;
        [mArr addObject:model];
        index++;
    }
    for (YYKlineModel* tempmodle in self.models) {
        tempmodle.index = index;
        index++;
    }
    [mArr addObjectsFromArray:self.models];
 
    self.models = mArr;
    [self calculateIndicators:YYKlineIncicatorMACD];
    [self calculateIndicators:YYKlineIncicatorMA];
    [self calculateIndicators:YYKlineIncicatorKDJ];
    [self calculateIndicators:YYKlineIncicatorRSI];
    [self calculateIndicators:YYKlineIncicatorBOLL];
    [self calculateIndicators:YYKlineIncicatorWR];
    [self calculateIndicators:YYKlineIncicatorEMA];
    [self calculateNeedDrawTimeModel];
}

- (void)calculateNeedDrawTimeModel {
    NSInteger gap = 50 / [YYKlineGlobalVariable kLineWidth] + [YYKlineGlobalVariable kLineGap];
    for (int i = 1; i < self.models.count; i++) {
        self.models[i].isDrawTime = i % gap == 0;
    }
}

- (void)calculateIndicators:(YYKlineIncicator)key {
    switch (key) {
        case YYKlineIncicatorMA:
            [YYMAModel calMAWithData:self.models params:@[@"10",@"30",@"60",@"5",@"20"]];
            break;
        case YYKlineIncicatorMACD:
            [YYMACDModel calMACDWithData:self.models params:@[@"12",@"26",@"9"]];
            break;
        case YYKlineIncicatorKDJ:
            [YYKDJModel calKDJWithData:self.models params:@[@"9",@"3",@"3"]];
            break;
        case YYKlineIncicatorRSI:
            [YYRSIModel calRSIWithData:self.models params:@[@"6",@"12",@"24"]];
            break;
        case YYKlineIncicatorWR:
            [YYWRModel calWRWithData:self.models params:@[@"6",@"10"]];
            break;
        case YYKlineIncicatorEMA:
            [YYEMAModel calEmaWithData:self.models params:@[@"7",@"30"]];
            break;
        case YYKlineIncicatorBOLL:
            [YYBOLLModel calBOLLWithData:self.models params:@[@"20",@"2"]];
            break;
    }
}

@end
