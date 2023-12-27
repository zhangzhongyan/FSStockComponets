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

@interface FSStockDetailVC ()<UITableViewDataSource, UITableViewDelegate, FSStockDetailViewDelegate>

@property (nonatomic, strong) FSStockDetailTitleView *titleView;

@property (nonatomic, strong) FSStockDetailToolBarView *toolBarView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) FSStockDetailCell *detailCell;

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
    [self refleshView];
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

- (void)refleshView
{
    self.tableView.hidden = NO;
    [self.tableView reloadData];
    [self.detailCell.stockDetailsView setDataWithHandicapJson:self.viewModel.handicapJson KLineJson:self.viewModel.kLineJson ChartTyep:self.viewModel.kLineChartType];
//    [self refleshHoldingViewIfNeed];
    [self refleshToolBarView];
}

- (void)refleshToolBarView
{
    [self.toolBarView setContentWithVM:self.viewModel.toolBarVM];
}

#pragma mark - <FSStockDetailViewDelegate>

/**
 *  K线时间选择回调
 *  index: 时间周期 0.盘前 1.盘中 2.盘后 3.分时 4.五日 5.日K 6.周K 7.月K 8.年K 9.1分 10.5分 11.15分 12.30分 13.60分
 *  type: 接口需要                                                           5.D 6.W 7.M 8.Y 9.Minute1 10.Minute5 11.Minute15 12.Minute30 13.Minute60
 */
- (void)KLineTimeSelectionWithIndex:(NSInteger)index
                               Type:(NSString *)type;
{
//    //注意它这个index不是index的意思
//    @weakify(self);
//    self.viewModel.allowLoadMore = NO;
//    [self.viewModel setKLineChartType:index];
//    [EVHUDUtils showLoadingOnView:self.view];
//    [self.viewModel sendKLineJsonRequestWithCompletionBlock:^(FSNetworkData * _Nonnull data, __kindof FSBaseRequest * _Nonnull request) {
//        @strongify(self);
//        [EVHUDUtils hideLoadingOnView:self.view];
//        if (!data.isSuccess) {
//            [EVHUDUtils showTextOnView:self.view text:data.errMsg];
//        }
//        //切换了页面必须设置数据
//        [self.detailCell.stockDetailsView updateKLineDataWithJson:self.viewModel.kLineJson ChartTyep:index Weights:self.viewModel.currentWeightText More:NO];
//    }];
}

/**
 *  K线权重选择回调
 *  type: 权重 F: 前复权 B: 后复权 N: 除权
 */
- (void)KLineWeightsSelectionWithType:(NSString *)type
{
//    @weakify(self);
//    self.viewModel.allowLoadMore = NO;
//    if ([type isEqualToString:@"F"]) {
//        [self.viewModel setKLineWeightType:EVKLineWeightTypeFront];
//    }
//    else if ([type isEqualToString:@"B"]) {
//        [self.viewModel setKLineWeightType:EVKLineWeightTypeBack];
//    }
//    else if ([type isEqualToString:@"N"]) {
//        [self.viewModel setKLineWeightType:EVKLineWeightTypeNote];
//    }
//    [EVHUDUtils showLoadingOnView:self.view];
//    [self.viewModel sendKLineJsonRequestWithCompletionBlock:^(FSNetworkData * _Nonnull data, __kindof FSBaseRequest * _Nonnull request) {
//        @strongify(self);
//        [EVHUDUtils hideLoadingOnView:self.view];
//        if (!data.isSuccess) {
//            [EVHUDUtils showTextOnView:self.view text:data.errMsg];
//        }
//        //切换了页面必须设置数据
//        [self.detailCell.stockDetailsView updateKLineDataWithJson:self.viewModel.kLineJson ChartTyep:self.viewModel.kLineChartType Weights:self.viewModel.currentWeightText More:NO];
//    }];
}

/**
 *  获取更多K线数据
 *  timestamp:  时间戳
 */
- (void)GetMoreKLineDataWithTimestamp:(NSString *)timestamp
{
//    @weakify(self);
//    self.viewModel.allowLoadMore = YES;
//    [self.viewModel sendMoreKLineJsonRequestWithTimeStamp:@(timestamp.integerValue * 1000) completionBlock:^(FSNetworkData * _Nonnull data, __kindof FSBaseRequest * _Nonnull request) {
//        @strongify(self);
//        //只有成功、并且是之前页面时(防止切换页面)
//        if (data.isSuccess && self.viewModel.allowLoadMore) {
//            NSDictionary *kLineJson = [request.responseJSONObject isKindOfClass:NSDictionary.class]? request.responseJSONObject: @{};
//            [self.detailCell.stockDetailsView updateKLineDataWithJson:kLineJson ChartTyep:self.viewModel.kLineChartType Weights:self.viewModel.currentWeightText More:YES];
//        }
//    }];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableView.hidden? 0: 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.detailCell;
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.tableView.frame.size.height;
//    if (self.viewModel.canHandleHoldingView) {
//        switch (self.viewModel.holdingVM.status) {
//            case EVStockDetailHoldingStatusPicking:
//            case EVStockDetailHoldingStatusPickDown:
//                return self.tableView.frame.size.height - EVStockDetailHoldingView.minContent;
//            case EVStockDetailHoldingStatusPickUp:
//                return self.tableView.frame.size.height - [EVStockDetailHoldingView maxContentWithVM:self.viewModel.holdingVM];
//        }
//    } else {
//        return self.tableView.frame.size.height - EVStockDetailHoldingEmptyView.viewHeight;
//    }
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

- (FSStockDetailCell *)detailCell {
    if (!_detailCell) {
        _detailCell = [[FSStockDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(FSStockDetailCell.class)];
        _detailCell.stockDetailsView.delegate = self;
    }
    return _detailCell;
}

@end
