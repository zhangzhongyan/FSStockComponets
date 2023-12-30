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

+ (NSString *)FSLocalizedStringForKey:(NSString *)key
{
    key = [NSString stringWithFormat:@"%@(FS)", key];
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
    NSString *mainBudleValue = [[NSBundle mainBundle] localizedStringForKey:key value:value table:nil];
    //修复value=""，并且主bundle没有定义的情况下，使用""
    return ([value isEqualToString:@""] && [mainBudleValue isEqualToString:key])? value: mainBudleValue;
}

#pragma mark - Private Methods

+ (nullable NSBundle *)languageBundleWithResource:(NSString *)resouce
{
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle fs_stockComponentsBundle] pathForResource:resouce ofType:@"lproj" inDirectory:@"Localizable"]];
    return bundle;
}

+ (NSBundle *)englishLanguageBundle
{
    static NSBundle *bundle1 = nil;
    if (!bundle1) {
        bundle1 = [FSStockComponetsLanguage languageBundleWithResource:@"en"];
    }
    return bundle1;
}

+ (NSBundle *)simpleChineseLanguageBundle
{
    static NSBundle *bundle2 = nil;
    if (!bundle2) {
        bundle2 = [FSStockComponetsLanguage languageBundleWithResource:@"zh-Hans"];
    }
    return bundle2;
}

+ (NSBundle *)chineseLanguageBundle
{
    static NSBundle *bundle3 = nil;
    if (!bundle3) {
        bundle3 = [FSStockComponetsLanguage languageBundleWithResource:@"zh-Hant"];
    }
    return bundle3;
}

@end
