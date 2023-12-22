//
//  EVCacheUtils.h
//  FSStockComponets_Example
//
//  Created by 张忠燕 on 2023/12/22.
//  Copyright © 2023 张忠燕. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EVCacheUtils : NSObject

+ (nullable NSString *)languageCode;

+ (void)setLanguageCode:(nullable NSString *)languageCode;

+ (void)removeLanguageCode;

@end

NS_ASSUME_NONNULL_END
