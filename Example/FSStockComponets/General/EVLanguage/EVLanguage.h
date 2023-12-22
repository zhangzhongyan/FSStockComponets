//
//  EVLanguage.h
//  EVCRMApp
//
//  Created by 张忠燕 on 2021/9/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/** 常用语言类型 */
typedef NS_ENUM(NSInteger, EVLanguageType) {
    /** 简体中文 */
    EVLanguageTypeSimpleChinese = 0,
    /** 英文 */
    EVLanguageTypeEnglish,
};

#define EVLanguage(key) [EVLanguage localizedStringForKey:key]

@interface EVLanguage : NSObject

+ (EVLanguage *)shared;

+ (NSString *)getLanguageCodeWithType:(EVLanguageType)type;

/** 获取系统语言 */
+ (NSString *)getSystemLanguageCode;

/** 获取当前的语言 */
+ (NSString *)getCurLanguageCode;

/** 获取显示的语言类型 */
+ (EVLanguageType)getVisiableLanguageType;

+ (NSString *)localizedStringForKey:(NSString *)key;

+ (BOOL)isChineseLanguage;

+ (NSLocale *)currentNSLocal;

@end

NS_ASSUME_NONNULL_END
