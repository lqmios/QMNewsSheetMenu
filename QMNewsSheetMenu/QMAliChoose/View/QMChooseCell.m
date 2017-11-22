//
//  QMChooseCell.m
//  QMNewsSheetMenu
//
//  Created by Match on 2017/11/21.
//  Copyright © 2017年 LuQingMing. All rights reserved.
//

#import "QMChooseCell.h"
#import "Masonry.h"

@interface QMChooseCell ()

@property (nonatomic,strong) UILabel                    *titleLabel;
@property (nonatomic,strong) UIImageView                *headImageView;

@end


@implementation QMChooseCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.headImageView];
        [self.contentView addSubview:self.button];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(10,12, 15,12));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImageView.mas_bottom).with.offset(0);
        make.width.equalTo(self.contentView);
        make.height.mas_equalTo(12);
    }];
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.top.equalTo(self.contentView.mas_top);
        make.right.equalTo(self.contentView.mas_right);
    }];
    
}

- (void)setDataArray:(NSMutableArray *)dataArray1 dataArray2:(NSMutableArray *)dataArray2 indexPath:(NSIndexPath *)indexPath
{
    QMChooseModel *model;
    if (indexPath.section == 0) {
        model = dataArray1[indexPath.row];
    }
    else
    {
        model = dataArray2[indexPath.row];
    }
    //设置button图片
    self.titleLabel.text = model.title;
    self.headImageView.image = [UIImage imageNamed:model.img];
    
    if (indexPath.section == 0) {
        self.button.userInteractionEnabled = YES;
        [self.button setImage:[UIImage imageNamed:@"life_reduce"] forState:UIControlStateNormal];
    }else{
        if ([dataArray1 containsObject:model]) {
            self.button.userInteractionEnabled = NO;
            [self.button setImage:[UIImage imageNamed:@"life_exist"] forState:UIControlStateNormal];
            
        }else{
            self.button.userInteractionEnabled = YES;
            [self.button setImage:[UIImage imageNamed:@"life_add"] forState:UIControlStateNormal];
        }
    }
}
#pragma mark --是否处于编辑状态
- (void)setInEditState:(BOOL)inEditState
{
    if (inEditState && _inEditState != inEditState) {
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.button.hidden = NO;
    }else{
        self.layer.borderColor = [UIColor clearColor].CGColor;
        self.button.hidden = YES;
    }
}


- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIImageView *)headImageView
{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc]init];
    }
    return _headImageView;
}
- (UIButton *)button
{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.layer.cornerRadius = 7.5;
        _button.hidden = YES;
    }
    return _button;
}

@end













