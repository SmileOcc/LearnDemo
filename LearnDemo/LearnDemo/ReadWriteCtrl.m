//
//  ReadWriteCtrl.m
//  LearnDemo
//
//  Created by odd on 7/15/24.
//

#import "ReadWriteCtrl.h"
#import <pthread.h>

@interface ReadWriteCtrl ()
@property (nonatomic, assign) pthread_rwlock_t lock;

@property (nonatomic, strong) dispatch_queue_t queue;


@end

@implementation ReadWriteCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 初始化锁
    pthread_rwlock_init(&_lock, NULL);
    
    //方式二
    self.queue = dispatch_queue_create("rw_queue", DISPATCH_QUEUE_CONCURRENT);

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    for (int i = 0; i < 5; i++) {
        dispatch_async(queue, ^{
            [self read];
        });
        
        dispatch_async(queue, ^{
            [self read];
        });
        
        dispatch_async(queue, ^{
            [self write];
        });
        
        dispatch_async(queue, ^{
            [self write];
        });
    }
    
    for (int i = 0; i < 5; i++) {
            [self read2];
            
            [self read2];
            
            [self write2];
            
            [self write2];
    }
}

- (void)read {
    pthread_rwlock_rdlock(&_lock);
    
    sleep(1);
    NSLog(@"%s", __func__);
    
    pthread_rwlock_unlock(&_lock);
}

- (void)write {
    pthread_rwlock_wrlock(&_lock);
    
    sleep(1);
    NSLog(@"%s", __func__);
    
    pthread_rwlock_unlock(&_lock);
}






- (void)read2 {
    dispatch_async(self.queue, ^{
        sleep(1);
        NSLog(@"%s", __func__);
    });
}

- (void)write2 {
    dispatch_barrier_sync(self.queue, ^{
        sleep(1);
        NSLog(@"%s", __func__);
    });
}


@end
