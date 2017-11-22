//
//  QMChooseFlowLayout.m
//  QMNewsSheetMenu
//
//  Created by Match on 2017/11/21.
//  Copyright © 2017年 LuQingMing. All rights reserved.
//

#import "QMChooseFlowLayout.h"

@interface QMChooseFlowLayout ()<UIGestureRecognizerDelegate>
//长按手势
@property (nonatomic,strong) UILongPressGestureRecognizer     *longPressGesture;
//当前indexPath
@property (nonatomic, strong) NSIndexPath *currentIndexPath;

@property (nonatomic, assign) CGPoint movePoint; //移动的中心点
@property (nonatomic, strong) UIView *moveView; //移动的视图
@end

@implementation QMChooseFlowLayout
//代码使用创建控件alloc init 时,系统底层调用init方法
- (instancetype)init
{
    if (self = [super init]) {
        [self configureObserver];
    }
    return self;
}
//添加观察者
- (void)configureObserver{
    [self addObserver:self forKeyPath:@"collectionView" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"collectionView"]) {
        [self setUpGesture];
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
#pragma mark - 移除观察者

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"collectionView"];
}
#pragma mark --长按手势

- (void)setUpGesture{
    if (self.collectionView == nil) {
        return;
    }
    _longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGesture:)];
    _longPressGesture.delegate = self;
    _longPressGesture.minimumPressDuration = 0.3f; //时间长短
    [self.collectionView addGestureRecognizer:_longPressGesture];
    
}

#pragma mark --action --
- (void)longPressGesture:(UILongPressGestureRecognizer *)gesture{
    if (!self.inEditorState) {
        [self setInEditorState:YES];
    }
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            //手势开始
            CGPoint locationPoint = [gesture locationInView:self.collectionView];
            //找到当前cell的位置
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:locationPoint];
            //判断哪个分区可以被点击并且移动
            if (indexPath == nil || indexPath.section != 0) {
                return;
            }
            self.currentIndexPath = indexPath;
            UICollectionViewCell *targetCell = [self.collectionView cellForItemAtIndexPath:self.currentIndexPath];
            //得到当前的映射
            self.moveView = [targetCell snapshotViewAfterScreenUpdates:YES];
            //隐藏被点击的cell
            targetCell.hidden = YES;
             //给截图添加上边框，如果不添加的话，截图有一部分是没有边框的，具体原因也没有找到
            self.moveView.layer.borderWidth = 0.5;
            self.moveView.layer.borderColor = [UIColor colorWithWhite:0.95 alpha:1].CGColor;
            [self.collectionView addSubview:self.moveView];
            //放大截图
              self.moveView.transform = CGAffineTransformMakeScale(1.1, 1.1);
            self.moveView.center = targetCell.center;
            
            
        }
            break;
        case UIGestureRecognizerStateChanged:{
            
            CGPoint point = [gesture locationInView:self.collectionView];
            //更新cell的位置
            self.moveView.center = point;
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
            if (indexPath == nil) {
                return;
            }
            if (indexPath.section == self.currentIndexPath.section && indexPath.section == 0) {
                //通过代理去改变数据源
                if ([self.delegate respondsToSelector:@selector(moveItemAtIndexPath:toIndexPath:)]) {
                    [self.delegate moveItemAtIndexPath:self.currentIndexPath toIndexPath:indexPath];
                }
                //移动方法
                [self.collectionView moveItemAtIndexPath:self.currentIndexPath toIndexPath:indexPath];
                self.currentIndexPath = indexPath;
            }
        }
            break;
        case UIGestureRecognizerStateEnded:{
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:self.currentIndexPath];
            //手势结束，把截图隐藏，显示出原来的cell
            [UIView animateWithDuration:0.5 animations:^{
                self.moveView.center = cell.center;
            } completion:^(BOOL finished) {
                [self.moveView removeFromSuperview];
                cell.hidden = NO;
                self.moveView = nil;
                self.currentIndexPath = nil;
                [self.collectionView reloadData];
            }];
        }
            break;
        default:
            break;
    }
}

#pragma mark--处于编辑状态
-(void)setInEditorState:(BOOL)inEditorState
{
    
    if (_inEditorState != inEditorState) {
        //通过代理方法改变处于编辑状态的cell
        if (self.delegate && [self.delegate respondsToSelector:@selector(didChangeEditorState:)]) {
            [self.delegate didChangeEditorState:inEditorState];
        }
    }
    _inEditorState = inEditorState;
}



@end
