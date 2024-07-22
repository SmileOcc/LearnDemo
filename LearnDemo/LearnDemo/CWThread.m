//
//  CWThread.m
//  LearnDemo
//
//  Created by odd on 5/23/24.
//

#import "CWThread.h"

@interface CWThread ()

@property (nonatomic, strong) NSThread *innerThread;
@property (nonatomic, assign) BOOL isStopped;

@end

@implementation CWThread

- (void)dealloc {
    NSLog(@"%s",__func__);
    [self stop];
}

- (instancetype)init {
  if (self = [super init]) {
    self.isStopped = NO;

    __weak typeof(self) weakSelf = self;
    self.innerThread = [[NSThread alloc] initWithBlock:^{
      // 添加Port到RunLoop
      [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
      while (weakSelf && !weakSelf.isStopped) {
        // 开启RunLoop
          [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
      }
    }];
    [self.innerThread start];
  }
  return self;
}

- (void)run {
  if (!self.innerThread) {
      return;
  }
  [self.innerThread start];
}

- (void)stop {
  if (!self.innerThread) {
      return;
  }
  [self performSelector:@selector(__stop) onThread:self.innerThread withObject:nil waitUntilDone:YES];
}

- (void)__stop {
  self.isStopped = YES;
  // 退出当前RunLoop
  CFRunLoopStop(CFRunLoopGetCurrent());
  self.innerThread = nil;
}

- (void)excuteTaskWithTarget:(id)target action:(SEL)action object:(id)object {
  if (!self.innerThread) {
      return;
  }
  [self performSelector:action onThread:self.innerThread withObject:object waitUntilDone:NO ];
}

- (void)excuteTask:(void (^)(void))task {
  if (!self.innerThread || !task) {
      return;
  }
  [self performSelector:@selector(__excuteTask:) onThread:self.innerThread withObject:task waitUntilDone:NO ];
}

- (void)__excuteTask:(void(^)(void))task {
  task();
}

@end
