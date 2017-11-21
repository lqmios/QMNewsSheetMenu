//
//  QMNewsSheetMenuView.h
//  QMNewsSheetMenu
//
//  Created by Match on 2017/11/16.
//  Copyright © 2017年 LuQingMing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QMNewsSheetMenuView : UIView

@property (nonatomic,assign) BOOL                  hiddenAllCornerFlag;
@property(nonatomic,strong)NSMutableArray          *mySubjectArray;
@property(nonatomic,strong)NSMutableArray          *recommendSubjectArray;

+ (instancetype)newsSheetMenu;
- (void)showNewsMenuView;
- (void)dismissNewsMenuView;

@end

















































