//
//  ViewController.m
//  滚动导航
//
//  Created by 谭鄱仑 on 15-1-13.
//  Copyright (c) 2015年 谭鄱仑. All rights reserved.
//

#import "ViewController.h"
#import "TPLScrollShowView.h"
//固件版本
#define iOSVersion [[[UIDevice currentDevice] systemVersion] floatValue]
//实际屏幕宽和高
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height


@interface ViewController ()
{
    TPLScrollShowView * _scrollShowView;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
//    CGFloat y = iOSVersion >= 7 ? 20 : 0;
    CGFloat height = iOSVersion >= 7 ? 64 : 44;

    
    _scrollShowView = [[TPLScrollShowView alloc] initWithFrame:CGRectMake(0,height, ScreenWidth, ScreenHeight - height)];
    _scrollShowView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_scrollShowView];
    
    
    //可以根据网络请求获得头标题数组，根据视图的Type创建不同的VC
    //set config
    _scrollShowView.titleHeight = 35;
    _scrollShowView.titleArray = [@[@"首页",@"宝妈攻略",@"排行榜",@"商品预警",@"分类"] mutableCopy];

    
    NSMutableArray * vcArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i < _scrollShowView.titleArray.count; i++)
    {
        UIViewController * vc = [[UIViewController alloc] init];
        vc.view.backgroundColor = [TPLHelpTool getRandomColor];
        [vcArray addObject:vc];
    }
    
    
    _scrollShowView.viewsControllerArray = vcArray;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
