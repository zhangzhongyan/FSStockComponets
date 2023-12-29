//
//  FSStockListVC.m
//  FSStockComponets
//
//  Created by 张忠燕 on 12/22/2023.
//  Copyright (c) 2023 张忠燕. All rights reserved.
//

//VC
#import "FSStockListVC.h"
#import "FSStockDetailVC.h"
//View
#import "FSStockListCell.h"
//Helper
#import "FSColorMacro.h"
#import "EVLanguage.h"
#import <FSStockComponets/FSStockComponetsLanguage.h>

@interface FSStockListVC ()<UITableViewDataSource, UITableViewDelegate, QuotationListDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) FSStockListCell *watchlistCell;

@property (nonatomic, strong, nullable) NSMutableArray *jsonList;

@end

@implementation FSStockListVC

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [FSStockComponetsLanguage setUserPreferredLanguage:FSStockComponetsLanguageTypeSimpleChinese];

    [self setupData];
    [self setupSubviews];
    [self setupConstraints];
    [self.watchlistCell.quotationListView setDataJsonList:self.jsonList];
}

#pragma mark - Private Methods

- (void)setupSubviews
{
    self.tableView.frame = self.view.bounds;
    self.tableView.backgroundColor = HEX_RGB(0xF5F6FA);
    self.title = EVLanguage(@"自选股");
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
}

- (void)setupConstraints
{
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view);
    }];
}

- (void)setupData
{
    NSDictionary *jsonListDict = [FSStockListVC jsonObjectWithResource:@"hqlist" type:@"json"];
    NSArray *jsonList = [jsonListDict objectForKey:@"datas"];
    self.jsonList = [jsonList isKindOfClass:NSArray.class]? [NSMutableArray arrayWithArray:jsonList]: nil;
}

+ (nullable id)jsonObjectWithResource:(NSString *)resource type:(NSString *)type
{
    // 获取 JSON 文件的路径
    NSString *path = [[NSBundle mainBundle] pathForResource:resource ofType:type];
    // 读取 JSON 文件数据
    NSData *data = [NSData dataWithContentsOfFile:path];
    // 将 JSON 数据转换为 Objective-C 对象
    NSError *error = nil;
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    return jsonObject;
}

#pragma mark - <QuotationListDelegate>

/**
 *  选中个股回调
 *  stockCode: 股票代码
 */
- (void)quotationListDelegateWithSelectedModel:(JMQuotationListModel *)model
{
    FSStockDetailVM *vm = [[FSStockDetailVM alloc] initWithStockModel:model kLineChartType:FSKLineChartTypeMinuteHour kLineWeightType:FSKLineWeightTypeFront];
    FSStockDetailVC *vc = [[FSStockDetailVC alloc] initWithVM:vm];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  自选股分类选择回调
 *  index: 选中下标
 */
- (void)quotationListDelegateWithSelectedCategoryIndex:(NSInteger)index
{
//    EVWatchListIndex nextInex = self.viewModel.index;
//    switch (index) {
//        case 0: {
//            nextInex = EVWatchListIndexAll;
//            break;
//        }
//        case 1: {
//            nextInex = EVWatchListIndexHK;
//            break;
//        }
//        case 2: {
//            nextInex = EVWatchListIndexUS;
//            break;
//        }
//        default: {
//            break;
//        }
//    }
//
//    [self.viewModel setIndex:nextInex];
//
//    @weakify(self);
//    [EVHUDUtils showLoadingOnView:self.view];
//    [self.viewModel sendWatchListRequestWithCompletionBlock:^(FSNetworkData * _Nonnull data, __kindof FSBaseRequest * _Nonnull request) {
//        @strongify(self);
//        [EVHUDUtils hideLoadingOnView:self.view];
//        if (!data.isSuccess) {
//            [EVHUDUtils showTextOnView:self.view text:data.errMsg];
//        }
//        [self refleshView];
//        [self subscribleStockQuotation];
//    }];
}

/**
 *  删除个股回调
 *  stockCode: 股票代码
 */
- (void)deleteOptionalStockWithSelectedStockCode:(NSString *)stockCode
                          fetchCompletionHandler:(void (^)(BOOL isDelete))completionHandler
{
//    EVQuotationSubscribleStockModel *targetModel = [self.viewModel targetModelWithAssetId:stockCode];
//    if (!targetModel) {
//        [EVHUDUtils showTextOnView:self.view text:EVLanguage(@"参数错误")];
//        return;
//    }
//
//    @weakify(self);
//    [EVHUDUtils showLoadingOnView:self.view];
//    [self.viewModel sendDeleteRequestWithStockModel:targetModel completionBlock:^(FSNetworkData * _Nonnull data, __kindof FSBaseRequest * _Nonnull request) {
//        @strongify(self);
//        [EVHUDUtils hideLoadingOnView:self.view];
//        completionHandler(data.isSuccess);
//    }];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.watchlistCell;
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.tableView.frame.size.height;
}



#pragma mark - Property

- (FSStockListCell *)watchlistCell {
    if (!_watchlistCell) {
        _watchlistCell = [[FSStockListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(FSStockListCell.class)];
        _watchlistCell.quotationListView.delegate = self;
    }
    return _watchlistCell;
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

@end
