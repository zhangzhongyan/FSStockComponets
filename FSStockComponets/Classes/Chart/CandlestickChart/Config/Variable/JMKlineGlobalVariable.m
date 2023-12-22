//
//  JMKlineGlobalVariable.m
//  ghchat
//
//  Created by fargowealth on 2021/10/26.
//

#import "JMKlineGlobalVariable.h"

/**
 *  K线图的宽度，默认20
 */
static CGFloat kJMKlineLineWidth = 6;

/**
 *  K线图的间隔，默认1
 */
static CGFloat kJMKlineLineGap = 2;


/**
 *  MainView的高度占比,默认为0.5
 */
static CGFloat kJMKlineMainViewRadio = 0.7;

/**
 *  VolumeView的高度占比,默认为0.5
 */
static CGFloat kJMKlineVolumeViewRadio = 0.3;

@implementation JMKlineGlobalVariable

/**
 *  K线图的宽度，默认20
 */
+ (CGFloat)kLineWidth {
    return kJMKlineLineWidth;
}

+ (void)setkLineWith:(CGFloat)kLineWidth {
    if (kLineWidth > JMKlineLineMaxWidth) {
        kLineWidth = JMKlineLineMaxWidth;
    }else if (kLineWidth < JMKlineLineMinWidth){
        kLineWidth = JMKlineLineMinWidth;
    }
    kJMKlineLineWidth = kLineWidth;
}

+ (void)setkLineWith2:(CGFloat)kLineWidth {
    kJMKlineLineWidth = kLineWidth;
}

/**
 *  K线图的间隔，默认1
 */
+ (CGFloat)kLineGap {
    return kJMKlineLineGap;
}

+ (void)setkLineGap:(CGFloat)kLineGap {
    kJMKlineLineGap = kLineGap;
}

/**
 *  MainView的高度占比,默认为0.5
 */
+ (CGFloat)kLineMainViewRadio {
    return kJMKlineMainViewRadio;
}

+ (void)setkLineMainViewRadio:(CGFloat)radio {
    kJMKlineMainViewRadio = radio;
}

/**
 *  VolumeView的高度占比,默认为0.2
 */
+ (CGFloat)kLineVolumeViewRadio {
    return kJMKlineVolumeViewRadio;
}

+ (void)setkLineVolumeViewRadio:(CGFloat)radio {
    kJMKlineVolumeViewRadio = radio;
}

@end
