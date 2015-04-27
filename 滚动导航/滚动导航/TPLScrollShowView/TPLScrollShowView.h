//
//  TPLScrollShowView.h
//  TPLScrollViews
//
//  Created by NB_TPL on 14-8-20.
//  Copyright (c) 2014年 NB_TPL. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TPLAutoChangeView : UIScrollView

//水平是否应该一开始就能滑动,默认为NO
@property(nonatomic,assign)BOOL horizontalShouldScroll;
//竖直是否应该一开始就能滑动，默认为NO
@property(nonatomic,assign)BOOL verticalShouldScroll;
//自动恢复
@property(nonatomic,assign)BOOL fitFrame;




//按滚动范围扩大方法
/**
 *  按滚动范围扩大方法
 */
-(void)fitContentSize;

//扩大Frame
-(void)addFrameFromSize:(CGSize)size;

@end





#pragma mark
#pragma mark           TPLScrollShowView
#pragma mark




@interface TPLScrollShowView : UIView


//左边距
@property(nonatomic,assign)CGFloat titleXPaddin;
//间距
@property(nonatomic,assign)CGFloat titleXSpace;
//默认宽度，如果设定就按默认宽度来，没设定就按标题长度来
@property(nonatomic,assign)CGFloat titleWidth;



//标题文字数组
@property(nonatomic,strong)NSMutableArray * titleArray;
//标题的背景颜色
@property(nonatomic,strong)UIColor * titlesBackgroundColor;
//展现的视图控制器数组
@property(nonatomic,strong)NSMutableArray * viewsControllerArray;
//标题高度
@property(nonatomic,assign)CGFloat titleHeight;
//标题字体
@property(nonatomic,strong)UIFont * titleFont;
//标题正常颜色
@property(nonatomic,strong)UIColor * titleNormalColor;
//标题选中颜色
@property(nonatomic,strong)UIColor * titleSelectColor;
//标题下标的滚动条高度
@property(nonatomic,assign)CGFloat titleBottomLineHeight;
//标题下标滚动条颜色
@property(nonatomic,strong)UIColor * titleBottomLineColor;
@property(nonatomic,weak)UIViewController * viewController;

//滑动到顶端,0为左边，1为右边
@property(nonatomic,strong)void (^scrollToEnd)(int endStyle);
//展示第几个视图的Block
@property(nonatomic,strong)void (^scrollToIndex)(int index);


//运动到第几个页面
-(void)setShowVCIndex:(int)index animation:(BOOL)animation;

@end
