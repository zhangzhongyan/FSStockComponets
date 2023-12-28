//
//  FSStockDetailChartView.m
//  JMQuotesComponets_Example
//
//  Created by fargowealth on 2023/5/30.
//  Copyright © 2023 liyunlong1512. All rights reserved.
//

#import "FSStockDetailChartView.h"
#import "QuotationConstant.h"
#import "UIButton+KJContentLayout.h"
#import "JMLineChartView.h"
#import "JMCandlestickChartView.h"
#import "JMKlineConstant.h"
#import "YYKlineConstant.h"
#import "JMChatManager.h"
#import "PopTimeMenuView.h"
//Helper
#import "NSBundle+FSStockComponents.h"

#define kButtonTag 1000
#define kButtonTimesharingTag 8888

@interface FSStockDetailChartView ()<PopTimeMenuViewDelegate>

/** 分时按钮 */
@property (nonatomic, strong) UIButton *timeBtn;

/** 时间选择按钮 */
@property (nonatomic, strong) NSArray *buttonTitles;
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) UIButton *selectedButton;

/** 更多按钮 */
@property (nonatomic, strong) UIButton *moreBtn;

/** 前复权 */
@property (nonatomic, strong) UIButton *resetBtn;

/** 选中时间 */
@property (nonatomic, copy) NSString *selectedTime;

/** 空数据 */
@property (nonatomic, strong) UIImageView *nullDataImageView;

/** 空数据 */
@property (nonatomic, strong) UILabel *nullDataLab;

/** 分时图 */
@property (nonatomic, strong) JMLineChartView *lineChartView;

/** 烛图 */
@property (nonatomic, strong) JMCandlestickChartView *candlestickChartView;

/** K线类型 */
@property (nonatomic, assign) NSInteger chartType;

/** 时间选择 */
@property (nonatomic, strong) PopTimeMenuView *timeSelectionView;

/** <#注释#> */
@property (nonatomic, strong) UIView *BGView;

@end

@implementation FSStockDetailChartView

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];        
    }
    return self;
}

#pragma mark - Private Methods

- (void)clickChartKLineWithType:(FSKLineChartType)type
{
    if ([self.delegate respondsToSelector:@selector(clickChartKLineWithType:)]) {
        [self.delegate clickChartKLineWithType:type];
    }
}

#pragma mark - PopTimeMenuViewDelegate

- (void)popTimeMenuViewTimeSelectionWithIndex:(NSInteger)index
                                        Title:(NSString *)title {
    [self.selectedButton setSelected:NO];
    [self.timeBtn setSelected:NO];
    
    self.selectedTime = title;
    
    [self.moreBtn setTitle:title forState:UIControlStateNormal];
    [self updateMoreBtnStateWithSelected:YES];
    [self clickChartKLineWithType:index + FSKLineChartTypeOneMinute];
    
    
    self.timeSelectionView.hidden = YES;
    self.BGView.hidden = YES;
}

- (void)popTimeMenuViewWeightsSelectionWithIndex:(NSInteger)index
                                           Title:(NSString *)title {
    [self.resetBtn setTitle:title forState:UIControlStateNormal];
    
    FSKLineWeightType weightType = FSKLineWeightTypeFront;
    switch (index) {
        case 1: {
            weightType = FSKLineWeightTypeBack;
            break;
        }
        case 2: {
            weightType = FSKLineWeightTypeNote;
            break;
        }
        default: {
            break;
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(KLineWeightsSelectionWithType:)]) {
        [self.delegate KLineWeightsSelectionWithType:weightType];
    }
    
    self.timeSelectionView.hidden = YES;
    self.BGView.hidden = YES;
}

#pragma mark — Private method

/**
 * view 点击事件
 */
- (void)viewTapped:(UITapGestureRecognizer *)sender {
    if (!self.timeSelectionView.hidden) {
        self.timeSelectionView.hidden = YES;
        self.BGView.hidden = YES;
    }
}

/**
 * 获取K线图类型
 */
- (KLineChartType)getReturnKlineTypeWithChartType:(NSInteger)chartType {
    switch (chartType) {
        case 0:{
            return KLineChartTypeBefore;
        }
            break;
        case 1:{
            return KLineChartTypeAfter;
        }
            break;
        case 2:{
            return KLineChartTypeBetween;
        }
            break;
        case 3:{
            return KLineChartTypeMinuteHour;
        }
            break;
        case 4:{
            return KLineChartTypeFiveDay;
        }
            break;
        case 5:{
            return KLineChartTypeDayK;
        }
            break;
        case 6:{
            return KLineChartTypeWeekK;
        }
            break;
        case 7:{
            return KLineChartTypeMonthK;
        }
            break;
        case 8:{
            return KLineChartTypeYearK;
        }
            break;
        case 9:{
            return KLineChartTypeOneMinute;
        }
            break;
        case 10:{
            return KLineChartTypefiveMinute;
        }
            break;
        case 11:{
            return KLineChartTypefifteenMinute;
        }
            break;
        case 12:{
            return KLineChartTypethirtyMinute;
        }
            break;
        case 13:{
            return KLineChartTypesixtyMinute;
        }
            break;
        default:{
            return KLineChartTypeDayK;
        }
            break;
    }
}

/**
 *  更新更多按钮状态
 *  selected 是否选中
 */
- (void)updateMoreBtnStateWithSelected:(BOOL)selected {
    
    UIImage *image = [NSBundle fsStockUI_imageName:@"expand_n.png"];
    UIImage *image_s = [NSBundle fsStockUI_imageName:@"expand_s.png"];
    
    if (selected) {
        [self.moreBtn setTitleColor:UIColor.delayPromptTextColor forState:UIControlStateNormal];
        [self.moreBtn setImage:image_s forState:UIControlStateNormal];
        [self.moreBtn setLayoutType:KJButtonContentLayoutStyleLeftImageRight];
        [self.moreBtn setPadding:2.f];
        [self.moreBtn setPeriphery:0.f];
        [self.moreBtn setBackgroundImage:[UIImage imageWithColor:UIColor.delayPromptViewBackgroundColor] forState:UIControlStateNormal];
    } else {
        [self.moreBtn setTitleColor:UIColor.handicapInfoTextColor forState:UIControlStateNormal];
        [self.moreBtn setImage:image forState:UIControlStateNormal];
        [self.moreBtn setLayoutType:KJButtonContentLayoutStyleLeftImageRight];
        [self.moreBtn setPadding:2.f];
        [self.moreBtn setPeriphery:0.f];
        [self.moreBtn setBackgroundImage:[UIImage imageWithColor:UIColor.backgroundColor] forState:UIControlStateNormal];
    }
    
}

- (void)ResetBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.timeSelectionView.hidden = NO;
    self.timeSelectionView.type = 1;
    self.timeSelectionView.selectionTitle = self.resetBtn.titleLabel.text;
    self.BGView.hidden = NO;
    
    [self.timeSelectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.resetBtn.mas_bottom).mas_offset(10);
        make.centerX.mas_equalTo(self.resetBtn);
        make.width.mas_offset(kWidthScale(64));
        make.height.mas_offset(kHeightScale(120));
    }];
    
}

- (void)MoreBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.timeSelectionView.hidden = NO;
    self.timeSelectionView.type = 0;
    self.timeSelectionView.selectionTitle = self.selectedTime;
    self.BGView.hidden = NO;

    [self.timeSelectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.moreBtn.mas_bottom).mas_offset(10);
        make.centerX.mas_equalTo(self.moreBtn);
        make.width.mas_offset(kWidthScale(64));
        make.height.mas_offset(kHeightScale(200));
    }];
}

- (void)TimeSelectionButtonClick:(UIButton *)sender {
    
    if (sender.tag == kButtonTimesharingTag){
        self.selectedButton.selected = NO;
        self.timeBtn.selected = YES;
    } else {
        // Deselect previously selected button
        self.timeBtn.selected = NO;
        self.selectedButton.selected = NO;
        
        // Select new button
        sender.selected = YES;
        self.selectedButton = sender;
        
        // Update other buttons
        for (UIButton *button in self.buttons) {
            if (button != sender) {
                button.selected = NO;
            }
        }
    }
    
    [self.moreBtn setTitle:self.selectedTime forState:UIControlStateNormal];
    [self updateMoreBtnStateWithSelected:NO];
    
    /// 更新显示图表
    if (sender.tag == kButtonTimesharingTag || sender.tag == 1000) {
        self.lineChartView.hidden = NO;
        self.candlestickChartView.hidden = YES;
    } else {
        self.lineChartView.hidden = YES;
        self.candlestickChartView.hidden = NO;
    }
    
    FSKLineChartType charType = FSKLineChartTypeBefore;
    if (sender.tag == kButtonTimesharingTag) {
        //美股：盘中   其他：分时
        charType = [[JMChatManager sharedInstance].market containsString:@"US"] ? FSKLineChartTypeBetween : FSKLineChartTypeMinuteHour;
    } else {
        charType = sender.tag - kButtonTag + FSKLineChartTypeFiveDay;
    }
    [self clickChartKLineWithType:charType];
}

/** 创建时间选择按钮
 * text                    文字
 * tag                     tag值
 */
- (UIButton *)CreateTimeSelectionBtnWithText:(NSString *)text
                                         Tag:(NSInteger)tag {
    
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:text forState:UIControlStateNormal];
    [btn.titleLabel setFont:kFont_Regular(14.f)];
    [btn setTitleColor:UIColor.handicapInfoTextColor forState:UIControlStateNormal];
    [btn setTitleColor:UIColor.delayPromptTextColor forState:UIControlStateSelected];
    [btn setBackgroundImage:[UIImage imageWithColor:UIColor.backgroundColor] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageWithColor:UIColor.delayPromptViewBackgroundColor] forState:UIControlStateHighlighted];
    [btn setBackgroundImage:[UIImage imageWithColor:UIColor.delayPromptViewBackgroundColor] forState:UIControlStateSelected];
    [btn.layer setCornerRadius:12.f];
    [btn.layer setMasksToBounds:YES];
    [btn addTarget:self action:@selector(TimeSelectionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTag:tag];
    return btn;
}

#pragma mark — 初始化视图

/** 初始化视图
 * chartType         K线类型
 * pointCount       分时图多少个点
 * currentPrice     当前价格
 * closPrice          收盘价格
 * kLineArray       K线数据
 * isInitialization   是否更新数据
 */
- (void)initUIWithChartType:(NSInteger)chartType
                 PointCount:(NSInteger)pointCount
               CurrentPrice:(CGFloat)currentPrice
                  ClosPrice:(CGFloat)closPrice
                 KLineArray:(NSArray *)kLineArray
           IsInitialization:(BOOL)isInitialization {
    
    if (chartType < 5) { // 分时图
        
        self.lineChartView.hidden = NO;
        self.candlestickChartView.hidden = YES;
        [self initTimeLineViewWithChartType:chartType PointCount:pointCount CurrentPrice:currentPrice ClosPrice:closPrice KLineArray:kLineArray];
        
    } else { //烛图
        
        self.lineChartView.hidden = YES;
        self.candlestickChartView.hidden = NO;
        [self initCandleChartViewWithChartType:chartType CurrentPrice:currentPrice ClosPrice:closPrice KLineArray:kLineArray IsInitialization:isInitialization];
        
    }
}

#pragma mark - 创建烛图

/** 创建烛图
 * chartType         K线类型
 * currentPrice     当前价格
 * closPrice          收盘价格
 * kLineArray       K线数据
 * isInitialization   是否更新数据
 */
- (void)initCandleChartViewWithChartType:(NSInteger)chartType
                            CurrentPrice:(CGFloat)currentPrice
                               ClosPrice:(CGFloat)closPrice
                              KLineArray:(NSArray *)kLineArray
                        IsInitialization:(BOOL)isInitialization {
    
    if (kLineArray.count == 0) {
        self.candlestickChartView.hidden = YES;
        return;
    }

    if (self.chartType != chartType) {
        self.chartType = chartType;
        self.candlestickChartView.isSuspend = NO;
    }

    self.candlestickChartView.reloading = NO;
    self.candlestickChartView.isInitialization = isInitialization;
    self.candlestickChartView.kLineChartType = [self getReturnKlineTypeWithChartType:chartType];
    self.candlestickChartView.currentPrice = currentPrice;
    self.candlestickChartView.linePainter = JMCandlePainter.class;
    JMKlineRootModel *groupModel = [JMKlineRootModel objectWithArray:kLineArray];
    self.candlestickChartView.rootModel = groupModel;
    [self.candlestickChartView reDraw];
    
}

#pragma mark - 创建分时图

/** 创建分时图
 * chartType         K线类型
 * pointCount       分时图多少个点
 * currentPrice     当前价格
 * closPrice          收盘价格
 * kLineArray       K线数据
 */
- (void)initTimeLineViewWithChartType:(NSInteger)chartType
                           PointCount:(NSInteger)pointCount
                         CurrentPrice:(CGFloat)currentPrice
                            ClosPrice:(CGFloat)closPrice
                           KLineArray:(NSArray *)kLineArray {
    

    if (!kLineArray) {
        self.lineChartView.hidden = YES;
        return;
    }
    
    NSInteger type;
    if (chartType == 4) {
        type = 3;
    } else {
        type = 2;
    }
    
    [YYKlineGlobalVariable setkLineWith:5];
    [YYKlineGlobalVariable setkLineGap:2];
    
    self.lineChartView.price = currentPrice;
    self.lineChartView.close = closPrice;
    self.lineChartView.centerViewType = KlineTypeTimeLine;
    self.lineChartView.linePainter =  YYTimelinePainter.class;
    self.lineChartView.pointCount = pointCount;
    pointCount = [JMChatManager getCountPointNumberByType:[JMChatManager sharedInstance].market
                                                   isDark:[JMChatManager sharedInstance].isDark
                                                isHalfDay:[JMChatManager sharedInstance].isHalfDay
                                                 chatType:type];
    kLineArray = [[kLineArray reverseObjectEnumerator] allObjects];
    self.lineChartView.pointCount = pointCount;
    self.lineChartView.close = closPrice;
    YYKlineRootModel *groupModel = [YYKlineRootModel objectWithTimeArray:kLineArray close:@(closPrice)];
    self.lineChartView.rootModel = groupModel;
    self.lineChartView.chartType = type;
    [self.lineChartView reDraw];
}


#pragma mark — UI

- (void)createUI {
    
    self.backgroundColor = UIColor.backgroundColor;
    
    self.buttonTitles = @[@"五日", @"日K", @"周K", @"月K", @"年K",];
    self.buttons = [[NSMutableArray alloc] init];
    self.selectedTime = @"1分";
    
    //规格选择
    __block UIButton *lastBtn = nil;
    // Create buttons
    [self.buttonTitles enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        self.selectedButton = [self CreateTimeSelectionBtnWithText:obj Tag:idx + kButtonTag];
        [self addSubview:self.selectedButton];
        [self.buttons addObject:self.selectedButton];
    }];
    
    // Layout buttons
    CGFloat buttonWidth = kWidthScale(40);
    CGFloat buttonHeight = kHeightScale(24);
    CGFloat spacing = 2;
    CGFloat startX = 0;
    CGFloat currentX = startX;
    
    [self addSubview:self.timeBtn];
    [self.timeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).mas_offset(16);
        make.left.mas_equalTo(self).mas_offset(12);
        make.width.mas_offset(buttonWidth);
        make.height.mas_offset(buttonHeight);
    }];
    
    for (UIButton *button in self.buttons) {
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self).mas_offset(16);
            make.left.mas_equalTo(self.timeBtn.mas_right).mas_offset(currentX);
            make.width.mas_offset(buttonWidth);
            make.height.mas_offset(buttonHeight);
        }];
        currentX += buttonWidth + spacing;
        lastBtn = button;
    }
    
    [self addSubview:self.moreBtn];
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lastBtn);
        make.right.mas_equalTo(lastBtn.mas_right).mas_offset(buttonWidth + 12);
        make.width.mas_offset(kWidthScale(50));
        make.height.mas_offset(buttonHeight);
    }];
    
    [self addSubview:self.resetBtn];
    [self.resetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lastBtn);
        make.right.mas_equalTo(self.mas_right).mas_offset(-16);
        make.height.mas_offset(buttonHeight);
    }];
    
    [self addSubview:self.nullDataImageView];
    [self.nullDataImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.centerY.mas_equalTo(self).mas_offset(-20);
    }];
    
    [self addSubview:self.nullDataLab];
    [self.nullDataLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nullDataImageView.mas_bottom).mas_offset(16);
        make.centerX.mas_equalTo(self);
    }];
    
    [self addSubview:self.lineChartView];
    [self.lineChartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeBtn.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(self).mas_offset(12);
        make.right.mas_equalTo(self.mas_right).mas_offset(-12);
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-10);
    }];
    
    [self addSubview:self.candlestickChartView];
    [self.candlestickChartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeBtn.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(self).mas_offset(12);
        make.right.mas_equalTo(self.mas_right).mas_offset(-12);
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-10);
    }];
    
    [self addSubview:self.BGView];
    [self.BGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self);
    }];
    
    [self addSubview:self.timeSelectionView];
    [self.timeSelectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.moreBtn.mas_bottom).mas_offset(10);
        make.centerX.mas_equalTo(self.moreBtn);
        make.width.mas_offset(kWidthScale(64));
        make.height.mas_offset(kHeightScale(200));
    }];
    
}

#pragma mark — Lazy

- (UIView *)BGView {
    if (!_BGView) {
        _BGView = [[UIView alloc] init];
        _BGView.hidden = YES;
        _BGView.backgroundColor = [UIColor clearColor];
        // 创建 UITapGestureRecognizer 对象
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
        // 将 UITapGestureRecognizer 对象添加到 view 中
        [_BGView addGestureRecognizer:tapGesture];
    }
    return _BGView;
}

- (PopTimeMenuView *)timeSelectionView {
    if (!_timeSelectionView) {
        _timeSelectionView = [[PopTimeMenuView alloc] init];
        _timeSelectionView.hidden = YES;
        _timeSelectionView.delegate = self;
    }
    return _timeSelectionView;
}

- (JMCandlestickChartView *)candlestickChartView {
    if (!_candlestickChartView) {
        _candlestickChartView = [[JMCandlestickChartView alloc] init];
        _candlestickChartView.hidden = YES;
    }
    return _candlestickChartView;
}

- (JMLineChartView *)lineChartView {
    if (!_lineChartView) {
        _lineChartView = [[JMLineChartView alloc] init];
        _lineChartView.hidden = YES;
    }
    return _lineChartView;
}

- (UILabel *)nullDataLab {
    if (!_nullDataLab) {
        _nullDataLab = [[UILabel alloc] init];
        _nullDataLab.text = FSLanguage(@"暂无数据(详情页)");
        _nullDataLab.textColor = UIColor.nullDataTextColor;
        _nullDataLab.font = kFont_Regular(14.f);
    }
    return _nullDataLab;
}

- (UIImageView *)nullDataImageView {
    if (!_nullDataImageView) {
        _nullDataImageView = [[UIImageView alloc] init];
        _nullDataImageView.image = [NSBundle fsStockUI_imageName:@"null_data.png"];
    }
    return _nullDataImageView;
}

- (UIButton *)resetBtn {
    if (!_resetBtn) {
        _resetBtn = [[UIButton alloc] init];
        [_resetBtn setTitle:@"前复权" forState:UIControlStateNormal];
        [_resetBtn setTitleColor:UIColor.handicapInfoTextColor forState:UIControlStateNormal];
        [_resetBtn.titleLabel setFont:kFont_Regular(14.f)];
        [_resetBtn addTarget:self action:@selector(ResetBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resetBtn;
}

- (UIButton *)moreBtn {
    if (!_moreBtn) {
        _moreBtn = [[UIButton alloc] init];
        [_moreBtn setTitle:@"1分" forState:UIControlStateNormal];
        [_moreBtn setTitleColor:UIColor.handicapInfoTextColor forState:UIControlStateNormal];
        [_moreBtn.titleLabel setFont:kFont_Regular(14.f)];
        [_moreBtn setImage:[NSBundle fsStockUI_imageName:@"expand_n.png"] forState:UIControlStateNormal];
        [_moreBtn setImage:[NSBundle fsStockUI_imageName:@"expand_s.png"] forState:UIControlStateSelected];
        [_moreBtn setLayoutType:KJButtonContentLayoutStyleLeftImageRight];
        [_moreBtn setPadding:2.f];
        [_moreBtn setPeriphery:0.f];
        [_moreBtn setBackgroundImage:[UIImage imageWithColor:UIColor.backgroundColor] forState:UIControlStateNormal];
        [_moreBtn.layer setCornerRadius:12.f];
        [_moreBtn.layer setMasksToBounds:YES];
        [_moreBtn addTarget:self action:@selector(MoreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBtn;
}

- (UIButton *)selectedButton {
    if (!_selectedButton) {
        _selectedButton = [[UIButton alloc] init];
    }
    return _selectedButton;
}

- (UIButton *)timeBtn {
    if (!_timeBtn) {
        _timeBtn = [[UIButton alloc] init];
        [_timeBtn setTitle:@"分时" forState:UIControlStateNormal];
        [_timeBtn.titleLabel setFont:kFont_Regular(14.f)];
        [_timeBtn setTitleColor:UIColor.handicapInfoTextColor forState:UIControlStateNormal];
        [_timeBtn setTitleColor:UIColor.delayPromptTextColor forState:UIControlStateSelected];
        [_timeBtn setBackgroundImage:[UIImage imageWithColor:UIColor.backgroundColor] forState:UIControlStateNormal];
        [_timeBtn setBackgroundImage:[UIImage imageWithColor:UIColor.delayPromptViewBackgroundColor] forState:UIControlStateHighlighted];
        [_timeBtn setBackgroundImage:[UIImage imageWithColor:UIColor.delayPromptViewBackgroundColor] forState:UIControlStateSelected];
        [_timeBtn.layer setCornerRadius:12.f];
        [_timeBtn.layer setMasksToBounds:YES];
        [_timeBtn addTarget:self action:@selector(TimeSelectionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_timeBtn setSelected:YES];
        [_timeBtn setTag:kButtonTimesharingTag];
    }
    return _timeBtn;
}

#pragma mark - 数据重载

- (void)setDataSource:(NSDictionary *)dataSource {
    _dataSource = dataSource;
    
    NSInteger chartType = [dataSource[@"chatType"] integerValue];
    NSInteger pointCount = 330;
    CGFloat price = [dataSource[@"price"] floatValue];
    CGFloat close = [dataSource[@"close"] floatValue];
    NSString * market = dataSource[@"marketType"];//市场类型
    BOOL isDark = [dataSource[@"isDark"] boolValue];//是否是暗盘
    BOOL isHalfDay = [dataSource[@"isHalfDay"] boolValue];//是否是半日市
    BOOL isClose = [dataSource[@"isClose"] boolValue];//是否收盘
    BOOL isStockIndex = [dataSource[@"isStockIndex"] boolValue];//是否是指数
    NSString * assetID = dataSource[@"assetID"];//股票代码
    BOOL isInitialization = [dataSource[@"isInitialization"] boolValue];//是否更新数据(切换K线)
    NSDictionary *dict = dataSource[@"result"];
    // K线图数据源
    NSArray * arr = dict[@"data"];
    
    //价格小数据点格式化
    NSString * priceFormate = dataSource[@"priceFormate"];
    if (!priceFormate || priceFormate.length == 0) {
        if ([market isEqualToString:@"ZH"]) {
            priceFormate = @"%.2f";
        } else {
            priceFormate = @"%.3f";
        }
    }
    
//    NSLog(@"========K线类型%ld==数据%@========",chartType,arr);

    [JMChatManager sharedInstance].isDark = isDark;
    [JMChatManager sharedInstance].isHalfDay = isHalfDay;
    [JMChatManager sharedInstance].market = market;
    [JMChatManager sharedInstance].isClose = isClose;
    [JMChatManager sharedInstance].isStockIndex = isStockIndex;
    [JMChatManager sharedInstance].priceFormate = priceFormate;
    [JMChatManager sharedInstance].chartType = chartType;

    // 此处字段为了解决重复重置数据问题
    [JMChatManager sharedInstance].assetID = assetID;
    
    // 创建视图
    [self initUIWithChartType:chartType PointCount:pointCount CurrentPrice:price ClosPrice:close KLineArray:arr IsInitialization:isInitialization];
    
}

@end
