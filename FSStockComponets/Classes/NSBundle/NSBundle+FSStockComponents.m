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

+ (NSString *)fsStockUI_localizedStringForKey:(NSString *)key
{
    return [self fsStockUI_localizedStringForKey:key value:nil];
}

+ (NSString *)fsStockUI_localizedStringForKey:(NSString *)key value:(nullable NSString *)value
{
    NSBundle *bundle = nil;
    FSLanguageType languageType = [NSBundle fsStockUI_localPreferredLanguage];
    switch (languageType) {
        case FSLanguageTypeUnknow:
        case FSLanguageTypeEnglish: {
            bundle = [NSBundle fsStockUI_englishLanguageBundle];
            break;
        }
        case FSLanguageTypeChinese: {
            bundle = [NSBundle fsStockUI_chineseLanguageBundle];
            break;
        }
        case FSLanguageTypeSimpleChinese: {
            bundle = [NSBundle fsStockUI_simpleChineseLanguageBundle];
            break;
        }
    }
    value = [bundle localizedStringForKey:key value:value table:nil];
    return [[NSBundle mainBundle] localizedStringForKey:key value:value table:nil];
}

+ (FSLanguageType)fsStockUI_localPreferredLanguage
{
    // （iOS获取的语言字符串比较不稳定）目前框架只处理en、zh-Hans、zh-Hant三种情况，其他按照系统默认处理
    NSString *language = [NSLocale preferredLanguages].firstObject;
    if ([language hasPrefix:@"en"]) {
        return FSLanguageTypeEnglish;
        language = @"en";
    } else if ([language hasPrefix:@"zh"]) {
        if ([language rangeOfString:@"Hans"].location != NSNotFound) {
            return FSLanguageTypeSimpleChinese;// 简体中文
        } else { // zh-Hant\zh-HK\zh-TW
            return FSLanguageTypeChinese;// 繁體中文
        }
    } else {
        return FSLanguageTypeUnknow;
    }
}

+ (BOOL)fsStockUI_isChineseLanguage
{
    FSLanguageType languageType = [NSBundle fsStockUI_localPreferredLanguage];
    switch (languageType) {
        case FSLanguageTypeUnknow:
        case FSLanguageTypeEnglish: {
            return NO;
        }
        case FSLanguageTypeChinese:
        case FSLanguageTypeSimpleChinese: {
            return YES;
        }
    }
}

#pragma mark - Private Methods

+ (NSBundle *)fsStockUI_englishLanguageBundle
{
    static NSBundle *bundle = nil;
    if (!bundle) {
        bundle = [NSBundle fsStockUI_languageBundleWithResource:@"en"];
    }
    return bundle;
}

+ (NSBundle *)fsStockUI_simpleChineseLanguageBundle
{
    static NSBundle *bundle = nil;
    if (!bundle) {
        bundle = [NSBundle fsStockUI_languageBundleWithResource:@"zh-Hans"];
    }
    return bundle;
}

+ (NSBundle *)fsStockUI_chineseLanguageBundle
{
    static NSBundle *bundle = nil;
    if (!bundle) {
        bundle = [NSBundle fsStockUI_languageBundleWithResource:@"zh-Hant"];
    }
    return bundle;
}

+ (nullable NSBundle *)fsStockUI_languageBundleWithResource:(NSString *)resouce
{
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle fs_stockComponentsBundle] pathForResource:resouce ofType:@"lproj" inDirectory:@"Localizable"]];
    return bundle;
}

@end
