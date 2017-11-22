//
//  ViewController.m
//  QMNewsSheetMenu
//
//  Created by Match on 2017/11/16.
//  Copyright © 2017年 LuQingMing. All rights reserved.
//

#import "ViewController.h"
#import "QMNewsSheetMenuView.h"
#import "QMAliChooseController.h"

@interface ViewController ()

@property (nonatomic,strong) QMNewsSheetMenuView       *menuView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"菜单选择";

   
    [self initSubViews];
    
}

- (void)initSubViews
{
    QMNewsSheetMenuView *menuView = [QMNewsSheetMenuView newsSheetMenu];
    self.menuView = menuView;
    menuView.mySubjectArray = @[@"推荐",@"科技",@"财经",@"体育",@"娱乐",@"视频"].mutableCopy;
    menuView.recommendSubjectArray = @[@"频道01",@"频道02",@"频道03",@"频道04",@"频道05",@"3z"].mutableCopy;
}

- (IBAction)TouTiaoNews:(id)sender {
    
     [self.menuView showNewsMenuView];
}

- (IBAction)aliAction:(id)sender {
    
    QMAliChooseController *qmAliChose = [[QMAliChooseController alloc]init];
    [self.navigationController pushViewController:qmAliChose animated:YES];
}


@end





















