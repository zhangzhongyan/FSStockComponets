//
//  EVWatchListCell.m
//  FSStockComponets_Example
//
//  Created by 张忠燕 on 2023/12/22.
//  Copyright © 2023 张忠燕. All rights reserved.
//

#import "FSStockListCell.h"

@interface FSStockListCell ()

@end

@implementation FSStockListCell

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
    
    [self.contentView addSubview:self.quotationListView];

}

- (void)setupConstraints {
    [self.quotationListView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

#pragma mark - property

// 初始化
- (JMQuotationListView *)quotationListView{
    if (!_quotationListView) {
        _quotationListView = [[JMQuotationListView alloc] init];
    }
    return _quotationListView;
}

@end

