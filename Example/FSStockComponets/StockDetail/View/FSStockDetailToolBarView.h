//
//  FSStockDetailToolBarView.h
//  Fargo
//
//  Created by 张忠燕 on 2023/6/16.
//  Copyright © 2023 geekthings. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSStockDetailToolBarVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface FSStockDetailToolBarView : UIView

@property (nonatomic, strong) UIButton *enquiryRecordButton;

@property (nonatomic, strong) UIButton *orderRecordButton;

@property (nonatomic, strong) UIButton *addWatchButton;

@property (nonatomic, strong) UIButton *unAddWatchButton;

@property (nonatomic, strong) UIButton *enquiryButton;

@property (nonatomic, strong) UIButton *orderButton;

- (void)setContentWithVM:(FSStockDetailToolBarVM *)vm;

+ (CGFloat)viewHeight;

@end

NS_ASSUME_NONNULL_END
