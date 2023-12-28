//
//  JMDelayPromptView.m
//  JMQuotesComponets_Example
//
//  Created by fargowealth on 2023/5/29.
//  Copyright © 2023 liyunlong1512. All rights reserved.
//

#import "JMDelayPromptView.h"
#import "QuotationConstant.h"
//Helper
#import "NSBundle+FSStockComponents.h"
#import "FSStockComponetsLanguage.h"
#import <FSOCCategories/NSString+FSSize.h>

@interface JMDelayPromptView ()

/** 文本 */
@property (nonatomic,strong) UILabel *titleLab;

/** 关闭按钮 */
@property (nonatomic,strong) UIButton *closeBtn;

@end

@implementation JMDelayPromptView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

#pragma mark - Public Methods

+ (CGFloat)viewHeight
{
    NSString *text = FSMacroLanguage(@"应港交所要求，行情延时至少15分钟");
    CGFloat height = [text getUICeilSize:kFont_Regular(12.f) limitWidth:kWidthScale(320)].height;
    return height + 8;
}

#pragma mark - Private Methods

- (void)CloseBtnClick {
    if ([self.delegate respondsToSelector:@selector(closePrompt)]) {
        [self.delegate closePrompt];
    }
}

#pragma mark - createUI

- (void)createUI {
    
    self.backgroundColor = UIColor.delayPromptViewBackgroundColor;
    
    [self addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16 - kWidthScale(20));
        make.top.bottom.mas_equalTo(self);
    }];
    
    [self addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16);
        make.centerY.mas_equalTo(self);
        make.size.mas_offset(kWidthScale(20));
    }];
    
}

#pragma mark — Lazy

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] init];
        [_closeBtn setBackgroundImage:[NSBundle fsStockUI_imageName:@"close.png"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(CloseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.text = FSMacroLanguage(@"应港交所要求，行情延时至少15分钟");
        _titleLab.font = kFont_Regular(12.f);
        _titleLab.textColor = UIColor.delayPromptTextColor;
        _titleLab.numberOfLines = 2;
    }
    return _titleLab;
}

@end
