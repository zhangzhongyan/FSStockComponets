//
//  JMStockInfoModel.m
//  JMQuotesComponets_Example
//
//  Created by fargowealth on 2023/5/30.
//  Copyright © 2023 liyunlong1512. All rights reserved.
//

#import "JMStockInfoModel.h"

@implementation JMStockInfoModel

- (NSString *)marketType {
    
    if (!_marketType){
        NSArray *assetIdList = [_assetId componentsSeparatedByString:@"."];
        _marketType = assetIdList.lastObject;
    }
    return _marketType;
}

@end

@implementation JMTimeChartModel

@end
