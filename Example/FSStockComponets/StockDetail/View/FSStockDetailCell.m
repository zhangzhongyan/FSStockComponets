//
//  FSStockDetailCell.m
//  Fargo
//
//  Created by 张忠燕 on 2023/6/12.
//  Copyright © 2023 geekthings. All rights reserved.
//

#import "FSStockDetailCell.h"
//Helper
#import <Masonry/Masonry.h>

@interface FSStockDetailCell ()

@end

@implementation FSStockDetailCell

#pragma mark - Initialize Methods

#pragma mark - Initialize Methods

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubviews];
        [self setupConstraints];
    }
    return self;
}

#pragma mark - Private Methods

- (void)setupSubviews {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = UIColor.whiteColor;
    
    [self.contentView addSubview:self.stockDetailsView];

}

- (void)setupConstraints {
    [self.stockDetailsView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

#pragma mark - property

// 初始化
- (JMStockDetailsView *)stockDetailsView{
    if (!_stockDetailsView) {
        _stockDetailsView = [[JMStockDetailsView alloc] init];
    }
    return _stockDetailsView;
}

@end
