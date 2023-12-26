//
//  FSStockDetailTitleView.m
//  Fargo
//
//  Created by 张忠燕 on 2023/6/13.
//  Copyright © 2023 geekthings. All rights reserved.
//

#import "FSStockDetailTitleView.h"
//Helper
#import <Masonry/Masonry.h>
#import "FSColorMacro.h"

@implementation FSStockDetailTitleView

#pragma mark - Initialize Methods

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
        [self setupConstraints];
        [self setupBinding];
    }
    return self;
}

#pragma mark - Overwrite Methods

- (CGSize)intrinsicContentSize
{
//    CGFloat maxWidth = MAX(self.titleLabel.intrinsicContentSize.width, self.subTitleLabel.intrinsicContentSize.width);
    return CGSizeMake(200, 44);
}

#pragma mark - Private Methods

- (void)setupSubviews
{
    [self addSubview:self.titleLabel];
    [self addSubview:self.subTitleLabel];
}

- (void)setupConstraints
{
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.height.equalTo(@(22));
        make.top.equalTo(self).offset(3);
    }];
    
    [self.subTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.height.equalTo(@(22));
        make.bottom.equalTo(self).offset(-3);
    }];
}

- (void)setupBinding
{
    
}

#pragma mark - property

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = UIColor.clearColor;
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _titleLabel.textColor = HEX_RGB(0x13161B);
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.backgroundColor = UIColor.clearColor;
        _subTitleLabel.font = [UIFont systemFontOfSize:14];
        _subTitleLabel.textColor = HEX_RGB(0x13161B);
    }
    return _subTitleLabel;
}

@end
