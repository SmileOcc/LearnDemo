//
//  CWThread.h
//  LearnDemo
//
//  Created by odd on 5/23/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CWThread : NSObject

/**
 关闭线程
 */
- (void)stop;

/// 在保活的线程里面执行的任务
/// @param target 目标对象
/// @param action selector
/// @param object object
- (void)excuteTaskWithTarget:(id)target action:(SEL)action object:(id)object;

/// 在保活的线程里执行任务
/// @param task 执行的任务
- (void)excuteTask:(void(^)(void))task;

@end

NS_ASSUME_NONNULL_END
