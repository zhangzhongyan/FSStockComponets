//
//  JMCandlestickChartView.m
//  JMQuotesComponets_Example
//
//  Created by fargowealth on 2023/5/30.
//  Copyright © 2023 liyunlong1512. All rights reserved.
//

#import "JMCandlestickChartView.h"

#import "QuotationConstant.h"
#import "JMMoveDetailInfoView.h"
#import "JMIndicatorView.h"

@interface JMCandlestickChartView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *painterView;
/** 价格，成交量Y轴 */
@property (nonatomic, strong) UIView *yAxisView;
/** 切换指标 */
@property (nonatomic, strong) UIButton *switchIndexBtn;
/** 顶部股票明细 */
@property (nonatomic, strong) UILabel *topLabel;


/** 长按后竖线 */
@property (nonatomic, strong) UIView *verticalView;
/** 长按后水平线 */
@property (nonatomic, strong) UIView *horizontalView;
/** 左侧浮动价格 */
@property (nonatomic, strong) UILabel *floatedPriceLab;
/** 右侧浮动涨跌幅 */
@property (nonatomic, strong) UILabel *floatedFluctuationRangeLab;
/** 底部浮动日期 */
@property (nonatomic, strong) UILabel *floatedDateLab;
/** 移动详细信息view */
@property (nonatomic, strong) JMMoveDetailInfoView *moveDetailInfoView;
/** 指示器view */
@property (nonatomic, strong) JMIndicatorView *selectorView;

/** 旧的scrollview准确位移 */
@property (nonatomic, assign) CGFloat oldExactOffset;
@property (nonatomic, assign) CGFloat pinchCenterX;
@property (nonatomic, assign) NSInteger pinchIndex;
/** 需要绘制Index开始值 */
@property (nonatomic, assign) NSInteger needDrawStartIndex;
/** 旧的contentoffset值 */
@property (nonatomic, assign) CGFloat oldContentOffsetX;
/** 旧的缩放值，捏合 */
@property (nonatomic, assign) CGFloat oldScale;
@property (nonatomic, weak) MASConstraint *painterViewXConstraint;
/** 第一个View的高所占比例 */
@property (nonatomic, assign) CGFloat mainViewRatio;
/** 第二个View(成交量)的高所占比例 */
@property (nonatomic, assign) CGFloat volumeViewRatio;

/** 记录主图位置 */
@property (nonatomic, assign) CGRect mainArea;
/** 记录主图model */
@property(nonatomic,strong) JMMinMaxModel *maxMin;
/** 记录成交量位置 */
@property (nonatomic, assign) CGRect volArea;
/** 记录成交量model */
@property(nonatomic,strong) JMMinMaxModel *volMaxMin;
/** 记录scrollView滑动位置 */
@property (nonatomic, assign) CGFloat lastContentOffset;
/** 记录view大小 */
@property (nonatomic, assign) CGRect viewArea;

/** 菊花 */
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

/** 是否空数据 */
@property (nonatomic, assign) BOOL isEmptyData;

/** 初始画布值X */
@property (nonatomic, assign) CGFloat initCanvasValueX;

/** 是否长按暂停 */
@property (nonatomic, assign) BOOL isTapSuspend;

@end

@implementation JMCandlestickChartView

#pragma mark — life cycle

static void dispatch_main_async_safe(dispatch_block_t block) {
    dispatch_async(dispatch_get_main_queue(), ^{
        block();
    });
}

// 解决异常缩放问题
-(void)layoutSubviews{
    [super layoutSubviews];
    if (!CGRectEqualToRect(self.viewArea,self.frame)) {
        [self reDraw];
        self.viewArea = self.frame;
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.mainViewRatio = [JMKlineGlobalVariable kLineMainViewRadio];
        self.volumeViewRatio = [JMKlineGlobalVariable kLineVolumeViewRadio];
        self.indicator1Painter = JMMAPainter.class;
        [self createUI];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LoadMoreDataNotification:) name:kNoticeName_LoadMoreData object:nil];
    }
    return self;
}

#pragma mark - 缩放执行方法

- (void)event_pichMethod:(UIPinchGestureRecognizer *)pinch {
    if (pinch.state == UIGestureRecognizerStateBegan) {
        self.scrollView.scrollEnabled = NO;
        CGPoint p1 = [pinch locationOfTouch:0 inView:self.painterView];
        CGPoint p2 = [pinch locationOfTouch:1 inView:self.painterView];
        self.pinchCenterX = (p1.x+p2.x)/2;
        self.pinchIndex = ABS(floor((self.pinchCenterX + self.scrollView.contentOffset.x) / ([JMKlineGlobalVariable kLineWidth] + [JMKlineGlobalVariable kLineGap])));
    }
    
    if (pinch.state == UIGestureRecognizerStateEnded) {
        self.scrollView.scrollEnabled = YES;
    }
    static CGFloat oldScale = 1.0f;
    CGFloat difValue = pinch.scale - oldScale;
    if(ABS(difValue) > JMKlineScaleBound) {
        CGFloat oldKlineWidth = [JMKlineGlobalVariable kLineWidth];
        CGFloat newKlineWidth = oldKlineWidth * (difValue > 0 ? (1 + JMKlineScaleFactor) : (1 - JMKlineScaleFactor));
        if (oldKlineWidth == JMKlineLineMinWidth && difValue <= 0) {
            return;
        }
        
        // 右侧已经没有更多数据时，从右侧开始缩放
        if (((CGRectGetWidth(self.scrollView.bounds) - self.pinchCenterX) / (newKlineWidth + [JMKlineGlobalVariable kLineGap])) > self.rootModel.models.count - self.pinchIndex) {
            self.pinchIndex = self.rootModel.models.count -1;
            self.pinchCenterX = CGRectGetWidth(self.scrollView.bounds);
        }
        
        // 左侧已经没有更多数据时，从左侧开始缩放
        if (self.pinchIndex * (newKlineWidth + [JMKlineGlobalVariable kLineGap]) < self.pinchCenterX) {
            self.pinchIndex = 0;
            self.pinchCenterX = 0;
        }
        
        // 数量很少，少于一屏时，从左侧开始缩放
        if ((CGRectGetWidth(self.scrollView.bounds) / (newKlineWidth + [JMKlineGlobalVariable kLineGap])) > self.rootModel.models.count) {
            self.pinchIndex = 0;
            self.pinchCenterX = 0;
        }
        
        [JMKlineGlobalVariable setkLineWith: newKlineWidth];
        oldScale = pinch.scale;
        NSInteger idx = self.pinchIndex - floor(self.pinchCenterX / ([JMKlineGlobalVariable kLineGap] + [JMKlineGlobalVariable kLineWidth]));
        CGFloat offset = idx * ([JMKlineGlobalVariable kLineGap] + [JMKlineGlobalVariable kLineWidth]);
        [self.rootModel calculateNeedDrawTimeModel];
        [self updateScrollViewContentSize];
        self.scrollView.contentOffset = CGPointMake(offset, 0);
        // scrollview的contentsize小于frame时，不会触发scroll代理，需要手动调用
        if (self.scrollView.contentSize.width < self.scrollView.bounds.size.width) {
            [self scrollViewDidScroll:self.scrollView];
        }
    }
}

#pragma mark - 长按手势执行方法

- (void)event_longPressMethod:(UILongPressGestureRecognizer *)longPress {
    static CGFloat oldPositionX = 0;
    if(UIGestureRecognizerStateChanged == longPress.state || UIGestureRecognizerStateBegan == longPress.state) {
        
        CGPoint location = [longPress locationInView:self.scrollView];
        if(ABS(oldPositionX - location.x) < ([JMKlineGlobalVariable kLineWidth] + [JMKlineGlobalVariable kLineGap])/2) {
            return;
        }
        
        // 暂停滑动
        self.scrollView.scrollEnabled = NO;
        oldPositionX = location.x;
        NSInteger idx = ABS(floor(location.x / ([JMKlineGlobalVariable kLineWidth] + [JMKlineGlobalVariable kLineGap])));
        idx = MIN(idx, self.rootModel.models.count - 1);
        
        if(idx != (self.rootModel.models.count - 1)) {
            self.isTapSuspend = YES;
        }
        
        [self updateLabelText: self.rootModel.models[idx]];
        
        // 竖线配置
        [self.verticalView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(idx * ([JMKlineGlobalVariable kLineWidth] + [JMKlineGlobalVariable kLineGap]) + [JMKlineGlobalVariable kLineWidth] / 2.5f));
//            make.left.equalTo(@(idx * ([JMKlineGlobalVariable kLineWidth] + [JMKlineGlobalVariable kLineGap]) + 2));
        }];
        [self.verticalView layoutIfNeeded];
        self.verticalView.hidden = NO;
        
        // 横线配置
        [self.horizontalView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(location.y);
        }];
        [self.horizontalView layoutIfNeeded];
        self.horizontalView.hidden = NO;

        // 模型
        JMKlineModel *lineModel = self.rootModel.models.lastObject;

        // 获取图表位置，进行赋值操作
        location = [longPress locationInView:self];
        if (CGRectContainsPoint(self.mainArea, location)) {

            CGFloat distance = (self.maxMin.max - self.maxMin.min) / self.mainArea.size.height;
            CGFloat height = CGRectGetMaxY(self.mainArea) - location.y;

            // 价格
            NSString *price = [NSString stringWithFormat:@" %.2f ",self.maxMin.min + height * distance];
            self.floatedPriceLab.text = price;

            // 涨跌幅
            NSString *fluctuationRange = [NSString stringWithFormat:@"%.2f%%",(self.maxMin.min + height * distance - lineModel.Close.doubleValue) / lineModel.Close.doubleValue * 100];
            self.floatedFluctuationRangeLab.text = fluctuationRange;

        } else if (CGRectContainsPoint(self.volArea, location)) {

            CGFloat distance = (self.volMaxMin.max - self.volMaxMin.min) / self.volArea.size.height;
            CGFloat height = CGRectGetMaxY(self.volArea) - location.y;
            CGFloat dif = 1.0;
            if (self.volMaxMin.max > 100000000) {
                dif = 100000000.0f;
            }else if(self.volMaxMin.max > 10000){
                dif = 10000.0f;
            }

            NSString * vol = [NSString stringWithFormat:@" %.2f ",(self.volMaxMin.min + height * distance) / dif];
            self.floatedPriceLab.text = vol;
        }

        // 左侧浮动价格
        [self.floatedPriceLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(location.y - 5);
        }];
        [self.floatedPriceLab layoutIfNeeded];
        self.floatedPriceLab.hidden = NO;
        
        // 根据K线图类型绘制
        if (self.kLineChartType < 5) {
            // 右侧浮动涨跌幅
            [self.floatedFluctuationRangeLab mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).offset(location.y - 5);
                make.right.equalTo(self.mas_right);
            }];
            [self.floatedFluctuationRangeLab layoutIfNeeded];
            self.floatedFluctuationRangeLab.hidden = NO;
        }

        // 底部浮动日期
        NSLog(@"hhhhhhh %f",location.x);
        if (location.x < kWidthScale(35)) {
            [self.floatedDateLab mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self.verticalView).mas_offset(kWidthScale(20));
                make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-CGRectGetHeight(self.painterView.bounds) * self.volumeViewRatio);
            }];
        } else if (location.x > kWidthScale(330)) {
            [self.floatedDateLab mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self.verticalView).mas_offset(-kWidthScale(20));
                make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-CGRectGetHeight(self.painterView.bounds) * self.volumeViewRatio);
            }];
        } else {
            [self.floatedDateLab mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self.verticalView);
                make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-CGRectGetHeight(self.painterView.bounds) * self.volumeViewRatio);
            }];
        }
        [self.floatedDateLab layoutIfNeeded];
        self.floatedDateLab.hidden = NO;

        // 移动详细信息view
        if (location.x > 200) { //判断位置，切换左右显示
            [self.moveDetailInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.topLabel.mas_bottom).mas_offset(10);
                make.left.mas_equalTo(self.yAxisView.mas_right).mas_offset(-50);
                make.width.mas_offset(100);
            }];
        } else {
            [self.moveDetailInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.topLabel.mas_bottom).mas_offset(10);
                make.right.mas_equalTo(self.mas_right).mas_offset(-50);
                make.width.mas_offset(100);
            }];
        }
        [self.moveDetailInfoView layoutIfNeeded];
        self.moveDetailInfoView.hidden = NO;

    }
    
    if(longPress.state == UIGestureRecognizerStateEnded) {
        oldPositionX = 0;
        [self performSelector:@selector(hideAllLongPressControl) withObject:nil afterDelay:2];
    }
}

#pragma mark — 隐藏长按控件

- (void)hideAllLongPressControl {
    self.verticalView.hidden = YES; // 取消竖线
    self.horizontalView.hidden = YES; // 取消横线
    self.floatedPriceLab.hidden = YES; // 取消左侧浮动价格
    self.floatedFluctuationRangeLab.hidden = YES; // 取消右侧浮动涨跌幅
    self.floatedDateLab.hidden = YES; // 取消底部浮动日期
    self.moveDetailInfoView.hidden = YES; // 取消移动详细信息view
    // 恢复scrollView的滑动
    self.scrollView.scrollEnabled = YES;
    self.isTapSuspend = NO;
}


#pragma mark - 重绘

- (void)reDraw {
    
    if (self.isSuspend){
        return;
    }
    
    if (self.isTapSuspend) {
        return;
    }
    
    dispatch_main_async_safe(^{
        self.isEmptyData = NO;
        CGFloat kLineViewWidth = self.rootModel.models.count * [JMKlineGlobalVariable kLineWidth] + (self.rootModel.models.count + 1) * [JMKlineGlobalVariable kLineGap] + 10;
        [self updateScrollViewContentSize];
        CGFloat offset = kLineViewWidth - self.scrollView.frame.size.width;
        self.scrollView.contentOffset = CGPointMake(MAX(offset, 0), 0);
        [self calculateNeedDrawModels];
    });
}

- (void)calculateNeedDrawModels {
    
    CGFloat lineGap = [JMKlineGlobalVariable kLineGap];
    CGFloat lineWidth = [JMKlineGlobalVariable kLineWidth];
    
    //数组个数
    NSInteger needDrawKlineCount = ceil((CGRectGetWidth(self.scrollView.frame))/(lineGap+lineWidth)) + 1;
    CGFloat scrollViewOffsetX = self.scrollView.contentOffset.x < 0 ? 0 : self.scrollView.contentOffset.x;
    NSUInteger leftArrCount = floor(scrollViewOffsetX / (lineGap + lineWidth));
    self.needDrawStartIndex = leftArrCount;
    
    NSArray *arr;
    //赋值数组
    if(self.needDrawStartIndex < self.rootModel.models.count) {
        if(self.needDrawStartIndex + needDrawKlineCount < self.rootModel.models.count) {
            arr = [self.rootModel.models subarrayWithRange:NSMakeRange(self.needDrawStartIndex, needDrawKlineCount)];
        } else {
            arr = [self.rootModel.models subarrayWithRange:NSMakeRange(self.needDrawStartIndex, self.rootModel.models.count - self.needDrawStartIndex)];
        }
    }
    
    [self drawWithModels: arr];
}

- (void)drawWithModels:(NSArray <JMKlineModel *>*)models {
    if (models.count <= 0) {
        return;
    }
    
    JMMinMaxModel *minMax = [JMMinMaxModel new];
    minMax.min = 9999999999999.f;
    [minMax combine:[self.linePainter getMinMaxValue: models]];
    if (self.indicator1Painter) {
        [minMax combine:[self.indicator1Painter getMinMaxValue: models]];
    }

    // 移除旧layer
    self.painterView.layer.sublayers = nil;
    self.yAxisView.layer.sublayers = nil;
    
    CGFloat offsetX = models.firstObject.index * (JMKlineGlobalVariable.kLineWidth + JMKlineGlobalVariable.kLineGap) - self.scrollView.contentOffset.x;
    
    // K线图
//    CGRect mainArea = CGRectMake(offsetX, 20, CGRectGetWidth(self.painterView.bounds), CGRectGetHeight(self.painterView.bounds) * self.mainViewRatio-40);
    CGRect mainArea = CGRectMake(offsetX, 35, CGRectGetWidth(self.painterView.bounds), CGRectGetHeight(self.painterView.bounds) * self.mainViewRatio-60);
    
    // 成交量
    CGRect secondArea = CGRectMake(offsetX, CGRectGetMaxY(mainArea) + 20, CGRectGetWidth(mainArea), CGRectGetHeight(self.painterView.bounds) * self.volumeViewRatio);
    
    // 时间轴
    [JMTimePainter drawToLayer:self.painterView.layer
                          area:CGRectMake(offsetX, CGRectGetMaxY(mainArea), CGRectGetWidth(mainArea)+20, 20)
                        models:models
                        minMax:minMax
                KLineChartType:self.kLineChartType
                  CurrentPrice:self.currentPrice];
    
    // 价格轴
//    [JMVerticalTextPainter drawPriceToLayer: self.yAxisView.layer area: CGRectMake(0, 20, JMKlineLinePriceViewWidth, CGRectGetHeight(mainArea)) minMax:minMax];
    [JMVerticalTextPainter drawPriceToLayer: self.yAxisView.layer area: CGRectMake(0, 20, JMKlineLinePriceViewWidth, CGRectGetHeight(mainArea) + 15) minMax:minMax];
    
    // 成交量轴
    [JMVerticalTextPainter drawVolumeToLayer: self.yAxisView.layer area: CGRectMake(0, CGRectGetMaxY(mainArea)+20, JMKlineLinePriceViewWidth, CGRectGetHeight(secondArea)) minMax:[JMVolPainter getMinMaxValue:models]];
    
    // 主图
    [self.linePainter drawToLayer: self.painterView.layer
                             area: mainArea
                           models: models
                           minMax: minMax
                   KLineChartType:self.kLineChartType
                     CurrentPrice:self.currentPrice];
    
    // 主图指标图
    if (self.indicator1Painter) {
        [self.indicator1Painter drawToLayer: self.painterView.layer area: mainArea models: models minMax: minMax];
    }
    
    // 成交量图
    [JMVolPainter drawToLayer: self.painterView.layer area: secondArea models:models minMax:[JMVolPainter getMinMaxValue:models]];
    
    // 文字
    [self updateLabelText: models.lastObject];
    
    // 赋值操作
    self.mainArea = mainArea;
    self.maxMin = minMax;
    self.volArea = secondArea;
    self.volMaxMin = [JMVolPainter getMinMaxValue:models];
    
}

#pragma mark - 通知方法

- (void)LoadMoreDataNotification:(NSNotification *)notification {
    
    NSArray * arr = notification.object;
    if (arr.count == 0) return;
    
    __block CGPoint oldPoint = self.scrollView.contentOffset;
    [self.rootModel  appendData:arr];
    dispatch_main_async_safe(^{
        [self updateScrollViewContentSize];
        double contentSizeW = arr.count * [JMKlineGlobalVariable kLineWidth] + (arr.count -1) * [JMKlineGlobalVariable kLineGap];
        CGPoint tempPoint = CGPointMake(contentSizeW + self.oldContentOffsetX, oldPoint.y);
        self.scrollView.contentOffset = tempPoint ;
        [self calculateNeedDrawModels];
        self.reloading = NO;
    });
    
}

#pragma mark — 查询更多交易日信息

- (void)getQueryMoreTradingDayInfoWithContentOffset:(CGPoint)contentOffset {
    
    NSInteger idx = ABS(floor(contentOffset.x / ([JMKlineGlobalVariable kLineWidth] + [JMKlineGlobalVariable kLineGap])));
    idx = MIN(idx, self.rootModel.models.count - 1);
    NSLog(@"时间：%@",self.rootModel.models[idx].V_YYYYMMDD);
    NSLog(@"index：%ld",self.rootModel.models[idx].index);
    NSLog(@"contentOffset.x:%f，oldContentOffsetX：%f",contentOffset.x, self.oldContentOffsetX);
    
    JMKlineModel * model = self.rootModel.models[idx];
    
    [self calculateNeedDrawModels];
    
    if (model.index <= 100 && !self.reloading) {
        self.reloading = YES;
        JMKlineModel * model = self.rootModel.models[0];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNoticeName_GetMoreData object:model.Timestamp];
    }
    
}

#pragma mark - scrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (self.scrollView.contentOffset.x < 0) {
        self.painterViewXConstraint.offset = 0;
    } else {
        self.painterViewXConstraint.offset = scrollView.contentOffset.x;
    }
    
//    NSLog(@"contentOffset.x:%f,contentSize.width:%f",self.scrollView.contentOffset.x,self.scrollView.contentSize.width);
    self.oldContentOffsetX = self.scrollView.contentOffset.x;
    [self getQueryMoreTradingDayInfoWithContentOffset:self.scrollView.contentOffset];
}

#pragma mark — Private method

- (void)updateLabelText:(JMKlineModel *)m {
    if (self.indicator1Painter) {
        self.topLabel.attributedText = [self.indicator1Painter getText: m];
    } else {
        self.topLabel.attributedText = m.V_Price;
    }
    // 底部浮动日期
    self.floatedDateLab.text = [NSString stringWithFormat:@" %@ ",m.V_YYYYMMDD];
    // 移动详细信息view
    self.moveDetailInfoView.chartType = self.kLineChartType;
    self.moveDetailInfoView.lineModel = m;
}

- (void)updateScrollViewContentSize {
    CGFloat contentSizeW = self.rootModel.models.count * [JMKlineGlobalVariable kLineWidth] + (self.rootModel.models.count -1) * [JMKlineGlobalVariable kLineGap];
    self.scrollView.contentSize = CGSizeMake(contentSizeW, self.scrollView.contentSize.height);
}

- (void)switchIndexButtonClick{
    self.selectorView.hidden = NO;
}

/// 指标选择
- (void)updateindicator1PainterWithIdx:(NSInteger)idx {
    switch (idx) {
        case 0:
            self.indicator1Painter = JMMAPainter.class;
            break;
        case 1:
            self.indicator1Painter = JMEMAPainter.class;
            break;
        case 2:
            self.indicator1Painter = JMBOLLPainter.class;
            break;
            
        default:
            break;
    }
    [self reDraw];
}

#pragma mark — UI

- (void)createUI {
    self.backgroundColor = [UIColor blueColor];
    
    self.backgroundColor = UIColor.backgroundColor;
    
    // 主图
    [self initScrollView];
    [self initPainterView];
    [self initYAxisView];
    [self initLabel];
    [self initLongPressControlUI];
    [self initMoveDetailInfoView];
    [self initSelectorView];
    
    // 菊花
    [self addSubview:self.indicatorView];
    
}

- (void)initScrollView {
    [self addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self);
    }];
}

- (void)initPainterView {
    [self.scrollView addSubview:self.painterView];
    [self.painterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.height.equalTo(self.scrollView);
        self.painterViewXConstraint = make.left.equalTo(self.scrollView);
    }];
}

- (void)initYAxisView {
    [self addSubview:self.yAxisView];
    [self.yAxisView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self);
        make.width.equalTo(@JMKlineLinePriceViewWidth);
    }];
}

- (void)initLabel {
   
    [self addSubview:self.switchIndexBtn];
    [self.switchIndexBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self).offset(5);
        make.height.equalTo(@10);
    }];
    
    [self addSubview:self.topLabel];
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).priorityLow();
        make.left.equalTo(self.switchIndexBtn.mas_right).mas_offset(8);
        make.top.equalTo(self).offset(5);
        make.height.equalTo(@10);
    }];

}

- (void)initLongPressControlUI {
    
    // 竖线
    [self.scrollView addSubview:self.verticalView];
    [self.verticalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0);
        make.width.equalTo(@(JMKlineLongPressVerticalViewWidth));
        make.height.equalTo(self.scrollView.mas_height);
        make.left.equalTo(@(-10));
    }];
    
    // 横线
    [self.scrollView addSubview:self.horizontalView];
    [self.horizontalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.scrollView.mas_width);
        make.height.equalTo(@(JMKlineLongPressVerticalViewWidth));
        make.left.equalTo(self);
        make.top.equalTo(self).offset(15);
    }];
    
    // 左侧浮动价格
    [self.scrollView addSubview:self.floatedPriceLab];
    [self.floatedPriceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(15);
        make.left.equalTo(self);
        make.top.equalTo(self).offset(50);
    }];
    
    // 右侧浮动涨跌幅
    [self.scrollView addSubview:self.floatedFluctuationRangeLab];
    [self.floatedFluctuationRangeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(15);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self).offset(50);
    }];
    
    // 底部浮动日期
    [self.scrollView addSubview:self.floatedDateLab];
    [self.floatedDateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(15);
        make.centerX.equalTo(self.verticalView);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
}

- (void)initMoveDetailInfoView {
    [self.scrollView addSubview:self.moveDetailInfoView];
    [self.moveDetailInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topLabel.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(self.yAxisView.mas_right).mas_offset(-50);
        make.width.mas_offset(100);
    }];
}

- (void)initSelectorView {

    [self addSubview:self.selectorView];
    [self.selectorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.switchIndexBtn.mas_bottom).mas_offset(5);
        make.left.mas_equalTo(self).mas_offset(5);
        make.width.mas_offset(30);
        make.height.mas_offset(90);
    }];
    
    // 回调函数
    WEAK_SELF(weakSelf);
    UIImage *image = [UIImage imageWithContentsOfFile:kImageNamed(@"expand_n.png")];
    [self.selectorView setSelectionIndicatorsBlock:^(NSString * _Nonnull title, NSInteger idx) {
        [weakSelf.switchIndexBtn setImage:image forState:UIControlStateNormal];
        [weakSelf.switchIndexBtn setTitle:title forState:UIControlStateNormal];
        [weakSelf.switchIndexBtn setLayoutType:KJButtonContentLayoutStyleLeftImageRight];
        weakSelf.selectorView.hidden = YES;
        [weakSelf updateindicator1PainterWithIdx:idx];
    }];
}

#pragma mark — Lazy

- (UIActivityIndicatorView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _indicatorView.frame = CGRectMake(0, 0, 100, 100);
        _indicatorView.center = self.center;
        
    }
    return _indicatorView;
}

- (JMIndicatorView *)selectorView {
    if (!_selectorView) {
        _selectorView = [[JMIndicatorView alloc] init];
        _selectorView.backgroundColor = UIColor.backgroundColor;
        _selectorView.layer.cornerRadius = 2.f;
        _selectorView.layer.masksToBounds = YES;
        _selectorView.layer.borderWidth = 1.0;
        _selectorView.layer.borderColor = UIColor.delayPromptViewBackgroundColor.CGColor;
        _selectorView.hidden = YES;
    }
    return  _selectorView;
}

- (JMMoveDetailInfoView *)moveDetailInfoView {
    if (!_moveDetailInfoView) {
        _moveDetailInfoView = [[JMMoveDetailInfoView alloc] init];
        _moveDetailInfoView.backgroundColor = UIColor.backgroundColor;
        _moveDetailInfoView.layer.cornerRadius = 4.f;
        _moveDetailInfoView.layer.masksToBounds = YES;
        _moveDetailInfoView.layer.borderWidth = 1.0;
        _moveDetailInfoView.layer.borderColor = UIColor.delayPromptViewBackgroundColor.CGColor;
        _moveDetailInfoView.hidden = YES;
    }
    return  _moveDetailInfoView;
}

- (UILabel *)floatedFluctuationRangeLab {
    if (!_floatedFluctuationRangeLab) {
        _floatedFluctuationRangeLab = [[UILabel alloc] init];
        _floatedFluctuationRangeLab.font = [UIFont systemFontOfSize:10.f];
        _floatedFluctuationRangeLab.backgroundColor = UIColor.backgroundColor;
        _floatedFluctuationRangeLab.textColor = UIColor.handicapInfoTextColor;
        _floatedFluctuationRangeLab.hidden = YES;
        _floatedFluctuationRangeLab.layer.borderWidth = 1.0;
        _floatedFluctuationRangeLab.layer.borderColor = UIColor.delayPromptViewBackgroundColor.CGColor;
    }
    return  _floatedFluctuationRangeLab;
}

- (UILabel *)floatedDateLab {
    if (!_floatedDateLab) {
        _floatedDateLab = [[UILabel alloc] init];
        _floatedDateLab.font = [UIFont systemFontOfSize:10.f];
        _floatedDateLab.backgroundColor = UIColor.backgroundColor;
        _floatedDateLab.textColor = UIColor.handicapInfoTextColor;
        _floatedDateLab.hidden = YES;
        _floatedDateLab.layer.borderWidth = 1.0;
        _floatedDateLab.layer.borderColor = UIColor.delayPromptViewBackgroundColor.CGColor;
    }
    return  _floatedDateLab;
}

- (UILabel *)floatedPriceLab {
    if (!_floatedPriceLab) {
        _floatedPriceLab = [[UILabel alloc] init];
        _floatedPriceLab.font = [UIFont systemFontOfSize:10.f];
        _floatedPriceLab.backgroundColor = UIColor.backgroundColor;
        _floatedPriceLab.textColor = UIColor.handicapInfoTextColor;
        _floatedPriceLab.hidden = YES;
        _floatedPriceLab.layer.borderWidth = 1.0;
        _floatedPriceLab.layer.borderColor = UIColor.delayPromptViewBackgroundColor.CGColor;
    }
    return  _floatedPriceLab;
}

- (UIView *)horizontalView {
    if (!_horizontalView) {
        _horizontalView = [[UIView alloc] init];
        _horizontalView.clipsToBounds = YES;
        _horizontalView.backgroundColor = UIColor.longPressLineColor;
        _horizontalView.hidden = YES;
    }
    return  _horizontalView;
}

- (UIView *)verticalView {
    if (!_verticalView) {
        _verticalView = [[UIView alloc] init];
        _verticalView.clipsToBounds = YES;
        _verticalView.backgroundColor = UIColor.longPressLineColor;
        _verticalView.hidden = YES;
    }
    return  _verticalView;
}

- (UILabel *)topLabel {
    if (!_topLabel) {
        _topLabel = [[UILabel alloc] init];
        _topLabel.font = [UIFont systemFontOfSize:8.f];
    }
    return  _topLabel;
}

- (UIButton *)switchIndexBtn {
    if (!_switchIndexBtn) {
        _switchIndexBtn = [[UIButton alloc] init];
        [_switchIndexBtn setImage:[UIImage imageWithContentsOfFile:kImageNamed(@"expand_n.png")] forState:UIControlStateNormal];
        [_switchIndexBtn setTitle:@"MA" forState:UIControlStateNormal];
        [_switchIndexBtn setTitleColor:UIColor.handicapInfoTextColor forState:UIControlStateNormal];
        [_switchIndexBtn.titleLabel setFont:[UIFont systemFontOfSize:10.f]];
        [_switchIndexBtn setLayoutType:KJButtonContentLayoutStyleLeftImageRight];
        [_switchIndexBtn addTarget:self action:@selector(switchIndexButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchIndexBtn;
}

- (UIView *)yAxisView {
    if (!_yAxisView) {
        _yAxisView = [[UIView alloc] init];
        _yAxisView.userInteractionEnabled = NO;
    }
    return  _yAxisView;
}

- (UIView *)painterView {
    if (!_painterView) {
        _painterView = [[UIView alloc] init];
    }
    return  _painterView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
        _scrollView.delegate = self;
        //缩放
        UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(event_pichMethod:)];
        [_scrollView addGestureRecognizer:pinchGesture];
        //长按
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(event_longPressMethod:)];
        [_scrollView addGestureRecognizer:longPressGesture];
    }
    return  _scrollView;
}

@end
