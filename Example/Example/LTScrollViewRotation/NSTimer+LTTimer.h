//
//  NSTimer+LTTimer.h
//  Example
//
//  Created by Latte_Bear on 16/3/21.
//  Copyright © 2016年 Latte_Bear. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (LTTimer)
/**
 *  暂停计时器
 */
- (void)pauseTimer;
/**
 *  恢复计时器
 */
- (void)resumeTimer;
/**
 *  特定时间后恢复计时器
 *
 *  @param duration 设置时间
 */
- (void)resumeTimerAfterTimerInterval:(NSTimeInterval)timeInterVal;
@end
