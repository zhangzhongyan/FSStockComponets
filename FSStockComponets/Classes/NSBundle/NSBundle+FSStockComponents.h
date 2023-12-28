//
//  NSBundle+FSStockComponents.h
//  FSStockComponets_Example
//
//  Created by 张忠燕 on 2023/12/25.
//  Copyright © 2023 张忠燕. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, FSLanguageType) {
    /** 未知  */
    FSLanguageTypeUnknow = 0,
    /** 英文  */
    FSLanguageTypeEnglish,
    /** 简体中文 */
    FSLanguageTypeSimpleChinese,
    /** 繁体中文 */
    FSLanguageTypeChinese,
};

#define FSLanguage(key) [NSBundle fsStockUI_localizedStringForKey:key]

@interface NSBundle (FSStockComponents)

+ (instancetype)fs_stockComponentsBundle;

+ (nullable UIImage *)fsStockUI_imageName:(NSString *)name;

+ (NSString *)fsStockUI_localizedStringForKey:(NSString *)key;

+ (NSString *)fsStockUI_localizedStringForKey:(NSString *)key value:(nullable NSString *)value;

+ (FSLanguageType)fsStockUI_localPreferredLanguage;

+ (BOOL)fsStockUI_isChineseLanguage;

@end

NS_ASSUME_NONNULL_END
