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
        [self setupConstraintsAndTextAligmentAndFont];
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
    [self setupConstraintsAndTextAligmentAndFont];
}

+ (NSInteger)columnsCount
{
    return 3;
}

+ (CGFloat)cellHeightWithType:(FSStockDetailInfoCellType)type
{
    switch (type) {
        case FSStockDetailInfoCellTypeChina:
            return ceil(kHeightScale(20));
        case FSStockDetailInfoCellTypeEnglish:
            return ceil(kHeightScale(44));
    }
}

#pragma mark - Private Methods

- (void)setupSubviews
{
    [self.contentView addSubview:self.titleLab];
    [self.contentView addSubview:self.describeLab];
    [self.contentView addSubview:self.contentLab];

}

- (void)setupConstraintsAndTextAligmentAndFont
{
    switch (self.type) {
        case FSStockDetailInfoCellTypeChina: {
            
            self.titleLab.textAlignment = NSTextAlignmentLeft;
            self.titleLab.font = kFont_Regular(11.f);
            
            self.describeLab.textAlignment = NSTextAlignmentLeft;
            self.describeLab.font = kFont_Regular(8.f);
            self.describeLab.hidden = NO;
            
            self.contentLab.textAlignment = NSTextAlignmentLeft;
            self.contentLab.font = kFont_Regular(11.f);

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
            
            self.titleLab.font = kFont_Regular(12.f);
            self.describeLab.font = kFont_Regular(12.f);
            self.contentLab.font = kFont_Regular(12.f);
            
            self.describeLab.hidden = YES;
            
            CGFloat height = ceil(kHeightScale(17));
            [self.titleLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.mas_equalTo(self.contentView);
                make.height.equalTo(@(height));
            }];
            
            [self.contentLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.titleLab.mas_bottom).mas_offset(2);
                make.left.right.mas_equalTo(self.titleLab);
                make.height.equalTo(@(height));
            }];
            
            NSInteger column = self.cell_indexPath.row % [FSStockDetailInfoCollectionViewCell columnsCount];
            switch (column) {
                case 0: {
                   
                    self.titleLab.textAlignment = NSTextAlignmentLeft;
                    self.describeLab.textAlignment = NSTextAlignmentLeft;
                    self.contentLab.textAlignment = NSTextAlignmentLeft;
                    
                    break;
                }
                case 1: {
         
                    self.titleLab.textAlignment = NSTextAlignmentCenter;
                    self.describeLab.textAlignment = NSTextAlignmentCenter;
                    self.contentLab.textAlignment = NSTextAlignmentCenter;
                    
                    break;
                }
                case 2: {
                    
                    self.titleLab.textAlignment = NSTextAlignmentRight;
                    self.describeLab.textAlignment = NSTextAlignmentRight;
                    self.contentLab.textAlignment = NSTextAlignmentRight;
                    
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
