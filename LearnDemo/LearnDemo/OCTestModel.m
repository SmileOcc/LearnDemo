//
//  OCTestModel.m
//  LearnDemo
//
//  Created by odd on 5/20/24.
//

#import "OCTestModel.h"
#import "CWStudent.h"

@implementation OCTestModel



//MARK: - 多线程-读写安全
- (void)testMutlRead {
    NSLog(@"线程多读单写：%s", __func__);

    // 初始化锁
    pthread_rwlock_init(&_lock, NULL);
    
    for(int i=0;i<100;i++) {
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



- (void)testMutlGCd {
//    dispatch_barrier_async：异步栅栏调用
//    这个函数传入的并发队列必须是自己通过dispatch_queue_cretate创建的
//    如果传入的是一个串行或是一个全局的并发队列，那这个函数便等同于dispatch_async函数的效果
    
    
    NSLog(@"GCD多读单写：%s", __func__);

    self.queue = dispatch_queue_create("rw_queue", DISPATCH_QUEUE_CONCURRENT);
    
    for (int i = 0; i < 5; i++) {
            [self readGcd];
            
            [self readGcd];
            
            [self writeGcd];
            
            [self writeGcd];
        }

}


- (void)readGcd {
    dispatch_async(self.queue, ^{
        sleep(1);
        NSLog(@"%s", __func__);
    });
}

- (void)writeGcd {
    dispatch_barrier_sync(self.queue, ^{
        sleep(1);
        NSLog(@"%s", __func__);
    });
}



- (void)testAfterDelay {
    [self testcccc];
    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//
//            NSLog(@"2");
//        //不执行
//            [self performSelector:@selector(testCC) withObject:nil afterDelay:3];
//            NSLog(@"---1====3");
//    });
    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//
//            NSLog(@"2");
//            [self performSelector:@selector(testCC) withObject:nil afterDelay:3];
//            [[NSRunLoop currentRunLoop] run];
//            NSLog(@"---1====3");
//    });
//    ---====44444
//    ---1====3
    
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSLog(@"2");
            [self performSelector:@selector(testCC) withObject:nil];
            NSLog(@"---1====3");
    });
    //---====44444
    //---1====3
}

- (void)testcccc {
    
//    CWStudent *stud = [[CWStudent alloc] init];
//    [stud test];
}

- (void)testCC {
    NSLog(@"---====44444");

}

//runloop
- (void)testRunLoopStart {
    [self testRunLoopAsync];
    

}

- (void)testRunLoopAsync {
    
    NSLog(@"1");
    
    //方式一错误
    //答案是1423，test方法并不会执行。
    //原因是如果是带afterDelay的延时函数，会在内部创建一个 NSTimer，然后添加到当前线程的RunLoop中。
    //也就是如果当前线程没有开启RunLoop，该方法会失效。
    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        NSLog(@"2");
//
//        [self performSelector:@selector(test) withObject:nil afterDelay:10];
//        NSLog(@"3");
//    });

    
    //方式二 错误
//    然而test方法依然不执行。
//     原因是如果RunLoop的mode中一个item都没有，RunLoop会退出。
//    即在调用RunLoop的run方法后，由于其mode中没有添加任何item去维持RunLoop的时间循环，RunLoop随即还是会退出。
//     所以我们自己启动RunLoop，一定要在添加item后
    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        NSLog(@"2");
//
//        [[NSRunLoop currentRunLoop] run];
//        [self performSelector:@selector(test) withObject:nil afterDelay:10];
//        NSLog(@"3");
//    });
    
    //正确方式
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSLog(@"2");
        [self performSelector:@selector(test) withObject:nil afterDelay:10];
        
        [[NSRunLoop currentRunLoop] run];
        
        NSLog(@"3");
    });
    
    NSLog(@"4");
    //14235
}

- (void)test {
    NSLog(@"====5");
}



//MARK: - =========捕获
typedef void (^MyBlock)(void);

- (MyBlock)createBlock {
    int number = 10;
    MyBlock block = ^{
        NSLog(@"Captured value: %d", number);//10
    };
    number = 20;
    
//    __block int number = 10;
//    MyBlock block = ^{
//        NSLog(@"Captured value: %d", number); //20
//    };
//    number = 20;
    
    return block;
}

- (void)executeBlock {
    MyBlock myBlock = [self createBlock];
    myBlock();
}


@end
