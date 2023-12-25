//
//  JMQuotationListView.m
//  JMQuotesComponets_Example
//
//  Created by fargowealth on 2023/5/29.
//  Copyright © 2023 liyunlong1512. All rights reserved.
//

#import "JMQuotationListView.h"
#import "QuotationConstant.h"
#import "UIButton+KJContentLayout.h"
#import "JMQuotationListTableViewCell.h"
#import "JMDelayPromptView.h"
#import "JMQuotationListHeadView.h"
#import "WOCrashProtectorManager.h"
//Helper
#import "NSBundle+FSStockComponents.h"

typedef NS_ENUM(NSInteger, SortState) {
    SortStateDefault,
    SortStateAscending,
    SortStateDescending
};

@interface JMQuotationListView () <UITableViewDataSource, UITableViewDelegate, DelayPromptViewDelegate, QuotationListHeadViewDelegate, UIGestureRecognizerDelegate>

/** 延时行情提示 */
@property (nonatomic,strong) JMDelayPromptView *delayPromptView;

/** 行情列表头部 */
@property (nonatomic,strong) JMQuotationListHeadView *quotationListHeadView;

/** 名称代码 */
@property (nonatomic,strong) UILabel *nameCodeLab;

/** 最新价格排序按钮 */
@property (nonatomic,strong) UIButton *sortPriceBtn;
@property (nonatomic, assign) SortState sortPriceState;

/** 涨跌幅排序按钮 */
@property (nonatomic,strong) UIButton *sortQuoteChangeBtn;
@property (nonatomic, assign) SortState sortQuoteState;

/** 行情列表 */
@property (nonatomic, strong) UITableView *tableView;

/** 默认数据源 */
@property (nonatomic,strong) NSMutableArray *defaultDataSource;

/** 排序数据源 */
@property (nonatomic,strong) NSMutableArray *sortDataSource;

/** 空数据 */
@property (nonatomic, strong) UIImageView *nullDataImageView;

/** 空数据 */
@property (nonatomic, strong) UILabel *nullDataLab;

/** HK */
@property (nonatomic, strong) NSMutableArray *hkDataSource;

/** US */
@property (nonatomic, strong) NSMutableArray *usDataSource;

/** 沪深 */
@property (nonatomic, strong) NSMutableArray *hsDataSource;

/** 是否暂停MQTT */
@property(nonatomic, assign) BOOL isPauseMQTT;

@end

@implementation JMQuotationListView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //开启防crash机制
        [WOCrashProtectorManager makeAllEffective];
        [self createUI];
        self.sortPriceState = SortStateDefault;
        self.sortQuoteState = SortStateDefault;
        self.isPauseMQTT = NO;
    }
    return self;
}

- (void)createUI {
    
    self.backgroundColor = UIColor.backgroundColor;
    
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
    
    
    [self addSubview:self.delayPromptView];
    [self.delayPromptView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self);
        make.height.mas_offset(kHeightScale(24));
    }];
    
    [self addSubview:self.quotationListHeadView];
    [self.quotationListHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.delayPromptView.mas_bottom).mas_offset(16);
        make.left.mas_equalTo(self).mas_offset(16);
        make.right.mas_equalTo(self.mas_right).mas_offset(-16);
        make.height.mas_offset(kHeightScale(24));
    }];
    
    [self addSubview:self.nameCodeLab];
    [self.nameCodeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.quotationListHeadView.mas_bottom).mas_offset(16);
        make.left.mas_equalTo(self).mas_offset(16);
    }];

    [self addSubview:self.sortQuoteChangeBtn];
    [self.sortQuoteChangeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameCodeLab);
        make.right.mas_equalTo(self.mas_right).mas_offset(-10);
        make.width.mas_offset(kWidthScale(60));
        make.height.mas_offset(kHeightScale(14));
    }];

    [self addSubview:self.sortPriceBtn];
    [self.sortPriceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.sortQuoteChangeBtn);
        make.right.mas_equalTo(self.sortQuoteChangeBtn.mas_left).mas_offset(-10);
        make.width.mas_offset(kWidthScale(80));
        make.height.mas_offset(kHeightScale(14));
    }];
    
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameCodeLab.mas_bottom).mas_offset(16);
        make.left.right.bottom.equalTo(self);
    }];
    
}

#pragma mark - Private method

#pragma mark - 自选股列表排序方法

/**
 * 自选股列表排序方法
 * sortState            排序方式
 * sortType             排序类型 1.价格 2.涨跌幅
 */

- (void)setDataSortingMethodWithSortState:(SortState)sortState
                                 SortType:(NSInteger)sortType  {
    // 获取当前时间
    NSDate *currentTime = [NSDate date];

    // 创建一个 NSDateFormatter 对象，用于格式化日期和时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    [dateFormatter setDateFormat:@"HH:mm"];

    // 将当前时间格式化为字符串
    NSString *currentTimeString = [dateFormatter stringFromDate:currentTime];

    // 比较当前时间和默认时间
    NSString *defaultTime1 = @"08:00";
    NSString *defaultTime2 = @"20:00";
    
    
    [self.hkDataSource removeAllObjects];
    [self.usDataSource removeAllObjects];
    [self.hsDataSource removeAllObjects];
    [self.sortDataSource removeAllObjects];
    
    [self.defaultDataSource enumerateObjectsUsingBlock:^(JMQuotationListModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        if (model.stockMarketType == StockMarketType_HK) {
            [self.hkDataSource addObject:model];
        } else if (model.stockMarketType == StockMarketType_US) {
            [self.usDataSource addObject:model];
        } else {
            [self.hsDataSource addObject:model];
        }
    }];
    
    if ([currentTimeString compare:defaultTime1] == NSOrderedDescending && [currentTimeString compare:defaultTime2] == NSOrderedAscending) {
        NSLog(@"当前时间处于默认时间1和默认时间2之间");
        [self setSortHKWithSortState:sortState SortType:sortType];
    } else {
        NSLog(@"当前时间不处于默认时间1和默认时间2之间");
        [self setSortUSWithSortState:sortState SortType:sortType];
    }
}

- (void)setSortHKWithSortState:(SortState)sortState
                      SortType:(SortState)sortType {
    
    switch (sortState) {
        case SortStateDefault:{
            [self.sortDataSource addObjectsFromArray:self.defaultDataSource];
        }
            break;
        case SortStateAscending:{
            
            if (sortType == 1) {
                // 价格升序
                [self.hkDataSource sortUsingComparator:^NSComparisonResult(JMQuotationListModel *a, JMQuotationListModel *b) {
                    if (a.price.floatValue < b.price.floatValue) {
                        return NSOrderedAscending;
                    } else if (a.price.floatValue > b.price.floatValue) {
                        return NSOrderedDescending;
                    } else {
                        return NSOrderedSame;
                    }
                }];
                
                [self.usDataSource sortUsingComparator:^NSComparisonResult(JMQuotationListModel *a, JMQuotationListModel *b) {
                    if (a.price.floatValue < b.price.floatValue) {
                        return NSOrderedAscending;
                    } else if (a.price.floatValue > b.price.floatValue) {
                        return NSOrderedDescending;
                    } else {
                        return NSOrderedSame;
                    }
                }];
                
                [self.hsDataSource sortUsingComparator:^NSComparisonResult(JMQuotationListModel *a, JMQuotationListModel *b) {
                    if (a.price.floatValue < b.price.floatValue) {
                        return NSOrderedAscending;
                    } else if (a.price.floatValue > b.price.floatValue) {
                        return NSOrderedDescending;
                    } else {
                        return NSOrderedSame;
                    }
                }];
            }
            
            if (sortType == 2) {
                // 涨跌幅升序
                [self.hkDataSource sortUsingComparator:^NSComparisonResult(JMQuotationListModel *a, JMQuotationListModel *b) {
                    if (a.changePct.floatValue < b.changePct.floatValue) {
                        return NSOrderedAscending;
                    } else if (a.changePct.floatValue > b.changePct.floatValue) {
                        return NSOrderedDescending;
                    } else {
                        return NSOrderedSame;
                    }
                }];
                
                [self.usDataSource sortUsingComparator:^NSComparisonResult(JMQuotationListModel *a, JMQuotationListModel *b) {
                    if (a.changePct.floatValue < b.changePct.floatValue) {
                        return NSOrderedAscending;
                    } else if (a.changePct.floatValue > b.changePct.floatValue) {
                        return NSOrderedDescending;
                    } else {
                        return NSOrderedSame;
                    }
                }];
                
                [self.hsDataSource sortUsingComparator:^NSComparisonResult(JMQuotationListModel *a, JMQuotationListModel *b) {
                    if (a.changePct.floatValue < b.changePct.floatValue) {
                        return NSOrderedAscending;
                    } else if (a.changePct.floatValue > b.changePct.floatValue) {
                        return NSOrderedDescending;
                    } else {
                        return NSOrderedSame;
                    }
                }];
            }
            
            [self.sortDataSource addObjectsFromArray:self.hkDataSource];
            [self.sortDataSource addObjectsFromArray:self.hsDataSource];
            [self.sortDataSource addObjectsFromArray:self.usDataSource];
            
        }
            break;
        case SortStateDescending:{
            if (sortType == 1) {
                // 价格降序
                [self.hkDataSource sortUsingComparator:^NSComparisonResult(JMQuotationListModel *a, JMQuotationListModel *b) {
                    if (a.price.floatValue > b.price.floatValue) {
                        return NSOrderedAscending;
                    } else if (a.price.floatValue < b.price.floatValue) {
                        return NSOrderedDescending;
                    } else {
                        return NSOrderedSame;
                    }
                }];
                
                [self.usDataSource sortUsingComparator:^NSComparisonResult(JMQuotationListModel *a, JMQuotationListModel *b) {
                    if (a.price.floatValue > b.price.floatValue) {
                        return NSOrderedAscending;
                    } else if (a.price.floatValue < b.price.floatValue) {
                        return NSOrderedDescending;
                    } else {
                        return NSOrderedSame;
                    }
                }];
                
                [self.hsDataSource sortUsingComparator:^NSComparisonResult(JMQuotationListModel *a, JMQuotationListModel *b) {
                    if (a.price.floatValue > b.price.floatValue) {
                        return NSOrderedAscending;
                    } else if (a.price.floatValue < b.price.floatValue) {
                        return NSOrderedDescending;
                    } else {
                        return NSOrderedSame;
                    }
                }];
            }
            
            if (sortType == 2) {
                // 涨跌幅降序
                [self.hkDataSource sortUsingComparator:^NSComparisonResult(JMQuotationListModel *a, JMQuotationListModel *b) {
                    if (a.changePct.floatValue > b.changePct.floatValue) {
                        return NSOrderedAscending;
                    } else if (a.changePct.floatValue < b.changePct.floatValue) {
                        return NSOrderedDescending;
                    } else {
                        return NSOrderedSame;
                    }
                }];
                
                [self.usDataSource sortUsingComparator:^NSComparisonResult(JMQuotationListModel *a, JMQuotationListModel *b) {
                    if (a.changePct.floatValue > b.changePct.floatValue) {
                        return NSOrderedAscending;
                    } else if (a.changePct.floatValue < b.changePct.floatValue) {
                        return NSOrderedDescending;
                    } else {
                        return NSOrderedSame;
                    }
                }];
                
                [self.hsDataSource sortUsingComparator:^NSComparisonResult(JMQuotationListModel *a, JMQuotationListModel *b) {
                    if (a.changePct.floatValue > b.changePct.floatValue) {
                        return NSOrderedAscending;
                    } else if (a.changePct.floatValue < b.changePct.floatValue) {
                        return NSOrderedDescending;
                    } else {
                        return NSOrderedSame;
                    }
                }];
                
            }
            
            [self.sortDataSource addObjectsFromArray:self.hkDataSource];
            [self.sortDataSource addObjectsFromArray:self.hsDataSource];
            [self.sortDataSource addObjectsFromArray:self.usDataSource];
            
        }
            break;
            
        default:
            break;
    }
    
}

- (void)setSortUSWithSortState:(SortState)sortState
                      SortType:(SortState)sortType {
    switch (sortState) {
        case SortStateDefault:{
            [self.sortDataSource addObjectsFromArray:self.defaultDataSource];
        }
            break;
        case SortStateAscending:{
            if (sortType == 1) {
                // 价格升序
                [self.hkDataSource sortUsingComparator:^NSComparisonResult(JMQuotationListModel *a, JMQuotationListModel *b) {
                    if (a.price.floatValue < b.price.floatValue) {
                        return NSOrderedAscending;
                    } else if (a.price.floatValue > b.price.floatValue) {
                        return NSOrderedDescending;
                    } else {
                        return NSOrderedSame;
                    }
                }];
                
                [self.usDataSource sortUsingComparator:^NSComparisonResult(JMQuotationListModel *a, JMQuotationListModel *b) {
                    if (a.price.floatValue < b.price.floatValue) {
                        return NSOrderedAscending;
                    } else if (a.price.floatValue > b.price.floatValue) {
                        return NSOrderedDescending;
                    } else {
                        return NSOrderedSame;
                    }
                }];
                
                [self.hsDataSource sortUsingComparator:^NSComparisonResult(JMQuotationListModel *a, JMQuotationListModel *b) {
                    if (a.price.floatValue < b.price.floatValue) {
                        return NSOrderedAscending;
                    } else if (a.price.floatValue > b.price.floatValue) {
                        return NSOrderedDescending;
                    } else {
                        return NSOrderedSame;
                    }
                }];
            }
            
            if (sortType == 2) {
                // 涨跌幅升序
                [self.hkDataSource sortUsingComparator:^NSComparisonResult(JMQuotationListModel *a, JMQuotationListModel *b) {
                    if (a.changePct.floatValue < b.changePct.floatValue) {
                        return NSOrderedAscending;
                    } else if (a.changePct.floatValue > b.changePct.floatValue) {
                        return NSOrderedDescending;
                    } else {
                        return NSOrderedSame;
                    }
                }];
                
                [self.usDataSource sortUsingComparator:^NSComparisonResult(JMQuotationListModel *a, JMQuotationListModel *b) {
                    if (a.changePct.floatValue < b.changePct.floatValue) {
                        return NSOrderedAscending;
                    } else if (a.changePct.floatValue > b.changePct.floatValue) {
                        return NSOrderedDescending;
                    } else {
                        return NSOrderedSame;
                    }
                }];
                
                [self.hsDataSource sortUsingComparator:^NSComparisonResult(JMQuotationListModel *a, JMQuotationListModel *b) {
                    if (a.changePct.floatValue < b.changePct.floatValue) {
                        return NSOrderedAscending;
                    } else if (a.changePct.floatValue > b.changePct.floatValue) {
                        return NSOrderedDescending;
                    } else {
                        return NSOrderedSame;
                    }
                }];
            }
            
            [self.sortDataSource addObjectsFromArray:self.usDataSource];
            [self.sortDataSource addObjectsFromArray:self.hkDataSource];
            [self.sortDataSource addObjectsFromArray:self.hsDataSource];
    
        }
            break;
        case SortStateDescending:{
            if (sortType == 1) {
                // 价格降序
                [self.hkDataSource sortUsingComparator:^NSComparisonResult(JMQuotationListModel *a, JMQuotationListModel *b) {
                    if (a.price.floatValue > b.price.floatValue) {
                        return NSOrderedAscending;
                    } else if (a.price.floatValue < b.price.floatValue) {
                        return NSOrderedDescending;
                    } else {
                        return NSOrderedSame;
                    }
                }];
                
                [self.usDataSource sortUsingComparator:^NSComparisonResult(JMQuotationListModel *a, JMQuotationListModel *b) {
                    if (a.price.floatValue > b.price.floatValue) {
                        return NSOrderedAscending;
                    } else if (a.price.floatValue < b.price.floatValue) {
                        return NSOrderedDescending;
                    } else {
                        return NSOrderedSame;
                    }
                }];
                
                [self.hsDataSource sortUsingComparator:^NSComparisonResult(JMQuotationListModel *a, JMQuotationListModel *b) {
                    if (a.price.floatValue > b.price.floatValue) {
                        return NSOrderedAscending;
                    } else if (a.price.floatValue < b.price.floatValue) {
                        return NSOrderedDescending;
                    } else {
                        return NSOrderedSame;
                    }
                }];
            }
            
            if (sortType == 2) {
                // 涨跌幅降序
                [self.hkDataSource sortUsingComparator:^NSComparisonResult(JMQuotationListModel *a, JMQuotationListModel *b) {
                    if (a.changePct.floatValue > b.changePct.floatValue) {
                        return NSOrderedAscending;
                    } else if (a.changePct.floatValue < b.changePct.floatValue) {
                        return NSOrderedDescending;
                    } else {
                        return NSOrderedSame;
                    }
                }];
                
                [self.usDataSource sortUsingComparator:^NSComparisonResult(JMQuotationListModel *a, JMQuotationListModel *b) {
                    if (a.changePct.floatValue > b.changePct.floatValue) {
                        return NSOrderedAscending;
                    } else if (a.changePct.floatValue < b.changePct.floatValue) {
                        return NSOrderedDescending;
                    } else {
                        return NSOrderedSame;
                    }
                }];
                
                [self.hsDataSource sortUsingComparator:^NSComparisonResult(JMQuotationListModel *a, JMQuotationListModel *b) {
                    if (a.changePct.floatValue > b.changePct.floatValue) {
                        return NSOrderedAscending;
                    } else if (a.changePct.floatValue < b.changePct.floatValue) {
                        return NSOrderedDescending;
                    } else {
                        return NSOrderedSame;
                    }
                }];
            }
            
            [self.sortDataSource addObjectsFromArray:self.usDataSource];
            [self.sortDataSource addObjectsFromArray:self.hkDataSource];
            [self.sortDataSource addObjectsFromArray:self.hsDataSource];
            
        }
            break;
        default:
            break;
    }
    
}

#pragma mark - QuotationListHeadViewDelegate

- (void)quotationListHeadViewWithSelectionIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(quotationListDelegateWithSelectedCategoryIndex:)]) {
        [self.delegate quotationListDelegateWithSelectedCategoryIndex:index];
    }
}

#pragma mark - DelayPromptViewDelegate

- (void)closePrompt {
    NSLog(@"关闭延时行情提示");
    self.delayPromptView.hidden = YES;
    [self.delayPromptView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(0);
    }];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    // 在这里处理 UITableViewCell 的左滑事件
    NSLog(@"左滑");
    self.isPauseMQTT = YES;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    self.isPauseMQTT = NO;
    [self.tableView setEditing:NO animated:YES];  // 重置编辑状态
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        
        self.isPauseMQTT = NO;
        if ([self.delegate respondsToSelector:@selector(deleteOptionalStockWithSelectedStockCode:fetchCompletionHandler:)]) {
            JMQuotationListModel *model = self.sortDataSource[indexPath.row];
            [self.delegate deleteOptionalStockWithSelectedStockCode:model.assetId fetchCompletionHandler:^(BOOL isDelete) {
                
                if (isDelete) {
                    // 在这里执行删除操作
                    [self.sortDataSource removeObjectAtIndex:indexPath.row];
                    [self.defaultDataSource removeObjectAtIndex:indexPath.row];
                    [self.tableView  deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                    [self.tableView setEditing:NO animated:YES];
                }
                
            }];
        }
        
    }];
    deleteAction.backgroundColor = UIColor.upColor;
    deleteAction.image = [NSBundle fsStockUI_imageName:@"delete.png"];
    
    UISwipeActionsConfiguration *Configuration = [UISwipeActionsConfiguration configurationWithActions:@[deleteAction]];
    Configuration.performsFirstActionWithFullSwipe = NO;
    return Configuration;
}

// 处理某行的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(quotationListDelegateWithSelectedModel:)]) {
        JMQuotationListModel *model = self.sortDataSource[indexPath.row];
        [self.delegate quotationListDelegateWithSelectedModel:model];
    }
}

/// 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sortDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JMQuotationListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JMQuotationListTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.quotationListModel = self.sortDataSource[indexPath.row];
    return cell;
}

#pragma mark - 按钮事件

- (void)SortQuoteChangeButtonClick:(UIButton *)sender {
    
    switch (self.sortQuoteState) {
        case SortStateDefault:
            self.sortQuoteState = SortStateAscending;
            [self.sortQuoteChangeBtn setImage:[NSBundle fsStockUI_imageName:@"sort_s.png"] forState:UIControlStateNormal];
            [self setDataSortingMethodWithSortState:SortStateAscending SortType:2];
            break;
        case SortStateAscending:
            self.sortQuoteState = SortStateDescending;
            [self.sortQuoteChangeBtn setImage:[NSBundle fsStockUI_imageName:@"sort_n.png"] forState:UIControlStateNormal];
            [self setDataSortingMethodWithSortState:SortStateDescending SortType:2];
            break;
        case SortStateDescending:
            self.sortQuoteState = SortStateDefault;
            [self.sortQuoteChangeBtn setImage:[NSBundle fsStockUI_imageName:@"sort.png"] forState:UIControlStateNormal];
            [self setDataSortingMethodWithSortState:SortStateDefault SortType:2];
            break;
        default:
            break;
    }
    
    [self.tableView reloadData];
}

- (void)SortPriceButtonClick:(UIButton *)sender {
       
    switch (self.sortPriceState) {
        case SortStateDefault:
            self.sortPriceState = SortStateAscending;
            [self.sortPriceBtn setImage:[NSBundle fsStockUI_imageName:@"sort_s.png"] forState:UIControlStateNormal];
            [self setDataSortingMethodWithSortState:SortStateAscending SortType:1];
            break;
        case SortStateAscending:
            self.sortPriceState = SortStateDescending;
            [self.sortPriceBtn setImage:[NSBundle fsStockUI_imageName:@"sort_n.png"] forState:UIControlStateNormal];
            [self setDataSortingMethodWithSortState:SortStateDescending SortType:1];
            break;
        case SortStateDescending:
            self.sortPriceState = SortStateDefault;
            [self.sortPriceBtn setImage:[NSBundle fsStockUI_imageName:@"sort.png"] forState:UIControlStateNormal];
            [self setDataSortingMethodWithSortState:SortStateDefault SortType:1];
            break;
        default:
            break;
    }
    
    [self.tableView reloadData];
    
}

#pragma mark — Lazy

- (NSMutableArray *)hsDataSource {
    if (!_hsDataSource) {
        _hsDataSource = [[NSMutableArray alloc] init];
    }
    return _hsDataSource;
}

- (NSMutableArray *)usDataSource {
    if (!_usDataSource) {
        _usDataSource = [[NSMutableArray alloc] init];
    }
    return _usDataSource;
}

- (NSMutableArray *)hkDataSource {
    if (!_hkDataSource) {
        _hkDataSource = [[NSMutableArray alloc] init];
    }
    return _hkDataSource;
}

- (NSMutableArray *)sortDataSource {
    if (!_sortDataSource) {
        _sortDataSource = [[NSMutableArray alloc] init];
    }
    return _sortDataSource;
}

- (NSMutableArray *)defaultDataSource {
    if (!_defaultDataSource) {
        _defaultDataSource = [[NSMutableArray alloc] init];
    }
    return _defaultDataSource;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
        // 设置tableView自动高度
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.backgroundColor = UIColor.stockDetailsBackgroundColor;
        _tableView.separatorColor = UIColor.dividingLineColor;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
        [_tableView registerClass:[JMQuotationListTableViewCell class] forCellReuseIdentifier:@"JMQuotationListTableViewCell"];
        _tableView.allowsSelectionDuringEditing = YES;
    }
    return _tableView;
}

- (UIButton *)sortQuoteChangeBtn {
    if (!_sortQuoteChangeBtn) {
        _sortQuoteChangeBtn = [[UIButton alloc] init];
        
        [_sortQuoteChangeBtn setImage:[NSBundle fsStockUI_imageName:@"sort.png"] forState:UIControlStateNormal];
        [_sortQuoteChangeBtn setTitle:FSLanguage(@"涨跌幅") forState:UIControlStateNormal];
        [_sortQuoteChangeBtn setTitleColor:UIColor.quotesListHeadTitleColor forState:UIControlStateNormal];
        [_sortQuoteChangeBtn.titleLabel setFont:kFont_Regular(12)];
        [_sortQuoteChangeBtn setLayoutType:KJButtonContentLayoutStyleLeftImageRight];
        [_sortQuoteChangeBtn setPadding:2.f];
        [_sortQuoteChangeBtn setPeriphery:0.f];
        [_sortQuoteChangeBtn addTarget:self action:@selector(SortQuoteChangeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sortQuoteChangeBtn;
}

- (UIButton *)sortPriceBtn {
    if (!_sortPriceBtn) {
        _sortPriceBtn = [[UIButton alloc] init];
        [_sortPriceBtn setImage:[NSBundle fsStockUI_imageName:@"sort.png"] forState:UIControlStateNormal];
        [_sortPriceBtn setTitle:FSLanguage(@"最新价格") forState:UIControlStateNormal];
        [_sortPriceBtn setTitleColor:UIColor.quotesListHeadTitleColor forState:UIControlStateNormal];
        [_sortPriceBtn.titleLabel setFont:kFont_Regular(12)];
        [_sortPriceBtn setLayoutType:KJButtonContentLayoutStyleLeftImageRight];
        [_sortPriceBtn setPadding:2.f];
        [_sortPriceBtn setPeriphery:0.f];
        [_sortPriceBtn addTarget:self action:@selector(SortPriceButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sortPriceBtn;
}

- (UILabel *)nameCodeLab {
    if (!_nameCodeLab){
        _nameCodeLab = [[UILabel alloc] init];
        _nameCodeLab.font = kFont_Regular(12);
        _nameCodeLab.text = FSLanguage(@"名称代码");
        _nameCodeLab.textColor = UIColor.quotesListHeadTitleColor;
    }
    return  _nameCodeLab;
}

- (JMQuotationListHeadView *)quotationListHeadView {
    if (!_quotationListHeadView){
        _quotationListHeadView = [[JMQuotationListHeadView alloc] init];
        _quotationListHeadView.delegate = self;
    }
    return  _quotationListHeadView;
}

- (JMDelayPromptView *)delayPromptView {
    if (!_delayPromptView){
        _delayPromptView = [[JMDelayPromptView alloc] init];
        _delayPromptView.delegate = self;
    }
    return  _delayPromptView;
}

- (UILabel *)nullDataLab {
    if (!_nullDataLab) {
        _nullDataLab = [[UILabel alloc] init];
        _nullDataLab.text = FSLanguage(@"暂无数据(列表)");
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

#pragma mark -  数据处理

-(void)setDataJsonList:(NSMutableArray *)dataJsonList {
    _dataJsonList = dataJsonList;
    
    [self.defaultDataSource removeAllObjects];
    [self.sortDataSource removeAllObjects];
    
    [dataJsonList enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSArray *assetIdList = [dic[@"assetId"] componentsSeparatedByString:@"."];
        NSString *type = assetIdList.lastObject;
        StockMarketType _stockMarketType = 0;
        if ([type isEqualToString:@"HK"]) {
            _stockMarketType = StockMarketType_HK;
        } else if ([type isEqualToString:@"US"]) {
            _stockMarketType = StockMarketType_US;
        } else if ([type isEqualToString:@"SZ"]) {
            _stockMarketType = StockMarketType_SZ;
        } else if ([type isEqualToString:@"SH"]) {
            _stockMarketType = StockMarketType_SH;
        }
        
        JMQuotationListModel *model = [[JMQuotationListModel alloc] init];
        model.name = dic[@"name"];
        model.assetId = dic[@"assetId"];
        model.price = dic[@"price"];
        model.change = dic[@"change"];
        model.changePct = dic[@"changePct"];
        model.stockMarketType = _stockMarketType;
        [self.defaultDataSource addObject:model];
        [self.sortDataSource addObject:model];
    }];
    
    self.tableView.hidden = self.defaultDataSource.count == 0 ? YES : NO;
    
    [self.tableView reloadData];
    
}

- (void)setMQTTDataWithJson:(NSDictionary *)json {
    
    NSString *funId = json[@"funId"];
    
    if (self.isPauseMQTT == YES) {
        return;
    }
    
    // 盘口
    if (funId.intValue == 2) {
     
        NSArray *array = json[@"data"];
        if (array.count == 0) return;
        
        NSString * assetIdStr = array.lastObject[0];
        
        [self.defaultDataSource enumerateObjectsUsingBlock:^(JMQuotationListModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
            // 判断股票代码是否一样
            if ([assetIdStr isEqualToString:model.assetId]) {
                // 替换元素
                JMQuotationListModel *newModel = self.defaultDataSource[idx];
                newModel.price = array.lastObject[6];
                newModel.changePct = array.lastObject[12];
                [self.defaultDataSource replaceObjectAtIndex:idx withObject:newModel];
                
//                // 局部刷新
//                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
//                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
        }];
        
        // 判断是否有排序条件
        if (self.sortPriceState == SortStateDefault && self.sortQuoteState == SortStateDefault) {
            
        }
        
        // 最新价格排序
        if (self.sortPriceState != SortStateDefault) {
            
            switch (self.sortPriceState) {
                case SortStateAscending:
                    [self setDataSortingMethodWithSortState:SortStateAscending SortType:1];
                    break;
                case SortStateDescending:
                    [self setDataSortingMethodWithSortState:SortStateDescending SortType:1];
                    break;
                default:
                    break;
            }
            
        }
        
        // 涨跌幅排序
        if (self.sortQuoteState != SortStateDefault) {
            
            switch (self.sortQuoteState) {
                case SortStateAscending:
                    [self setDataSortingMethodWithSortState:SortStateAscending SortType:2];
                    break;
                case SortStateDescending:
                    [self setDataSortingMethodWithSortState:SortStateDescending SortType:2];
                    break;
                default:
                    break;
            }
            
        }
        
        
        [self.tableView reloadData];
    }
    
}

/** 这种选中Tab */
- (void)setSelectionTabIndex:(NSInteger)index {
    [self.quotationListHeadView setSelectionTabIndex:index];
}

@end
