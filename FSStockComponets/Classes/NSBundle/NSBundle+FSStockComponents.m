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

+ (NSString *)fsStockUI_localizedStringForKey:(NSString *)key
{
    return [self fsStockUI_localizedStringForKey:key value:nil];
}

+ (NSString *)fsStockUI_localizedStringForKey:(NSString *)key value:(nullable NSString *)value
{
    static NSBundle *bundle = nil;
    if (bundle == nil) {
        // （iOS获取的语言字符串比较不稳定）目前框架只处理en、zh-Hans、zh-Hant三种情况，其他按照系统默认处理
        NSString *language = [NSLocale preferredLanguages].firstObject;
        if ([language hasPrefix:@"en"]) {
            language = @"en";
        } else if ([language hasPrefix:@"zh"]) {
            if ([language rangeOfString:@"Hans"].location != NSNotFound) {
                language = @"zh-Hans"; // 简体中文
            } else { // zh-Hant\zh-HK\zh-TW
                language = @"zh-Hant"; // 繁體中文
            }
        } else {
            language = @"en";
        }
        
        // 从MJRefresh.bundle中查找资源
        bundle = [NSBundle bundleWithPath:[[NSBundle fs_stockComponentsBundle] pathForResource:language ofType:@"lproj" inDirectory:@"Localizable"]];
    }
    value = [bundle localizedStringForKey:key value:value table:nil];
    return [[NSBundle mainBundle] localizedStringForKey:key value:value table:nil];
}

@end
