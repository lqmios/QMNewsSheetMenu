//
//  QMNewsSheetMenuView.m
//  QMNewsSheetMenu
//
//  Created by Match on 2017/11/16.
//  Copyright © 2017年 LuQingMing. All rights reserved.
//

#import "QMNewsSheetMenuView.h"
#import "QMNewsSheetItem.h"

#define KScreenWidth   [UIScreen mainScreen].bounds.size.width
#define KScreenHeight  [UIScreen mainScreen].bounds.size.height

static CGFloat const kNewsBottomSpace = 100.0f;
static NSTimeInterval const kAnimationDuration = 0.25f;

@interface QMNewsSheetMenuView ()
{
    CGPoint _lastPoint;
    QMNewsSheetItem *_currentItem;
    QMNewsSheetItem *_placeHolderItem;
}

@property(nonatomic,strong)UIScrollView             *newsSheetScrollView;
/*顶部View*/
@property (nonatomic,strong) UIView                  *navTopView;
/*关闭菜单按钮*/
@property (nonatomic,strong) UIButton                *closeMenuButton;
/*编辑按钮*/
@property (nonatomic,strong) UIButton                *editorButton;
/*我的频道View*/
@property (nonatomic,strong) UIView                  *mySubjectView;
/*推荐频道*/
@property(nonatomic,strong)UIView         *recommendSubjectView;
@property (nonatomic,strong) UILabel                 *myTitleLabel;
@property (nonatomic,strong) UILabel                 *recommendLabel;
@property(nonatomic,strong) NSMutableArray<QMNewsSheetItem *> *mySubjectItemArray;
@property(nonatomic,strong) NSMutableArray<QMNewsSheetItem*> *recommendSubjectItemArray;

@end

@implementation QMNewsSheetMenuView
/*@synthesize:如果你没有手动实现 setter 方法和 getter 方法，那么编译器会自动为你加上这两个方法*/
@synthesize mySubjectArray = _mySubjectArray;
@synthesize recommendSubjectArray = _recommendSubjectArray;


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
         _placeHolderItem = [QMNewsSheetItem new];
        [self addSubview:self.newsSheetScrollView];
        [self addSubview:self.navTopView];
        
        [self.navTopView addSubview:self.closeMenuButton];
        [self.navTopView addSubview:self.editorButton];
        //
    
       [self setUp];
        
    }
    return self;
}
- (void)setUp{
 
    if (self.mySubjectArray.count <=0 || self.recommendSubjectArray <=0)
        return;
    
    [self setMySubject];
    [self setRecommentSubject];
    self.hiddenAllCornerFlag = YES;
}
/*初始化*/
+(instancetype)newsSheetMenu
{
    CGFloat statueHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGRect rect = CGRectMake(0, KScreenHeight, KScreenWidth, KScreenHeight - statueHeight);
    return [[self alloc]initWithFrame:rect];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.navTopView.frame =CGRectMake(0, 0, self.bounds.size.width, 35);
    self.closeMenuButton.frame = CGRectMake(0, 0, 60, self.navTopView.bounds.size.height);
    self.editorButton.frame = CGRectMake(self.bounds.size.width - 60, 0, 60, self.navTopView.bounds.size.height);
    self.newsSheetScrollView.frame = CGRectMake(0, self.navTopView.bounds.size.height, self.bounds.size.width, self.bounds.size.height - self.navTopView.bounds.size.height);
    
    [self updateAllView];
    
}

- (void)updateAllView{
    //屏膜边距
    CGFloat marginScreen = 10.0f;
    //每行个数
    NSInteger column = 4;
    //item之间的距离
    CGFloat marginItem = 10.0f;
    //item的高度
    CGFloat itemHeight = 35.0f;
    //title 的高度
    CGFloat titleHeight = 30.0f;
    
    //--------------------------现有频道View--------------------//
    self.myTitleLabel.frame = CGRectMake(marginScreen, 0, KScreenWidth - 2*marginScreen, titleHeight);
    //item宽度
    CGFloat itemWidth = (KScreenWidth - 2 * marginScreen - (column - 1)*marginItem)/column;
    //行数
    CGFloat mySuRow = (self.mySubjectItemArray.count - 1) / column + 1;

    //MAX(A,B)取大值的时候要注意A、B是否是无符号型
    mySuRow = MAX(mySuRow, 0);
    
    for (NSInteger i = 0; i < self.mySubjectItemArray.count; i ++) {
        QMNewsSheetItem *item = self.mySubjectItemArray[i];
        //当前行
        NSInteger currentRow = i / column ;
        //当前列
        NSInteger currentColumn = i % column;
        
        CGFloat orx = marginScreen + currentColumn * marginItem + currentColumn * itemWidth;
        
        CGFloat ory = titleHeight + marginScreen + currentRow * marginItem + currentRow * itemHeight;
        
        item.frame = CGRectMake(orx, ory, itemWidth, itemHeight);
        
    }
    CGFloat mySubHeight = titleHeight + 2 * marginScreen + mySuRow * itemHeight + marginItem * (mySuRow - 1);
    
    self.mySubjectView.frame = CGRectMake(0, 0, KScreenWidth, mySubHeight);
    if (self.mySubjectItemArray.count <= 0) {
        mySubHeight = 0.0f;
        self.mySubjectView.frame = CGRectZero;
    }
    
    //--------------------------推荐频道View--------------------//
    CGFloat recSubRow = (self.recommendSubjectItemArray.count - 1) / column + 1;
    recSubRow = MAX(recSubRow, 0);
    for (NSInteger i = 0; i < self.recommendSubjectItemArray.count;  i++) {
        QMNewsSheetItem *item = self.recommendSubjectItemArray[i];
        //行
        NSInteger currentRow = i / column;
        //列
        NSInteger currntCloumn = i % column;
        //当前x轴
        CGFloat orx = marginScreen + currntCloumn *marginItem + currntCloumn * itemWidth;
        //当前y轴
        CGFloat ory = titleHeight + marginScreen + currentRow * marginItem + currentRow*itemHeight;
        item.frame = CGRectMake(orx, ory, itemWidth, itemHeight);

    }
   CGFloat recSubHeight =titleHeight + 2 * marginScreen+ recSubRow * itemHeight + marginItem * (recSubRow - 1);
    self.recommendLabel.frame = self.myTitleLabel.frame;
    CGFloat recOry = CGRectGetMaxY(self.mySubjectView.frame);
    
    self.recommendSubjectView.frame = CGRectMake(0, recOry, KScreenWidth, recSubHeight);
    if (self.recommendSubjectItemArray.count <= 0) {
        recSubHeight = 0.0f;
        self.recommendSubjectView.frame = CGRectZero;
    }
    //内容高度
    CGFloat scHeight = CGRectGetMaxY(self.recommendSubjectView.frame);
    
    self.newsSheetScrollView.contentSize = CGSizeMake(0, scHeight + kNewsBottomSpace);
    
    
}

- (void)setMySubject{
    
    _mySubjectView = [[UIView alloc]initWithFrame:CGRectZero];
    _mySubjectView.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1];
    [self.newsSheetScrollView addSubview:self.mySubjectView];
    //lable
    _myTitleLabel = [[UILabel alloc]init];
    _myTitleLabel.text = @"我的频道(点击编辑长按可以拖动)";
    _myTitleLabel.textColor = [UIColor grayColor];
    _myTitleLabel.font = [UIFont systemFontOfSize:12];
    [self.mySubjectView addSubview:self.myTitleLabel];
    
    [self.mySubjectItemArray removeAllObjects];
    
    for (int i = 0; i < self.mySubjectArray.count; i++)
    {
        QMNewsSheetItem *item = [[QMNewsSheetItem alloc]init];
        item.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        item.itemTitle = self.mySubjectArray[i];
        //删除模式
        item.flagType = QMCornerFlagTypeDelet;
         item.longGestureEnable = YES;
        [self.mySubjectView addSubview:item];
        [self.mySubjectItemArray addObject:item];
        //事件
        [item setItemCloseBlock:^(QMNewsSheetItem *item) {
          
            [self updateMoveItem:item];
        }];
        
        [item setLongPresBlock:^(UILongPressGestureRecognizer *longPressGesture) {
            NSLog(@"长按手势");
        }];
        
    }
}

- (void)setRecommentSubject{
    
    _recommendSubjectView = [[UIView alloc]initWithFrame:CGRectZero];
    _recommendSubjectView.backgroundColor = [UIColor colorWithWhite:0.99 alpha:1];
    [self.newsSheetScrollView addSubview:self.recommendSubjectView];
    
    _recommendLabel = [[UILabel alloc]init];
    _recommendLabel.text = @"推荐频道";
    _recommendLabel.textColor = [UIColor lightGrayColor];
    _recommendLabel.font = [UIFont systemFontOfSize:12];
    [self.recommendSubjectView addSubview:self.recommendLabel];
    
    //
    [self.recommendSubjectItemArray removeAllObjects];
    for (int i = 0; i < self.recommendSubjectArray.count; i ++)
    {
        QMNewsSheetItem *item = [[QMNewsSheetItem alloc]init];
        item.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        item.itemTitle = self.recommendSubjectArray[i];
        item.longGestureEnable = NO;
        item.flagType = QMCornerFlagTypeAddition;
        [self.recommendSubjectView addSubview:item];
        [self.recommendSubjectItemArray addObject:item];
        //事件
        [item setItemCloseBlock:^(QMNewsSheetItem *item) {

            [self updateMoveItem:item];
        }];
        [item setLongPresBlock:^(UILongPressGestureRecognizer *longPressGesture) {
            NSLog(@"长按手势");
        }];
    }
    
}


#pragma mark -弹出View
- (void)showNewsMenuView
{
    //把自身添加到window上
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    CGFloat statueHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGRect rect = CGRectMake(0, statueHeight, KScreenWidth, KScreenHeight - statueHeight);
    /*
     Spring Animation: https://www.renfei.org/blog/ios-8-spring-animation.html
     usingSpringWithDamping:表示弹簧的震动效果。值范围 0.0f-1.0f,数值越小，弹簧的震动效果越明显
     initialSpringVelocity：表示初始速度，数值越大初始速度越快。
     */
    [UIView animateWithDuration:kAnimationDuration delay:0.05 usingSpringWithDamping:0.8 initialSpringVelocity:0.01 options:UIViewAnimationOptionCurveLinear animations:^{
        self.frame = rect;
        self.alpha = 1.0f;
    } completion:^(BOOL finished) {
        
    }];
    
}

#pragma mark --隐藏View
- (void)dismissNewsMenuView
{
    CGFloat statueHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGRect rect = CGRectMake(0, KScreenHeight, KScreenWidth, KScreenHeight - statueHeight);
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.frame = rect;
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
    }];
}
#pragma mark ---数据处理私有方法
- (void)updateMoveItem:(QMNewsSheetItem *)item{
    if (item.flagType == QMCornerFlagTypeDelet) {
        [self moveItemFromMySubjectToRecommend:item];
    }
    else if (item.flagType == QMCornerFlagTypeAddition){
        [self moveItemFromRecommendToMySubject:item];
    }
    [UIView animateWithDuration:kAnimationDuration animations:^{
        [self updateAllView];
    }];
}

//增加频道
- (void)moveItemFromRecommendToMySubject:(QMNewsSheetItem *)item
{
    [self.recommendSubjectItemArray removeObject:item];
    [self.recommendSubjectArray removeObject:item.itemTitle];
    item.flagType = QMCornerFlagTypeDelet;
    
    [self.mySubjectItemArray addObject:item];
    [self.mySubjectArray addObject:item.itemTitle];
    
    if (item.subviews) {
        [item removeFromSuperview];
        [self.mySubjectView addSubview:item];
    }
}
//删除频道
- (void)moveItemFromMySubjectToRecommend:(QMNewsSheetItem *)item
{
    [self.mySubjectItemArray removeObject:item];
    [self.mySubjectArray removeObject:item.itemTitle];
    
    item.flagType = QMCornerFlagTypeAddition;
 
    [self.recommendSubjectItemArray addObject:item];
    [self.recommendSubjectArray addObject:item.itemTitle];
    
    if (item.subviews) {
        [item removeFromSuperview];
        [self.recommendSubjectView addSubview:item];
    }
}

- (void)closeMenuButtonAction:(UIButton *)sender
{
    [self dismissNewsMenuView];
}

- (void)editorButtonAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    self.hiddenAllCornerFlag = !sender.selected;
    NSString *titleString = sender.selected ? @"完成":@"编辑";
    [sender setTitle:titleString forState:UIControlStateNormal];
}

#pragma mark -- setter --获取数据---

- (void)setMySubjectArray:(NSMutableArray *)mySubjectArray
{
    _mySubjectArray = mySubjectArray;
    [self.newsSheetScrollView.subviews sortedArrayUsingSelector:@selector(removeFromSuperview)];
    [self setUp];
}

- (void)setRecommendSubjectArray:(NSMutableArray *)recommendSubjectArray
{
    _recommendSubjectArray = recommendSubjectArray;
    [self.newsSheetScrollView.subviews sortedArrayUsingSelector:@selector(removeFromSuperview)];
    [self setUp];
}

- (void)setHiddenAllCornerFlag:(BOOL)hiddenAllCornerFlag{
    _hiddenAllCornerFlag = hiddenAllCornerFlag;
    [self hiddenAllFlag:hiddenAllCornerFlag];
}
#pragma mark -- 遍历views，拿到需要的View
- (void)hiddenAllFlag:(BOOL)hidden
{
    for (UIView *view in self.mySubjectView.subviews) {
        if ([view isKindOfClass:[QMNewsSheetItem class]]) {
            QMNewsSheetItem *item = (QMNewsSheetItem *)view;
            item.cornerFlagHidden = hidden;
        }
    }
    
    for (UIView *view in self.recommendSubjectView.subviews) {
        if ([view isKindOfClass:[QMNewsSheetItem class]]) {
            QMNewsSheetItem *item = (QMNewsSheetItem *)view;
            item.cornerFlagHidden = hidden;
        }
    }
}

#pragma mark --lazy--

- (UIView *)navTopView
{
    if (!_navTopView) {
        _navTopView = [[UIView alloc]init];
        _navTopView.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    }
    return _navTopView;
}
- (UIButton *)closeMenuButton
{
    if (!_closeMenuButton) {
        _closeMenuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeMenuButton setTitle:@"关闭" forState:UIControlStateNormal];
        [_closeMenuButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _closeMenuButton.backgroundColor = [UIColor whiteColor];
        [_closeMenuButton addTarget:self action:@selector(closeMenuButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeMenuButton;
}

- (UIButton *)editorButton
{
    if (!_editorButton) {
        _editorButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editorButton setTitle:@"编辑" forState:UIControlStateNormal];
        _editorButton.backgroundColor = [UIColor whiteColor];
        [_editorButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_editorButton addTarget:self action:@selector(editorButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editorButton;
}

- (UIScrollView *)newsSheetScrollView
{
    if (!_newsSheetScrollView) {
        _newsSheetScrollView = [[UIScrollView alloc]initWithFrame:CGRectZero];
        _newsSheetScrollView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
        
    }
    return _newsSheetScrollView;
}

- (NSMutableArray *)mySubjectArray
{
    if (!_mySubjectArray) {
        _mySubjectArray = [NSMutableArray array];
    }
    return _mySubjectArray;
}
- (NSMutableArray *)recommendSubjectArray
{
    if (!_recommendSubjectArray) {
        _recommendSubjectArray = [NSMutableArray array];
    }
    return _recommendSubjectArray;
}
- (NSMutableArray *)mySubjectItemArray
{
    if (!_mySubjectItemArray) {
        _mySubjectItemArray = [NSMutableArray array];
    }
    return _mySubjectItemArray;
}

- (NSMutableArray *)recommendSubjectItemArray
{
    if (!_recommendSubjectItemArray) {
        _recommendSubjectItemArray = [NSMutableArray array];
    }
    return _recommendSubjectItemArray;
}


@end




















































