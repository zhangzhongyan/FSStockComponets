//
//  JMKlineGlobalVariable.h
//  ghchat
//
//  Created by fargowealth on 2021/10/26.
//

#import <Foundation/Foundation.h>
#import "JMKlineConstant.h"

NS_ASSUME_NONNULL_BEGIN

@interface JMKlineGlobalVariable : NSObject

/**
 *  K线图的宽度，默认20
 */
+ (CGFloat)kLineWidth;

+ (void)setkLineWith:(CGFloat)kLineWidth;
+ (void)setkLineWith2:(CGFloat)kLineWidth;

/**
 *  K线图的间隔，默认1
 */
+ (CGFloat)kLineGap;

+ (void)setkLineGap:(CGFloat)kLineGap;

/**
 *  MainView的高度占比,默认为0.5
 */
+ (CGFloat)kLineMainViewRadio;

+ (void)setkLineMainViewRadio:(CGFloat)radio;

/**
 *  VolumeView的高度占比,默认为0.2
 */
+ (CGFloat)kLineVolumeViewRadio;

+ (void)setkLineVolumeViewRadio:(CGFloat)radio;

@end

NS_ASSUME_NONNULL_END
