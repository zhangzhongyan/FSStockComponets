//
//  FSStockDetailVC.h
//  FSStockComponets_Example
//
//  Created by 张忠燕 on 2023/12/22.
//  Copyright © 2023 张忠燕. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSStockDetailVM.h"

NS_ASSUME_NONNULL_BEGIN

@interface FSStockDetailVC : UIViewController

/// 指定构造函数
/// @param viewModel viewModel
- (instancetype)initWithVM:(FSStockDetailVM *)viewModel;
- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
