//
//  JMTimelinePainter.h
//  ghchat
//
//  Created by fargowealth on 2021/10/26.
//

#import <QuartzCore/QuartzCore.h>
#import "JMPainterProtocol.h"

NS_ASSUME_NONNULL_BEGIN

// 分时图
@interface JMTimelinePainter : CALayer <JMPainterProtocol>

@end

NS_ASSUME_NONNULL_END
