//
//  PopTimeMenuTableViewCell.h
//  JMQuotesComponets
//
//  Created by fargowealth on 2023/7/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PopTimeMenuTableViewCell : UITableViewCell

/** 标题 */
@property (nonatomic, strong) UILabel *titleLab;

/** 选中图标 */
@property (nonatomic, strong) UIImageView *selectionIcon;

@end

NS_ASSUME_NONNULL_END
