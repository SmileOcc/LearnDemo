//
//  OCTestModel.h
//  LearnDemo
//
//  Created by odd on 5/20/24.
//

#import <Foundation/Foundation.h>
#import <pthread.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCTestModel : NSObject

@property (nonatomic, assign) pthread_rwlock_t lock;

@property (nonatomic, strong) dispatch_queue_t queue;

- (void)testAfterDelay;
@end

NS_ASSUME_NONNULL_END
