//
//  JMIndicatorView.m
//  ghchat
//
//  Created by 李云龙 on 2021/10/30.
//

#import "JMIndicatorView.h"
#import "UIColor+JMColor.h"
#import <Masonry/Masonry.h>

@interface JMIndicatorView ()

/** 数据 */
@property (nonatomic, strong) NSArray *array;

@end

@implementation JMIndicatorView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.array = @[@"MA",@"EMA",@"BOLL"];
        
        //规格选择
        __block UIButton *selectorBtn = nil;
        [self.array enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            UIButton *btn = [self CreateSelectorButtonWithTitle:obj Tag:idx];
            [self addSubview:btn];
            
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self);
                make.right.mas_equalTo(self.mas_right);
                make.height.mas_offset(30);

                if (selectorBtn) {
                    make.top.mas_equalTo(selectorBtn.mas_bottom);
                } else {
                    make.top.mas_equalTo(self);
                }
                
                selectorBtn = btn;
            }];
            
        }];
        
    }
    
    return self;
}

#pragma mark — Private method

- (void)SelectorButtonClick:(UIButton *)sender {
    NSLog(@"选择了%ld",sender.tag);
    
    if (self.SelectionIndicatorsBlock) {
        self.SelectionIndicatorsBlock(self.array[sender.tag], sender.tag);
    }
    
}

/**
 * 创建选择器按钮
 */
- (UIButton *)CreateSelectorButtonWithTitle:(NSString *)title
                                        Tag:(NSInteger)tag {
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:UIColor.handicapInfoTextColor forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:10.f]];
    [btn addTarget:self action:@selector(SelectorButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTag:tag];
    return btn;
}

#pragma mark - setter & getter

@end
