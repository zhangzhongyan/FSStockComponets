//
//  FSStockDetailToolBarView.m
//  Fargo
//
//  Created by 张忠燕 on 2023/6/16.
//  Copyright © 2023 geekthings. All rights reserved.
//

#import "FSStockDetailToolBarView.h"
//Helper
#import <FSOCCategories/UIButton+FSHitEdgeInsets.h>
#import <FSOCUtils/FSDeviceUtils.h>
#import "FSColorMacro.h"
#import <FSOCUtils/FSSizeScaleUtils.h>
#import <Masonry.h>
#import "EVLanguage.h"
#import "FSFontMacro.h"

@interface FSStockDetailToolBarView ()

@property (nonatomic, strong) UIView *lineView;

@end

@implementation FSStockDetailToolBarView

#pragma mark - Initialize Methods

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
        [self setupConstraints];
    }
    return self;
}

#pragma mark - Public Methods

+ (CGFloat)viewHeight
{
    return 60 + FSDeviceUtils.safeAreaInsetsBottom;
}

- (void)setContentWithVM:(FSStockDetailToolBarVM *)vm
{
    self.enquiryRecordButton.selected = !vm.enquiryRecord;
    self.orderRecordButton.selected = !vm.orderRecord;
    self.enquiryButton.selected = !vm.enquiry;
    self.orderButton.selected = !vm.order;
    self.addWatchButton.hidden = vm.addWatch;
    self.unAddWatchButton.hidden = !vm.addWatch;
    
    //询价
    self.enquiryButton.layer.borderColor = vm.enquiry? HEX_RGB(0x29477D).CGColor: HEX_RGB(0xA0ADC5).CGColor;
    
    //下单
    self.orderButton.backgroundColor = vm.order? HEX_RGB(0x11326F): HEX_RGB(0xA0ADC5);
}

#pragma mark - Private Methods

- (void)setupSubviews
{
    [self addSubview:self.lineView];
    [self addSubview:self.enquiryRecordButton];
    [self addSubview:self.orderRecordButton];
    [self addSubview:self.addWatchButton];
    [self addSubview:self.unAddWatchButton];
    [self addSubview:self.enquiryButton];
    [self addSubview:self.orderButton];
}

- (void)setupConstraints
{
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.equalTo(@(1));
    }];
    
    [self.enquiryRecordButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.height.equalTo(@(40));
        make.top.equalTo(self).offset(10);
    }];
    
    [self.orderRecordButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.enquiryRecordButton.mas_right).offset(0);
        make.height.top.equalTo(self.enquiryRecordButton);
    }];
    
    [self.unAddWatchButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.orderRecordButton.mas_right).offset(0);
        make.height.top.equalTo(self.enquiryRecordButton);
    }];
    
    [self.addWatchButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.unAddWatchButton);
    }];
    
    [self.orderButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.top.equalTo(self).offset(13);
        make.width.equalTo(@(sizeCeilScaleX(74)));
        make.height.equalTo(@(34));
    }];
    
    [self.enquiryButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.top.equalTo(self.orderButton);
        make.right.equalTo(self.orderButton.mas_left).offset(-12);
    }];
}

#pragma mark - property

- (UIButton *)enquiryRecordButton {
    if (!_enquiryRecordButton) {
        _enquiryRecordButton = S_FONT(10.0f);
        _enquiryRecordButton.titleLabel.font = [UIFont systemFontOfSize:10];
        [_enquiryRecordButton setTitle:EVLanguage(@"询价记录") forState:UIControlStateNormal];
        [_enquiryRecordButton setTitleColor:HEX_RGB(0x7787A2) forState:UIControlStateNormal];
        [_enquiryRecordButton setTitleColor:HEX_RGB(0xBCC4D0) forState:UIControlStateSelected];
        [_enquiryRecordButton setImage:[UIImage imageNamed:@"watchList_enquiryRecord"] forState:UIControlStateNormal];
        [_enquiryRecordButton setImage:[UIImage imageNamed:@"watchList_enquiryRecordHL"] forState:UIControlStateSelected];
    }
    return _enquiryRecordButton;
}

- (UIButton *)orderRecordButton {
    if (!_orderRecordButton) {
        _orderRecordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _orderRecordButton.titleLabel.font = S_FONT(10.0f);
        [_orderRecordButton setTitle:EVLanguage(@"下单记录(自选股)") forState:UIControlStateNormal];
        [_orderRecordButton setTitleColor:HEX_RGB(0x7787A2) forState:UIControlStateNormal];
        [_orderRecordButton setTitleColor:HEX_RGB(0xBCC4D0) forState:UIControlStateSelected];
        [_orderRecordButton setImage:[UIImage imageNamed:@"watchList_orderRecord"] forState:UIControlStateNormal];
        [_orderRecordButton setImage:[UIImage imageNamed:@"watchList_orderRecordHL"] forState:UIControlStateSelected];
    }
    return _orderRecordButton;
}

- (UIButton *)addWatchButton {
    if (!_addWatchButton) {
        _addWatchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addWatchButton.titleLabel.font = S_FONT(10.0f);
        [_addWatchButton setTitle:EVLanguage(@"加自选") forState:UIControlStateNormal];
        [_addWatchButton setTitleColor:HEX_RGB(0x7787A2) forState:UIControlStateNormal];
        [_addWatchButton setImage:[UIImage imageNamed:@"watchList_add"] forState:UIControlStateNormal];
    }
    return _addWatchButton;
}

- (UIButton *)unAddWatchButton {
    if (!_unAddWatchButton) {
        _unAddWatchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _unAddWatchButton.titleLabel.font = S_FONT(10.0f);
        [_unAddWatchButton setTitle:EVLanguage(@"已添加") forState:UIControlStateNormal];
        [_unAddWatchButton setTitleColor:HEX_RGB(0x7787A2) forState:UIControlStateNormal];
        [_unAddWatchButton setImage:[UIImage imageNamed:@"watchList_delete"] forState:UIControlStateNormal];
        _unAddWatchButton.hidden = YES;
    }
    return _unAddWatchButton;
}


- (UIButton *)enquiryButton {
    if (!_enquiryButton) {
        _enquiryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _enquiryButton.titleLabel.font = S_FONT(14.0f);
        [_enquiryButton setTitle:EVLanguage(@"询价(股票)") forState:UIControlStateNormal];
        [_enquiryButton setTitleColor:HEX_RGB(0x29477D) forState:UIControlStateNormal];
        [_enquiryButton setTitleColor:HEX_RGB(0xA0ADC5) forState:UIControlStateSelected];
        _enquiryButton.hitEdgeInsets = UIEdgeInsetsMake(-11.0f, -10.0f, -11.0f, -11.0f);
        _enquiryButton.layer.cornerRadius = 17;
        _enquiryButton.layer.masksToBounds = YES;
        _enquiryButton.layer.borderColor = HEX_RGB(0x29477D).CGColor;
        _enquiryButton.layer.borderWidth = 1;
    }
    return _enquiryButton;
}

- (UIButton *)orderButton {
    if (!_orderButton) {
        _orderButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _orderButton.titleLabel.font = S_FONT(14.0f);
        [_orderButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_orderButton setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
        [_orderButton setTitle:EVLanguage(@"下单(股票)") forState:UIControlStateNormal];
        _orderButton.hitEdgeInsets = UIEdgeInsetsMake(-11.0f, -11.0f, -11.0f, -10.0f);
        _orderButton.layer.cornerRadius = 17;
        _orderButton.layer.masksToBounds = YES;
        _orderButton.backgroundColor = HEX_RGB(0x11326F);
    }
    return _orderButton;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = HEX_RGB(0xF3F4F7);
    }
    return _lineView;
}

@end
