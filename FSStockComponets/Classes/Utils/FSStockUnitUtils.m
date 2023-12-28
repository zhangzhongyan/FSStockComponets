//
//  FSStockUnitUtils.m
//  FSStockComponets
//
//  Created by 张忠燕 on 2023/12/28.
//

#import "FSStockUnitUtils.h"
//Helper
#import "FSStockComponetsLanguage.h"

@implementation FSStockUnitUtils

#pragma mark - Public Methods

+ (NSString *)readbleVolumeWithNumber:(CGFloat)number
{
    return [FSStockUnitUtils readbleNumber:number type:1];
}

+ (NSString *)readbleDealAmoutWithNumber:(CGFloat)number
{
    return [FSStockUnitUtils readbleNumber:number type:2];
}

+ (NSString *)readbleKLineVerticalUnitWithNumber:(CGFloat)number
{
    NSString * text = @"";
    if (number >= 1e8) {
        text = [NSString stringWithFormat:@"%.2f%@", number/1e8, FSMacroLanguage(@"亿")];
    } else if (number >= 1e4) {
        number = ([FSStockComponetsLanguage isChineseLanguage])? number: number * 10;
        text = [NSString stringWithFormat:@"%.2f%@", number/1e4, FSMacroLanguage(@"万")];
    } else if (number >= 10) {
        text = [NSString stringWithFormat:@"%.2f", number];
    } else {
        text = [NSString stringWithFormat:@"%.3f", number];
    }
    return text;
}

#pragma mark - Private Methods

+ (NSString *)readbleNumber:(CGFloat)number type:(NSInteger)type
{
    //类型 1.成交量 2.成交额
    NSString * text = @"";
    if (number >= 1e8) {
        text = [NSString stringWithFormat:@"%.2f%@", number/1e8, FSMacroLanguage(@"亿")];
    } else if (number >= 1e4) {
        number = ([FSStockComponetsLanguage isChineseLanguage])? number: number * 10;
        text = [NSString stringWithFormat:@"%.2f%@", number/1e4, FSMacroLanguage(@"万")];
    } else {
        if (type == 1) {
            text = [NSString stringWithFormat:@"%.0f", number];
        } else {
            text = [NSString stringWithFormat:@"%.2f", number];
        }
    }
    return text;
}

@end
