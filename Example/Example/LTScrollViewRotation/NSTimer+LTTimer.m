//
//  NSTimer+LTTimer.m
//  Example
//
//  Created by Latte_Bear on 16/3/21.
//  Copyright © 2016年 Latte_Bear. All rights reserved.
//

#import "NSTimer+LTTimer.h"

@implementation NSTimer (LTTimer)
- (void)pauseTimer {
    if (![self isValid]) {
        return;
    }
    [self setFireDate:[NSDate distantFuture]];
}
- (void)resumeTimer {
    if (![self isValid]) {
        return;
    }
    [self setFireDate:[NSDate date]];
}
- (void)resumeTimerAfterTimerInterval:(NSTimeInterval)timerInterVal {
    if (![self isValid]) {
        return;
    }
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:timerInterVal]];
}
@end
