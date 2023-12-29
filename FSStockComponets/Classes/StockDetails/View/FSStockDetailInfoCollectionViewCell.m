//
//  FSStockDetailInfoCollectionViewCell.m
//  JMQuotesComponets_Example
//
//  Created by fargowealth on 2023/5/30.
//  Copyright © 2023 liyunlong1512. All rights reserved.
//

#import "FSStockDetailInfoCollectionViewCell.h"
#import "QuotationConstant.h"

@interface FSStockDetailInfoCollectionViewCell ()

/** 盘口信息 */
@property (nonatomic, strong) FSStockDetailInfoModel *model;

/** 标题 */
@property (nonatomic, strong) UILabel *titleLab;

/** 描述 */
@property (nonatomic, strong) UILabel *describeLab;

/** 内容 */
@property (nonatomic, strong) UILabel *contentLab;

@end

@implementation FSStockDetailInfoCollectionViewCell

#pragma mark - Initialize Methods

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    
    return self;
}

#pragma mark - Public Methods

- (void)setContentWithModel:(FSStockDetailInfoModel *)model indexPath:(NSIndexPath *)indexPath
{
    self.model = model;
    self.titleLab.text = model.titleStr;
    self.describeLab.text = model.describeStr;
    self.contentLab.text = model.contentStr;
    self.contentLab.textColor = model.myColor;
}

#pragma mark - Private Methods

- (void)createUI {
    
    [self.contentView addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView);
    }];
    
    [self.contentView addSubview:self.describeLab];
    [self.describeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.titleLab.mas_right).mas_offset(2);
    }];
    
    [self.contentView addSubview:self.contentLab];
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView.mas_right);
    }];
    
}

#pragma mark - property

- (UILabel *)contentLab {
    if (!_contentLab) {
        _contentLab = [[UILabel alloc] init];
        _contentLab.text = @"4228.55 万亿";
        _contentLab.font = kFont_Regular(11.f);
        _contentLab.textColor = UIColor.handicapInfoTextColor;
    }
    return _contentLab;
}

- (UILabel *)describeLab {
    if (!_describeLab) {
        _describeLab = [[UILabel alloc] init];
        _describeLab.text = @"";
        _describeLab.font = kFont_Regular(8.f);
        _describeLab.textColor = UIColor.secondaryTextColor;
    }
    return _describeLab;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.text = @"总市值";
        _titleLab.font = kFont_Regular(11.f);
        _titleLab.textColor = UIColor.secondaryTextColor;
    }
    return _titleLab;
}

@end
