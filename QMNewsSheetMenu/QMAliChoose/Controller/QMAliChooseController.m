//
//  QMAliChooseController.m
//  QMNewsSheetMenu
//
//  Created by Match on 2017/11/21.
//  Copyright © 2017年 LuQingMing. All rights reserved.
//

#import "QMAliChooseController.h"
#import "QMChooseCell.h"
#import "QMFooterReusableView.h"
#import "QMHeaderReusableView.h"
#import "QMChooseFlowLayout.h"
#import "QMChooseModel.h"

#define K_Cell @"cell"
#define K_No_Cell @"noCell"
#define K_Head_Cell @"headCell"
#define K_Foot_Cell @"footCell"

#define Screen_Width [UIScreen mainScreen].bounds.size.width
#define Screen_Height [UIScreen mainScreen].bounds.size.height

@interface QMAliChooseController ()<UICollectionViewDelegate,UICollectionViewDataSource,QMChooseFlowLayoutDelegate>

@property (nonatomic,strong) UICollectionView       *collectionView;
@property (nonatomic,strong) QMChooseFlowLayout              *flowLayout;
//记录编辑状态
@property (nonatomic,assign) BOOL                         inEditorState;
@property (nonatomic,strong) NSMutableArray                *dataArray1;
@property (nonatomic,strong) NSMutableArray                  *dataArray2;
//右边按钮
@property (nonatomic,strong) UIButton                       *rightButton;
//删除完毕时显示文字
@property (nonatomic,strong) UILabel                          *messageLabel;

@end

@implementation QMAliChooseController

- (void)viewDidLoad {
    [super viewDidLoad];self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"生活应用";
    [self initSubViews];
    [self initDatas];
}

- (void)initSubViews
{
    [self.view addSubview:self.collectionView];
    [self setRightButton];
}

- (void)initDatas{
    for (int i = 0; i < 6; i ++) {
        QMChooseModel *model = [[QMChooseModel alloc]init];
        model.title = [NSString stringWithFormat:@"推荐%@",@(i)];
        model.img = @"life_choose";
        [self.dataArray1 addObject:model];
        [self.dataArray2 addObject:model];
    }
    for (int i = 0; i < 4; i ++) {
        QMChooseModel *model = [[QMChooseModel alloc]init];
        model.title = [NSString stringWithFormat:@"生活%@",@(i)];
        model.img = @"life_choose";
        [self.dataArray2 addObject:model];
    }
    
}

- (void)setRightButton{
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightButton setTitle:@"管理" forState: UIControlStateNormal];
    [_rightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_rightButton sizeToFit];
    [_rightButton setTitle:@"完成" forState:UIControlStateSelected];
    //将rightItem设置成自定义按钮
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:_rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
}
#pragma mark ---编辑按钮
- (void)rightButtonAction:(UIButton *)sender
{
    if (!self.inEditorState) {
        self.inEditorState = YES;
        self.collectionView.allowsSelection = NO;
    }else{
        self.inEditorState = NO;
        self.collectionView.allowsSelection = YES;
    }
    [self.flowLayout setInEditorState:self.inEditorState];
}
//btnClick:event:
- (void)btnClick:(UIButton *)sender event:(id)event
{
    //获取点击button的位置
    NSSet *touches = [event allTouches];//Returns all touches associated with the event.
    UITouch *touch = [touches anyObject];
    //拿到对应的indexPath
    CGPoint currentPoint = [touch locationInView:_collectionView];
    NSIndexPath *indexPath = [_collectionView indexPathForItemAtPoint:currentPoint];
    
    if (indexPath.section == 0 && indexPath != nil) { //点击移除
        //performBatchUpdates:插入动画 http://www.liuchungui.com/blog/2015/11/24/uicollectionviewdong-hua/
        [self.collectionView performBatchUpdates:^{
            [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
            [self.dataArray1 removeObjectAtIndex:indexPath.row]; //删除
        } completion:^(BOOL finished) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
            });
        }];
    } else if (indexPath != nil) { //点击添加
        //在第一组最后增加一个
        [self.dataArray1 addObject:self.dataArray2[indexPath.row]];
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:self.dataArray1.count - 1 inSection:0];
        [self.collectionView performBatchUpdates:^{
            [self.collectionView insertItemsAtIndexPaths:@[newIndexPath]];
        } completion:^(BOOL finished) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
            });
        }];
    }
}
#pragma mark -QMChooseFlowLayoutDelegate
- (void)didChangeEditorState:(BOOL)inEditorState{
    
    self.inEditorState = inEditorState;
    self.rightButton.selected = inEditorState;
    //遍历cell。改变状态
    for (QMChooseCell *cell in self.collectionView.visibleCells) {
        cell.inEditState = inEditorState;
    }
}

- (void)moveItemAtIndexPath:(NSIndexPath *)formPath toIndexPath:(NSIndexPath *)toPath{
    QMChooseModel *model = self.dataArray1[formPath.row];
    //先把移动的这个model移除
    [self.dataArray1 removeObject:model];
    //再把这个移动的model插入到响应的位置
    [self.dataArray1 insertObject:model atIndex:toPath.row];
}

#pragma mark --UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.dataArray1.count;
    }else{
        return self.dataArray2.count;
    }
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    QMChooseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:K_Cell forIndexPath:indexPath];
    [cell setDataArray:self.dataArray1 dataArray2:self.dataArray2 indexPath:indexPath];
    //是否处于编辑状态
    cell.inEditState = self.inEditorState;
    [cell.button addTarget:self action:@selector(btnClick:event:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.inEditorState) { //如果不在编辑状态
        NSLog(@"点击了第%@个分区的第%@个cell", @(indexPath.section), @(indexPath.row));
    }
}
//头尾视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        QMHeaderReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:K_Head_Cell forIndexPath:indexPath];
        if (indexPath.section == 0) {
            headerView.headLabel.text = @"我的应用";
        }else{
            headerView.headLabel.text = @"推荐应用";
        }
        return headerView;
    }else if ([kind isEqualToString:UICollectionElementKindSectionFooter]){
        QMFooterReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:K_Foot_Cell forIndexPath:indexPath];
        return footerView;
        
    }
    return nil;
}
//header高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (self.dataArray1.count == 0) {
        if (section == 0) {
            self.messageLabel.frame = CGRectMake(0, 30, Screen_Width, 100);
            //显示没有更多的提示
            [self.collectionView addSubview:self.messageLabel];
            return CGSizeMake(Screen_Width, 100);
        } else {
            return CGSizeMake(Screen_Width, 25);
        }
    } else {
        [self.messageLabel removeFromSuperview];
        return CGSizeMake(Screen_Width, 25);
    }
}
//footer 高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    if (section == 0) {
        return CGSizeMake(Screen_Width, 10);
    }else{
        return CGSizeMake(Screen_Width, CGFLOAT_MIN);
    }
}

#pragma mark -- lazy--
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height) collectionViewLayout:self.flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        //
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        //cell注册
        [_collectionView registerClass:[QMChooseCell class] forCellWithReuseIdentifier:K_Cell];
        //header注册
        [_collectionView registerClass:[QMHeaderReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:K_Head_Cell];
        //footer注册
        [_collectionView registerClass:[QMFooterReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:K_Foot_Cell];
    
    }
    return _collectionView;
}
//元素大小设置
- (QMChooseFlowLayout *)flowLayout
{
    if (!_flowLayout) {
        _flowLayout = [[QMChooseFlowLayout alloc]init];
        _flowLayout.delegate = self;
        //设置每个图片大小
        CGFloat width = (Screen_Width - 80)/4;
        _flowLayout.itemSize = CGSizeMake(width, width);
        //设置滚动方向的间距
        _flowLayout.minimumLineSpacing = 10;
        //
        _flowLayout.minimumInteritemSpacing = 10;
        //设置collectionView整体的上下左右的间距
        _flowLayout.sectionInset = UIEdgeInsetsMake(10, 20, 20, 20);
        //设置滚动方向
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return _flowLayout;
}

- (NSMutableArray *)dataArray1
{
    if (!_dataArray1) {
        _dataArray1 = [NSMutableArray array];
    }
    return _dataArray1;
}

- (NSMutableArray *)dataArray2
{
    if (!_dataArray2) {
        _dataArray2 = [NSMutableArray array];
    }
    return _dataArray2;
}
//没有应用的提示
- (UILabel *)messageLabel
{
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.font = [UIFont systemFontOfSize:12];
        _messageLabel.numberOfLines = 0;
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.text = @"您还未添加任何应用\n长按下面的应用可以添加";
    }
    return _messageLabel;
}
@end













