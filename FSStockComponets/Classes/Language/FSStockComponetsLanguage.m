//
//  FSStockComponetsLanguage.m
//  FSOCCategories
//
//  Created by 张忠燕 on 2023/12/28.
//

#import "FSStockComponetsLanguage.h"
//Helper
#import "NSBundle+FSStockComponents.h"
#import <objc/runtime.h>

@implementation FSStockComponetsLanguage

+ (FSStockComponetsLanguageType)localPreferredLanguage
{
    NSArray<NSString *> *appleLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    NSString *languageCode = appleLanguages.firstObject;
    if ([languageCode hasPrefix:@"en"]) {
        return FSStockComponetsLanguageTypeEnglish;
    } else if ([languageCode hasPrefix:@"zh"]) {
        if ([languageCode rangeOfString:@"Hans"].location != NSNotFound) {
            return FSStockComponetsLanguageTypeSimpleChinese;// 简体中文
        } else { // zh-Hant\zh-HK\zh-TW
            return FSStockComponetsLanguageTypeChinese;// 繁體中文
        }
    } else {
        return FSStockComponetsLanguageTypeUnknow;
    }
}

/// 用户偏好语言
+ (FSStockComponetsLanguageType)userPreferredLanguage
{
    NSNumber *number = objc_getAssociatedObject(self, @selector(userPreferredLanguage));
    if (number) {
        return number.integerValue;
    } else {
        return FSStockComponetsLanguageTypeUnknow;
    }
}

/// 设置用户偏好语言
+ (void)setUserPreferredLanguage:(FSStockComponetsLanguageType)type
{
    objc_setAssociatedObject(self, @selector(userPreferredLanguage), @(type), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (FSStockComponetsLanguageType)finallyPreferredLanguage
{
    FSStockComponetsLanguageType userType = [FSStockComponetsLanguage userPreferredLanguage];
    if (userType != FSStockComponetsLanguageTypeUnknow) {
        return userType;
    } else {
        //没有用户偏好，取机器本地偏好，本地没有偏好默认用英文
        FSStockComponetsLanguageType localType = [FSStockComponetsLanguage localPreferredLanguage];
        if (localType == FSStockComponetsLanguageTypeUnknow) {
            return FSStockComponetsLanguageTypeEnglish;
        } else {
            return localType;
        }
    }
}

+ (BOOL)isChineseLanguage
{
    FSStockComponetsLanguageType type = [FSStockComponetsLanguage finallyPreferredLanguage];
    switch (type) {
        case FSStockComponetsLanguageTypeUnknow:
        case FSStockComponetsLanguageTypeEnglish:
            return NO;
        case FSStockComponetsLanguageTypeChinese:
        case FSStockComponetsLanguageTypeSimpleChinese:
            return YES;
    }
}

+ (NSString *)localizedStringForKey:(NSString *)key
{
    return [self localizedStringForKey:key value:nil];
}

+ (NSString *)localizedStringForKey:(NSString *)key value:(nullable NSString *)value
{
    NSBundle *bundle = nil;
    FSStockComponetsLanguageType type = [FSStockComponetsLanguage finallyPreferredLanguage];
    switch (type) {
        case FSStockComponetsLanguageTypeUnknow:
        case FSStockComponetsLanguageTypeEnglish: {
            bundle = [FSStockComponetsLanguage englishLanguageBundle];
            break;
        }
        case FSStockComponetsLanguageTypeChinese: {
            bundle = [FSStockComponetsLanguage chineseLanguageBundle];
            break;
        }
        case FSStockComponetsLanguageTypeSimpleChinese: {
            bundle = [FSStockComponetsLanguage simpleChineseLanguageBundle];
            break;
        }
    }
    value = [bundle localizedStringForKey:key value:value table:nil];
    return [[NSBundle mainBundle] localizedStringForKey:key value:value table:nil];
}

#pragma mark - Private Methods

+ (nullable NSBundle *)languageBundleWithResource:(NSString *)resouce
{
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle fs_stockComponentsBundle] pathForResource:resouce ofType:@"lproj" inDirectory:@"Localizable"]];
    return bundle;
}

+ (NSBundle *)englishLanguageBundle
{
    static NSBundle *bundle = nil;
    if (!bundle) {
        bundle = [FSStockComponetsLanguage languageBundleWithResource:@"en"];
    }
    return bundle;
}

+ (NSBundle *)simpleChineseLanguageBundle
{
    static NSBundle *bundle = nil;
    if (!bundle) {
        bundle = [FSStockComponetsLanguage languageBundleWithResource:@"zh-Hans"];
    }
    return bundle;
}

+ (NSBundle *)chineseLanguageBundle
{
    static NSBundle *bundle = nil;
    if (!bundle) {
        bundle = [FSStockComponetsLanguage languageBundleWithResource:@"zh-Hant"];
    }
    return bundle;
}

@end