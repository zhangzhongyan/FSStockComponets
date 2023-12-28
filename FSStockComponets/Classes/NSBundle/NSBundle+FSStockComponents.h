//
//  NSBundle+FSStockComponents.h
//  FSStockComponets_Example
//
//  Created by 张忠燕 on 2023/12/25.
//  Copyright © 2023 张忠燕. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (FSStockComponents)

+ (instancetype)fs_stockComponentsBundle;

+ (nullable UIImage *)fsStockUI_imageName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
