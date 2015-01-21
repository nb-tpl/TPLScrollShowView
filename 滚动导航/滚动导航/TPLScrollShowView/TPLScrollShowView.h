//
//  TPLScrollShowView.h
//  TPLScrollViews
//
//  Created by NB_TPL on 14-8-20.
//  Copyright (c) 2014年 NB_TPL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPLScrollShowView : UIView




//标题文字数组
@property(nonatomic,strong)NSMutableArray * titleArray;
//展现的视图控制器数组
@property(nonatomic,strong)NSMutableArray * viewsControllerArray;
//标题高度
@property(nonatomic,assign)CGFloat titleHeight;

@property(nonatomic,weak)UIViewController * viewController;

//滑动到顶端,0为左边，1为右边
@property(nonatomic,strong)void (^scrollToEnd)(int endStyle);


//运动到第几个页面
-(void)setShowVCIndex:(int)index animation:(BOOL)animation;

@end
