//
//  FSStockComponetsLanguage.h
//  FSOCCategories
//
//  Created by 张忠燕 on 2023/12/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, FSStockComponetsLanguageType) {
    /** 未知  */
    FSStockComponetsLanguageTypeUnknow = 0,
    /** 英文  */
    FSStockComponetsLanguageTypeEnglish,
    /** 简体中文 */
    FSStockComponetsLanguageTypeSimpleChinese,
    /** 繁体中文 */
    FSStockComponetsLanguageTypeChinese,
};

#define FSMacroLanguage(key) [FSStockComponetsLanguage localizedStringForKey:key]

@interface FSStockComponetsLanguage : NSObject

+ (FSStockComponetsLanguageType)localPreferredLanguage;

/// 用户偏好语言
+ (FSStockComponetsLanguageType)userPreferredLanguage;

/// 设置用户偏好语言
+ (void)setUserPreferredLanguage:(FSStockComponetsLanguageType)type;

/// 最终显示语言
+ (FSStockComponetsLanguageType)finallyPreferredLanguage;

+ (BOOL)isChineseLanguage;

+ (NSString *)localizedStringForKey:(NSString *)key;

+ (NSString *)localizedStringForKey:(NSString *)key value:(nullable NSString *)value;

@end

NS_ASSUME_NONNULL_END
