//
//  FSStockDetailChartViewModel.m
//  FSStockComponets
//
//  Created by 张忠燕 on 2023/12/27.
//

#import "FSStockDetailChartViewModel.h"

@implementation FSStockDetailChartViewModel

+ (instancetype) objectWithTimeArray:(NSArray *)arr {
    NSAssert([arr isKindOfClass:[NSArray class]], @"arr不是一个数组，请检查返回数据类型并手动适配");
    FSStockDetailChartViewModel *groupModel = [[FSStockDetailChartViewModel alloc] init];
    NSMutableArray *mArr = @[].mutableCopy;
    NSInteger index = 0;
    for (NSInteger i = [arr count]-1; i>=0; i--) {
        NSArray *item = arr[i];
        JMTimeChartModel *model = [JMTimeChartModel new];
        model.index = index;
        model.assetID = item[0];
        model.pushTime = item[1];
        model.currentPrice = item[2];
        model.averagePrice = item[3];
        model.yesterdayClosePrice = item[4];
        model.minuteVolume = item[5];
        model.minuteTurnover = item[6];
        model.addTo5DaysTimeSharing = [item[7] isEqualToString:@"Y"] ? YES : NO;
        model.todayOpenPrice = item[8];
        [mArr addObject:model];
        index++;
    }
    groupModel.timeChartModels = mArr;
    return groupModel;
}

@end
