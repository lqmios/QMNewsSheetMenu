//
//  QMHeaderReusableView.m
//  QMNewsSheetMenu
//
//  Created by Match on 2017/11/21.
//  Copyright © 2017年 LuQingMing. All rights reserved.
//

#import "QMHeaderReusableView.h"

@implementation QMHeaderReusableView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.headLabel];
    }
    return self;
}

- (UILabel *)headLabel
{
    if (!_headLabel) {
        _headLabel = [UILabel new];
        _headLabel.font = [UIFont systemFontOfSize:16];
        _headLabel.frame = CGRectMake(16, 0, 150, 20);
    }
    return _headLabel;
}
@end
