//
//  EVCacheUtils.m
//  FSStockComponets_Example
//
//  Created by 张忠燕 on 2023/12/22.
//  Copyright © 2023 张忠燕. All rights reserved.
//

#import "EVCacheUtils.h"
//Helper
#import <PINCache/PINCache.h>

static NSString * const kPCLanguageCode = @"kPCLanguageCode";

@implementation EVCacheUtils

#pragma mark - Language Code

+ (nullable NSString *)languageCode {
    return [PINCache.sharedCache objectForKey:kPCLanguageCode];
}

+ (void)setLanguageCode:(nullable NSString *)languageCode {
    [[PINCache sharedCache] setObject:languageCode ?: @"" forKey:kPCLanguageCode];
}

+ (void)removeLanguageCode {
    [[PINCache sharedCache] removeObjectForKey:kPCLanguageCode];
}

@end
