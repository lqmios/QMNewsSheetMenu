//
//  QMChooseFlowLayout.h
//  QMNewsSheetMenu
//
//  Created by Match on 2017/11/21.
//  Copyright © 2017年 LuQingMing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QMChooseFlowLayoutDelegate <NSObject>
/*更新数据源*/

- (void)moveItemAtIndexPath:(NSIndexPath *)formPath toIndexPath:(NSIndexPath *)toPath;
//改变编辑状态
- (void)didChangeEditorState:(BOOL)inEditorState;

@end

@interface QMChooseFlowLayout : UICollectionViewFlowLayout

@property (nonatomic,weak) id<QMChooseFlowLayoutDelegate> delegate;
//检测编辑状态
@property (nonatomic,assign) BOOL inEditorState;

@end






























