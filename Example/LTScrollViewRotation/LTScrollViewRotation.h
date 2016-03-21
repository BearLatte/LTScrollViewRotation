//
//  LTScrollViewRotation.h
//  Example
//
//  Created by Latte_Bear on 16/3/21.
//  Copyright © 2016年 Latte_Bear. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTScrollViewRotation : UIView <UIScrollViewDelegate>
@property (nonatomic, readonly) UIScrollView *scrollView;
@property (nonatomic, readonly, strong) UIPageControl *pageControl;


/**
 *  重写初始化操作
 *
 *  @param frame             frame
 *  @param animationDuration 动画间隔时长，如果 <= 0,不自动滚动
 *
 *  @return 本实例
 */
- (id)initWithFrame:(CGRect)frame animationDuration:(NSTimeInterval)animationDuration;

/** 获取分页符的总数 */
@property (nonatomic, copy) NSInteger (^totalPagesNumber)(void);
/** 获取每个内容视图在分页符的位置 */
@property (nonatomic, copy) UIView *(^contentViewAtIndex)(NSInteger pageIndex);
/** 点击事件执行的block */
@property (nonatomic, copy) void (^tapActionBlock)(NSInteger pageIndex);
@end
