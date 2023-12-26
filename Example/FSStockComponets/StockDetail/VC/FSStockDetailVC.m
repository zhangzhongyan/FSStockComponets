//
//  FSStockDetailVC.m
//  FSStockComponets_Example
//
//  Created by 张忠燕 on 2023/12/22.
//  Copyright © 2023 张忠燕. All rights reserved.
//

#import "FSStockDetailVC.h"
//View
#import "FSStockDetailTitleView.h"
#import "FSStockDetailCell.h"
#import "FSStockDetailToolBarView.h"
//Helper
#import "FSColorMacro.h"
#import <Masonry/Masonry.h>

@interface FSStockDetailVC ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) FSStockDetailTitleView *titleView;

@property (nonatomic, strong) FSStockDetailToolBarView *toolBarView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) FSStockDetailVM *viewModel;

@end

@implementation FSStockDetailVC

#pragma mark - Initialize Methods

- (instancetype)initWithVM:(FSStockDetailVM *)viewModel
{
    self = [super init];
    if (self) {
        _viewModel = viewModel;
    }
    return self;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
    [self setupConstraints];
    [self refleshToolBarView];
}


#pragma mark - Private Methods

- (void)setupSubviews
{
    self.tableView.hidden = YES;
    self.tableView.backgroundColor = HEX_RGB(0xF5F6FA);
    self.view.backgroundColor = HEX_RGB(0xF5F6FA);

    [self.view addSubview:self.tableView];
    
//    self.hideHeaderRefresh = YES; //不处理刷新
    self.navigationItem.titleView = self.titleView;
//    [self setNavigationRightBarButtonItemWithImage:[UIImage imageNamed:@"nav_search_icon"] target:self action:@selector(clickSearchButton)];
//    [self.view addSubview:self.holdingView];
    [self.view addSubview:self.toolBarView];
//    [self.view addSubview:self.holdingEmptyView];
}

- (void)setupConstraints
{
    [self.toolBarView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@([FSStockDetailToolBarView viewHeight]));
    }];
//
//    [self.holdingEmptyView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(self.view);
//        make.bottom.equalTo(self.toolBarView.mas_top);
//        make.height.equalTo([EVStockDetailHoldingEmptyView viewHeight]);
//    }];
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.toolBarView.mas_top);
    }];
}

- (void)refleshToolBarView
{
    [self.toolBarView setContentWithVM:self.viewModel.toolBarVM];
}

#pragma mark - Property

- (FSStockDetailTitleView *)titleView {
    if (!_titleView) {
        _titleView = [[FSStockDetailTitleView alloc] init];
        _titleView.titleLabel.text = self.viewModel.stockModel.name.length? self.viewModel.stockModel.name: @"--";
        _titleView.subTitleLabel.text = self.viewModel.stockModel.assetId.length? self.viewModel.stockModel.assetId: @"--";
    }
    return _titleView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = 0.0f;
        
        //关闭估算行高
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
    }
    return _tableView;
}

- (FSStockDetailToolBarView *)toolBarView {
    if (!_toolBarView) {
        _toolBarView = [[FSStockDetailToolBarView alloc] initWithFrame:CGRectZero];
        _toolBarView.backgroundColor = UIColor.whiteColor;
//        [_toolBarView.enquiryRecordButton addTarget:self action:@selector(clickEnquiryRecordButton:) forControlEvents:UIControlEventTouchUpInside];
//        [_toolBarView.orderRecordButton addTarget:self action:@selector(clickOrderRecordButton:) forControlEvents:UIControlEventTouchUpInside];
//        [_toolBarView.addWatchButton addTarget:self action:@selector(clickAddStockRecordButton:) forControlEvents:UIControlEventTouchUpInside];
//        [_toolBarView.unAddWatchButton addTarget:self action:@selector(clickAddStockRecordButton:) forControlEvents:UIControlEventTouchUpInside];
//        [_toolBarView.enquiryButton addTarget:self action:@selector(clickEnquiryButton:) forControlEvents:UIControlEventTouchUpInside];
//        [_toolBarView.orderButton addTarget:self action:@selector(clickOrderButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _toolBarView;
}

@end
