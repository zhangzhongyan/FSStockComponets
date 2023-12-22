//
//  JMMinMaxModel.m
//  ghchat
//
//  Created by fargowealth on 2021/10/26.
//

#import "JMMinMaxModel.h"

@implementation JMMinMaxModel

+ (instancetype)modelWithMin:(CGFloat)min max:(CGFloat)max {
    JMMinMaxModel *m = [JMMinMaxModel new];
    m.min = min;
    m.max = max;
    return m;
}

- (CGFloat)distance {
    return self.max - self.min;
}


- (void)combine: (JMMinMaxModel *)m {
    self.min = MIN(self.min, m.min);
    self.max = MAX(self.max, m.max);
}

@end
