//
//  NSBundle+FSStockComponents.m
//  FSStockComponets_Example
//
//  Created by 张忠燕 on 2023/12/25.
//  Copyright © 2023 张忠燕. All rights reserved.
//

#import "NSBundle+FSStockComponents.h"
#import "FSStockComponets.h"

@implementation NSBundle (FSStockComponents)

#pragma mark - Public Methods

+ (instancetype)fs_stockComponentsBundle
{
    static NSBundle *stockComponentsBundle = nil;
    if (stockComponentsBundle == nil) {
        NSBundle *bundle = [NSBundle bundleForClass:FSStockComponets.class];
        NSString *path = [bundle pathForResource:@"FSStockComponents" ofType:@"bundle"];
        stockComponentsBundle = [NSBundle bundleWithPath:path];
    }
    return stockComponentsBundle;
}

+ (nullable UIImage *)fsStockUI_imageName:(NSString *)name
{
    NSString *path = [[NSBundle fs_stockComponentsBundle] pathForResource:name ofType:nil inDirectory:@"images"];;
    return path.length? [UIImage imageWithContentsOfFile:path]: nil;
}

@end
