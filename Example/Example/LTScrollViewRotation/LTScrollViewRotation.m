//
//  LTScrollViewRotation.m
//  Example
//
//  Created by Latte_Bear on 16/3/21.
//  Copyright © 2016年 Latte_Bear. All rights reserved.
//

#import "LTScrollViewRotation.h"
#import "NSTimer+LTTimer.h"




@interface LTScrollViewRotation()
/** 滚动视图 */
@property (nonatomic, strong) UIScrollView *scrollView;
/** 用于接收内容视图的数组 */
@property (nonatomic, strong) NSMutableArray *contentViews;
/** 计时器实例 */
@property (nonatomic, strong) NSTimer *timer;
/** 当前翻页控件的索引数 */
@property (nonatomic, assign) NSInteger currentPageIndex;
/** 总的翻页控件数 */
@property (nonatomic, assign) NSInteger totalPageNumber;
/** 翻页动画持续时长 */
@property (nonatomic, assign) NSTimeInterval animationDuration;
@end



@implementation LTScrollViewRotation

- (void)setTotalPagesNumber:(NSInteger (^)(void))totalPagesNumber {
    //获取到翻页符的数量直接赋值
    _totalPageNumber = totalPagesNumber();
    _pageControl.numberOfPages = _totalPageNumber;
    if (_totalPageNumber > 0) {
        [self configContentViews];
        [self.timer resumeTimerAfterTimerInterval:self.animationDuration];
    }
    
}

//默认初始化
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        //自动调整子视图
        self.autoresizesSubviews = YES;
        //初始化滚动视图
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.scrollView.autoresizingMask = 0xff;
        self.scrollView.contentMode = UIViewContentModeCenter;
        //设置滚动视图的内容视图大小，这里设置3 * scrollView的宽度表示可前后翻页 1为不能手动翻页 2为只能向前翻页
        self.scrollView.contentSize = CGSizeMake(3 * CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame));
        self.scrollView.pagingEnabled = YES;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.delegate = self;
        //将滚动视图添加到视图中
        [self addSubview:self.scrollView];
        
        //设置默认选中的页面
        self.currentPageIndex = 0;
        
        
        //初始化分页控件
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, frame.size.height - 20, frame.size.width, 20)];
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        //将分页控件添加到视图中
        [self addSubview:_pageControl];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame animationDuration:(NSTimeInterval)animationDuration {
    self = [self initWithFrame:frame];
    if (animationDuration > 0.0) {
        self.timer = [NSTimer
                      scheduledTimerWithTimeInterval:(self.animationDuration = animationDuration)
                                              target:self
                                            selector:@selector(startAnimationTimer:)
                                            userInfo:nil
                                             repeats:YES];
        
        [self.timer pauseTimer];
    }
    return self;
}
#pragma mark - 响应方法
- (void)startAnimationTimer:(NSTimer *)timer {
    CGPoint newOffset = CGPointMake(self.scrollView.contentOffset.x + CGRectGetWidth(self.scrollView.frame), self.scrollView.contentOffset.y);
    [self.scrollView setContentOffset:newOffset animated:YES];
}
- (void)contentViewTapAction:(UITapGestureRecognizer *)tap {
    if (self.tapActionBlock) {
        self.tapActionBlock(self.currentPageIndex);
    }
}
#pragma mark - 私有方法
/**
 *  设置内容视图
 */
- (void)configContentViews {
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self setScrollViewContentDataSource];
    
    
    NSInteger count = 0;
    for (UIView *contentView in self.contentViews) {
        contentView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewTapAction:)];
        [contentView addGestureRecognizer:tapGesture];
        CGRect rightRect = contentView.frame;
        rightRect.origin = CGPointMake(CGRectGetWidth(self.scrollView.frame) * (count++), 0);
        contentView.frame = rightRect;
        [self.scrollView addSubview:contentView];
    }
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];
}
/**
 *  设置ScrollView的内容数据源
 */
- (void)setScrollViewContentDataSource {
    NSInteger previousPageIndex = [self nextPageIndexWithCurrentIndex:self.currentPageIndex - 1];
    NSInteger nextPageIndex = [self nextPageIndexWithCurrentIndex:self.currentPageIndex + 1];
    if (!self.contentViews) {
        self.contentViews = [[NSArray array] mutableCopy];
    }
    [self.contentViews removeAllObjects];
    if (self.contentViewAtIndex) {
        [self.contentViews addObject:self.contentViewAtIndex(previousPageIndex)];
        [self.contentViews addObject:self.contentViewAtIndex(_currentPageIndex)];
        [self.contentViews addObject:self.contentViewAtIndex(nextPageIndex)];
    }
}
//获取下个页面的索引数
- (NSInteger)nextPageIndexWithCurrentIndex:(NSInteger)currentIndex {
    if (currentIndex == -1) {
        return self.totalPageNumber - 1;
    }else if (currentIndex == self.totalPageNumber) {
        return 0;
    }else {
        return currentIndex;
    }
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.timer pauseTimer];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.timer resumeTimerAfterTimerInterval:self.animationDuration];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int contentOffsetX = scrollView.contentOffset.x;
    if (contentOffsetX >= (2 * CGRectGetWidth(scrollView.frame))) {
        self.currentPageIndex = [self nextPageIndexWithCurrentIndex:self.currentPageIndex + 1];
        _pageControl.currentPage = self.currentPageIndex;
        [self configContentViews];
    }
    if (contentOffsetX <= 0) {
        self.currentPageIndex = [self nextPageIndexWithCurrentIndex:self.currentPageIndex - 1];
        _pageControl.currentPage = self.currentPageIndex;
        [self configContentViews];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [scrollView setContentOffset:CGPointMake(CGRectGetWidth(scrollView.frame), 0) animated:YES];
}
@end
