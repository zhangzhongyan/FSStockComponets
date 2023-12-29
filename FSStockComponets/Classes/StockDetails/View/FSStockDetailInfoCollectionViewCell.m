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

@property (nonatomic, strong, nullable) NSIndexPath *cell_indexPath;

@property (nonatomic, assign) FSStockDetailInfoCellType type;

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
        [self setupSubviews];
        [self setupConstraints];
    }
    
    return self;
}

#pragma mark - Public Methods

- (void)setContentWithModel:(FSStockDetailInfoModel *)model indexPath:(NSIndexPath *)indexPath type:(FSStockDetailInfoCellType)type
{
    self.model = model;
    self.cell_indexPath = indexPath;
    self.type = type;
    self.titleLab.text = model.titleStr;
    self.describeLab.text = model.describeStr;
    self.contentLab.text = model.contentStr;
    self.contentLab.textColor = model.myColor;
    [self setupConstraints];
}

+ (NSInteger)columnsCount
{
    return 3;
}

#pragma mark - Private Methods

- (void)setupSubviews
{
    [self.contentView addSubview:self.titleLab];
    [self.contentView addSubview:self.describeLab];
    [self.contentView addSubview:self.contentLab];

}

- (void)setupConstraints
{
    switch (self.type) {
        case FSStockDetailInfoCellTypeChina: {
            [self.titleLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.contentView);
                make.left.mas_equalTo(self.contentView);
            }];
            
            [self.describeLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.contentView);
                make.left.mas_equalTo(self.titleLab.mas_right).mas_offset(2);
            }];
            
            [self.contentLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.contentView);
                make.right.mas_equalTo(self.contentView.mas_right);
            }];
            break;
        }
            
        case FSStockDetailInfoCellTypeEnglish: {
            
//            NSInteger row = self.cell_indexPath.row / [FSStockDetailInfoCollectionViewCell columnsCount];
            NSInteger column = self.cell_indexPath.row % [FSStockDetailInfoCollectionViewCell columnsCount];
            switch (column) {
                case 0: {
                    [self.titleLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.top.left.mas_equalTo(self.contentView);
                    }];
                    
                    [self.describeLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.centerY.mas_equalTo(self.contentView);
                        make.left.mas_equalTo(self.titleLab.mas_right).mas_offset(2);
                    }];
                    
                    [self.contentLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(self.titleLab.mas_bottom).mas_offset(2);
                        make.left.mas_equalTo(self.titleLab);
                    }];
                    
                    break;
                }
                case 1: {
                    
                    [self.titleLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.top.centerX.mas_equalTo(self.contentView);
                    }];
                    
                    [self.describeLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.centerY.mas_equalTo(self.contentView);
                        make.left.mas_equalTo(self.titleLab.mas_right).mas_offset(2);
                    }];
                    
                    [self.contentLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(self.titleLab.mas_bottom).mas_offset(2);
                        make.centerX.mas_equalTo(self.titleLab);
                    }];
                    
                    break;
                }
                case 2: {
                    
                    [self.titleLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.top.right.mas_equalTo(self.contentView);
                    }];
                    
                    [self.describeLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.centerY.mas_equalTo(self.contentView);
                        make.right.mas_equalTo(self.titleLab.mas_left).mas_offset(-2);
                    }];
                    
                    [self.contentLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(self.titleLab.mas_bottom).mas_offset(2);
                        make.right.mas_equalTo(self.titleLab);
                    }];
                    break;
                }
            }
            
            break;
        }
    }
   
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
