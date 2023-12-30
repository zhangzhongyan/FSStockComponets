//
//  JMKlineConstant.h
//  ghchat
//
//  Created by fargowealth on 2021/10/26.
//

#ifndef JMKlineConstant_h
#define JMKlineConstant_h

#import <UIKit/UIKit.h>
#import "JMKlineConstant.h"
#import "JMKlineGlobalVariable.h"
#import "JMIndicatorModel.h"
#import "JMKlineModel.h"
#import "JMKlineRootModel.h"
#import "JMMinMaxModel.h"
#import "JMBOLLPainter.h"
#import "JMCandlePainter.h"
#import "JMEMAPainter.h"
#import "JMKDJPainter.h"
#import "JMMAPainter.h"
#import "JMMACDPainter.h"
#import "JMPainterProtocol.h"
#import "JMRSIPainter.h"
#import "JMTimePainter.h"
#import "JMTimelinePainter.h"
#import "JMVerticalTextPainter.h"
#import "JMVolPainter.h"
#import "JMWRPainter.h"
#import "UIButton+KJContentLayout.h"
#import "UIColor+JMColor.h"

/**
 *  宽度
 */
#define JMkWidth [[UIScreen mainScreen] bounds].size.width

/**
 *  K线图View的宽度
 */
#define JMKlineMainViewWidth [[UIScreen mainScreen] bounds].size.width - 200

/**
 *  K线图Y的View的宽度
 */
#define JMKlineLinePriceViewWidth 120

/**
 *  K线最大的宽度
 */
#define JMKlineLineMaxWidth 20

/**
 *  K线图最小的宽度
 */
#define JMKlineLineMinWidth 2

/**
 *  K线图缩放界限
 */
#define JMKlineScaleBound 0.02

/**
 *  K线的缩放因子
 */
#define JMKlineScaleFactor 0.07

/**
 *  长按时的线的宽度
 */
#define JMKlineLongPressVerticalViewWidth 1

/**
 *  上下影线宽度
 */
#define JMKlineLineWidth 1

#endif /* JMKlineConstant_h */
