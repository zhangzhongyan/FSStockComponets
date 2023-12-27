//
//  FSStockDetailInfoModel.m
//  FSStockComponets
//
//  Created by 张忠燕 on 2023/12/27.
//

#import "FSStockDetailInfoModel.h"

@implementation FSStockDetailInfoModel

- (NSString *)marketType {
    
    if (!_marketType){
        NSArray *assetIdList = [_assetId componentsSeparatedByString:@"."];
        _marketType = assetIdList.lastObject;
    }
    return _marketType;
}

@end
