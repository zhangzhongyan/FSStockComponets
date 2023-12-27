//
//  FSStockDetailView.m
//  JMQuotesComponets_Example
//
//  Created by fargowealth on 2023/5/30.
//  Copyright © 2023 liyunlong1512. All rights reserved.
//

#import "FSStockDetailView.h"
#import "FSStockDetailChartView.h"

#import "QuotationConstant.h"
#import "JMDelayPromptView.h"
#import "FSStockDetailInfoView.h"
#import <MJExtension/MJExtension.h>
#import "WOCrashProtectorManager.h"

@interface FSStockDetailView ()<DelayPromptViewDelegate, FSStockDetailChartViewDelegate, StockInfoViewDelegate>

@property (nonatomic, assign) FSKLineChartType seletedKLineChartType;

/** 滚动视图 */
@property (nonatomic, strong) UIScrollView *scrollView;

/** 延时行情提示 */
@property (nonatomic,strong) JMDelayPromptView *delayPromptView;

/** 股票信息view */
@property (nonatomic, strong) FSStockDetailInfoView *stockInfoView;

/** K线图view */
@property (nonatomic, strong) FSStockDetailChartView *middleLayerView;

/** 盘口信息数据源 */
@property (nonatomic, strong) FSStockDetailInfoModel *stockInfoModel;

/** 初始K线信息数据 */
//@property (nonatomic, strong) NSDictionary *kLineJson;
@property (nonatomic, strong) NSMutableArray *klineDataList;

/** <#注释#> */
@property(nonatomic, assign) CGFloat aaa;
@property(nonatomic, assign) CGFloat bbb;

@end

@implementation FSStockDetailView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //开启防crash机制
        [WOCrashProtectorManager makeAllEffective];
        
        self.seletedKLineChartType = FSKLineChartTypeMinuteHour; //默认分时
        [self createUI];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:kNoticeName_GetMoreData object:nil];
        
        [self performSelector:@selector(delayedMethod) withObject:nil afterDelay:1.0];
        
    }
    return self;
}

- (void)delayedMethod {
//    NSLog(@"1秒后执行了这个方法");
    // 将 myView 的位置转换为 scrollView 的坐标系
    CGRect myViewFrameInScrollView = [self.middleLayerView convertRect:self.middleLayerView.frame toView:self.scrollView];
//    // 输出 myView 在 scrollView 中的位置和大小
//    NSLog(@"myView 在 scrollView 中的位置：(%f, %f)", myViewFrameInScrollView.origin.x, myViewFrameInScrollView.origin.y);
//    NSLog(@"myView 在 scrollView 中的大小：(%f, %f)", myViewFrameInScrollView.size.width, myViewFrameInScrollView.size.height);
    self.middleLayerView.originY = myViewFrameInScrollView.size.height;
    self.aaa = myViewFrameInScrollView.origin.y;
    self.bbb = myViewFrameInScrollView.size.height;
}

- (void)createUI {
    
    self.backgroundColor = UIColor.stockDetailsBackgroundColor;
    
    [self addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self);
//        make.width.mas_offset(kScreenWidth);
    }];

    [self.scrollView addSubview:self.delayPromptView];
    [self.delayPromptView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.scrollView.mas_top);
        make.left.mas_equalTo(self.scrollView.mas_left);
//        make.right.mas_equalTo(self.scrollView.mas_right);
        make.width.equalTo(self.scrollView.mas_width);
        make.height.equalTo(@([JMDelayPromptView viewHeight]));
    }];

    [self.scrollView addSubview:self.stockInfoView];
    [self.stockInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.delayPromptView.mas_bottom);
        make.left.mas_equalTo(self.scrollView.mas_left);
        make.width.equalTo(self.scrollView.mas_width);
    }];

    [self.scrollView addSubview:self.middleLayerView];
    [self.middleLayerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.stockInfoView.mas_bottom).mas_offset(14);
        make.left.mas_equalTo(self.scrollView.mas_left);
        make.width.equalTo(self.scrollView.mas_width);
        make.height.mas_offset(kHeightScale(345));
        make.bottom.equalTo(self.scrollView.mas_bottom);
    }];
    
//    [self addSubview:self.delayPromptView];
//    [self.delayPromptView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.mas_equalTo(self);
//        make.height.mas_offset(kHeightScale(24));
//    }];
//
//    [self addSubview:self.stockInfoView];
//    [self.stockInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.delayPromptView.mas_bottom).mas_offset(14);
//        make.left.right.mas_equalTo(self);
//    }];
//
//    [self addSubview:self.middleLayerView];
//    [self.middleLayerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.stockInfoView.mas_bottom).mas_offset(14);
//        make.left.right.mas_equalTo(self);
//        make.height.mas_offset(kHeightScale(345));
//    }];
    
}

#pragma mark - Private method

/**
 * K线图MQTT请求数据组装
 * json K线数据
 * model 盘口数据
 * chatType K线图类型
 */
- (void)setKLineChartMQTTRequestDataAssemblyWithKLineJson:(NSDictionary *)json
                                           StockInfoModel:(FSStockDetailInfoModel *)model
                                                 ChatType:(NSInteger)chatType {
    
    NSArray *array = json[@"data"];
    
    if (array.count == 0) {
        return;
    }
    
    BOOL isClose = [self getClosingStatusWithMarket:model.marketType TimeSharingStatus:1 StockInfoModel:model];
    
    FSStockDetailChartViewModel *viewModel = [FSStockDetailChartViewModel objectWithTimeArray:array];
    
    [viewModel.timeChartModels enumerateObjectsUsingBlock:^(FSStockTimeChartModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        viewModel.assetID = obj.assetID;
        viewModel.chatType = obj.addTo5DaysTimeSharing ? 4 : 3;
        viewModel.isClose = isClose;
        viewModel.marketType = [self getMarketTypeWithMarket:model.marketType TimeSharingStatus:1];
        viewModel.price = obj.currentPrice;
        viewModel.close = obj.yesterdayClosePrice;
    }];
    
    // 判断股票代码是否一样
    if (![model.assetId isEqualToString:viewModel.assetID]) {
        return;
    }
    
#warning 修改
    // 判断当前是否位于选择时间分类
    if (viewModel.chatType != self.seletedKLineChartType) {
        return;
    }
    
    // 是否盘中
    if (model.threeMarketStatus.intValue != 2) {
        return;
    }
    
    [self setEncapsulateKLineChartData:viewModel];
}

/**
 * 获取收盘状态
 * market 市场类型
 * status   US分时图类型 0/盘前 1/盘中 2/盘后
 * model
 */
- (BOOL)getClosingStatusWithMarket:(NSString *)market
                 TimeSharingStatus:(NSInteger)status
                    StockInfoModel:(FSStockDetailInfoModel *)model {
    
    if ([market isEqualToString:@"HK"]) {
        
        return model.status == 7 ? NO : YES;
        
    } else if ([market isEqualToString:@"US"]) {
        
        NSArray *list = [model.usTradeStatus componentsSeparatedByString:@"|"];
        if (list.count != 3) {
            return YES;
        }
        
        if (status == 0) {
            return [list[0] isEqualToString:@"1"] ? NO : YES;
          } else if (status == 1) {
            return [list[1] isEqualToString:@"1"] ? NO : YES;
          } else if (status == 2) {
            return [list[2] isEqualToString:@"1"] ? NO : YES;
          }
        
    } else if ([market isEqualToString:@"SZ"] || [market isEqualToString:@"SH"] || [market isEqualToString:@"ML"]) {
        return model.status == 7 ? NO : YES;
    }
    
    return YES;
}

/**
 * 获取市场类型
 * market 市场类型
 * status   US分时图类型 0/盘前 1/盘中 2/盘后
 */
- (NSString *)getMarketTypeWithMarket:(NSString *)market
                    TimeSharingStatus:(NSInteger)status {
    
    NSString *type = @"HK";
    if ([market isEqualToString:@"HK"]) {
        type = @"HK";
    } else if ([market isEqualToString:@"US"]) {
        if (status == 0) {
            type = @"US1"; //盘前
        } else if (status == 1) {
            type = @"US2"; //盘中
        } else if (status == 2) {
            type = @"US3"; //盘后
        }
    } else if ([market isEqualToString:@"SZ"] || [market isEqualToString:@"SH"] || [market isEqualToString:@"ML"]) {
        type = @"ZH";
    }
    return type;
}

/**
 * K线图API请求数据组装
 * json K线数据
 * model 盘口数据
 * chatType K线图类型
 */
- (void)setKLineChartAPIRequestDataAssemblyWithKLineJson:(NSDictionary *)json
                                          StockInfoModel:(FSStockDetailInfoModel *)model
                                                ChatType:(NSInteger)chatType {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    BOOL isClose = [self getClosingStatusWithMarket:model.marketType TimeSharingStatus:1 StockInfoModel:model];
    
    [dic setObject:model.assetId forKey:@"assetID"];
    [dic setObject:[NSString stringWithFormat:@"%ld",chatType] forKey:@"chatType"];
    [dic setObject:model.preClose forKey:@"close"];
    [dic setObject:[NSString stringWithFormat:@"%d",isClose] forKey:@"isClose"];
    [dic setObject:[self getMarketTypeWithMarket:model.marketType TimeSharingStatus:1] forKey:@"marketType"];
    [dic setObject:model.price forKey:@"price"];
    [dic setObject:json[@"result"] forKey:@"result"];
    
    self.middleLayerView.dataSource = dic;
}

/**
 * 再次封装K线图数据
 * newData 新数据
 */
- (void)setEncapsulateKLineChartData:(FSStockDetailChartViewModel *)model {
    
    // ["分时时间戳", "最新价", "均价", "分钟成交量", "分钟成交额", "今开"]
    [model.timeChartModels enumerateObjectsUsingBlock:^(FSStockTimeChartModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        // 获取数组最后一个元素的时间
        NSArray *lastObjectArray = self.klineDataList.lastObject;
        NSString *timestampStr = lastObjectArray[0];
        // 推送数据的时间
        long pushTime = [obj.pushTime longValue];
        
        NSArray * array = @[obj.pushTime, obj.currentPrice, obj.averagePrice, obj.minuteVolume, obj.minuteTurnover, obj.todayOpenPrice];
        
        
        NSTimeInterval timestamp1 = timestampStr.longValue / 1000.0;
        NSTimeInterval timestamp2 = pushTime / 1000.0;

        NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:timestamp1];
        NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:timestamp2];

        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
        [calendar setTimeZone:timeZone];

        NSDateComponents *hour1 = [calendar components:NSCalendarUnitHour fromDate:date1];
        NSDateComponents *hour2 = [calendar components:NSCalendarUnitHour fromDate:date2];
        
        NSDateComponents *minute1 = [calendar components:NSCalendarUnitMinute fromDate:date1];
        NSDateComponents *minute2 = [calendar components:NSCalendarUnitMinute fromDate:date2];
        
        
        // 小时小于
        if (hour1.hour < hour2.hour) {
            [self.klineDataList addObject:array];
        }
        
        // 小时等于
        if (hour1.hour == hour2.hour) {
            
            // 分钟小于，添加数据
            if (minute1.minute < minute2.minute) {
                [self.klineDataList addObject:array];
            }

            // 分钟一样，更新数据
            if (minute1.minute == minute2.minute) {
                [self.klineDataList replaceObjectAtIndex:self.klineDataList.count - 1 withObject:array];
            }
            
        }

    }];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    BOOL isClose = [self getClosingStatusWithMarket:model.marketType TimeSharingStatus:1 StockInfoModel:self.stockInfoModel];
    
    [dic setObject:model.assetID forKey:@"assetID"];
    [dic setObject:[NSString stringWithFormat:@"%ld", model.chatType] forKey:@"chatType"];
    [dic setObject:[NSString stringWithFormat:@"%@", model.close] forKey:@"close"];
    [dic setObject:[NSString stringWithFormat:@"%d",isClose] forKey:@"isClose"];
    [dic setObject:[self getMarketTypeWithMarket:model.marketType TimeSharingStatus:1] forKey:@"marketType"];
    [dic setObject:model.price forKey:@"price"];
    
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
    [dataDic setObject:self.klineDataList forKey:@"data"];
    [dic setObject:dataDic forKey:@"result"];
    
    self.middleLayerView.dataSource = dic;
    
    NSLog(@"");
}

/**
 * 获取K线图类型
 * 5.D 6.W 7.M 8.Y 9.Minute1 10.Minute5 11.Minute15 12.Minute30 13.Minute60
 */
- (NSString *)getReturnKlineTypeWithAPIType:(NSInteger)type {
    switch (type) {
        case 5:{
            return @"D";
        }
            break;
        case 6:{
            return @"W";
        }
            break;
        case 7:{
            return @"M";
        }
            break;
        case 8:{
            return @"Y";
        }
            break;
        case 9:{
            return @"Minute1";
        }
            break;
        case 10:{
            return @"Minute5";
        }
            break;
        case 11:{
            return @"Minute15";
        }
            break;
        case 12:{
            return @"Minute30";
        }
            break;
        case 13:{
            return @"Minute60";
        }
            break;
        default:{
            return @"";
        }
            break;
    }
}

#pragma mark - 通知方法

- (void)handleNotification:(NSNotification *)notification {
    if ([self.delegate respondsToSelector:@selector(GetMoreKLineDataWithTimestamp:)]) {
        [self.delegate GetMoreKLineDataWithTimestamp:[NSString stringWithFormat:@"%@",notification.object]];
    }
}

#pragma mark - StockInfoViewDelegate

- (void)setIsExpand:(BOOL)isExpand {
    self.middleLayerView.isExpand = isExpand;
    if (isExpand) {
        self.middleLayerView.originY = self.aaa - 25;
    } else {
        self.middleLayerView.originY = self.bbb;
    }
}

#pragma mark - DelayPromptViewDelegate

- (void)closePrompt {
    NSLog(@"关闭延时行情提示");
    self.delayPromptView.hidden = YES;
    self.middleLayerView.isClosePrompt = YES;
    [self.delayPromptView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(0);
    }];
}

#pragma mark — Lazy

- (FSStockDetailInfoModel *)stockInfoModel {
    if (!_stockInfoModel){
        _stockInfoModel = [[FSStockDetailInfoModel alloc] init];
    }
    return  _stockInfoModel;
}

- (FSStockDetailChartView *)middleLayerView {
    if (!_middleLayerView){
        _middleLayerView = [[FSStockDetailChartView alloc] init];
        _middleLayerView.delegate = self;
    }
    return  _middleLayerView;
}

- (FSStockDetailInfoView *)stockInfoView {
    if (!_stockInfoView){
        _stockInfoView = [[FSStockDetailInfoView alloc] init];
        _stockInfoView.delegate = self;
    }
    return  _stockInfoView;
}

- (JMDelayPromptView *)delayPromptView {
    if (!_delayPromptView){
        _delayPromptView = [[JMDelayPromptView alloc] init];
        _delayPromptView.delegate = self;
    }
    return  _delayPromptView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView){
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return  _scrollView;
}

#pragma mark - 数据重载

- (void)setMQTTDataWithJson:(NSDictionary *)json {
    
    NSString *funId = json[@"funId"];
    
    // 盘口
    if (funId.intValue == 2) {
        
        NSArray *array = json[@"data"];
        if (array.count == 0) return;
        
        // HK
        // "资产ID","名称",资产类型,资产状态,"昨收","开盘","现价","最高","最低","成交量","成交额","涨跌额","涨跌幅","总市值","流通市值","换手率","动态市盈率","市净率","量比","委比","平均价","收益",净资产,"","静态市盈率",更新时间,"日期","时分秒","振幅",盘中状态值,"52周最高","52周最低","历史最高","历史最低","资产类别","交易货币","每股资产净值","溢价","杠杠比率","实际杠杠","牛熊溢价","打和点","距收回价","换股价"
        
        // US
        // "资产ID","名称",资产类型,资产状态,"昨收","开盘","现价","最高","最低","成交量","成交额","涨跌额","涨跌幅","总市值","流通市值","换手率","动态市盈率","市净率","量比","委比","平均价","收益",净资产,"","静态市盈率",更新时间,"日期","时分秒","振幅",盘中状态值,"52周最高","52周最低","历史最高","历史最低"
        NSString * assetIdStr = array.lastObject[0];
        
        if (![self.stockInfoModel.assetId isEqualToString:assetIdStr]) {
            return;
        }
        
        FSStockDetailInfoModel *model = self.stockInfoModel;
        model.assetId = array.lastObject[0];
        model.name = array.lastObject[1];
        model.status = [array.lastObject[3] intValue];
        model.preClose = array.lastObject[4];
        model.open = array.lastObject[5];
        model.price = array.lastObject[6];
        model.high = array.lastObject[7];
        model.low = array.lastObject[8];
        model.volume = array.lastObject[9];
        model.turnover = array.lastObject[10];
        model.change = array.lastObject[11];
        model.changePct = array.lastObject[12];
        model.totalVal = array.lastObject[13];
        model.fmktVal = array.lastObject[14];
        model.turnRate = array.lastObject[15];
        model.ttmPe = array.lastObject[16];
        model.pb = array.lastObject[17];
        model.volRate = array.lastObject[18];
        model.avgPrice = array.lastObject[20];
        model.epsp = array.lastObject[21];
        model.pe = array.lastObject[24];
        model.ts = array.lastObject[25];
        model.ampLiTude = array.lastObject[28];
        model.threeMarketStatus = array.lastObject[29];
        model.week52High = array.lastObject[30];
        model.week52Low = array.lastObject[31];
        model.hisHigh = array.lastObject[32];
        model.hisLow = array.lastObject[33];
        
        self.stockInfoView.stockInfoViewModel = [[FSStockDetailInfoViewModel alloc] initWithModel:model];
        self.stockInfoModel = model;
        
    }
    
    // 分时
    if (funId.intValue == 4) {
#warning 修改
        [self setKLineChartMQTTRequestDataAssemblyWithKLineJson:json
                                                 StockInfoModel:self.stockInfoModel
                                                       ChatType:self.seletedKLineChartType];
    }
    
}

- (void)updateKLineDataWithJson:(NSDictionary *)json
                      ChartTyep:(NSInteger)chartType
                        Weights:(NSString *)weights
                           More:(BOOL)more {
    
    if (more) {
        NSArray * arr = json[@"result"][@"data"];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNoticeName_LoadMoreData object:arr];
    } else {
        NSArray * array = json[@"result"][@"data"];
        if (array.count <= 0) return;
        
        self.klineDataList = [[NSMutableArray alloc] initWithArray:array];
        [self setKLineChartAPIRequestDataAssemblyWithKLineJson:json StockInfoModel:self.stockInfoModel ChatType:chartType];
    }
    
}

- (void)setDataWithHandicapJson:(NSDictionary *)handicapJson
                      KLineJson:(NSDictionary *)kLineJson
                      ChartTyep:(NSInteger)chartType {
    
    FSStockDetailInfoModel *model = [FSStockDetailInfoModel mj_objectWithKeyValues:handicapJson];
    self.stockInfoView.stockInfoViewModel = [[FSStockDetailInfoViewModel alloc] initWithModel:model];
    self.stockInfoModel = model;
    
    NSArray * array = kLineJson[@"result"][@"data"];
    if (array.count <= 0) return;
    
    self.klineDataList = [[NSMutableArray alloc] initWithArray:array];
    [self setKLineChartAPIRequestDataAssemblyWithKLineJson:kLineJson StockInfoModel:model ChatType:chartType];
    
    if ([model.marketType isEqualToString:@"US"]){
        [self closePrompt];
    }
    
}

#pragma mark - <FSStockDetailChartViewDelegate>

- (void)KLineWeightsSelectionWithType:(NSString *)type {
    NSLog(@"权重选择 %@", type);
    if ([self.delegate respondsToSelector:@selector(KLineWeightsSelectionWithType:)]) {
        [self.delegate KLineWeightsSelectionWithType:type];
    }
}

- (void)clickChartKLineWithType:(FSKLineChartType)type {
    self.seletedKLineChartType = type;
    if ([self.delegate respondsToSelector:@selector(KLineTimeSelectionWithIndex:Type:)]) {
        [self.delegate KLineTimeSelectionWithIndex:index Type: [self getReturnKlineTypeWithAPIType:index]];
    }
}

#pragma mark - property

- (KLineChartType)theKLineChartType {
    return self.seletedKLineChartType;
}

@end
