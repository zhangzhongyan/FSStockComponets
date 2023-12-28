//
//  FSStockUnitUtils.h
//  FSStockComponets
//
//  Created by 张忠燕 on 2023/12/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FSStockUnitUtils : NSObject

+ (NSString *)readbleVolumeWithNumber:(CGFloat)number;

+ (NSString *)readbleDealAmoutWithNumber:(CGFloat)number;

@end

NS_ASSUME_NONNULL_END
