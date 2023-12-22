//
//  YYTimePainter.h
//  YYKline
//
//  Copyright © 2019 WillkYang. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "YYPainterProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface YYTimePainter : CALayer <YYPainterProtocol>
+ (void)drawToLayer2:(CALayer *)layer area:(CGRect)area models:(NSArray<YYKlineModel *> *)models minMax:(YYMinMaxModel *)minMaxModel close:(CGFloat)close price:(CGFloat)price;

+ (void)drawToLayer3:(CALayer *)layer area:(CGRect)area models:(NSArray<YYKlineModel *> *)models minMax:(YYMinMaxModel *)minMaxModel close:(CGFloat)close price:(CGFloat)price;


+ (void)drawToLayer4:(CALayer *)layer area:(CGRect)area models:(NSArray<YYKlineModel *> *)models minMax:(YYMinMaxModel *)minMaxModel close:(CGFloat)close price:(CGFloat)price;
@end

NS_ASSUME_NONNULL_END
