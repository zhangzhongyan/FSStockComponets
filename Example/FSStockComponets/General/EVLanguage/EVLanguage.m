//
//  EVLanguage.m
//  EVCRMApp
//
//  Created by 张忠燕 on 2021/9/10.
//

#import "EVLanguage.h"
//Helper
#import "EVCacheUtils.h"

/// 简体中文
static NSString * const kGTZhHans = @"zh-Hans";
/// 繁体中文
static NSString * const kGTZhHant = @"zh-Hant";
/// 英语
static NSString * const kGTEn = @"en";

@implementation EVLanguage

#pragma mark - Initialize Methods

+ (EVLanguage *)shared {
    static EVLanguage *singlton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singlton = [[EVLanguage alloc] init];
    });
    return singlton;
}

#pragma mark - Public Methods

+ (NSString *)getLanguageCodeWithType:(EVLanguageType)type {
    switch (type) {
        case EVLanguageTypeEnglish:
            return kGTEn;
        case EVLanguageTypeSimpleChinese:
            return kGTZhHans;
    }
}

+ (NSString *)getSystemLanguageCode {
    NSArray<NSString *> *appleLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    NSString *languageCode = appleLanguages.firstObject;
    
    if ([languageCode hasPrefix:kGTZhHans]) {
        languageCode = kGTZhHans;
    }
    else if ([languageCode hasPrefix:kGTZhHant]) {
        languageCode = kGTZhHant;
    }
    else {
        languageCode = kGTEn;
    }
    return languageCode;
}

+ (NSString *)getCurLanguageCode {
    NSString *languageCode = EVCacheUtils.languageCode;
    if (!languageCode.length) {
        
        //没有设置过语言、按照系统语言设置
        languageCode = [self getSystemLanguageCode];
        
        //由于不支持繁体中文、切换至简体中文
        languageCode = [languageCode isEqualToString:kGTZhHant]? kGTZhHans: languageCode;
    }
    return languageCode;
}

+ (EVLanguageType)getVisiableLanguageType {
    NSString *curLCode = [self getCurLanguageCode];
    if ([curLCode isEqualToString:kGTZhHans]) {
        return EVLanguageTypeSimpleChinese;
    }
    else if ([curLCode isEqualToString:kGTZhHant]) {
        return EVLanguageTypeSimpleChinese;
    }
    else {
        return EVLanguageTypeEnglish;
    }
}

+ (NSString *)localizedStringForKey:(NSString *)key {
    NSString *languageCode = [self getCurLanguageCode];
   
    NSString *path = [[NSBundle mainBundle] pathForResource:languageCode ofType:@"lproj"];
    
    return [[NSBundle bundleWithPath:path] localizedStringForKey:(key) value:nil table:nil];
}

+ (BOOL)isChineseLanguage
{
    return self.getVisiableLanguageType == EVLanguageTypeSimpleChinese;
}

+ (NSLocale *)currentNSLocal
{
    if ([EVLanguage isChineseLanguage]) {
        return [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
    }
    else {
        return [NSLocale localeWithLocaleIdentifier:@"en-us"];
    }
}

@end
