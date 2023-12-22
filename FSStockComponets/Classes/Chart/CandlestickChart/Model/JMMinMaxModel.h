//
//  JMMinMaxModel.h
//  ghchat
//
//  Created by fargowealth on 2021/10/26.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMMinMaxModel : NSObject

@property (nonatomic, assign) CGFloat min;
@property (nonatomic, assign) CGFloat max;

- (CGFloat)distance;

+ (instancetype)modelWithMin:(CGFloat)min max:(CGFloat)max;

- (void)combine: (JMMinMaxModel *)m;

@end

NS_ASSUME_NONNULL_END
