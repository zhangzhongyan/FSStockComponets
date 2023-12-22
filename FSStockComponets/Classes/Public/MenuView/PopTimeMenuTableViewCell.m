//
//  PopTimeMenuTableViewCell.m
//  JMQuotesComponets
//
//  Created by fargowealth on 2023/7/7.
//

#import "PopTimeMenuTableViewCell.h"
#import "QuotationConstant.h"
#import <Masonry/Masonry.h>

@implementation PopTimeMenuTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createUI];
    }
    return self;
}

#pragma mark -  创建UI

- (void)createUI {
    
    [self addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self).mas_offset(kWidthScale(8));
    }];
    
    [self addSubview:self.selectionIcon];
    [self.selectionIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self.mas_right).mas_offset(-kWidthScale(8));
    }];
    
}

#pragma mark — Lazy

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.text = @"1分";
        _titleLab.font = kFont_Regular(12.f);
        _titleLab.textColor = UIColor.handicapInfoTextColor;
    }
    return _titleLab;
}

- (UIImageView *)selectionIcon {
    if (!_selectionIcon) {
        _selectionIcon = [[UIImageView alloc] init];
        _selectionIcon.image = [UIImage imageWithContentsOfFile:kImageNamed(@"xzjt.png")];
    }
    return _selectionIcon;
}

@end
