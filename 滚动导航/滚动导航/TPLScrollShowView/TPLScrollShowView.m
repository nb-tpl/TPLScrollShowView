//
//  IFScrollShowView.m
//  IFScrollViews
//
//  Created by NB_TPL on 14-8-20.
//  Copyright (c) 2014年 NB_TPL. All rights reserved.
//

#import "TPLScrollShowView.h"

//#import "TPLAutoChangeView.h"
//#import "TPLHelpTool.h"



#pragma mark
#pragma mark           TPLAutoChangeView
#pragma mark
@implementation TPLAutoChangeView
@synthesize horizontalShouldScroll = _horizontalShouldScroll,verticalShouldScroll = _verticalShouldScroll;
@synthesize fitFrame = _fitFrame;
#pragma mark
#pragma mark---------------property
//竖直是否初始能滑动
-(void)setVerticalShouldScroll:(BOOL)verticalShouldScroll
{
    _verticalShouldScroll = verticalShouldScroll;
    if (_verticalShouldScroll)
    {
        if (self.frame.size.height >= self.contentSize.height)
        {
            self.contentSize = CGSizeMake(self.contentSize.width, self.frame.size.height + 1);
        }
    }
}
//水平是否初始能滑动
-(void)setHorizontalShouldScroll:(BOOL)horizontalShouldScroll
{
    _horizontalShouldScroll = horizontalShouldScroll;
    if (_horizontalShouldScroll)
    {
        if (self.frame.size.width >= self.contentSize.width)
        {
            self.contentSize = CGSizeMake(self.frame.size.width + 1, self.contentSize.height);
        }
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.userInteractionEnabled = YES;
        _verticalShouldScroll = NO;
        _horizontalShouldScroll = NO;
        _fitFrame = NO;
    }
    return self;
}


//改变自己的滑动范围
-(void)addSubview:(UIView *)view
{
    //水平扩充和恢复
    if ((view.frame.origin.x + view.frame.size.width) > self.contentSize.width)
    {
        self.contentSize = CGSizeMake(view.frame.origin.x + view.frame.size.width, self.contentSize.height);
    }
    else
    {
        if (_fitFrame)
        {
            if (_horizontalShouldScroll)
            {
                self.contentSize = CGSizeMake(self.frame.size.width + 1, self.contentSize.height);
            }
            else
            {
                self.contentSize = CGSizeMake(self.frame.size.width, self.contentSize.height);
            }
        }
    }
    //垂直扩充和恢复
    if((view.frame.origin.y + view.frame.size.height) > self.contentSize.height ||(view.frame.origin.y + view.frame.size.height) > self.frame.size.height)
    {
        self.contentSize = CGSizeMake(self.contentSize.width, view.frame.origin.y + view.frame.size.height);
    }
    else
    {
        if (_fitFrame)
        {
            if (_verticalShouldScroll)
            {
                self.contentSize = CGSizeMake(self.contentSize.width, self.frame.size.height + 1);
            }
            else
            {
                self.contentSize = CGSizeMake(self.contentSize.width, self.frame.size.height);
            }
        }
    }
    [super addSubview:view];
}



#pragma mark
#pragma mark---------------Function
-(void)addFrameFromSize:(CGSize)size
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width + size.width, self.frame.size.height + size.height);
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
}


@end

#pragma mark
#pragma mark           TPLScrollShowView
#pragma mark

#define title_xSpace_default 20
#define dealocInfo NSLog(@"%@ 释放了",[self class])

//mainView
#define TitlesBackgroundColor [UIColor colorWithRed:0.917 green:0.927 blue:0.917 alpha:1.000]
#define MainTitleFont [UIFont systemFontOfSize:16.0f]
#define MainTitleNormalColor [UIColor colorWithWhite:0.407 alpha:1.000]
#define MainTitleSelectColor [UIColor colorWithRed:0.389 green:0.670 blue:0.265 alpha:1.000]
#define MainTitleBottomLineHeight 3
#define MainTitleBottomLineColor [UIColor colorWithRed:0.393 green:0.665 blue:0.265 alpha:1.000]


@interface TPLScrollShowView ()<UIScrollViewDelegate>
{
//视图
    //标题的滚动视图
    TPLAutoChangeView * _titleScrollView;
    UIImageView * _titleBottomLine;
    //视图控制器的滚动视图
    UIScrollView * _viewsVCScrollView;
//    UIView * _swipView;
    
//数据
    NSMutableArray * _titleLabelsArray;
    
    
//辅助变量
    NSInteger _currentVC;
    BOOL _isClicked;
}

//初始化所有视图
-(void)refreshViews;
//展示标题
-(void)showTitle;

@end

@implementation TPLScrollShowView
-(void)dealloc
{
    dealocInfo;
}


#pragma mark
#pragma mark           property
#pragma mark
-(void)setTitleHeight:(CGFloat)titleHeight
{
    _titleHeight = titleHeight;
    [self refreshViews];
}
-(void)setTitleArray:(NSMutableArray *)titleArray
{
    _titleArray = titleArray;
    [self refreshViews];
}
-(void)setViewsControllerArray:(NSMutableArray *)viewsControllerArray
{
    _viewsControllerArray = viewsControllerArray;
    [self refreshViews];
}
-(void)setTitleFont:(UIFont *)titleFont
{
    _titleFont = titleFont;
    [self refreshViews];
}
-(void)setTitleNormalColor:(UIColor *)titleNormalColor
{
    _titleNormalColor = titleNormalColor;
    [self refreshViews];
}
-(void)setTitleSelectColor:(UIColor *)titleSelectColor
{
    _titleSelectColor = titleSelectColor;
    [self refreshViews];
}

-(void)setTitleBottomLineHeight:(CGFloat)titleBottomLineHeight
{
    _titleBottomLineHeight = titleBottomLineHeight;
    [self refreshViews];
}
-(void)setTitleBottomLineColor:(UIColor *)titleBottomLineColor
{
    _titleBottomLineColor = titleBottomLineColor;
    _titleBottomLine.backgroundColor = _titleBottomLineColor;
}
-(void)setTitlesBackgroundColor:(UIColor *)titlesBackgroundColor
{
    _titlesBackgroundColor = titlesBackgroundColor;
    _titleScrollView.backgroundColor = _titlesBackgroundColor;
}






#pragma mark
#pragma mark           init
#pragma mark
-(void)initBaseData
{
    _titleXPaddin = 10;
    _titleXSpace = title_xSpace_default;
    _titleWidth = 0;
    _titleFont = MainTitleFont;
    _titleNormalColor = MainTitleNormalColor;
    _titleSelectColor = MainTitleSelectColor;
    _titleBottomLineHeight = MainTitleBottomLineHeight;
    _titleBottomLineColor = MainTitleBottomLineColor;
    _titlesBackgroundColor = TitlesBackgroundColor;
    
    _titleLabelsArray = [[NSMutableArray alloc] initWithCapacity:0];
    _currentVC = 0;

}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //data init
        [self initBaseData];

        //help value init
        
        //init view
        [self refreshViews];
        
    }
    return self;
}
#pragma mark
#pragma mark           init view
#pragma mark
//初始化所有视图
-(void)refreshViews
{
    //刷新标题
    [self showTitle];
    //刷新视图控制器
    [self showViews];
    
    
    
   //刷新当前点击
    [self fitContentOffsetForCurrentVCAnimation:YES];
}
//展示标题
-(void)showTitle
{
    
    //重新刷新标题位置大小
    if(!_titleScrollView)
    {
        _titleScrollView = [[TPLAutoChangeView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, _titleHeight)];
        _titleScrollView.backgroundColor = _titlesBackgroundColor;
        _titleScrollView.showsHorizontalScrollIndicator = NO;;
        [self addSubview:_titleScrollView];
    }
    else
    {
        _titleScrollView.frame = CGRectMake(0, 0, self.frame.size.width, _titleHeight);
        _titleScrollView.contentSize = CGSizeMake(self.frame.size.width, _titleHeight);
    }
    //清空标题
    for (UIButton * titleButton in _titleLabelsArray)
    {
        [titleButton removeFromSuperview];
    }
    [_titleLabelsArray removeAllObjects];
    
    
    CGFloat x = _titleXPaddin;
    int i = 0;
    for (NSString * title in _titleArray)
    {
//        CGFloat width = [TPLHelpTool lengthOfString:title withFont:_titleFont];
        CGFloat width = [TPLScrollShowView lengthOfString:title withFont:_titleFont];

        width = width;
        if (_titleWidth != 0)
        {
            width = _titleWidth;
        }
        UILabel * titleLabel = [[UILabel alloc] init];
        titleLabel.frame = CGRectMake(x, 0, width, _titleHeight);
        titleLabel.font = _titleFont;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = title;
        titleLabel.userInteractionEnabled = YES;
        titleLabel.textColor = _titleNormalColor;
        UITapGestureRecognizer * tapOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleClicked:)];
        tapOne.numberOfTapsRequired = 1;
        [titleLabel addGestureRecognizer:tapOne];
        
        titleLabel.tag = 1000 + i;
        [_titleScrollView addSubview:titleLabel];
        [_titleLabelsArray addObject:titleLabel];
        
        i++;
        x = x + width + _titleXSpace;
    }
    //调整下
    _titleScrollView.contentSize = CGSizeMake(_titleScrollView.contentSize.width+ _titleXPaddin, _titleScrollView.contentSize.height);
}

//展示视图
-(void)showViews
{
    //调整视图位置大小
    if (_viewsVCScrollView)
    {
        _viewsVCScrollView.frame = CGRectMake(0,_titleHeight, self.frame.size.width,self.frame.size.height - _titleHeight);
        _viewsVCScrollView.contentSize = CGSizeMake(self.frame.size.width * _viewsControllerArray.count, self.frame.size.height - _titleHeight);
    }
    else
    {
        _viewsVCScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,_titleHeight, self.frame.size.width,self.frame.size.height - _titleHeight)];
        _viewsVCScrollView.delegate = self;
//        _viewsVCScrollView.bounces = NO;
        _viewsVCScrollView.pagingEnabled = YES;
        _viewsVCScrollView.showsHorizontalScrollIndicator = NO;
        _viewsVCScrollView.contentSize = CGSizeMake(self.frame.size.width * _viewsControllerArray.count, self.frame.size.height - _titleHeight);
        [self addSubview:_viewsVCScrollView];
    }
    //testing
//        _viewsVCScrollView.contentSize = CGSizeMake(self.frame.size.width * 1, self.frame.size.height - _titleHeight);
}

#pragma mark
#pragma mark           UIScrollViewDelegate
#pragma mark
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    //滑到顶之后能继续滑出侧滑菜单
    if (_scrollToEnd)
    {
        if (scrollView.contentOffset.x < -50)
        {
            _scrollToEnd(0);
        }
        else if (scrollView.contentOffset.x - 50 > scrollView.contentSize.width - scrollView.frame.size.width)
        {
            _scrollToEnd(1);
        }
    }
    
    if (_viewsVCScrollView == scrollView && _isClicked == NO)
    {
        if (scrollView.contentOffset.x > (_currentVC*scrollView.frame.size.width + scrollView.frame.size.width) && (scrollView.contentOffset.x + scrollView.frame.size.width) < scrollView.contentSize.width)
        {
            UILabel * tempLabel = [_titleLabelsArray objectAtIndex:_currentVC];
            tempLabel.textColor = _titleNormalColor;
            _currentVC++;
            UILabel * nowLabel = [_titleLabelsArray objectAtIndex:_currentVC];
            nowLabel.textColor = _titleSelectColor;
        }
        else if (scrollView.contentOffset.x > 0 && (scrollView.contentOffset.x + scrollView.frame.size.width) < _currentVC*self.frame.size.width)
        {
            UILabel * tempLabel = [_titleLabelsArray objectAtIndex:_currentVC];
            tempLabel.textColor = _titleNormalColor;
            _currentVC--;
            UILabel * nowLabel = [_titleLabelsArray objectAtIndex:_currentVC];
            nowLabel.textColor = _titleSelectColor;
        }

        
        //往前还是往后
        if (scrollView.contentOffset.x > _currentVC*_viewsVCScrollView.frame.size.width &&
            scrollView.contentOffset.x + _viewsVCScrollView.frame.size.width < scrollView.contentSize.width)//往后翻
        {
            //后一个Label
            UILabel * nextLabel = [_titleLabelsArray objectAtIndex:_currentVC + 1];
            UILabel * currentLabel = [_titleLabelsArray objectAtIndex:_currentVC];
            CGFloat distance = nextLabel.center.x - currentLabel.center.x;
            CGFloat widthChange = nextLabel.frame.size.width - currentLabel.frame.size.width;
            
            CGFloat temp = scrollView.contentOffset.x - scrollView.frame.size.width*_currentVC;
            CGFloat ratio = temp/scrollView.frame.size.width;
            CGFloat addValue = distance*ratio;
            _titleBottomLine.center = CGPointMake(currentLabel.center.x + addValue, _titleBottomLine.center.y);
            _titleBottomLine.frame = CGRectMake(_titleBottomLine.frame.origin.x, _titleBottomLine.frame.origin.y, currentLabel.frame.size.width + widthChange*ratio, _titleBottomLine.frame.size.height);
        }
        else if (scrollView.contentOffset.x < _currentVC*_viewsVCScrollView.frame.size.width &&scrollView.contentOffset.x > 0)//往前翻
        {
            //后一个Label
            UILabel * previousLabel = [_titleLabelsArray objectAtIndex:_currentVC - 1];
            UILabel * currentLabel = [_titleLabelsArray objectAtIndex:_currentVC];
            CGFloat distance = currentLabel.center.x - previousLabel.center.x;
            CGFloat widthChange = currentLabel.frame.size.width - previousLabel.frame.size.width;
            
            CGFloat temp = scrollView.contentOffset.x - scrollView.frame.size.width*_currentVC;
            CGFloat ratio = temp/scrollView.frame.size.width;
            CGFloat addValue = distance*ratio;
            _titleBottomLine.center = CGPointMake(currentLabel.center.x + addValue, _titleBottomLine.center.y);
            _titleBottomLine.frame = CGRectMake(_titleBottomLine.frame.origin.x, _titleBottomLine.frame.origin.y, currentLabel.frame.size.width + widthChange*ratio, _titleBottomLine.frame.size.height);
        }
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int count = scrollView.contentOffset.x/scrollView.frame.size.width;
    CGFloat tempValue = scrollView.contentOffset.x - count*scrollView.frame.size.width;
    if (tempValue > scrollView.frame.size.width/2.0f)
    {
        count++;
    }
    
    if (_currentVC != count)
    {
        UILabel * previousTitleLabel = [_titleLabelsArray objectAtIndex:_currentVC];
        previousTitleLabel.textColor = _titleNormalColor;
        _currentVC = count;
    }
    [self fitContentOffsetForCurrentVCAnimation:YES];
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _isClicked = NO;
}

//scrollV动画结束
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (_viewsVCScrollView == scrollView)
    {
        UIViewController * vc = [_viewsControllerArray objectAtIndex:_currentVC];
        
        if (vc.view.superview == nil)
        {
            vc.view.frame = CGRectMake(_currentVC*self.frame.size.width, 0, self.frame.size.width, _viewsVCScrollView.frame.size.height);
            [_viewsVCScrollView addSubview:vc.view];
        }

        [vc viewDidAppear:YES];
    }
}


#pragma mark
#pragma mark           button function
#pragma mark
-(void)titleClicked:(UITapGestureRecognizer*)tap
{
    _isClicked = YES;
    //之前的标题
    UILabel * previousTitleLabel = [_titleLabelsArray objectAtIndex:_currentVC];
    previousTitleLabel.textColor = _titleNormalColor;
    
    BOOL animation = abs((int)_currentVC - (int)(tap.view.tag - 1000)) == 1 ? YES:NO;
    _currentVC = tap.view.tag - 1000;
    UILabel * currentTitleLabel = [_titleLabelsArray objectAtIndex:_currentVC];
    currentTitleLabel.textColor = _titleSelectColor;
    typeof(self) __weak weak_self = self;
    [UIView animateWithDuration:0.2 animations:^{
        _titleBottomLine.frame = CGRectMake(currentTitleLabel.frame.origin.x, _titleHeight - _titleBottomLineHeight, currentTitleLabel.frame.size.width, _titleBottomLineHeight);
    } completion:^(BOOL finish){
        typeof(weak_self) __strong strong_self = weak_self;
        if (strong_self)
        {
            [strong_self fitContentOffsetForCurrentVCAnimation:animation];
        }
    }];
}


#pragma mark
#pragma mark           help function
#pragma mark
-(void)fitContentOffsetForCurrentVCAnimation:(BOOL)animation
{
    if (!(_titleLabelsArray.count > 0))
    {
        return;
    }
    
    
    //到右边顶
    if (_currentVC < _titleLabelsArray.count - 1)
    {
        UILabel * nextLabel = [_titleLabelsArray objectAtIndex:_currentVC + 1];
        
        if (nextLabel.frame.origin.x + nextLabel.frame.size.width/2 >= _titleScrollView.contentOffset.x + _titleScrollView.frame.size.width)//将右面的移出来
        {
            [self showTitleOffsetForIndex:_currentVC+1 animation:animation];
        }
    }
    
    //到左边顶
    if (_currentVC > 0)
    {
        UILabel * previousLabel = [_titleLabelsArray objectAtIndex:_currentVC - 1];
        
        if (previousLabel.frame.origin.x + previousLabel.frame.size.width/2 <= _titleScrollView.contentOffset.x)//将前面的移出来
        {
            [self showTitleOffsetForIndex:_currentVC-1 animation:animation];
        }
    }
    
    if (_currentVC == 0 || _currentVC == _titleLabelsArray.count - 1)
    {
        [self showTitleOffsetForIndex:_currentVC animation:animation];
    }
    
    //显示视图
    [self resetCurrentVCAnimation:animation];
}

//根据当前展现调整标题展现的位置
-(void)showTitleOffsetForIndex:(NSInteger)index animation:(BOOL)animation
{
    UILabel * showTitleLabel = [_titleLabelsArray objectAtIndex:index];

    //如果在左边未显示出来
    if (_titleScrollView.contentOffset.x > showTitleLabel.frame.origin.x)
    {
        [_titleScrollView setContentOffset:CGPointMake(showTitleLabel.frame.origin.x - 10, 0) animated:animation];
    }
    else if((_titleScrollView.contentOffset.x + _titleScrollView.frame.size.width) < (showTitleLabel.frame.origin.x + showTitleLabel.frame.size.width))//右边未显示全
    {
        [_titleScrollView setContentOffset:CGPointMake((showTitleLabel.frame.origin.x + showTitleLabel.frame.size.width + 10) - _titleScrollView.frame.size.width, 0) animated:animation];
    }

}


//刷新当前点击
-(void)resetCurrentVCAnimation:(BOOL)animation
{
    //设定当前点击
    if (!_titleBottomLine)
    {
        _titleBottomLine = [[UIImageView alloc] init];
        _titleBottomLine.backgroundColor = _titleBottomLineColor;
        [_titleScrollView addSubview:_titleBottomLine];
    }
    
    //当前标题颜色
    if (_titleLabelsArray.count > 0)
    {
        UILabel * titleLabel = [_titleLabelsArray objectAtIndex:_currentVC];
        titleLabel.textColor = _titleSelectColor;
        _titleBottomLine.frame = CGRectMake(titleLabel.frame.origin.x, _titleHeight - _titleBottomLineHeight, titleLabel.frame.size.width, _titleBottomLineHeight);
    }
    
    //当前视图
    if (_viewsControllerArray.count > 0)
    {
        UIViewController * vc = [_viewsControllerArray objectAtIndex:_currentVC];
        if (vc.view.superview == nil && _viewsVCScrollView.contentOffset.x == _currentVC*self.frame.size.width)
        {
            vc.view.frame = CGRectMake(_currentVC*self.frame.size.width, 0, self.frame.size.width, _viewsVCScrollView.frame.size.height);
            [_viewsVCScrollView addSubview:vc.view];
            [vc viewDidAppear:YES];
        }
        
        [_viewsVCScrollView setContentOffset:CGPointMake(_currentVC*self.frame.size.width, 0) animated:animation];
        if (animation)
        {
        }
        else
        {
            [vc viewDidAppear:animation];
        }
        [self scrollToIndex:(int)_currentVC];

//        [vc viewDidAppear:YES];改为动画结束后调用
    }
}

-(void)scrollToIndex:(int)index
{
    if (_scrollToIndex)
    {
        _scrollToIndex(index);
    }
}


//获得字符串长度
#define MORE_WIDTH 0
+(CGFloat)lengthOfString:(NSString*)string withFont:(UIFont*)font
{
//    NSString * systemString = [TPLHelpTool getSystemVersion];
    NSString * systemString = [TPLScrollShowView getSystemVersion];

    CGSize size;
    if ([systemString intValue] >= 7)
    {
        size = [string sizeWithAttributes:[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName]];
    }
    else
    {
        size = [string sizeWithFont:font];
    }
    
    return size.width + MORE_WIDTH;
}

//获得操作系统版本号
+(NSString *)getSystemVersion
{
    return  [[UIDevice currentDevice] systemVersion];
}




#pragma mark
#pragma mark           publich function
#pragma mark
//运动到第几个页面
-(void)setShowVCIndex:(int)index animation:(BOOL)animation
{
    if (index < _titleLabelsArray.count)
    {
        _isClicked = YES;
        //之前的标题
        UILabel * previousTitleLabel = [_titleLabelsArray objectAtIndex:_currentVC];
        previousTitleLabel.textColor = _titleNormalColor;
        
        
        _currentVC = index;
        UILabel * currentTitleLabel = [_titleLabelsArray objectAtIndex:_currentVC];
        currentTitleLabel.textColor = _titleSelectColor;
        CGFloat animationDuration = animation ? 0.2f : 0;
        typeof(self) __weak weak_self = self;
        [UIView animateWithDuration:animationDuration animations:^{
            _titleBottomLine.frame = CGRectMake(currentTitleLabel.frame.origin.x, _titleHeight - _titleBottomLineHeight, currentTitleLabel.frame.size.width, _titleBottomLineHeight);
        } completion:^(BOOL finish){
            typeof(weak_self) __strong strong_self = weak_self;
            if (strong_self)
            {
                [strong_self fitContentOffsetForCurrentVCAnimation:animation];
            }
        }];
    }
}

#pragma mark
#pragma mark           swipView
#pragma mark
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
