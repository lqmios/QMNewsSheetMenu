//
//  QMChooseCell.h
//  QMNewsSheetMenu
//
//  Created by Match on 2017/11/21.
//  Copyright © 2017年 LuQingMing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QMChooseModel.h"

@interface QMChooseCell : UICollectionViewCell

@property (nonatomic,strong) UIButton                   *button;
/*是否处于编辑状态*/
@property (nonatomic, assign) BOOL                       inEditState;

- (void)setDataArray:(NSMutableArray *)dataArray1 dataArray2:(NSMutableArray *)dataArray2 indexPath:(NSIndexPath *)indexPath;

@end
