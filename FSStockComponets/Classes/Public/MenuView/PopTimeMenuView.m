//
//  PopTimeMenuView.m
//  JMQuotesComponets
//
//  Created by fargowealth on 2023/7/7.
//

#import "PopTimeMenuView.h"
#import "QuotationConstant.h"
#import <Masonry/Masonry.h>
#import "PopTimeMenuTableViewCell.h"

@interface PopTimeMenuView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

/** 时间 */
@property (nonatomic, strong) NSArray *timeArray;

/** 权重 */
@property (nonatomic, strong) NSArray *weightsArray;

@end

@implementation PopTimeMenuView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

#pragma mark — Private method

#pragma mark - UITableViewDataSource, UITableViewDelegate


// 处理某行的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld",indexPath.row);
    
    if (self.type == 0){
        NSLog(@"点击了%@",self.timeArray[indexPath.row]);
        if ([self.delegate respondsToSelector:@selector(popTimeMenuViewTimeSelectionWithIndex:Title:)]) {
            [self.delegate popTimeMenuViewTimeSelectionWithIndex:indexPath.row Title:self.timeArray[indexPath.row]];
        }

    } else if (self.type == 1) {
        NSLog(@"点击了%@",self.weightsArray[indexPath.row]);
        if ([self.delegate respondsToSelector:@selector(popTimeMenuViewWeightsSelectionWithIndex:Title:)]) {
            [self.delegate popTimeMenuViewWeightsSelectionWithIndex:indexPath.row Title:self.weightsArray[indexPath.row]];
        }
    }
    
}

/// 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.type == 0 ? self.timeArray.count : self.weightsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PopTimeMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PopTimeMenuTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString * titleStr = self.type == 0 ? self.timeArray[indexPath.row] : self.weightsArray[indexPath.row];
    cell.titleLab.text = titleStr;
    
    if ([titleStr isEqualToString:self.selectionTitle]) {
        // 两个字符串相等
        cell.selectionIcon.hidden = NO;
        cell.titleLab.textColor = UIColor.delayPromptTextColor;
    } else {
        // 两个字符串不相等
        cell.selectionIcon.hidden = YES;
        cell.titleLab.textColor = UIColor.handicapInfoTextColor;
    }
    
    return cell;
}

#pragma mark - createUI

- (void)createUI {
    
    self.backgroundColor = [UIColor whiteColor];
    
    // 设置阴影颜色、偏移量、透明度和半径
    self.layer.shadowColor = UIColor.jmShadowColor.CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 2);
    self.layer.shadowOpacity = 0.3;
    self.layer.shadowRadius = 1.0;
    
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.mas_equalTo(self);
    }];
    
}

#pragma mark — Lazy

-(NSArray *)weightsArray
{
    if (!_weightsArray) {
        _weightsArray = @[@"前复权",@"后复权",@"除权"];
    }
    return _weightsArray;
}

-(NSArray *)timeArray
{
    if (!_timeArray) {
        _timeArray = @[@"1分",@"5分",@"15分",@"30分",@"60分"];
    }
    return _timeArray;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
        // 设置tableView自动高度
        _tableView.rowHeight = kHeightScale(40);
        _tableView.separatorColor = UIColor.dividingLineColor;
        [_tableView registerClass:[PopTimeMenuTableViewCell class] forCellReuseIdentifier:@"PopTimeMenuTableViewCell"];
        _tableView.allowsSelectionDuringEditing = YES;
    }
    return _tableView;
}

#pragma mark - 数据重载

- (void)setType:(NSInteger)type {
    _type = type;
    [self.tableView reloadData];
}

- (void)setSelectionTitle:(NSString *)selectionTitle {
    _selectionTitle = selectionTitle;
    [self.tableView reloadData];
}

@end
