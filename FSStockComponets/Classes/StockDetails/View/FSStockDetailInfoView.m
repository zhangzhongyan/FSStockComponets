//
//  FSStockDetailInfoView.m
//  JMQuotesComponets_Example
//
//  Created by fargowealth on 2023/5/30.
//  Copyright © 2023 liyunlong1512. All rights reserved.
//

#import "FSStockDetailInfoView.h"
#import "QuotationConstant.h"
#import "FSStockDetailInfoCollectionViewCell.h"
//Helper
#import "NSBundle+FSStockComponents.h"
#import "FSStockComponetsLanguage.h"
#import <FSOCCategories/UIButton+FSHitEdgeInsets.h>
#import <FSOCUtils/FSDeviceUtils.h>

@interface FSStockDetailInfoView ()<UICollectionViewDataSource, UICollectionViewDelegate>

/** 最新价格 */
@property (nonatomic, strong) UILabel *latestPriceLab;

/** 涨跌额 */
@property (nonatomic, strong) UILabel *changeAmountLab;

/// 涨跌幅
@property (nonatomic, strong) UILabel *quoteChangeLab;

/** 交易状态 */
@property (nonatomic, strong) UILabel *tradingStatusLab;

/** 盘口信息*/
@property (nonatomic, strong) UICollectionView *handicapInfoCollectionView;

/** 展开按钮 */
@property (nonatomic, strong) UIButton *expandBtn;
@property (nonatomic, strong) UIImageView *expandImageView;

@property (nonatomic, assign) FSStockDetailInfoCellType cellType;

@end

@implementation FSStockDetailInfoView

#pragma mark - Initialize Methods

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.cellType = [FSStockComponetsLanguage isChineseLanguage]? FSStockDetailInfoCellTypeChina: FSStockDetailInfoCellTypeEnglish;
        [self createUI];
    }
    return self;
}

#pragma mark - Private Methods

- (void)createUI {
    
    self.backgroundColor = UIColor.backgroundColor;
    
    [self addSubview:self.latestPriceLab];
    [self.latestPriceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self).mas_offset(16);
    }];
    
    [self addSubview:self.changeAmountLab];
    [self.changeAmountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.latestPriceLab.mas_top).mas_offset(8);
        make.left.mas_equalTo(self.latestPriceLab.mas_right).mas_offset(10);
    }];
    
    [self addSubview:self.quoteChangeLab];
    [self.quoteChangeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.changeAmountLab.mas_bottom);
        make.left.mas_equalTo(self.changeAmountLab);
    }];
    
    [self addSubview:self.tradingStatusLab];
    [self.tradingStatusLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.latestPriceLab.mas_bottom);
        make.left.mas_equalTo(self.latestPriceLab);
    }];
    
    [self addSubview:self.handicapInfoCollectionView];
    [self.handicapInfoCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tradingStatusLab.mas_bottom).mas_offset(16);
        make.left.right.mas_equalTo(self);
        make.height.mas_offset(kHeightScale(3*[FSStockDetailInfoCollectionViewCell cellHeightWithType:self.cellType]));
    }];
    
    [self addSubview:self.expandImageView];
    [self.expandImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.handicapInfoCollectionView.mas_bottom);
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-10);
        make.size.mas_offset(kWidthScale(10));
    }];
    
    [self addSubview:self.expandBtn];
    [self.expandBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.expandImageView);
        make.size.mas_offset(kWidthScale(30));
    }];
    
}

+ (CGFloat)collectionCellHorizontalGap
{
    return 12;
}

+ (CGFloat)collectionViewLeftOffset
{
    return 16;
}

#pragma mark - ExpandBtnClick

- (void)ExpandBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.handicapInfoCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(kHeightScale(8*[FSStockDetailInfoCollectionViewCell cellHeightWithType:self.cellType]));
        }];
        self.expandImageView.image = [NSBundle fsStockUI_imageName:@"expand_s.png"];
    } else {
        [self.handicapInfoCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(kHeightScale(3*[FSStockDetailInfoCollectionViewCell cellHeightWithType:self.cellType]));
        }];
        self.expandImageView.image = [NSBundle fsStockUI_imageName:@"expand_n.png"];
    }
    
    if ([self.delegate respondsToSelector:@selector(setIsExpand:)]) {
        [self.delegate setIsExpand:sender.selected];
    }
    
    [self.handicapInfoCollectionView reloadData];
}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate

// 点击元素响应方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

// 和UITableView类似，UICollectionView也可设置段头段尾
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        return headerView;
        
    } else {
        
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        return footerView;
        
    }
    
}

//  设置页脚(水平滑动的时候设置width,垂直滑动的时候设置height)
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    
    return CGSizeMake(kFS_ScreenWidth, 0);
}

//  设置页眉(水平滑动的时候设置width,垂直滑动的时候设置height)
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeMake(kFS_ScreenWidth, 0);
}

//  定义每个单元格相互之间的距离
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 12;
}

//  定义单元格所在行line之间的距离,前一行和后一行的距离
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{

    return 0;
}

//  设置分区
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

//  定义每个分区上的元素个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.expandBtn.isSelected ? self.stockInfoViewModel.handicapInfoList.count : 9;
}

//  设置每个元素大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //cell宽
    CGFloat totalHorizontalGap = [FSStockDetailInfoView collectionViewLeftOffset] * 2 + [FSStockDetailInfoView collectionCellHorizontalGap] * 2;
    CGFloat width = (kFS_ScreenWidth - totalHorizontalGap) / [FSStockDetailInfoCollectionViewCell columnsCount];
    return CGSizeMake(width, [FSStockDetailInfoCollectionViewCell cellHeightWithType:self.cellType]);
}

//  定义每个元素的margin(边缘 上-左-下-右)
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, [FSStockDetailInfoView collectionViewLeftOffset], 0, [FSStockDetailInfoView collectionViewLeftOffset]);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    FSStockDetailInfoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FSStockDetailInfoCollectionViewCell" forIndexPath:indexPath];
    [cell setContentWithModel:self.stockInfoViewModel.handicapInfoList[indexPath.row] indexPath:indexPath type:self.cellType];
    return cell;
    
}

#pragma mark — Lazy

- (UIButton *)expandBtn {
    if (!_expandBtn) {
        _expandBtn = [[UIButton alloc] init];
//        [_expandBtn setBackgroundImage:[NSBundle fsStockUI_imageName:@"expand_n.png")] forState:UIControlStateNormal];
//        [_expandBtn setBackgroundImage:[NSBundle fsStockUI_imageName:@"expand_s.png")] forState:UIControlStateHighlighted];
//        [_expandBtn setBackgroundImage:[NSBundle fsStockUI_imageName:@"expand_s.png")] forState:UIControlStateSelected];
//        [_expandBtn setTouchAreaInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        [_expandBtn addTarget:self action:@selector(ExpandBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _expandBtn.hitEdgeInsets = UIEdgeInsetsMake(-10, -10, -10, -10);
    }
    return _expandBtn;
}

- (UIImageView *)expandImageView {
    if (!_expandImageView) {
        _expandImageView = [[UIImageView alloc] init];
        _expandImageView.image = [NSBundle fsStockUI_imageName:@"expand_n.png"];
    }
    return _expandImageView;
}

- (UICollectionView *)handicapInfoCollectionView {
    if (!_handicapInfoCollectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _handicapInfoCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _handicapInfoCollectionView.backgroundColor = UIColor.backgroundColor;
        _handicapInfoCollectionView.dataSource = self;
        _handicapInfoCollectionView.delegate = self;
        _handicapInfoCollectionView.showsVerticalScrollIndicator = NO;
        _handicapInfoCollectionView.showsHorizontalScrollIndicator = NO;
        
        //默认cell
        [_handicapInfoCollectionView registerClass:[FSStockDetailInfoCollectionViewCell class] forCellWithReuseIdentifier:@"FSStockDetailInfoCollectionViewCell"];
        //默认组头
        [_handicapInfoCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
        //默认组尾
        [_handicapInfoCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView"];
        
    }
    return _handicapInfoCollectionView;
}

- (UILabel *)tradingStatusLab {
    if (!_tradingStatusLab) {
        _tradingStatusLab = [[UILabel alloc] init];
        _tradingStatusLab.text = @"--";
        _tradingStatusLab.font = kFont_Regular(11);
        _tradingStatusLab.textColor = UIColor.secondaryTextColor;
    }
    return _tradingStatusLab;
}

- (UILabel *)quoteChangeLab {
    if (!_quoteChangeLab) {
        _quoteChangeLab = [[UILabel alloc] init];
        _quoteChangeLab.text = @"--";
        _quoteChangeLab.font = kFont_Regular(14);
        _quoteChangeLab.textColor = UIColor.flatColor;
    }
    return _quoteChangeLab;
}

- (UILabel *)changeAmountLab {
    if (!_changeAmountLab) {
        _changeAmountLab = [[UILabel alloc] init];
        _changeAmountLab.text = @"--";
        _changeAmountLab.font = kFont_Regular(14);
        _changeAmountLab.textColor = UIColor.flatColor;
    }
    return _changeAmountLab;
}

- (UILabel *)latestPriceLab {
    if (!_latestPriceLab) {
        _latestPriceLab = [[UILabel alloc] init];
        _latestPriceLab.text = @"--";
        _latestPriceLab.font = kFont_Regular(40);
        _latestPriceLab.textColor = UIColor.flatColor;
    }
    return _latestPriceLab;
}

#pragma mark - 数据重载

- (void)setStockInfoViewModel:(FSStockDetailInfoViewModel *)stockInfoViewModel {
    _stockInfoViewModel = stockInfoViewModel;
    
    self.latestPriceLab.text = stockInfoViewModel.price.length? stockInfoViewModel.price: @"--";
    self.latestPriceLab.textColor = stockInfoViewModel.priceColor;
    
    self.changeAmountLab.text = stockInfoViewModel.change.length? stockInfoViewModel.change: @"--";
    self.changeAmountLab.textColor = stockInfoViewModel.changeColor;
    
    self.quoteChangeLab.text = stockInfoViewModel.changePct.length? stockInfoViewModel.changePct: @"--";
    self.quoteChangeLab.textColor = stockInfoViewModel.changePctColor;
    
    self.tradingStatusLab.text = stockInfoViewModel.tradingStatus.length? stockInfoViewModel.tradingStatus: @"--";
    
    [self.handicapInfoCollectionView reloadData];
    
}

@end
