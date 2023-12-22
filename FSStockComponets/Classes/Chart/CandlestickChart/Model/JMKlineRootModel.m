//
//  JMKlineRootModel.m
//  ghchat
//
//  Created by fargowealth on 2021/10/26.
//

#import "JMKlineRootModel.h"
#import "JMKlineGlobalVariable.h"

@implementation JMKlineRootModel

+ (instancetype) objectWithArray:(NSArray *)arr {
    NSAssert([arr isKindOfClass:[NSArray class]], @"arr不是一个数组，请检查返回数据类型并手动适配");
    JMKlineRootModel *groupModel = [JMKlineRootModel new];
    NSMutableArray *mArr = @[].mutableCopy;
    NSInteger index = 0;
    for (NSInteger i = 0; i < arr.count; i++) {
        NSArray *item = arr[i];
        NSLog(@"==========%@==%ld===========", item, i);
        JMKlineModel *model = [JMKlineModel new];
        model.index = index;
        model.Timestamp = @([item[0] doubleValue] / 1000);
        model.Open = item[1];
        model.High = item[2];
        model.Low =  item[3];
        model.Close = item[4];
        model.Volume = item[5];
        model.Turnover = item[6];
        model.yesterdayClose = item[7];
        model.PrevModel = mArr.lastObject;
        [mArr addObject:model];
        index++;
        
    }
    groupModel.models = mArr;
    [groupModel calculateIndicators:JMKlineIncicatorMACD];
    [groupModel calculateIndicators:JMKlineIncicatorMA];
    [groupModel calculateIndicators:JMKlineIncicatorKDJ];
    [groupModel calculateIndicators:JMKlineIncicatorRSI];
    [groupModel calculateIndicators:JMKlineIncicatorBOLL];
    [groupModel calculateIndicators:JMKlineIncicatorWR];
    [groupModel calculateIndicators:JMKlineIncicatorEMA];
    [groupModel calculateNeedDrawTimeModel];
    return groupModel;
}

/**
 * 分时数据
 * arr                        数据源
 * closingPrice         收盘价
 */
+ (instancetype) objectTimeSharWithArray:(NSArray *)arr
                            ClosingPrice:(NSNumber *)closingPrice {
    NSAssert([arr isKindOfClass:[NSArray class]], @"arr不是一个数组，请检查返回数据类型并手动适配");
    JMKlineRootModel *groupModel = [JMKlineRootModel new];
    NSMutableArray *mArr = @[].mutableCopy;
    NSInteger index = 0;
    for (NSInteger i = 0; i < arr.count; i++) {
        NSArray *item = arr[i];
        JMKlineModel *model = [JMKlineModel new];
        model.index = index;
        model.Timestamp = @([item[0] doubleValue]/1000);
        model.Open = item[1];
        model.High = item[1];
        model.Low = item[1];
        model.Close = closingPrice;
        model.Volume = item[3];
        model.avgPrice = item[2];
        model.PrevModel = mArr.lastObject;
        [mArr addObject:model];
        index++;
    }
    groupModel.models = mArr;
    [groupModel calculateIndicators:JMKlineIncicatorMACD];
    [groupModel calculateIndicators:JMKlineIncicatorMA];
    [groupModel calculateIndicators:JMKlineIncicatorKDJ];
    [groupModel calculateIndicators:JMKlineIncicatorRSI];
    [groupModel calculateIndicators:JMKlineIncicatorBOLL];
    [groupModel calculateIndicators:JMKlineIncicatorWR];
    [groupModel calculateIndicators:JMKlineIncicatorEMA];
    [groupModel calculateNeedDrawTimeModel];
    return groupModel;
}

- (void)calculateNeedDrawTimeModel {
    NSInteger gap = 50 / [JMKlineGlobalVariable kLineWidth] + [JMKlineGlobalVariable kLineGap];
    for (int i = 1; i < self.models.count; i++) {
        self.models[i].isDrawTime = i % gap == 0;
    }
}

- (void)calculateIndicators:(JMKlineIncicator)key {
    switch (key) {
        case JMKlineIncicatorMA:
            [JMMAModel calMAWithData:self.models params:@[@"5",@"10",@"20",@"30",@"60"]];
            break;
        case JMKlineIncicatorMACD:
            [JMMACDModel calMACDWithData:self.models params:@[@"12",@"26",@"9"]];
            break;
        case JMKlineIncicatorKDJ:
            [JMKDJModel calKDJWithData:self.models params:@[@"9",@"3",@"3"]];
            break;
        case JMKlineIncicatorRSI:
            [JMRSIModel calRSIWithData:self.models params:@[@"6",@"12",@"24"]];
            break;
        case JMKlineIncicatorWR:
            [JMWRModel calWRWithData:self.models params:@[@"6",@"10"]];
            break;
        case JMKlineIncicatorEMA:
            [JMEMAModel calEmaWithData:self.models params:@[@"7",@"30"]];
            break;
        case JMKlineIncicatorBOLL:
            [JMBOLLModel calBOLLWithData:self.models params:@[@"20",@"2"]];
            break;
    }
}

#pragma mark — 合并数组

-(void)appendData:(NSArray *)arr{
    NSAssert([arr isKindOfClass:[NSArray class]], @"arr不是一个数组，请检查返回数据类型并手动适配");
    NSMutableArray *mArr = @[].mutableCopy;
    NSInteger index = 0;
    for (NSInteger i = 0; i < arr.count; i++) {
        NSArray *item = arr[i];
        JMKlineModel *model = [JMKlineModel new];
        model.index = index;
        model.Timestamp = @([item[0] doubleValue] / 1000);
        model.Open = item[1];
        model.High = item[2];
        model.Low = item[3];
        model.Close = item[4];
        model.Volume = item[5];
        model.Turnover = item[6];
        model.yesterdayClose = item[7];
        model.PrevModel = mArr.lastObject;
        [mArr addObject:model];
        index++;
    }
    for (JMKlineModel* tempmodle in self.models) {
        tempmodle.index = index;
        index++;
    }
    [mArr addObjectsFromArray:self.models];
 
    self.models = mArr;
    [self calculateIndicators:JMKlineIncicatorMACD];
    [self calculateIndicators:JMKlineIncicatorMA];
    [self calculateIndicators:JMKlineIncicatorKDJ];
    [self calculateIndicators:JMKlineIncicatorRSI];
    [self calculateIndicators:JMKlineIncicatorBOLL];
    [self calculateIndicators:JMKlineIncicatorWR];
    [self calculateIndicators:JMKlineIncicatorEMA];
    [self calculateNeedDrawTimeModel];
}

@end
