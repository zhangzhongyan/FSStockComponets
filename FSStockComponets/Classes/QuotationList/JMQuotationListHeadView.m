//
//  JMQuotationListHeadView.m
//  JMQuotesComponets_Example
//
//  Created by fargowealth on 2023/5/29.
//  Copyright © 2023 liyunlong1512. All rights reserved.
//

#import "JMQuotationListHeadView.h"
#import "QuotationConstant.h"

@interface JMQuotationListHeadView ()

/// 市场分类按钮
@property (nonatomic, strong) NSArray *buttonTitles;
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) UIButton *selectedButton;
/** 选中index */
@property(nonatomic, assign) NSInteger selectedTabIndex;

@end

@implementation JMQuotationListHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.selectedTabIndex = 0;
        [self createMarketCategoriesUI];
    }
    return self;
}

#pragma mark - 创建市场分类UI

- (void)buttonTapped:(UIButton *)sender {
    // Deselect previously selected button
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
    if ([self.delegate respondsToSelector:@selector(quotationListHeadViewWithSelectionIndex:)]) {
        [self.delegate quotationListHeadViewWithSelectionIndex:sender.tag];
    }
}


- (void)createMarketCategoriesUI {
    
    self.buttonTitles = @[@"全部", @"港股", @"美股"];
    self.buttons = [[NSMutableArray alloc] init];
    
    UIImage *imgae_n = [UIImage imageWithContentsOfFile:kImageNamed(@"marketTypeBtnBG_n.png")];
    UIImage *imgae_s = [UIImage imageWithContentsOfFile:kImageNamed(@"marketTypeBtnBG_s.png")];
    
    // Create buttons
    [self.buttonTitles enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectZero];
        [button setTitle:obj forState:UIControlStateNormal];
        [button.titleLabel setFont:kFont_Regular(12)];
        [button setTitleColor:UIColor.secondaryTextColor forState:UIControlStateNormal];
        [button setTitleColor:UIColor.selectedColor forState:UIControlStateSelected];
        [button setBackgroundImage:imgae_n forState:UIControlStateNormal];
        [button setBackgroundImage:imgae_s forState:UIControlStateHighlighted];
        [button setBackgroundImage:imgae_s forState:UIControlStateSelected];
        [button.layer setCornerRadius:2.f];
        [button.layer setMasksToBounds:YES];
        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [button setTag:idx];
        [self addSubview:button];
        [self.buttons addObject:button];
        if(idx == self.selectedTabIndex){
            button.selected = YES;
            self.selectedButton = button;
        }
    }];
    
    // Layout buttons
    CGFloat buttonWidth = kWidthScale(40);
    CGFloat buttonHeight = kHeightScale(24);
    CGFloat spacing = kWidthScale(12);
    CGFloat startX = 0;
    CGFloat currentX = startX;
    for (UIButton *button in self.buttons) {
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self).mas_offset(0);
            make.left.mas_equalTo(self).mas_offset(currentX);
            make.width.mas_offset(buttonWidth);
            make.height.mas_offset(buttonHeight);
        }];
        currentX += buttonWidth + spacing;
    }
    
}

#pragma mark - 数据重载

- (void)setSelectionTabIndex:(NSInteger)index {
    
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
    
    self.selectedTabIndex = index;
    
    [self createMarketCategoriesUI];
    
    if ([self.delegate respondsToSelector:@selector(quotationListHeadViewWithSelectionIndex:)]) {
        [self.delegate quotationListHeadViewWithSelectionIndex:index];
    }
    
}

@end
