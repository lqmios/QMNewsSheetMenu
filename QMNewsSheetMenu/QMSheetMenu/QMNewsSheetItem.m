//
//  QMNewsSheetItem.m
//  QMNewsSheetMenu
//
//  Created by Match on 2017/11/16.
//  Copyright © 2017年 LuQingMing. All rights reserved.
//

#import "QMNewsSheetItem.h"

@interface QMNewsSheetItem ()
/*关闭按钮*/
@property (nonatomic,strong) UIButton                *closeButton;
@property (nonatomic,strong) UILabel                 *itemTitleLabel;
@property (nonatomic,strong) UILongPressGestureRecognizer                *longPress;

@end

@implementation QMNewsSheetItem
- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 4.0f;
        [self addGestureRecognizer:self.longPress];
        [self addSubview:self.closeButton];
        [self addSubview:self.itemTitleLabel];
   
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat buttonWidth = 20;
    CGFloat buttonHeight =20;
    self.closeButton.frame = CGRectMake(self.frame.size.width - 0.8 * buttonWidth, -0.3 * buttonWidth, buttonWidth, buttonHeight);
    self.closeButton.layer.cornerRadius = buttonWidth / 2.0f;
    self.itemTitleLabel.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
}

#pragma mark --- setter --

- (void)setFlagType:(QMCornerFlagType)flagType
{
    _flagType = flagType;
    
    if (flagType == QMCornerFlagTypeNone) {
        self.closeButton.hidden = YES;
        return;
    }
    
    NSString * title = self.cornerFlagDictionary[[NSString stringWithFormat:@"%d",(int)flagType]];
    self.closeButton.hidden = NO;
    [self.closeButton setTitle:title forState:UIControlStateNormal];
    
}

- (void)setItemTitle:(NSString *)itemTitle
{
    _itemTitle = [itemTitle copy];
    self.itemTitleLabel.text = itemTitle;
}

- (void)setCornerFlagHidden:(BOOL)cornerFlagHidden
{
    _cornerFlagHidden = cornerFlagHidden;
    self.longGestureEnable = cornerFlagHidden;

    if (self.flagType != QMCornerFlagTypeDelet) {
        self.longGestureEnable = NO;
    }
    [self commitAnimation:cornerFlagHidden];
}



- (void)commitAnimation:(BOOL)hidden
{
    if (hidden) {
        [UIView animateWithDuration:0.15 animations:^{
            self.closeButton.alpha = 0.0f;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.15 animations:^{
            self.closeButton.alpha = 1.0f;
        }];
    }
}

- (NSDictionary *)cornerFlagDictionary{
    return @{
             @"1":@"x",
             @"2":@"+"
             };
}

#pragma mark --事件处理-

- (void)longPressGesture:(UILongPressGestureRecognizer*)ges{
    if (!self.longGestureEnable)
        return;
    
    if (self.longPresBlock) {
        self.longPresBlock(ges);
    }
}

- (void)qm_close{
    if (self.itemCloseBlock) {
        self.itemCloseBlock(self);
    }
}

#pragma amrk --lazy--
- (UIButton *)closeButton
{
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setTitle:@"x" forState:UIControlStateNormal];
        _closeButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_closeButton addTarget:self action:@selector(qm_close) forControlEvents:UIControlEventTouchUpInside];
        _closeButton.backgroundColor = [UIColor lightGrayColor];
    }
    return _closeButton;
}

- (UILabel *)itemTitleLabel
{
    if (!_itemTitleLabel) {
        _itemTitleLabel = [[UILabel alloc]init];
        _itemTitleLabel.textColor = [UIColor blackColor];
        _itemTitleLabel.font = [UIFont systemFontOfSize:10];
        _itemTitleLabel.textAlignment = NSTextAlignmentCenter;
     
    }
    return _itemTitleLabel;
}

- (UILongPressGestureRecognizer *)longPress
{
    if (!_longPress) {
        _longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGesture:)];
        self.longGestureEnable = YES;
    }
    return _longPress;
}

@end












































