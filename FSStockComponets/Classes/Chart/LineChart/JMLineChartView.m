//
//  JMLineChartView.m
//  JMQuotesComponets_Example
//
//  Created by fargowealth on 2023/5/30.
//  Copyright © 2023 liyunlong1512. All rights reserved.
//

#import "JMLineChartView.h"

#import "YYMoveDetailInfoView.h"

static CGFloat topLableHeight = 35;
#define midLableHeight 10
#define bottomLableHeight 20

@interface JMLineChartView ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *painterView;
@property (nonatomic, strong) UILabel *leftLabel; // 辅助线价格标识
@property (nonatomic, strong) UILabel *middleLabel; // 辅助线时间标识
@property (nonatomic, strong) UILabel *rightLabel; // 辅助线涨跌标识
@property (nonatomic, strong) UILabel *topLabel; // 顶部详细信息
@property (nonatomic, strong) UIView *verticalView; // 辅助线竖线
@property (nonatomic, strong) UIView *horizontalView; // 辅助线横线

@property (nonatomic, assign) CGFloat oldExactOffset; // 旧的scrollview准确位移
@property (nonatomic, assign) CGFloat pinchCenterX;
@property (nonatomic, assign) NSInteger pinchIndex;
@property (nonatomic, assign) NSInteger needDrawStartIndex; // 需要绘制Index开始值
@property (nonatomic, assign) CGFloat oldContentOffsetX; // 旧的contentoffset值
@property (nonatomic, assign) CGFloat oldScale; // 旧的缩放值，捏合
@property (nonatomic, weak) MASConstraint *painterViewXConstraint;
@property (nonatomic, assign) CGFloat mainViewRatio; // 第一个View的高所占比例
@property (nonatomic, assign) CGFloat volumeViewRatio; // 第二个View(成交量)的高所占比例


@property (nonatomic, strong) YYMoveDetailInfoView *moveDetailInfoView; // 详细提示view

@property (nonatomic, assign) CGRect mainArea;
@property (nonatomic, assign) CGRect volArea;
@property (nonatomic, assign) CGRect timeArea;

@property (nonatomic, assign) CGRect viewArea;

@property(nonatomic,strong) YYMinMaxModel * maxMin;
@property(nonatomic,strong) YYMinMaxModel * volMaxMin;

@property(nonatomic,assign) BOOL reloading;

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView; // 菊花

@end

@implementation JMLineChartView

#pragma mark — life cycle

static void dispatch_main_async_safe(dispatch_block_t block) {
    dispatch_async(dispatch_get_main_queue(), ^{
        block();
    });
}

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
        [YYKlineGlobalVariable setkLineMainViewRadio:0.7];
        [YYKlineGlobalVariable setkLineVolumeViewRadio:0.3];
        self.mainViewRatio = [YYKlineGlobalVariable kLineMainViewRadio];
        self.volumeViewRatio = [YYKlineGlobalVariable kLineVolumeViewRadio];
        self.indicator1Painter = YYMAPainter.class;
        [self createUI];
    }
    return self;
}

#pragma mark — Private method

-(void)hideAll{
    self.verticalView.hidden = YES; // 取消竖线
    self.horizontalView.hidden = YES;
    self.moveDetailInfoView.hidden = YES;
    self.leftLabel.hidden = YES;
    self.rightLabel.hidden = YES;
    self.middleLabel.hidden = YES;
}

- (void)updateLabelText:(YYKlineModel *)m {
    if (self.indicator1Painter) {
        self.topLabel.attributedText = [self.indicator1Painter getText: m];
    } else {
        self.topLabel.attributedText = m.V_Price;
    }
    // 底部浮动日期
    self.middleLabel.text = [NSString stringWithFormat:@" %@ ", m.V_MMddHHMM];
}

- (void)updateScrollViewContentSize {
    CGFloat contentSizeW = self.rootModel.models.count * [YYKlineGlobalVariable kLineWidth] + (self.rootModel.models.count -1) * [YYKlineGlobalVariable kLineGap];
    self.scrollView.contentSize = CGSizeMake(contentSizeW, self.scrollView.contentSize.height);
}

#pragma mark 长按手势执行方法

- (void)event_longPressMethod:(UILongPressGestureRecognizer *)longPress {
    static CGFloat oldPositionX = 0;
    if ( !self.rootModel.models || self.rootModel.models.count == 0) {
        return;
    }
    if(UIGestureRecognizerStateChanged == longPress.state || UIGestureRecognizerStateBegan == longPress.state) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        CGPoint location = [longPress locationInView:self.scrollView];

        oldPositionX = location.x;
        NSInteger idx = ABS(floor(location.x / ([YYKlineGlobalVariable kLineWidth] + [YYKlineGlobalVariable kLineGap])));
        idx = MIN(idx, self.rootModel.models.count - 1);
        [self updateLabelText: self.rootModel.models[idx]];
        
        // 竖线配置
        [self.verticalView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(idx * ([YYKlineGlobalVariable kLineWidth] + [YYKlineGlobalVariable kLineGap]) + [YYKlineGlobalVariable kLineWidth]/2.f));
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
        YYKlineModel *lineModel = self.rootModel.models.lastObject;

        // 获取图表位置，进行赋值操作
        location = [longPress locationInView:self];
        if (CGRectContainsPoint(self.mainArea, location)) {

            CGFloat distance = (self.maxMin.max - self.maxMin.min) / self.mainArea.size.height;
            CGFloat height = CGRectGetMaxY(self.mainArea) - location.y;

            // 价格
            NSString *price = [NSString stringWithFormat:@" %.2f ",self.maxMin.min + height * distance];
            self.leftLabel.text = price;

            // 涨跌幅
            NSString *fluctuationRange = [NSString stringWithFormat:@" %.2f%% ",(self.maxMin.min + height * distance - lineModel.Close.doubleValue) / lineModel.Close.doubleValue * 100];
            self.rightLabel.text = fluctuationRange;

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
            self.rightLabel.text = vol;
        }

        // 左侧浮动价格
        [self.leftLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(location.y - 5);
        }];
        [self.leftLabel layoutIfNeeded];
        self.leftLabel.hidden = NO;
        
        // 右侧浮动涨跌幅
        [self.rightLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(location.y - 5);
            make.right.equalTo(self.mas_right);
        }];
        [self.rightLabel layoutIfNeeded];
        self.rightLabel.hidden = NO;

        // 底部浮动日期
        [self.middleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.verticalView);
            make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-CGRectGetHeight(self.painterView.bounds) * self.volumeViewRatio);
        }];
        [self.middleLabel layoutIfNeeded];
        self.middleLabel.hidden = NO;
        
        // 移动详细信息view
        if (location.x > 100) { //判断位置，切换左右显示
            [self.moveDetailInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.topLabel.mas_bottom).mas_offset(10);
                make.left.mas_equalTo(self).mas_offset(50);
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
        // 移动详细信息view
        self.moveDetailInfoView.lineModel = self.rootModel.models[idx];
        
    }
    
    if(longPress.state == UIGestureRecognizerStateEnded) {
        oldPositionX = 0;
        [self performSelector:@selector(hideAll) withObject:nil afterDelay:3];
    }
}

#pragma mark — 重绘

- (void)reDraw {
    CGFloat rightSpace = 2;
    if (self.centerViewType == KlineTypeTimeLine && self.pointCount != 0) {
        CGFloat klineWidth = 2*(self.frame.size.width-rightSpace)/(3*self.pointCount+1);
        [YYKlineGlobalVariable setkLineWith2:klineWidth];
        [YYKlineGlobalVariable setkLineGap:klineWidth/2];
        rightSpace = 0;
        topLableHeight = 10;
        self.topLabel.hidden = YES;
    }else{
        self.topLabel.hidden = NO;
        topLableHeight = 35;
    }
    
    dispatch_main_async_safe(^{
        CGFloat kLineViewWidth = self.rootModel.models.count * [YYKlineGlobalVariable kLineWidth] + (self.rootModel.models.count + 1) * [YYKlineGlobalVariable kLineGap]+rightSpace;
        [self updateScrollViewContentSize];
        CGFloat offset = kLineViewWidth - self.scrollView.frame.size.width;
        self.scrollView.contentOffset = CGPointMake(MAX(offset, 0), 0);
//        if (offset == self.oldContentOffsetX) {
            [self calculateNeedDrawModels];
//        }
    });

}

- (void)calculateNeedDrawModels {
    CGFloat lineGap = [YYKlineGlobalVariable kLineGap];
    CGFloat lineWidth = [YYKlineGlobalVariable kLineWidth];
    
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

- (void)drawWithModels:(NSArray <YYKlineModel *>*)models {
    if (models.count <= 0) {
        // 移除旧layer
        self.painterView.layer.sublayers = nil;
//        return;
    }
    
    YYMinMaxModel *minMax = [YYMinMaxModel new];
    minMax.min = 9999999999999.f;
    [minMax combine:[self.linePainter getMinMaxValue: models]];
    if (self.indicator1Painter) {
        [minMax combine:[self.indicator1Painter getMinMaxValue: models]];
    }

    // 移除旧layer
    self.painterView.layer.sublayers = nil;
    
    CGFloat offsetX = models.firstObject.index * (YYKlineGlobalVariable.kLineWidth + YYKlineGlobalVariable.kLineGap) - self.scrollView.contentOffset.x;
    
    CGFloat drawHeight = CGRectGetHeight(self.bounds) - topLableHeight -midLableHeight-bottomLableHeight;
    CGFloat mainHeight = drawHeight*self.mainViewRatio;
    CGFloat volHeight = drawHeight*self.volumeViewRatio;
    
    CGRect mainArea = CGRectMake(offsetX, topLableHeight, CGRectGetWidth(self.bounds), mainHeight);
    CGRect volArea = CGRectMake(offsetX, CGRectGetMaxY(mainArea)+midLableHeight+bottomLableHeight, CGRectGetWidth(mainArea), volHeight);
    CGRect timeArea = CGRectMake(offsetX, CGRectGetMaxY(mainArea), CGRectGetWidth(mainArea), midLableHeight);
    self.mainArea = mainArea;
    self.volArea = volArea;
    self.timeArea = timeArea;
    self.maxMin = minMax;
    
    
    if (self.centerViewType == KlineTypeTimeLine) {
        if (self.chartType == 3) {
            [YYTimePainter drawToLayer:self.painterView.layer area:timeArea models:models minMax:minMax close:self.close price:self.price];
        }else{//分时时间轴
            [YYTimePainter drawToLayer2:self.painterView.layer area:timeArea models:models minMax:minMax close:self.close price:self.price];
        }
        [YYVolPainter drawToLayer2: self.painterView.layer area: volArea models:models minMax:[YYVolPainter getMinMaxValue:models] close:self.close price:self.price];
    }else{
        // 时间轴
        if (self.chartType == 9) {
            [YYTimePainter drawToLayer4:self.painterView.layer area:timeArea models:models minMax:minMax close:self.close price:self.price];
        }else{
            [YYTimePainter drawToLayer3:self.painterView.layer area:timeArea models:models minMax:minMax close:self.close price:self.price];
        }
      
        [YYVolPainter drawToLayer: self.painterView.layer area: volArea models:models minMax:[YYVolPainter getMinMaxValue:models] close:self.close price:self.price];
    }


    
    // 主图
    [self.linePainter drawToLayer: self.painterView.layer area: mainArea models: models minMax: minMax close:self.close price:self.price];
    
    // 主图指标图
    if (self.indicator1Painter) {
        [self.indicator1Painter drawToLayer: self.painterView.layer area: mainArea models: models minMax: minMax close:self.close price:self.price];
    }

    // 文字
    [self updateLabelText: models.lastObject];
}

#pragma mark — UI

- (void)createUI {
    
    self.backgroundColor = UIColor.backgroundColor;
    
    // 主图
    [self initScrollView];
    [self initPainterView];
    [self initVerticalView];
    [self initLabel];
    [self initMoveDetail];
    
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

- (void)initVerticalView {
    [self.scrollView addSubview:self.verticalView];
    [self.verticalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0);
        make.width.equalTo(@(YYKlineLongPressVerticalViewWidth));
        make.height.equalTo(self.scrollView.mas_height);
        make.left.equalTo(@(-10));
    }];
    
    [self.scrollView addSubview:self.horizontalView];
    [self.horizontalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.scrollView.mas_width);
        make.height.equalTo(@(YYKlineLongPressVerticalViewWidth));
        make.left.equalTo(self);
        make.top.equalTo(self).offset(15);
    }];
}

- (void)initLabel {

    [self.scrollView addSubview:self.leftLabel];
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(15);
        make.left.equalTo(self);
        make.top.equalTo(self).offset(50);
    }];
    
    // 底部浮动日期
    [self.scrollView addSubview:self.middleLabel];
    [self.middleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(15);
        make.centerX.equalTo(self.verticalView);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    // 右侧浮动涨跌幅
    [self.scrollView addSubview:self.rightLabel];
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(15);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self).offset(50);
    }];
    
    UILabel *label4 = [UILabel new];
    label4.font = [UIFont systemFontOfSize:9];
    label4.textColor = UIColor.moveViewTitleColor;
    [self addSubview:label4];
    self.topLabel = label4;

    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self);
        make.height.mas_equalTo(topLableHeight-10);
    }];
}

-(void)initMoveDetail{
    [self.scrollView addSubview:self.moveDetailInfoView];
    [self.moveDetailInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topLabel.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(self).mas_offset(50);
        make.width.mas_offset(100);
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

- (YYMoveDetailInfoView *)moveDetailInfoView {
    if (!_moveDetailInfoView) {
        _moveDetailInfoView = [[YYMoveDetailInfoView alloc] init];
        _moveDetailInfoView.backgroundColor = UIColor.backgroundColor;
        _moveDetailInfoView.layer.cornerRadius = 4.f;
        _moveDetailInfoView.layer.masksToBounds = YES;
        _moveDetailInfoView.layer.borderWidth = 1.0;
        _moveDetailInfoView.layer.borderColor = UIColor.delayPromptViewBackgroundColor.CGColor;
        _moveDetailInfoView.hidden = YES;
    }
    return  _moveDetailInfoView;
}

- (UILabel *)rightLabel {
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.font = [UIFont systemFontOfSize:10.f];
        _rightLabel.backgroundColor = UIColor.backgroundColor;
        _rightLabel.textColor = UIColor.handicapInfoTextColor;
        _rightLabel.hidden = YES;
        _rightLabel.layer.borderWidth = 1.0;
        _rightLabel.layer.borderColor = UIColor.delayPromptViewBackgroundColor.CGColor;
    }
    return  _rightLabel;
}

- (UILabel *)middleLabel {
    if (!_middleLabel) {
        _middleLabel = [[UILabel alloc] init];
        _middleLabel.font = [UIFont systemFontOfSize:10.f];
        _middleLabel.backgroundColor = UIColor.backgroundColor;
        _middleLabel.textColor = UIColor.handicapInfoTextColor;
        _middleLabel.hidden = YES;
        _middleLabel.layer.borderWidth = 1.0;
        _middleLabel.layer.borderColor = UIColor.delayPromptViewBackgroundColor.CGColor;
    }
    return  _middleLabel;
}

- (UILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.font = [UIFont systemFontOfSize:10.f];
        _leftLabel.backgroundColor = UIColor.backgroundColor;
        _leftLabel.textColor = UIColor.handicapInfoTextColor;
        _leftLabel.hidden = YES;
        _leftLabel.layer.borderWidth = 1.0;
        _leftLabel.layer.borderColor = UIColor.delayPromptViewBackgroundColor.CGColor;
    }
    return  _leftLabel;
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
        //长按
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(event_longPressMethod:)];
        [_scrollView addGestureRecognizer:longPressGesture];
    }
    return  _scrollView;
}

#pragma mark - 数据重载

-(void)setCenterViewType:(KlineType)centerViewType{
    if (centerViewType != _centerViewType) {
        _centerViewType = centerViewType;
        if (_centerViewType == KlineTypeTimeLine) {
            self.indicator1Painter = nil;
            self.topLabel.hidden = YES;
        }else{
            self.indicator1Painter = YYMAPainter.class;
            self.topLabel.hidden = NO;
        }
    }
}

@end
