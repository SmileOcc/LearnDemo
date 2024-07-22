
#命令函数
swift中函数派发查看方式：可将swift代码转换为SIL(中间码)
swiftc -emit-silgen -O example.swift

#swift和OC的区别？
1）swift是静态语言，有类型推断，OC是动态语言。
2）swift是一门支持多编程范式的语言，既支持面向对象编程，也支持面向协议编程，同时还支持函数式编程，OC面向对象编程。
3）swift注重值类型，OC注重引用类型。
4）swift支持泛型，OC只支持轻量泛型。
5）swift支持静态派发（效率高）、动态派发（函数表派发、消息派发）方式，OC支持动态派发（消息派发）方式。
6）swift的协议不仅可以被类实现，也可以被struct和enum实现。
7）swift有元组类型、支持运算符重载。
8）swift支持命名空间。
9）swift支持默认参数。


#总结：swift比Objective-C优势：
1）swift容易阅读，语法和文件结构简易化。
2）swift更易于维护，文件分离后结构更清晰。
3）swift更加安全，它是类型安全的语言：
4）swift代码更少，简洁的语法，可以省去大量冗余代码。
5）swift速度更快，运算性能更高。

#Swift中的常量和OC中的常量有啥区别？
OC中的常量（const）是编译期决定的，Swift中的常量（let）是运行时确定的

#String 与 NSString 的关系与区别？
本质区别：[String是结构体]，NSString是类，结构体是值类型，
值类型被赋予给一个变量、常量或者被传递给一个函数的时候，其值会被拷贝。

#weak和assign的区别

weak 只可以修饰对象。如果修饰基本数据类型，编译器会报错-“Property with ‘weak’ attribute must be of object type”。
assign 可修饰对象，和基本数据类型。

weak 不会产生野指针问题。因为weak修饰的对象释放后（引用计数器值为0），指针会自动被置nil，之后再向该对象发消息也不会崩溃。 weak是安全的。
assign 如果修饰对象，会产生野指针问题；如果修饰基本数据类型则是安全的。
修饰的对象释放后，指针不会自动被置空，此时向对象发消息会崩溃。

#weak和unowned
Weak引用利用了ARC的功能，当一个引用被声明为weak的时候，ARC并不会retain这个对象。ARC会记录所有的weak引用以及它们所指向的对象，当某个对象的引用计数降到0并被销毁之后，ARC会自动将nil赋予这个引用，这也是swift中必须将weak引用声明为optional var的原因。

与weak引用相类似，unowned引用也不会保存一个strong引用至它所指向的对象。
将一个引用声明为Unowned，意味着ARC对这个引用将不再起任何作用。如果引用的对象被销毁了，我们将真正面临悬挂指针的问题。所以，官方的说法是使用unowned引用必须确保unowned引用所指向的对象拥有与unowned引用相同的或更长的生命期限，因为这样是最安全的。


#============== 4种派发机制：

1、内联（inline）最快
2、静态派发（Static Dispatch）
3、函数表派发（Virtual Dispatch）
4、动态派发（Dynamic Dispatch）(最慢）


# Swift 的派发方式总结
<参考 readFile>

1.值类型 ： 静态派发
2.final、扩展 ：静态派发
3.引用类型：函数表派发
4.协议 ：函数表派发（单独的函数表派发）
5.dynomic + @objc ：走消息机制
dynamic 关键字可以用于修饰变量或函数，它的意思也与 Objective-C完全不同。
它告诉编译器使用动态分发而不是静态分发。
Objective-C 区别于其他语言的一个特点在于它的动态性，任何方法调用实际上都是消息分发，
而 Swift则尽可能做到静态分发。 
因此，标记为 dynamic 的变量或函数会隐式的加上 @objc 关键字，他会使用 Objective-C 的 runtime 机制。
@objc 修饰符：可以将 Swift 类型文件中的类、属性和方法等，暴露给Objective-C 类使用


静态派发：[编译器讲函数地址直接编码在汇编中]，调用的时候根据地址直接跳转到实现，
编译器可以进行内联等优化，Struct都是静态派发。

动态派发：[运行时查找函数表]，找到后再跳转到实现，动态派发仅仅多一个查表环节并不是他慢的原因，
真正的原因是它阻止了【编译器可以进行的内联等优化手段】

执行方法时,首先要查找到正确的方法,然后执行.能够在编译期确定执行方法的方式叫做静态分派static dispatch,
无法在编译期确定,只能在运行时去确定执行方法的分派方式叫做动态分派dynamic dispatch.


#如何在Swift中使用动态派发和静态派发？

动态派发（消息转发，函数表派发）
可以使用继承，重写父类的方法 -> 函数表派发
使用dynamic + @objc，方法公开给OC runtime使用 -> 消息机制
在这种类型的派发中，在运行时而不是编译时选择实现方法，会增加运行时的性能开销。
优势：具有灵活性(大多数的OOP语言都支持动态派发，因为它允许多态)

[静态派发:]
final 关键字
static 关键字
优势：和动态派发相比，非常快。编译器可以在编译器定位到函数的位置。因此函数被调用时，编译器能通过函数的内存地址，直接找到它的函数实现。极大的提高了性能，可以达到类型inline的编译期优化


[函数表派发：]

函数表派发是编译型语言实现动态行为最常见的实现方式. 函数表使用了一个数组来存储类声明的每一个函数的指针. 大部分语言把这个称为 "virtual table"(虚函数表), Swift 里称为 "witness table". 每一个类都会维护一个函数表, 里面记录着类所有的函数, 如果父类函数被 override 的话, 表里面只会保存被 override 之后的函数. 一个子类新添加的函数, 都会被插入到这个数组的最后. 运行时会根据这一个表去决定实际要被调用的函数.


#如何在Swift中使用动态派发和静态派发？

1、要实现动态派发，可以使用继承，重写父类的方法。另外我们可以使用dynamic关键字，并且需要在方法或类前面加上关键字@objc，以便方法公开给OC runtime使用

2、要实现静态派发，我们可以使用final和static关键字，保证不会被覆写


# ============== 什么是RunLoop

#RunLoop的数据结构
NSRunLoop(Foundation)是CFRunLoop(CoreFoundation)的封装，提供了面向对象的API
 RunLoop 相关的主要涉及五个类：

CFRunLoop：RunLoop对象
 CFRunLoopMode：运行模式
 CFRunLoopSource：输入源/事件源
 CFRunLoopTimer：定时源
 CFRunLoopObserver：观察者


#什么是RunLoop
RunLoop是通过内部维护的事件循环来对事件/消息进行管理的一个对象。

RunLoop的字面意思是运行循环，是在程序在运行过程中保持循环做一些事情，也就是保持程序的持续运行。
每条线程都有唯一的一个与之对应的runloop对象，主线程的Runloop已经自己创建好，子线程的runloop需要主动创建。
RunLoop在第一次获取时创建，在线程结束时销毁。
主线程的runloop是默认开启的，iOS应用程序里面，
程序启动后会调用main函数，main函数会调用UIApplicationMain（）函数，
这个方法的主线程会设置一个runloop对象。



App启动的时候会在主Runloop里面注册两个观察者和一个回调函数，
第一个Observe观察到entry即将进入loop的时候，
会调用_objc_autoreleasePoolPush（）创建自动释放池，
优先级最高，保证在所有回调方法之前。

第二个Observe观察到即将进入休眠或者退出的时候，
当监听到Beforewaiting的时候，调用_objc_autoreleasePoolPop() 和 _objc_autoreleasePoolPush() 
释放旧的创建新的，当监听到Exit的时候调用_objc_autoreleasePoolPop释放pool，
这里的Observe优先级最低，发生在所有回调函数之后。


当UI改变（ Frame变化、 UIView/CALayer 的继承结构变化等）时，或手动调用了 UIView/CALayer 的 setNeedsLayout/setNeedsDisplay方法后，这个 UIView/CALayer 就被标记为待处理。

苹果注册了一个用来监听BeforeWaiting和Exit的Observer，
在它的[回调函数里会遍历所有待处理的] UIView/CAlayer 以执行实际的绘制和调整，并更新 UI 界面

#RunLoop的主要作用
保持程序的持续运行；
处理App中的各种事件（比如：触摸事件、定时器事件、Selector事件）
节省CPU资源，提高程序性能：该做事时做事，该休息时休息

#RunLoop的运行逻辑

总结：Runloop是iOS中用于事件接收和分发的机制，‌它通过一个循环不断调度工作并处理输入事件。‌Runloop可以看作是一种循环，‌通过这种循环使得应用程序能够持续运行，‌并允许线程随时处理事件。‌在不需要进行事件处理时，‌Runloop可以使线程进入休眠状态，‌从而节省CPU资源，‌提高程序性能。‌
Runloop的运行逻辑大致如下

1、首先根据modeName查找对应的运行mode -> 判断mode里面有没有source/timer/observer(有）->
2、通知observers: RunLoop即将进入Loop，（此处会创建自动释放池) ->

大体主流程：
3、通知 RunLoop即将触发 Timer 回调；
4、通知 RunLoop即将触发 Source0 （非port）回调；
5、RunLoop 触发 Source0 (非port) 回调；
6、如果有 Source1 (基于port) 处于 ready 状态，直接处理这个 Source1 然后跳转去处理消息。-->跳转处理消息AAA（唤醒之后）；
7、通知 Observers: RunLoop 的线程即将进入休眠(sleep)；
8、调用 [mach_msg] 等待接受 [mach_port] 的消息。线程将进入休眠, 直到被下面某一个事件唤醒；
（一个基于 port 的Source 的事件、一个 Timer 到时间了、RunLoop 自身的超时时间到了、被其他什么调用者手动唤醒）
9、通知 Observers: RunLoop 的线程刚刚被唤醒了；

收到消息，处理消息AAA。
10、判断接收的消息
如果一个 Timer 到时间了，触发这个Timer的回调；
如果有dispatch到main_queue的block，执行block；
如果一个 Source1 (基于port) 发出事件了，处理这个事件；

11、判断是否结束处理；
超出传入参数标记的超时时间了、被外部调用者强制停止了、source/timer/observer一个都没有了

12、通知 Observers: RunLoop 即将退出（释放自动释放池）




int CFRunLoopRunSpecific(runloop, modeName, seconds, stopAfterHandle) {

/// 首先根据modeName找到对应mode
    CFRunLoopModeRef currentMode = __CFRunLoopFindMode(runloop, modeName, false);
/// 如果mode里没有source/timer/observer, 直接返回。
    if (__CFRunLoopModeIsEmpty(currentMode)) return;
    
///1. 通知 Observers: RunLoop 即将进入 loop。
（此处有Observer会创建AutoreleasePool: _objc_autoreleasePoolPush();）

///2. 通知 Observers: RunLoop 即将触发 Timer 回调。
///3. 通知 Observers: RunLoop 即将触发 Source0 (非port) 回调。
/// 执行被加入的block
/// 4. RunLoop 触发 Source0 (非port) 回调。
/// 执行被加入的block
/// 5. 如果有 Source1 (基于port) 处于 ready 状态，直接处理这个 Source1 然后跳转去处理消息。-->跳转处理消息AAA（唤醒之后）
/// 6.通知 Observers: RunLoop 的线程即将进入休眠(sleep)。
/// 7. 调用 mach_msg 等待接受 mach_port 的消息。线程将进入休眠, 直到被下面某一个事件唤醒。
            /// • 一个基于 port 的Source 的事件。  ---
            /// • 一个 Timer 到时间了
            /// • RunLoop 自身的超时时间到了
            /// • 被其他什么调用者手动唤醒
/// 8. 通知 Observers: RunLoop 的线程刚刚被唤醒了。
/// 收到消息，处理消息AAA。
/// 9.1 如果一个 Timer 到时间了，触发这个Timer的回调。
/// 9.2 如果有dispatch到main_queue的block，执行block。
/// 9.3 如果一个 Source1 (基于port) 发出事件了，处理这个事件
/// 执行加入到Loop的block

///判断是否结束处理
if (sourceHandledThisLoop && stopAfterHandle) {
    /// 进入loop时参数说处理完事件就返回。
    retVal = kCFRunLoopRunHandledSource;
} else if (timeout) {
    /// 超出传入参数标记的超时时间了
    retVal = kCFRunLoopRunTimedOut;
} else if (__CFRunLoopIsStopped(runloop)) {
    /// 被外部调用者强制停止了
    retVal = kCFRunLoopRunStopped;
} else if (__CFRunLoopModeIsEmpty(runloop, currentMode)) {
    /// source/timer/observer一个都没有了
    retVal = kCFRunLoopRunFinished;
}
/// 如果没超时，mode里没空，loop也没被停止，那继续loop。

///10. 通知 Observers: RunLoop 即将退出。
（此处有Observer释放AutoreleasePool: _objc_autoreleasePoolPop();）
    __CFRunLoopDoObservers(rl, currentMode, kCFRunLoopExit);
    
    
{
    /// 1. 通知Observers，即将进入RunLoop
    /// 此处有Observer会创建AutoreleasePool: _objc_autoreleasePoolPush();
    __CFRUNLOOP_IS_CALLING_OUT_TO_AN_OBSERVER_CALLBACK_FUNCTION__(kCFRunLoopEntry);
    do {
 
        /// 2. 通知 Observers: 即将触发 Timer 回调。
        __CFRUNLOOP_IS_CALLING_OUT_TO_AN_OBSERVER_CALLBACK_FUNCTION__(kCFRunLoopBeforeTimers);
        /// 3. 通知 Observers: 即将触发 Source (非基于port的,Source0) 回调。
        __CFRUNLOOP_IS_CALLING_OUT_TO_AN_OBSERVER_CALLBACK_FUNCTION__(kCFRunLoopBeforeSources);
        __CFRUNLOOP_IS_CALLING_OUT_TO_A_BLOCK__(block);
 
        /// 4. 触发 Source0 (非基于port的) 回调。
        __CFRUNLOOP_IS_CALLING_OUT_TO_A_SOURCE0_PERFORM_FUNCTION__(source0);
        __CFRUNLOOP_IS_CALLING_OUT_TO_A_BLOCK__(block);
 
        /// 6. 通知Observers，即将进入休眠
        /// 此处有Observer释放并新建AutoreleasePool: _objc_autoreleasePoolPop(); _objc_autoreleasePoolPush();
        __CFRUNLOOP_IS_CALLING_OUT_TO_AN_OBSERVER_CALLBACK_FUNCTION__(kCFRunLoopBeforeWaiting);
 
        /// 7. sleep to wait msg.
        mach_msg() -> mach_msg_trap();
        
 
        /// 8. 通知Observers，线程被唤醒
        __CFRUNLOOP_IS_CALLING_OUT_TO_AN_OBSERVER_CALLBACK_FUNCTION__(kCFRunLoopAfterWaiting);
 
        /// 9. 如果是被Timer唤醒的，回调Timer
        __CFRUNLOOP_IS_CALLING_OUT_TO_A_TIMER_CALLBACK_FUNCTION__(timer);
 
        /// 9. 如果是被dispatch唤醒的，执行所有调用 dispatch_async 等方法放入main queue 的 block
        __CFRUNLOOP_IS_SERVICING_THE_MAIN_DISPATCH_QUEUE__(dispatched_block);
 
        /// 9. 如果如果Runloop是被 Source1 (基于port的) 的事件唤醒了，处理这个事件
        __CFRUNLOOP_IS_CALLING_OUT_TO_A_SOURCE1_PERFORM_FUNCTION__(source1);
 
 
    } while (...);
 
    /// 10. 通知Observers，即将退出RunLoop
    /// 此处有Observer释放AutoreleasePool: _objc_autoreleasePoolPop();
    __CFRUNLOOP_IS_CALLING_OUT_TO_AN_OBSERVER_CALLBACK_FUNCTION__(kCFRunLoopExit);
}



#RunLoop的运用、使用
1、runloop保证线程的长久存活
2、解决NSTimer在滑动时停止工作的问题
3、滚动视图流畅性优化
4、监测iOS卡顿：Runloop 可以用来检测卡顿

在主线程中创建一个runloop的observer，子线程中观察observer的状态。
主线程的操作是在kCFRunLoopBeforeSources和kCFRunLoopBeforeWaiting之间，检测这两个状态之间的时间，如果超过某个阈值，可以判断当前可能发生了卡顿线程。

一个子线程当它的任务执行完毕之后都会销毁，所以每次执行异步任务都会频繁去创建和销毁线程，这样无疑是耗费资源的。这种情况下我们可以利用runloop来保证线程在执行完任务后不背销毁而进入“休眠”状态，等待下一个任务的执行再被唤醒。

-(void)runloopThreadTest{
    MyThread* thread = [[MyThread alloc]initWithBlock:^{
        NSLog(@"runloopThreadTest");

        //如果注释了下面这一行，子线程中的任务并不能正常执行
        [[NSRunLoop currentRunLoop] addPort:[NSMachPort port] forMode:NSRunLoopCommonModes];
        //一定要开启
        [[NSRunLoop currentRunLoop] run];
    }];
    [threadstart];
}


滚动视图流畅性优化
在我们的开发过程中经常遇到列表型上面有图片的，一般下载图片用异步，setimage则使用同步。
为imageView设置image,是在UITrackingRunLoopMode中也可以进行的，
如果图片很大，图片解压缩和渲染肯定会很耗时，那么卡顿就是必然的。
我们可以再setImage的时候手动设置runloop的mode：
[imageView performSelector:@selector(setImage:) withObject:image afterDelay:0 inModes:@[NSDefaultRunLoopMode]];

TableView延迟加载图片。把setImage放到NSDefaultRunLoopMode去做，也就是在滑动的时候并不会去调用赋值图片的方法，而是会等到滑动完毕切换到NSDefaultRunLoopMode下面才会调用。


#RunLoop与线程的关系
每条线程都有唯一一个与之对应的RunLoop对象
【RunLoop保存在一个全局的Dictionary里，线程作为key，RunLoop作为value】
线程刚创建时并没有RunLoop对象，RunLoop会在第一次获取它时创建
RunLoop会在线程结束时自动销毁
主线程的RunLoop已经默认获取并开启，子线程是 默认没有开启RunLoop

当runloop休眠的时候，是从用户态切换到了内核态，当有消息唤醒时，就从内核态再切换到用户态中

tip:GCD很多东西不依赖于Runloop，它们是分开的。但是GCD从子线程回到主线程的时候，是依赖于Runloop的

#RunLoop与NSTimer的关系
NSTimer创建之后，需要添加到Runloop中才会工作，RunLoop的主线程默认是默认的模式，而子线程的RunLoop是默认没有开启的。

修改运行模式，可修改成如下
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(run) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:UITrackingRunLoopMode];

如果定时器添加到主线程中，则不需要开始runloop，定时器就可以工作，但是如果，直接添加到子线程中，需要手动开启



#滑动TableVIew的时候我们的定时器还会生效吗？有什么方案吗？

不生效，TableVIew正常情况下运行在kCFRunLoopDefaultMode模式下，
当TableVIew进行滑动的时候会发生mode的切换会切换到UITrackingRunLoopMode上，
NSTimer默认情况下是添加到当前RunLoopDefaultMode上，定时器就不会生效了，

CFRunLoopAddTimer(runloop，timer，commonMode)

可以通过CFRunLoopAddTimer把我们当前RunLoop添加到commonMode中，
达到同步Source/Timer/Observer到多个mode效果，此时定时器就可以生效了



#RunLoop的线程保活（常驻线程）
runLoop与线程是一一对应的关系，如果线程结束，而且RunLoop没有任何的sources0、source1、timer、observer，
那么RunLoop会马上退出；如果想让RunLoop不要立马退出，那么就需要添加事件源，RunLoop本身提供了添加事件源的接口

为当前线程开启一个RunLoop。
 —— [NSRunLoop currentRunLoop] 或者CFRunLoopSourceCreate创建

向该RunLoop中添加一个Port/Source等维持RunLoop的事件循环。 
—— addPort 或者 addSource添加事件源并且设置mode(mode需一致)
启动RunLoop。—— run 或者CFRunLoopRunInMode(mode需一致) 
如果想移除就在合适时机调用RunLoopRemoveSource移除


NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
// 往RunLoop里面添加Source\Timer\Observer，Port相关的是Source1事件
// 添加了一个Source1，但是这个Source1也没啥事，所以线程在这里就休眠了，不会往下走，----end----一直不会打印
[runLoop addPort:[NSMachPort port] forMode:NSRunLoopCommonModes];
[runLoop run];



#事件循环(Event Loop)是什么？
没有消息需要处理时，休眠以避免资源占用。        用户态——内核态        当前线程休眠
有消息需要处理时，立刻被唤醒。        内核态——用户态        当前线程唤醒



#main函数为什么能一直保持运行的状态而不退出？
在main函数当中调用UIApplicationMain函数内部会启动主线程的RunLoop，而RunLoop是对事件循环维护的一种机制，
可以做到在有事做的时候去做事，没有事情做的时候会通过用户态到内核态的切换，避免资源占用，当前线程处于休眠状态。


#我们的程序从点击图标到启动到最终程序被杀死系统是怎样实现的
在RunLoop启动之后，会发送一个通知来告知观察者当前RunLoop即将启动，
之后RunLoop会将要处理Timer/source0事件发送通知，在进入Source0的处理，
如果有Source1要处理就去处理唤醒时收到的消息，
如果没有Source1要处理，此时线程将要休眠发送通知，
然后我们就要发生关于用户态到内核态的切换，线程正式进入休眠等待唤醒。
线程可以通过Source1来进行当前RunLoop的唤醒，
或者Timer事件的回调，
或者外部手动唤醒，线程刚被唤醒之后发送通知，通知观察者当前线程被唤醒了，处理唤醒时收到的消息，之后又会回到将要处理Timer/Source0事件。顺次向下执行即可。

在main函数当中调用UIApplicationMain函数内部会启动主线程的RunLoop，
经过一系列的处理，我们的主线程处于休眠状态，如果此时我们点击一个屏幕会产生一个mach port，
会转成source1把我们的主线程唤醒处理，
当我们把程序杀死会发生RunLoop的即将退出的通知，RunLoop退出之后，线程也就销毁了。

UIApplicationMain函数一直没有返回，而是不断地接收处理消息以及等待休眠，所以运行程序之后会保持持续运行状态


#Runloop在实际开发中的应用

1. 控制线程生命周期（线程保活）
如果需要经常在子程序执行任务，可能希望一个线程可以重复使用，避免每次都要创建、销毁带来不必要的开销

2. 解决NSTimer在滑动时停止工作的问题

3. 监控应用卡顿
（检测 FPS 变化幅度是一种方案 普通）
我们知道程序中的任务都是在线程中执行，
而线程依赖于 RunLoop，并且RunLoop总是在相应的状态下执行任务，执行完成以后会切换到下一个状态，
如果在一个状态下[执行时间]过长导致无法进入下一个状态就可以认为发生了卡顿，
所以可以根据主线程 RunLoop 的状态变化检测任务执行时间是否太长。
至于多长时间算作卡顿可以依据自己的需要来设置，一般情况下可以设置1秒钟作为阀值。


4. 性能优化


案例：tableView的Cell中有多个ImageView，同时加载大图，导致UI卡顿。
解决思路：使用Runloop每次循环址添加一张图片。
工具：这里我们需要使用到CFRunloop
实现过程：

1、把加载图片等代码保存起来，先不执行 （保存一段代码，block）
2、监听Runloop循环（CFRunloopObserver）
3、每次都从任务数组中取出一个加载图片等代码执行（执行block代码）


# Runtime 都干了什么？

就是尽可能地把决定从编译器推迟到运行期, 就是尽可能地做到动态. 只是在运行的时候才会去确定对象的类型和方法的. 因此利用Runtime机制可以在程序运行时动态地修改类和对象中的所有属性和方法

程序运行时动态地修改类和对象中的所有属性和方法，就是用来在程序运行是改变类的属性和行为的

动态添加类和方法：Runtime 允许在运行时动态添加新的类、方法和实例变量，从而实现动态性和灵活性。

消息传递和消息转发：Runtime 机制允许在运行时动态发送消息给对象，并且可以通过消息转发机制处理未实现的方法调用。

分类添加属性 关联对象：Runtime 允许给现有的类动态关联新的属性，这在某些情况下可以避免子类化。

获取类信息：Runtime 提供了一系列函数来获取类的信息，包括类名、父类、实例变量、方法列表等。

方法交换：Runtime 允许在运行时交换两个方法的实现，这在某些情况下可以用来实现方法的替换或调试。
如：字体适配、button防止重复点击（btn分类设置
@property (nonatomic, assign) NSTimeInterval timerInterval;
@property (nonatomic, assign) BOOL isOk;

字典转模型
思路：利用运行时，遍历模型中所有属性，根据模型的属性名，去字典中查找key，取出对应的值，给模型的属性赋值。


#输出下边代码的执行顺序 RunLoop异步线程

 NSLog(@"1");

dispatch_async(dispatch_get_global_queue(0, 0), ^{

    NSLog(@"2");

    [self performSelector:@selector(test) withObject:nil afterDelay:10];

    NSLog(@"3");
});

NSLog(@"4");

- (void)test {
    NSLog(@"5");
}
答案是1423，test方法并不会执行。
原因是如果是带afterDelay的延时函数，会在内部创建一个 NSTimer，然后添加到当前线程的RunLoop中。
也就是如果当前线程[没有开启RunLoop]，该方法会失效。
 
那么我们改成:

dispatch_async(dispatch_get_global_queue(0, 0), ^{

        NSLog(@"2");

        [[NSRunLoop currentRunLoop] run];

        [self performSelector:@selector(test) withObject:nil afterDelay:10];

        NSLog(@"3");
    });
然而test方法依然不执行。
原因是如果RunLoop的mode中一个item都没有，RunLoop会退出。
即在调用RunLoop的run方法后，由于其[mode中没有添加任何item]去维持RunLoop的时间循环，RunLoop随即还是会退出。
[所以我们自己启动RunLoop，一定要在添加item后]

//这个才是对的
dispatch_async(dispatch_get_global_queue(0, 0), ^{

        NSLog(@"2");
        [self performSelector:@selector(test) withObject:nil afterDelay:10];
        [[NSRunLoop currentRunLoop] run];

        NSLog(@"3");
});


#子线程中调用connection方法，为什么不回调？因为没有加入runloop，执行完任务就销毁了，所以没有回调。

在iOS或macOS开发中，网络请求一般使用NSURLConnection或NSURLSession等API来实现。
当在子线程中调用NSURLConnection的方法时，如果不加入runloop，可能会导致请求没有回调的问题。

这是因为NSURLConnection和NSURLSession都是基于runloop来工作的，它们会在runloop中注册回调事件，等待网络请求的响应。
如果在子线程中调用这些API而没有加入runloop，那么请求会在子线程中立即执行完毕，而没有等待网络请求的响应，导致没有回调。

解决这个问题的方法是将子线程的runloop启动起来，使得NSURLConnection或NSURLSession能够在其中注册回调事件并等待网络请求的响应。
可以通过调用NSRunLoop的实例方法run来启动runloop，示例代码如下：

- (void)startRequestInThread {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://example.com"]];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    
    // 加入runloop
    [connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
    // 启动runloop
    [[NSRunLoop currentRunLoop] run];
}
其中，scheduleInRunLoop:forMode:方法将NSURLConnection对象加入到当前子线程的runloop中，run方法启动runloop并等待事件的发生，包括网络请求的响应。



# ============== 什么是自动释放池


OC中的一种内存自动回收机制，
它可以延迟加入AutoreleasePool中的变量release的时机当创建一个对象，
在正常情况下，变量会在超出其作用域时立即 release，
如果将其加入到自动释放池中，这个对象并不会立即释放，
而会等到 runloop 休眠 / 超出autoreleasepool作用域之后进行释放

从程序启动到加载完成，主线程对应的 Runloop 会处于休眠状态，等待用户交互来唤醒 Runloop
用户每次交互都会启动一次 Runloop ，用于处理用户的所有点击、触摸等事件
Runloop 在监听到交互事件后，就会创建自动释放池，并将所有延迟释放的对象添加到自动释放池中
在一次完整的 Runloop 结束之前，会向自动释放池中所有对象发送 release 消息，然后销毁自动释放池


原理
1.自动释放池的本质是__AtAutoreleasePool结构体，包含构造函数和析构函数
2.结构体声明，触发构造函数，调用objc_autoreleasePoolPush函数，本质是对象压栈的push方法
3.当结构体出作用域空间，触发析构函数，调用objc_autoreleasePoolPop函数，本质是对象出栈的pop方法



#Autorelease Pool的底层实现和相关事项总结


autorelease pool是为引用计数机制服务的，我们创建的所有需要autorelease的对象，都要在一个pool中进行

1主线程在每一个runloop的circle开始时都会自动创建一个pool，然后在结束时自动调用[pool drain]。
所以我们在主线程中如果没有特殊需求不需要手动创建autorelease pool。有特殊需求的情况见3。


2在子线程中，如果我们调用了诸如
“NSString *str = [NSString stringWithFormat:@"%@",xxx]这类的方法，
就需要自动释放池，这时我们必须手动创建autorelease pool，否则会导致leak。
但是如果我们只用[[MyClass alloc] init]方法来创建对象，
因为它们出了作用域就会被自动销毁，则不需要我们手动创建池子了。


3另一个被广泛讨论的场景就是
在主线程（子线程中如果我们开启了runloop，当然也一样）的一个循环中短时间创建大量对象，
如果我们不想等到当前runloop的circle结束时才释放这些对象（这时内存可能已经暴涨很多了），
就可以在循环体中手动创建一个pool，使得每次循环结束时都将本次循环中产生的临时变量及时释放掉。


autoreleasepool的嵌套使用：
在嵌套使用的时候，添加好各自堆栈的哨兵对象，
出栈时，先释放内部，在释放外部。


#Swift中的Autorelease Pool
wift 1.0时还有各种对应OC中遍历构造器的创建对象的方法，比如“String.stringWithFormat”。而从Swift 1.1开始这类方法都被废弃了，我们基本都只能使用init方法来创建对象，这种情况下就不需要autorelease pool了





#什么是AutoreleasePoolPage？

1.@autorelease展开来其实就是objc_autoreleasePoolPush和objc_autoreleasePoolPop，
但是这两个函数也是封装的一个底层对象AutoreleasePoolPage，
实际对应的是[AutoreleasePoolPage::push]和[AutoreleasePoolPage::pop]

2.autoreleasepool本身并没有内部结构，而是一种通过AutoreleasePoolPage为节点的双向链表结构

3.根据AutoreleasePoolPage双向链表的结构，
可以看到当调用objc_autoreleasePoolPush的时候实际上除了初始化poolpage对象属性之外，
还会插入一个POOL_SENTINEL哨兵，
用来区分不同autoreleasepool之间包裹的对象。

4.当对象调用 autorelease 方法时，会将实际对象插入 AutoreleasePoolPage 的栈中，通过next指针移动。

5.autoreleasePoolPage的结构字段上面有介绍，
其中每个双向链表的node节点也就是poolpage对象内存大小为4096，
除了基础属性之外，外插一个POOL_SENTINEL，
每出现一个@autorelease就会有一个哨兵，
剩下的通过begin和end来标识是否存储满，满了就会重新创建一个poolpage来链接链表，
按照这个套路，出现一个PoolPush就创建一个哨兵，出现一个对象的autorelease，
就增加一个实际的对象，满了就创建新的链表节点这样衍生下去

6.AutoreleasePoolPage::pop那么当调用pop的时候，
会传入需要drain的哨兵节点，遍历该内存地址上方所有对象，直到遇到对应的哨兵，
然后释放栈中遍历到的对象，每删除一页就修正双向链表的指针，最后两张图很容易理解


#是所有的对象都会被加入到自动释放池中嘛？
1. 使用alloc、new、copy、mutableCopy前缀开头的方法进行对象创建，不会加入到自动释放池；
它们的空间开辟由开发者申请，释放也由开发者进行管理
2.还有一些由TaggerPoint管理的小对象也不会加入到自动释放池中


#自动释放池和runloop的关系
runloop会自动开启autorelease
1.主程序在事件循环的每个循环开始时在主线程上创建一个自动释放池
2.并在结束时将其排空，从而释放在处理事件时生成的任何自动释放对象

#============== weak底层原理

weak 关键字的作用是弱引用，所引用对象的计数器不会加1，并在引用对象被释放的时候自动被设置为 nil。
weak的原理在于Runtime底层维护了一张weak_table_t结构的hash表，key是所指对象的地址，value是weak指针的地址数组。
对象释放时，调用clearDeallocating函数根【对象地址】获取所有weak指针地址的数组，
然后遍历这个数组把其中的数据设为nil，最后把这个entry从weak表中删除，最后清理对象的记录。

当weak指针的数量小于等于4时，是数组， 超过时，会变成hash表)。

weak_table_t是一个全局weak 引用的表



[weak 的实现原理可以概括以下三步]：

初始化时：runtime会调用[objc_initWeak]函数，初始化一个新的weak指针指向对象的地址。
添加引用时：objc_initWeak函数会调用 [objc_storeWeak()] 函数， objc_storeWeak() 的作用是更新指针指向，创建对应的弱引用表。
释放时，调用[clearDeallocating]函数。clearDeallocating函数首先根据对象地址获取所有weak指针地址的数组，
然后遍历这个数组把其中的数据设为nil，最后把这个entry从weak表中删除，清理对象的记录。



[objc_initWeak 函数]

初始化开始时，会调用 objc_initWeak 函数，初始化新的 weak 指针指向对象的地址。
当我们初始化 weak 变量时，runtime 会调用 NSObject.m 中的 objc_initWeak，
而 objc_initWeak 函数里面的实现如下：

id objc_initWeak(id *location, id newObj) {
// 查看对象实例是否有效,无效对象直接导致指针释放
    if (!newObj) {
        *location = nil;
        return nil;
    }
    // 这里传递了三个 Bool 数值
    // 使用 template 进行常量参数传递是为了优化性能
    return storeWeakfalse/*old*/, true/*new*/, true/*crash*/>
    (location, (objc_object*)newObj);
}


[storeWeak 函数]
该方法的实现：

storeWeak方法实际上是接收了3个参数，分别是haveOld、haveNew和crashIfDeallocating ，这三个参数都是以模板的方式传入的，是三个bool类型的参数。 分别表示weak指针之前是否指向了一个弱引用，weak指针是否需要指向一个新的引用，若果被弱引用的对象正在析构，此时再弱引用该对象是否应该crash。
该方法维护了[oldTable] 和[newTable]分别表示旧的引用弱表和新的弱引用表，它们都是[SideTable的hash表]。
如果weak指针之前指向了一个弱引用，则会调用[weak_unregister_no_lock] 方法
将旧的weak指针地址移除（前提是weak指针会指向一个新的对象）。
如果weak指针需要指向一个新的引用，则会调用[weak_register_no_lock] 方法
将新的weak指针地址添加到弱引用表中。
调用setWeaklyReferenced_nolock 方法修改weak新引用的对象的bit标志位（优化版isa指针的标记是否被弱引用的成员变量）

[dealloc 函数]
当对象的引用计数为0时，底层会调用_objc_rootDealloc方法对对象进行释放，
而在_objc_rootDealloc方法里面会调用rootDealloc方法

#weak修饰的释放则自动被置为nil的实现原理

Runtime维护着一个Weak表，用于存储指向某个对象的所有Weak指针
Weak表是Hash表，Key是所指对象的地址，Value是Weak指针地址的数组
在对象被回收的时候，经过层层调用，会最终触发arr_clear_deallocating 函数，
clearDeallocating函数首先根据对象地址获取所有weak指针地址的数组，然后遍历这个数组把其中的数据设为nil
weak指针的使用涉及到Hash表的增删改查，有一定的性能开销.


#weak释放为nil过程
1、调用objc_release
2、因为对象的引用计数为0，所以执行dealloc
3、在dealloc中，调用了_objc_rootDealloc函数
4、在_objc_rootDealloc中，调用了object_dispose函数
5、调用objc_destructInstance
6、最后调用objc_clear_deallocating。

对象准备释放时，调用clearDeallocating函数。
clearDeallocating函数首先根据对象地址获取所有weak指针地址的数组，
然后遍历这个数组把其中的数据设为nil，最后把这个entry从weak表中删除，最后清理对象的记录。

[objc_clear_deallocating该函数的动作如下：]
1、从weak表中获取废弃对象的地址为键值的记录
2、将包含在记录中的所有附有 weak修饰符变量的地址，赋值为nil
3、将weak表中该记录删除
4、从引用计数表中删除废弃对象的地址为键值的记录


#怎么实现类似Weak的功能：
通过关联对象assManager关系对象指针与weak,处理当对象引用计数为0时，设置weak为nil;


#请简单说明并比较以下关键词：strong, weak, assign, copy

strong 表示指向并拥有该对象。其修饰的对象引用计数会增加1。该对象只要引用计数不为 0 则不会被销毁。当然强行将其设为 nil 可以销毁它。
weak表示指向但不拥有该对象。其修饰的对象引用计数不会增加。无需手动设置，该对象会自行在内存中销毁。
assign 主要用于修饰基本数据类型，如 NSInteger 和 CGFloat，这些数值主要存在于栈上。

weak 一般用来修饰对象，assign 一般用来修饰基本数据类型。
原因是assign修饰的对象被释放后，指针的地址依然存在，造成野指针，在堆上容易造成崩溃。
而栈上的内存系统会自动处理，不会造成野指针。

copy 与 strong 类似。
不同之处是 strong 的复制是多个指针指向同一个地址，
而 copy 的复制每次会在内存中拷贝一份对象，指针指向不同地址。
copy 一般用在修饰有可变对应类型的不可变对象上，如 NSString ,NSArray , NSDictionary 。


#请说明并比较以下关键词：__weak，__block

__weak与weak基本相同。前者用于修饰变量（variable），后者用于修饰属性（property）。__weak 主要用于防止block中的循环引用。
__block也用于修饰变量。它是引用修饰，所以其修饰的值是动态变化的，即可以被重新赋值的。__block用于修饰某些block内部将要修改的外部变量。
__weak和__block的使用场景几乎与block息息相关。而所谓block，就是Objective-C对于闭包的实现。闭包就是没有名字的函数，或者理解为指向函数的指针。



#autorelease对快速大量创建对象时

for循环中大量创建对象时，使用 autorelease 可以有效控制内存的快速增长（虽然不添加autorelease也会调用delloc销毁对象，但是这样的释放没有创建快，内存虽然最后也会降下来，但是如果加autorelease 可以减少内存峰值）
for (int i = 0; i<100000000; i++) {
    @autoreleasepool {
        NSLog(@"%d",i);
        __autoreleasing LZPerson *p =[LZPerson new];
    }
}


#=============OC中的Block
Block是OC中一种比较特殊的对象，和其他OC对象一样使用，只是比较特殊。
Block用来封装一段函数/代码块和函数的调用环境，等到需要的时候再去调用。
封装：Block内部会把Block的参数，返回值，执行体封装成一个函数，并且存储该函数的内存地址。
调用环境：Block内部会捕获变量，并且存储这些捕获的变量。

Block本质是一个C++结构体
isa指针，指向Block所属的类。证明Block本质上是一个OC对象。
__block_impl impl的内存地址就是__main_block_impl_0的内存首地址。
*FuncPtr指针，指向该 Block的执行函数。
__main_block_desc_0保存了Block描述信息。
还有Block的构造函数。
还有Block捕获的变量（这里暂未展示）。


#Block的类型

通过调用class方法查看其类型以及继承链发现：block有三种类型。
(__NSGlobalBlock__ : __NSGlobalBlock : NSBlock : NSObject)
(__NSStackBlock__ : __NSStackBlock : NSBlock : NSObject)
(__NSMallocBlock__ : __NSMallocBlock : NSBlock : NSObject)


1、如果创建了一个block，但是没有访问auto变量，block是[__NSGlobalBlock__]类型：
void (^block1)(void) = ^ {
};


2、如果创建了一个block，访问了auto变量，block是[__NSStackBlock__]类型：
int age = 10;
void (^block2)(void) = ^{
    NSLog(@"age = %d",age);
};

3、需要在MRC环境下验证，在ARC环境下，编译器可能会将栈上的block复制到堆上

4、如果一个__NSStackBlock__类型block，调用了copy方法，block变成[__NSMallocBlock__]类型：
int age = 10;
void (^block3)(void) = [^{
    NSLog(@"age = %d",age);
} copy];



#为什么Block要调用copy把栈Block复制到堆区呢？

Block刚被创建出来时候，若不是GlobalBlock就是StackBlock，栈内存是系统自动管理，超过作用域就会释放。
如果不把栈Block复制到堆区，很有可能调用栈Block的时候它已经被销毁，就会导致数据错乱。


#在ARC环境下，编译器会根据情况自动将栈上的block复制到堆上比如以下情况

1、block作为函数返回值时。
2、将block赋值给__strong指针时。
3、block作为Cocoa API中方法名含有usingBlock的方法参数时。
4、block作为GCD API的方法参数时。
5、block访问了auto变量。

ARC下block属性的建议写法：
@property (copy, nonatomic) void (^block)(void);
@property (strong, nonatomic) void (^block)(void);


#Swift 中如何通过闭包捕获和管理上下文环境？
闭包在Swift中是可以捕获和存储其所在上下文中任何常量和变量的引用的自包含函数块。这个特性让闭包能够在它被定义的环境外操作那些常量和变量。

1、 当定义一个闭包时，它自动捕获周围的上下文环境中的常量和变量，使得即使原始环境不存在，闭包也可以使用这些捕获的值。

2、 为了管理捕获的引用并避免循环引用（尤其是当闭包和实例相互引用时），可以使用捕获列表。
捕获列表可以定义捕获的引用是强引用、弱引用还是无主引用，以适应不同的场景。

3、 使用闭包捕获上下文环境非常适合执行异步操作，如网络请求回调，因为它们可以保持必要的状态直到异步操作完成。

通过理解和正确使用闭包捕获的概念，开发者可以编写出既强大又安全的异步代码。


#Swift闭包，尾随闭包，逃逸闭包
尾随闭包：当闭包是函数的最后一个参数并且闭包体简只有一行时，可以省略return关键字和大括号，将闭包写在函数的尾部；
逃逸闭包：@escaping将一个闭包作为参数传递给一个函数，而且这个闭包需要在函数执行完毕后才执行，那么这个闭包就被称为“逃逸闭包”。

#Block的捕获

block对局部变量基本数据类型的捕获，是在创建时捕获了值，并保存副本在自己的结构体中，修改也是修改副本，不会影响到原本的值
如果希望block内部修改的值是原本的值，或者希望block捕获的值后面还会变化，需要对原本的变量添加[__block]修饰符。
- (MyBlock)createBlock {
    int number = 10;
    MyBlock block = ^{
        NSLog(@"Captured value: %d", number);//10
    };
    number = 20;
    
    __block int number = 10;
    MyBlock block = ^{
        NSLog(@"Captured value: %d", number); //20
    };
    number = 20;
    
    return block;
}

#Swift block

闭包对变量进行捕获，是将变量复制到了堆上，之后不论是闭包内，还是闭包外，操作的值，都是堆上的这个值，闭包对这个值强持有。

捕获值的本质是将变量存储到堆上。

        var i = 0
        let closure = {
            print("\(i)")//1
            i += 1
        }
        i += 1
        print("\(i)")//1
        closure()
        print("\(i)")//2
        

就像block那样，没有__block修饰符的int？
使用捕获列表 [] in

        var i1 = 0
        let closure1 = { [i1] in
            print("\(i1)")//0
            //i1 += 1 //不捕获了
        }
        i1 += 1
        closure1()
        i1 += 1
        closure1()
        print("\(i1)")//2
        //0 0 2
        
        
#Block捕获的外部变量可以改变值的是静态变量，静态全局变量，全局变量，(局部变量 需要block)
全局变量和静态全局变量的值改变，以及它们被Block捕获进去，因为是全局的，作用域很广
静态变量和自动变量，被Block从外面捕获进来，成为__main_block_impl_0这个结构体的成员变量
自动变量是以值传递方式传递到Block的构造函数里面去的。Block只捕获Block中会用到的变量。由于只捕获了自动变量的值，并非内存地址，所以Block内部不能改变自动变量的

静态变量传递给Block是内存地址值，所以能在Block里面直接改变值。
block可以修改全局变量，是因为全局变量放在推区，局部变量在栈区，所以不能修改，
加上__block之后，相当于加了个标识位，遇到__block就把内存由栈区放在推区。

##====================


#浅拷贝和深拷贝的区别？
浅拷贝只是对 内存地址的复制，两个指针指向同一个地址，增加被拷贝对象的引用计数，没有发生新的内存分配。
深拷贝：目标对象指针和源对象指针，指向两片内容相同的内存空间。



#NSMutableArray用copy修饰会出现什么问题?
[出现调用可变方法不可控问题，会导致程序崩溃]。
给Mutable 被声明为copy修饰的属性赋值， 过程描述如下：

如果赋值过来的是NSMutableArray对象,[会对可变对象进行copy操作,拷贝结果是不可变的,那么copy后就是NSArray]
如果赋值过来的是NSArray对象, 会对不可变对象进行copy操作,拷贝结果仍是不可变的,那么copy之后仍是NSArray。
所以不论赋值过来的是什么对象,只要对NSMutableArray进行copy操作,返回的对象都是不可变的。
那原来属性声明的是NSMutableArray,可能会调用了add或者remove方法，
拷贝后的结果是不可变对象,所以一旦调用这些方法就会程序崩溃(crash)



#如何理解的atomic的线程安全呢，有没有什么隐患？
保证setter和getter存取方法的线程安全（仅仅对setter和getter方法加锁）。
atomic对一个数组，进行赋值或获取，是可以保证线程安全的。
但是如果进行数组进行操作，比如给数据加对象或移除对象，是不在atomic的保证范围。



#Swift 中的协议和继承有什么区别？
协议和继承在Swift中都用于定义一个类型应有的行为，但它们的使用场景和方式有明显区别：

1、 协议定义了一个蓝图，规定了遵循协议的类型必须实现的方法和属性，但不提供这些方法和属性的具体实现。协议可以被枚举、结构体和类遵循。

2、 继承允许一个类继承另一个类的特性，如方法和属性。子类可以重写父类中的方法和属性来提供特定的实现。继承仅限于类之间的关系。

协议支持多重继承，即一个类型可以遵循多个协议，而继承则是单一继承，一个类只能继承自另一个类。协议适用于定义一组应该被不同类型实现的接口，而继承更多的是为了代码的复用和扩展已有的类行为。


#===============
#NSOperation与GCD区别

1、[GCD的核心是C语言写的系统服务，执行和操作简单高效]，因此NSOperation底层也通过GCD实现，
换个说法就是NSOperation是对GCD更高层次的抽象，这是他们之间最本质的区别。因此如果希望自定义任务，建议使用NSOperation

2、[依赖关系]，NSOperation可以设置两个NSOperation之间的依赖，第二个任务依赖于第一个任务完成执行，
GCD无法设置依赖关系，不过可以通过dispatch_barrier_async来实现这种效果；

3、[KVO(键值对观察)]，NSOperation和容易判断Operation当前的状态(是否执行，是否取消)，对此GCD无法通过KVO进行判断；
优先级，NSOperation可以设置自身的优先级，但是优先级高的不一定先执行，GCD只能设置队列的优先级，无法在执行的block设置优先级；

4、[继承]，NSOperation是一个抽象类，实际开发中常用的两个类是NSInvocationOperation和NSBlockOperation，
同样我们可以自定义NSOperation，GCD执行任务可以自由组装，没有继承那么高的代码复用度；

5、[效率]，直接使用GCD效率确实会更高效，
NSOperation会多一点开销，但是通过NSOperation可以获得依赖，优先级，继承，键值对观察这些优势，相对于多的那么一点开销确实很划算；



#GCD 的两个核心

任务：执行什么操作
队列：用来存放任务

GCD 会自动将队列中的任务取出，放到对应的线程中执行；
任务的取出遵循队列的 FIFO 原则：先进先出，后进后出；

GCD 中，要执行队列中的任务时，会自动开启一个线程，当任务执行完，[线程不会立刻销毁]，而是放到了线程池中。
如果接下来还要执行任务的话就从线程池中取出线程，这样节省了创建线程所需要的时间。
但如果一段时间内没有执行任务的话，该线程就会被销毁，再执行任务就会创建新的线程。


#GCD 队列类型

串行队列（[DISPATCH_QUEUE_SERIAL]）
以 FIFO 顺序处理传入的任务，即让任务一个接着一个执行。
并发队列（[DISPATCH_QUEUE_CONCURRENT]）
可以让多个任务并发（同时）执行（自动开启多个线程执行任务）；
并发功能只有在异步函数dispatch_async下才有效；
尽管任务同时执行，但是您可以使用 barrier 栅栏函数在队列中创建同步点（关于栅栏函数后面会讲到）。
主队列（dispatch_queue_main_t）
主队列是一种特殊的串行队列，它特殊在与主线程关联，主队列的任务都在主线程上执行，主队列在程序一开始就被系统创建并与主线程关联。


全局并发队列与手动创建的并发队列的区别：
手动创建的并发队列可以设置唯一标识，可以跟踪错误，而全局并发队列没有；


#死锁的四大条件

死锁形成的原因：

系统资源不足
进程（线程）推进的顺序不恰当；
资源分配不当
死锁形成的条件：

互斥条件：所谓互斥就是进程在某一时间内独占资源。
请求与保持条件：一个进程因请求资源而阻塞时，对已获得的资源保持不放。
不剥夺条件：进程已获得资源，在末使用完之前，不能强行剥夺。
循环等待条件：若干进程之间形成一种头尾相接的循环等待资源关系。


主线程里面同步死锁
新串行队列里异步里面放同步，死锁
新串行队列里面，同步里面放同步，死锁
主线程执行异步里面循环，死锁。

NSLog(@"1");
    dispatch_async(dispatch_get_main_queue(), ^{
        while (1) {
            NSLog(@"2");
        }
    });

    dispatch_async(dispatch_get_main_queue(), ^{
        while (1) {
            NSLog(@"3");
        }
    });
    NSLog(@"4");

只输出1和4 和2。 输出的2在主线程里面一直循环，死锁了。


@autoreleasepool {
        dispatch_sync(dispatch_get_main_queue(), ^(void){
            NSLog(@"这里死锁了");
        });
    }
在主队列([主队列也是一个串行队列])中同步添加block任务,
导致主线程等待dispatch_sync函数执行完后处理block,
而block等待主线程执行dispatch_sync函数结束,
函数结束又需要block执行结束,导致相互等待,产生死锁.




用同步的方法编程，往往是要求保证任务之间的执行顺序是完全确定的。
NSLog(@"这个也不会死锁0");
dispatch_queue_t queue = dispatch_queue_create("serial", nil);
dispatch_sync(queue, ^(void){
    NSLog(@"这个也不会死锁1");
});
NSLog(@"这个也不会死锁2");
输出：0、1、2


且不说GCD提供了很多强大的功能来满足这个需求，向串行队列中同步的添加任务本身就是不合理的，毕竟队列已经是串行的了，直接异步添加就可以了啊。所以，解决文章开头那个死锁例子的最简单的方法就是在合适的位置添加一个字母a。

异步 dispatch_async,或者 使用不相同的串行队列.


/*
 队列的特点：FIFO (First In First Out) 先进先出
 以下将 block（任务2）提交到主队列，主队列将来要取出这个任务放到主线程执行。
 而主队列此时已经有任务，就是执行（viewDidLoad方法），
 所以主队列要想取出 block（任务2），就要等上一个任务（viewDidLoad方法）先执行完，才能取出该任务执行。
 而 dispatch_sync 函数必须执行完 block（任务2）才会返回，才能往下执行代码。
 所以（任务2）要等待（viewDidLoad方法）执行完，（viewDidLoad方法）要等待（任务2）执行完。互相等待，就产生了死锁。
 */
- (void)viewDidLoad {
    [super viewDidLoad];

    NSLog(@"执行任务1");

    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_sync(queue, ^{
        NSLog(@"执行任务2");
    });

    NSLog(@"执行任务3");
}
/*
 打印：
 2020-01-19 00:16:26.980630+0800 多线程[25011:5507937] 执行任务1
 (lldb) 
 */
 
 
 
 /*
 block0（任务2）和 block1（任务3）都添加到串行队列里去，
 由于队列任务先进先出，在当前子线程执行 block1 必须要先执行完 block0
 而 block0 执行完的前提是 sync 的 block1（任务3）要执行完，才能执行（任务4）
 所以产生了死锁
 */
- (void)viewDidLoad {
    [super viewDidLoad];

    NSLog(@"执行任务1");
    dispatch_queue_t queue = dispatch_queue_create("myqueue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        NSLog(@"执行任务2");
        dispatch_sync(queue, ^{
            NSLog(@"执行任务3");
        });
        NSLog(@"执行任务4");
    });
    NSLog(@"执行任务5");
}
/*
 打印：
 2020-01-19 02:55:20.608987+0800 多线程[25339:5586331] 执行任务1
 2020-01-19 02:55:20.609307+0800 多线程[25339:5586331] 执行任务5
 2020-01-19 02:55:20.609446+0800 多线程[25339:5586387] 执行任务2
 (lldb) 
 */


#dispatch_block_notify

在被观察块 block 执行完毕之后，立即将通知块 block 提交到指定队列。

    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_SERIAL);
    dispatch_block_t observation_block = dispatch_block_create(0, ^{
        NSLog(@"observation_block begin");
        [NSThread sleepForTimeInterval:1];
        NSLog(@"observation_block done");
    });
    dispatch_async(queue, observation_block);
    dispatch_block_t notification_block = dispatch_block_create(0, ^{
        NSLog(@"notification_block");
    });
    //当observation_block执行完毕后，提交notification_block到global queue中执行
    dispatch_block_notify(observation_block, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), notification_block);
/*
2020-02-01 20:04:04.340404+0800 多线程[6851:1257066] observation_block begin
2020-02-01 20:04:05.342687+0800 多线程[6851:1257066] observation_block done
2020-02-01 20:04:05.342877+0800 多线程[6851:1257060] notification_block
 */
 
 #dispatch_block_wait
 
同步等待，直到指定的 block 执行完成或指定的超时时间结束为止才返回；
设置等待时间 [DISPATCH_TIME_NOW] 会立刻返回，
设置 [DISPATCH_TIME_FOREVER] 会无限期等待指定的 block 执行完成才返回。


    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_SERIAL);
    dispatch_block_t block = dispatch_block_create(0, ^{
        NSLog(@"begin");
        [NSThread sleepForTimeInterval:1];
        NSLog(@"done");
    });
    dispatch_async(queue, block);
    //等待前面的任务执行完毕
    dispatch_block_wait(block, DISPATCH_TIME_FOREVER);
    NSLog(@"coutinue");
/*
2020-02-01 20:16:18.361881+0800 多线程[6894:1266019] begin
2020-02-01 20:16:19.363144+0800 多线程[6894:1266019] done
2020-02-01 20:16:19.363419+0800 多线程[6894:1265943] coutinue
 */
 
#dispatch_block_cancel
异步取消指定的 block，[正在执行的 block 不会被取消]。


#dispatch_group_wait
同步等待先前 dispatch_group_async 添加的 block 都执行完毕或指定的超时时间结束为止才返回。

    // 创建队列组
    dispatch_group_t group = dispatch_group_create();
    // 获取全局并发队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    // 添加异步任务：把任务添加到队列，等所有任务都执行完毕，通知队列组
    dispatch_group_async(group, queue, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"%@,执行任务1",[NSThread currentThread]);
        }
    });
    dispatch_group_async(group, queue, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"%@,执行任务2",[NSThread currentThread]);
        }
    });
    // 所有（dispatch_group_async）任务都执行完毕，获得通知（异步执行），将（dispatch_group_notify）中的 block 任务添加到指定队列 
    // 这行代码是会立刻执行的
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 但是里面的任务需要等到队列组的都执行完毕，等待通知
        for (int i = 0; i < 3; i++) {
            NSLog(@"%@,执行任务3",[NSThread currentThread]);
        }
    });
/*
<NSThread: 0x600000cbd200>{number = 4, name = (null)},执行任务1
<NSThread: 0x600000c68440>{number = 7, name = (null)},执行任务2
<NSThread: 0x600000c68440>{number = 7, name = (null)},执行任务2
<NSThread: 0x600000cbd200>{number = 4, name = (null)},执行任务1
<NSThread: 0x600000c68440>{number = 7, name = (null)},执行任务2
<NSThread: 0x600000cbd200>{number = 4, name = (null)},执行任务1
<NSThread: 0x600000cedbc0>{number = 1, name = main},执行任务3
<NSThread: 0x600000cedbc0>{number = 1, name = main},执行任务3
<NSThread: 0x600000cedbc0>{number = 1, name = main},执行任务3
 */

#队列组的原理

<void dispatch_group_enter(dispatch_group_t group);>
<void dispatch_group_leave(dispatch_group_t group);>

    dispatch_group_async(group, queue, ^{ 
    }); 
    //等价于
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        dispatch_group_leave(group);
    });


    // 1.创建队列组
    dispatch_group_t group = dispatch_group_create();
    // 2.获取全局并发队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    //ARC中不用写也不能写
//    dispatch_retain(group);
    // 3.进入队列组，执行此函数后，再添加的异步执行的block任务都会被group监听
    dispatch_group_enter(group);
    // 4.添加任务
    dispatch_async(queue, ^{
        NSLog(@"%@,执行任务1",[NSThread currentThread]);
        // 5.离开队列组
        dispatch_group_leave(group);
        //ARC中不用写也不能写
//        dispatch_release(group);
    });
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        NSLog(@"%@,执行任务2",[NSThread currentThread]);
        dispatch_group_leave(group);
    });
    // 6.获得队列组的通知
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"%@,执行任务3",[NSThread currentThread]); //[[最后执行，即使在这个方法后添加到组里的]]
    });
    // 7.等待队列组，监听的队列中的所有任务都执行完毕，才会执行后续代码，会阻塞线程（很少使用）
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER); //[[阻塞任务4，不然是第一个执行]]
    NSLog(@"%@,执行任务4",[NSThread currentThread]);
/*
<NSThread: 0x600003d98d00>{number = 3, name = (null)},执行任务1
<NSThread: 0x600003d4de80>{number = 9, name = (null)},执行任务2
<NSThread: 0x600003dcd2c0>{number = 1, name = main},<执行任务4>
<NSThread: 0x600003dcd2c0>{number = 1, name = main},<执行任务3>
 */


#dispatch_once 单例
在应用程序的生命周期内只执行一次提交的 block。

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
    });


// 普通单例，线程不安全
+ (instancetype)shareGCDTest {
    static id instance = nil;
    if (instance == nil) {
        instance = [[self alloc]init];
    }
    return instance;
}
// 加锁，线程安全
+ (instancetype)shareGCDTestLock {
    static id instance = nil;
    @synchronized (self) {
        if (instance == nil) {
            instance = [[self alloc]init];
        }
    }
    return instance;
}
// dispatch_once，线程安全，效率更高
+ (instancetype)shareGCDTestOnce {
    static id instance = nil;
    // dispatch_once
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[self alloc]init];
        }
    });
    return instance;
}


#Dispatch After 延迟执行

#Dispatch Barrier <栅栏函数>

Dispatch Barrier： 在并发调度队列中执行的任务的同步点。

 使用栅栏来同步调度队列中一个或多个任务的执行。在向并发调度队列添加栅栏时，该队列会延迟栅栏任务（以及栅栏之后提交的所有任务）的执行，直到所有先前提交的任务都执行完成为止。在完成先前的任务后，队列将自己执行栅栏任务。栅栏任务执行完毕后，队列将恢复其正常执行行为。

Dispatch Barrier 栅栏函数：

同步栅栏函数
dispatch_barrier_sync：提交一个栅栏 block 以同步执行，并等待该 block 执行完；
dispatch_barrier_sync_f：提交一个栅栏 function 以同步执行，并等待该 function 执行完。
异步栅栏函数
dispatch_barrier_async：提交一个栅栏 block 以异步执行，并直接返回；
dispatch_barrier_async_f：提交一个栅栏 function 以异步执行，并直接返回。

<现有任务1、2、3、4，前两个任务执行完毕，再执行后两个任务以及主线程的代码。>

    dispatch_queue_t queue = dispatch_queue_create("myqueue", DISPATCH_QUEUE_CONCURRENT);
    /* 1.异步函数 */
    dispatch_async(queue, ^{
        for (NSUInteger i = 0; i < 3; i++) {
            NSLog(@"执行任务1-%zd-%@",i,[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (NSUInteger i = 0; i < 3; i++) {
            NSLog(@"执行任务2-%zd-%@",i,[NSThread currentThread]);
        }
    });
    /* 2. 同步栅栏函数 */
    dispatch_barrier_sync(queue, ^{
        NSLog(@"------------------dispatch_barrier_sync-%@",[NSThread currentThread]);
    });
    NSLog(@"任务1、2执行完毕");
    /* 3. 异步函数 */
    dispatch_async(queue, ^{
        for (NSUInteger i = 0; i < 3; i++) {
            NSLog(@"执行任务3-%zd-%@",i,[NSThread currentThread]);
        }
    });
    NSLog(@"正在执行任务3、4");
    dispatch_async(queue, ^{
        for (NSUInteger i = 0; i < 3; i++) {
            NSLog(@"执行任务4-%zd-%@",i,[NSThread currentThread]);
        }
    });
/*
执行任务1-0-<NSThread: 0x600003ffa780>{number = 5, name = (null)}
执行任务2-0-<NSThread: 0x600003fefa00>{number = 3, name = (null)}
执行任务2-1-<NSThread: 0x600003fefa00>{number = 3, name = (null)}
执行任务1-1-<NSThread: 0x600003ffa780>{number = 5, name = (null)}
执行任务2-2-<NSThread: 0x600003fefa00>{number = 3, name = (null)}
执行任务1-2-<NSThread: 0x600003ffa780>{number = 5, name = (null)}
------------------dispatch_barrier_sync-<NSThread: 0x600003fa5b80>{number = 1, name = main}
<任务1、2执行完毕>
<正在执行任务3、4>
执行任务3-0-<NSThread: 0x600003ffa780>{number = 5, name = (null)}
执行任务4-0-<NSThread: 0x600003fefa00>{number = 3, name = (null)}
执行任务3-1-<NSThread: 0x600003ffa780>{number = 5, name = (null)}
执行任务4-1-<NSThread: 0x600003fefa00>{number = 3, name = (null)}
执行任务3-2-<NSThread: 0x600003ffa780>{number = 5, name = (null)}
执行任务4-2-<NSThread: 0x600003fefa00>{number = 3, name = (null)}
 */




改为[异步栅栏函数]，任务3、4仍然可以等到任务1、2以及栅栏任务都执行完毕再执行，但[不会阻塞主线程]，并且栅栏任务是在[子线程执行]。

    dispatch_queue_t queue = dispatch_queue_create("myqueue", DISPATCH_QUEUE_CONCURRENT);
    /* 1.异步函数 */
    dispatch_async(queue, ^{
        for (NSUInteger i = 0; i < 3; i++) {
            NSLog(@"执行任务1-%zd-%@",i,[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (NSUInteger i = 0; i < 3; i++) {
            NSLog(@"执行任务2-%zd-%@",i,[NSThread currentThread]);
        }
    });
    /* 2. 异步栅栏函数 */
    dispatch_barrier_async(queue, ^{
        NSLog(@"------------------dispatch_barrier_async-%@",[NSThread currentThread]);
    });
    NSLog(@"任务1、2执行完毕");
    /* 3. 异步函数 */
    dispatch_async(queue, ^{
        for (NSUInteger i = 0; i < 3; i++) {
            NSLog(@"执行任务3-%zd-%@",i,[NSThread currentThread]);
        }
    });
    NSLog(@"正在执行任务3、4");
    dispatch_async(queue, ^{
        for (NSUInteger i = 0; i < 3; i++) {
            NSLog(@"执行任务4-%zd-%@",i,[NSThread currentThread]);
        }
    });
/*
<任务1、2执行完毕>
执行任务2-0-<NSThread: 0x6000020f3100>{number = 4, name = (null)}
<正在执行任务3、4>
执行任务1-0-<NSThread: 0x6000020c6a00>{number = 6, name = (null)}
执行任务2-1-<NSThread: 0x6000020f3100>{number = 4, name = (null)}
执行任务1-1-<NSThread: 0x6000020c6a00>{number = 6, name = (null)}
执行任务2-2-<NSThread: 0x6000020f3100>{number = 4, name = (null)}
执行任务1-2-<NSThread: 0x6000020c6a00>{number = 6, name = (null)}
------------------dispatch_barrier_async-<NSThread: 0x6000020c6a00>{number = 6, name = (null)}
执行任务4-0-<NSThread: 0x6000020d2e00>{number = 7, name = (null)}
执行任务3-0-<NSThread: 0x6000020c6a00>{number = 6, name = (null)}
执行任务4-1-<NSThread: 0x6000020d2e00>{number = 7, name = (null)}
执行任务3-1-<NSThread: 0x6000020c6a00>{number = 6, name = (null)}
执行任务4-2-<NSThread: 0x6000020d2e00>{number = 7, name = (null)}
执行任务3-2-<NSThread: 0x6000020c6a00>{number = 6, name = (null)}
 */
 
 
 
 
 
#保证线程安全
例如： 我们要从网络上异步获取很多图片，然后将它们添加到非线程安全的对象——数组中去：异步并发。

   同一时间点，可能有多个线程执行给数组添加对象的方法，所以可能会丢掉 1 到多次，我们执行 1000 次，可能数组就保存了 990 多个，还有程序出现奔溃的可能。

解决办法：

① 加锁：比较耗时，而且下载完什么时候添加进数组也不一定。我们希望所有图片都下载完，再往数组里面添加；
② 使用 GCD 队列组；
③ 使用dispatch_barrier_async函数，栅栏中的任务会等待队列中的所有任务执行完成，才会执行栅栏中的任务，保证了线程安全。


    dispatch_queue_t queue = dispatch_queue_create("myqueue", DISPATCH_QUEUE_CONCURRENT);
    for (int i = 0; i < 5; i++) {
        dispatch_async(queue, ^{
            //下载图片
            NSLog(@"图片下载完成%d,%@",i,[NSThread currentThread]);
            dispatch_barrier_async(queue, ^{
                //将图片添加进数组
                NSLog(@"添加图片%d,%@",i,[NSThread currentThread]);
            });
        });
    }
/*
图片下载完成2,<NSThread: 0x600000348d80>{number = 5, name = (null)}
图片下载完成0,<NSThread: 0x600000341f40>{number = 4, name = (null)}
图片下载完成1,<NSThread: 0x60000036f480>{number = 6, name = (null)}
图片下载完成3,<NSThread: 0x60000039ce80>{number = 7, name = (null)}
图片下载完成4,<NSThread: 0x600000348d80>{number = 5, name = (null)}
添加图片2,<NSThread: 0x600000348d80>{number = 5, name = (null)}
添加图片0,<NSThread: 0x600000348d80>{number = 5, name = (null)}
添加图片1,<NSThread: 0x600000348d80>{number = 5, name = (null)}
添加图片3,<NSThread: 0x600000348d80>{number = 5, name = (null)}
添加图片4,<NSThread: 0x600000348d80>{number = 5, name = (null)}
*/


#实现读写安全
dispatch_barrier_async可以用来实现“读写安全”。
我们将“写”操作放在dispatch_barrier_async中，
这样能确保在“写”操作的时候会等待前面的“读”操作完成，
而后续的“读”操作也会等到“写”操作完成后才能继续执行，提高文件读写的执行效率。

    // 创建一个并发队列
    dispatch_queue_t queue = dispatch_queue_create("myqueue", DISPATCH_QUEUE_CONCURRENT);
    // 读：执行“读”操作
    dispatch_async(queue, ^{
        
    });
    // 写：执行“写”操作
    dispatch_barrier_async(queue, ^{
        
    });


- (void)viewDidLoad {
    [super viewDidLoad];
    self.queue = dispatch_queue_create("myqueue", DISPATCH_QUEUE_CONCURRENT);
    for (int i = 0; i < 3; i++) {
        [test read];
        [test read];
        <[test write];>
        [test read];
    }
}

- (void)read {
    dispatch_async(self.queue, ^{
        sleep(1);
        NSLog(@"read,%@",[NSThread currentThread]);
    });
}

- (void)write {
    dispatch_barrier_async(self.queue, ^{
        sleep(1);
        NSLog(@"write,%@",[NSThread currentThread]);
    });
}

/*
2020-01-20 01:45:09.847878+0800 多线程[27767:6103230] read,<NSThread: 0x600002d42ac0>{number = 7, name = (null)}
2020-01-20 01:45:09.847849+0800 多线程[27767:6096149] read,<NSThread: 0x600002d8ed80>{number = 4, name = (null)}
2020-01-20 01:45:10.849965+0800 多线程[27767:6096149] write,<NSThread: 0x600002d8ed80>{number = 4, name = (null)}
2020-01-20 01:45:11.851259+0800 多线程[27767:6103230] read,<NSThread: 0x600002d42ac0>{number = 7, name = (null)}
2020-01-20 01:45:11.851265+0800 多线程[27767:6103231] read,<NSThread: 0x600002d42640>{number = 8, name = (null)}
2020-01-20 01:45:11.851277+0800 多线程[27767:6096149] read,<NSThread: 0x600002d8ed80>{number = 4, name = (null)}
2020-01-20 01:45:12.854305+0800 多线程[27767:6103231] write,<NSThread: 0x600002d42640>{number = 8, name = (null)}
2020-01-20 01:45:13.859167+0800 多线程[27767:6103231] read,<NSThread: 0x600002d42640>{number = 8, name = (null)}
2020-01-20 01:45:13.859167+0800 多线程[27767:6103230] read,<NSThread: 0x600002d42ac0>{number = 7, name = (null)}
2020-01-20 01:45:13.859167+0800 多线程[27767:6096149] read,<NSThread: 0x600002d8ed80>{number = 4, name = (null)}
2020-01-20 01:45:14.864153+0800 多线程[27767:6103231] write,<NSThread: 0x600002d42640>{number = 8, name = (null)}
2020-01-20 01:45:15.869272+0800 多线程[27767:6096149] read,<NSThread: 0x600002d8ed80>{number = 4, name = (null)}
 */


不同点：

dispatch_barrier_sync：提交一个栅栏 block 以同步执行，并等待该 block 执行完；由于是同步，不会开启新的子线程，会阻塞当前线程。
dispatch_barrier_async：提交一个栅栏 block 以异步执行，并直接返回，会继续往下执行代码，不会阻塞当前线程。
注意点：

dispatch_barrier_(a)sync函数传入的的队列必须是自己<手动创建的并发队列>，
如果传入的是全局并发队列或者串行队列，那么这个函数是<没有栅栏>的效果的，效果等同于dispatch_(a)sync函数。
只能栅栏dispatch_barrier_(a)sync函数中传入的queue。


#Dispatch Semaphore 信号量

dispatch_semaphore可以用来控制最大并发数量，可以用来实现 iOS 的线程同步方案。
信号量的初始值，可以用来控制线程并发访问的最大数量；
信号量的初始值为1，代表同时只允许 1 条线程访问资源，保证线程同步。

    //信号量的初始值
    int value = 1;
    //创建信号量
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(value);
    //如果信号量的值<=0,当前线程就会进入休眠等待（直到信号量的值>0）
    //如果信号量的值>0,就-1，然后继续往下执行代码
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    //让信号量的值+1
    dispatch_semaphore_signal(semaphore);
    
#以下打印的 a 的值为多少？

    __block int a = 0;
    while (a < 10) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            a++;
        });
    }
    NSLog(@"%d",a);
    
/* 打印3次的结果
2020-01-29 02:35:42.070283+0800 多线程[49119:9919097] 12
2020-01-29 02:35:51.528086+0800 多线程[49119:9919097] 10
2020-01-29 02:35:52.285512+0800 多线程[49119:9919097] 15
 */
解析：[会发生资源抢夺]。当执行while第一次判断a的值时a=0，条件成立，开启一条线程异步执行任务a++。
由于异步不用等待当前语句执行完毕，就可以执行下一条语句，


#如何让 a 最终的值为10？

    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    __block int a = 0;
    while (a < 10) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            a++;
            NSLog(@"a=%d,%@",a,[NSThread currentThread]);
            dispatch_semaphore_signal(semaphore);
        });
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    }
    NSLog(@"%d",a);


#如何取消GCD任务

iOS8之后可以调用dispatch_block_cancel来取消
需要注意必须用<dispatch_block_create>创建dispatch_block_t，
dispatch_block_cancel也只能取消<尚未执行>的任务，对正在执行的任务不起作用



#NSOperation 是如何终止/取消任务的

正在执行的任务，NSOperation 也是不能取消的。



#多线程，异步执行（async）一个 performSelector 会执行么？如果加上 afterDelay 呢

performSelector会执行，加上 afterDelay [不会执行]；
原因 performSelector 只是单纯的直接调用某函数，afterDelay 是在该子线程执行一个 NSTimer，
注意一点：子线程中的 runloop 默认是没有启动的状态，要想 afterDelay 生效，
要 runloop 在线程有事务的状态下跑起来，所以需要执行 [[NSRunLoop currentRunLoop] run]。

    dispatch_async(dispatch_get_global_queue(0, 0), ^{

            NSLog(@"2");
            [self performSelector:@selector(testCC) withObject:nil afterDelay:3];
            [[NSRunLoop currentRunLoop] run];
            NSLog(@"---1====3");
    });
    2
    ---====44444
    ---1====3



#==================
#扩展（Extension）

#问：一般用扩展做什么？

声明私有属性
声明私有方法
声明私有成员变量

#扩展的特点：

编译时决议
只以声明的形式存在，多数情况下存在于宿主类的.m文件中
不能为系统类添加扩展



#Category加载过程 [分类->原类->父类]

1.通过Runtime加载某个类的所有Category数据

2.把所有Category的[方法、属性、协议数据]，合并到一个大数组中。后面参与编译的Category数据，[会在数组的前面]

3.将合并后的分类数据（方法、属性、协议），插入到类原来数据的前面


OC特有的分类Category，依赖于类。它可以在不改变原来的类内容的基础上，为类增加一些方法。分类的使用注意：

（1）分类只能增加方法，不能增加成员变量；

（2）在分类方法的实现中可以访问原来类中的成员变量；

（3）分类中可以重新实现原来类中的方法，但是会覆盖掉原来的方法，导致原来的方法无法再使用；

（4）方法调用的优先级：[分类->原类->父类]，若包含有多个分类，则最后参与编译的分类优先；


#Category 添加属性的底层实现

Category编译之后的底层结构是struct category_t
里面存储着分类的对象方法、类方法、属性、协议信息。
当程序编译时会将Category中的这些信息存放到这个结构体中。



在程序运行的时候，runtime会将Category的数据，合并到类信息中（类对象、元类对象中）。底层实现步骤如下
0. 通过Runtime加载某个类的所有Category数据；
0. 把所有Category的方法、属性、协议数据，合并到一个大数组中，后面参与编译的Category数据，会在数组的前面。
0. 将合并后的Category分类数据（方法、属性、协议），插入到存放类(类对象、元类对象)原来数据的数组前面。
0. 由于Category分类的数据（方法、属性、协议）在类数据数组的最前面，所以当调用原类、Category(分类)中同名的方法时，会优先调用Category(分类)中的方法，从而实现覆盖了类原本的方法。

Category实际上允许添加属性的，同样可以使用@property，
[但是不会生成_变量（带下划线的成员变量），也不会生成添加属性的getter和setter方法]，
所以，尽管添加了属性，也无法使用点语法调用getter和setter方法

添加的属性系统并没有自动生成成员变量，也没有实现set和get方法，只是生成了set和get方法的声明。
这就是为什么在分类中扩展了属性，在外部并没有办法调用。
在外部调用点语法设值和取值，本质其实就是调用属性的set和get方法，现在系统并没有实现这两个方法

AssociationsManager
AssociationsHashMap
ObjectAssociationMap
ObjcAssociation

objc_setAssociatedObject
objc_getAssociatedObject

• 关联对象并不是存储在关联对象本身内存中
• 关联对象存储在全局的一个AssociationsManager中
• 设置关联对象为nil,就相当于移除了关联对象



runtime函数中，确实有一个[class_addIvar()]函数用于给类添加成员变量
这个函数只能在[“构建一个类的过程中”]调用。一旦完成类定义，就不能再添加成员变量了。
经过编译的类在程序启动后就runtime加载，没有机会调用addIvar

#关联对象是线程安全的么？
是线程安全的
因为关联对象的值是储存在一个全局的AssociationsManager中的AssociationsHashMap hashMap表中，set和get都是以对象的地址为key计算出下标值取出对应的ObjectAssociationMap，再以void * 为key去ObjectAssociationMap这张hashMap表中取出ObjcAssociation，再取出_value。


#关联对象怎么释放，对象释放时怎么释放关联对象？
移除单个的关联对象只需传入nil会抹除ObjectAssociationMap中对应的ObjcAssociation：

  objc_setAssociatedObject(self, @selector(name), nil, OBJC_ASSOCIATION_COPY_NONATOMIC);


#问：能否为分类添加成员变量？

不能

#由问题 category能否添加成员变量，如果可以，如何给category添加成员变量？

答案：不可以直接给category添加成员变量，但是可以通过[关联对象]实现添加成员变量的效果



id objc_getAssociatedObject(id _Nonnull object, const void * _Nonnull key)

void objc_setAssociatedObject(id _Nonnull object, const void * _Nonnull key, id _Nullable value, objc_AssociationPolicy policy)

void objc_removeAssociatedObjects(id _Nonnull object)


关联对象并不是存储在被关联对象本身内存中
关联对象存储在全局的统一的一个[AssociationsManager]中
设置关联对象为nil，就相当于是移除关联对象 // 类(分类).属性 = nil



首先objc_setAssociatedObject会创建一个AssociationsManager；
AssociationsManager里面维护了一个AssociationsHashMap 哈希表的单例键值对映射，

由AssociationsHashMap来存储所有的关联对象(这相当于把所有对象的关联对象都存在一个全局map里面),
这个 map的的key是传进来的这个对象的指针地址（任意两个不同对象的指针地址一定是不同的），
而这个map的value对应ObjectAssociationMap。
ObjectAssociationMap里面维护了从 key 到ObjcAssociation的映射，即关联记录，
其中key就是关联对象里面自己定义的key值，value对应ObjcAssociation



#=======================
#load方法（一次）
+load方法是根据[方法地址直接调用]，并不是经过objc_msgSend函数调用

调用时机
+load方法会在runtime加载类、分类时调用
每个类、分类的+load，在程序运行时只[调用一次]

调用顺序:[【父类】-【子类】-【分类】]

[先调用父类的+load]
按照编译先后顺序调用（先编译，先调用）
调用子类的+load之前会先调用父类的+load

[再调用分类的+load]
按照编译先后顺序调用（先编译，先调用）



#initialize方法(可多次)

+initialize方法会在类第一次接收到消息时调用，+initialize是通过[objc_msgSend]进行调用的

调用顺序:[【父类】-【子类】
先调用父类的+initialize，再调用子类的+initialize
先初始化父类，再初始化子类，每个类只会初始化1次([父类可以触发多次])

注：如果有分类的情况，分类的+initialize方法会[覆盖掉]类的+initialize方法


#+load、initialize方法的区别
+initialize和+load的很大区别是，+initialize是通过objc_msgSend进行调用的，所以有以下特点

如果[子类没有实现+initialize]，会调用父类的+initialize（所以父类的+initialize可能会被调用多次）
如果分类实现了+initialize，就覆盖类本身的+initialize调用







#通知 NSNotication
接收通知的线程和发送通知的线程一致

NSNotificationCenter定义了[两个Table]，同时为了封装观察者信息，也定义了Observation保存观察者信息。
他们的结构体可以简化如下所示：

typedef struct NCTbl {
   Observation   *wildcard;  // 保存既没有没有传入通知名字也没有传入object的通知
   MapTable       nameless;  // 保存没有传入通知名字的通知
   MapTable       named;     // 保存传入了通知名字的通知
} NCTable;
typedef struct Obs {
   id        observer;       // 保存接受消息的对象
   SEL       selector;       // 保存注册通知时传入的SEL
   struct Obs    *next;      // 保存注册了同一个通知的下一个观察者
   struct NCTbl  *link;      // 保存改Observation的Table
} Observation;
</pre>
在NSNotificationCenter内部一共保存了两张表，
一张用于保存添加观察者的时候传入的NotificationName的情况；
一张用于保存添加观察者的时候没有传入NotificationCenter的情况


在Named Table中，NotificationName作为表的key，
因为我们在注册观察者的时候是可以传入一个object参数用于只监听该对象发出的通知，并且一个通知可以添加多个观察者，所以还需要一张表用来保存object和observe的对应关系。这张表的key、value分别是以object为key，observe为value。所以对于Named Table，最终的结构为：

首先外层有一个Table，以通知名称为key。其value同样是一个Table。
为了实现可以传入一个参数object用于只监听指定该对象发出的通知，及一个通知可以添加多个观察者。
则内Table以传入的object为key，用链表来保存所有的观察者，并且以这个链表为value。


特别说明：在实际开发中，我们经常将object参数传nil，这个时候系统会根据nil自动产生一个key。
相当于这个key对应的value（链表）保存的就是对于当前NotificationName没有传入object的所有观察者。当NotificationName被发送时，在链表中的观察者都会收到通知。



UNamed Table结构比Named Table简单得多。
因为没有NotificationName作为key。这里直接就以object为key，比Named Table少了一层Table嵌套


#NSNotificationCenter 添加观察者的流程

首先在初始化NSNotificationCenter时会创建一个对象，这个对象里面保存了Named Table、UNamed Table和其他信息。

首先会根据传入的参数，实例化一个[Observation]。
该Observation对象保存了观察者对象、接收到通知观察者对所执行的方法，
由于[Observation是一个链表，还保存了下一个Observation的地址]。
根据是否传入通知的Name，选择在Named Table还是UNamed Table进行操作。
如果传入通知的name，则会先去用name去查找是否已经有对应的value（注意这个时候返回的value是一个Table）
如果没有对应的value，则创建一个新的Table，然后将这个Table以name为key添加到Named Table。如果有value，那直接去取出这个Table。
得到了保存Observation的Table之后，就通过传入的object拿对应的链表。如果object为空，会默认有一个key表示传入object为空的情况，取的时候也会直接用这个key去取，表示任何地方发送通知都会监听。
如果保存Observation的Table中根据object作为key没有找到对应的链表时，则会创建一个节点，作为头结点插入进去；如果找到了则直接在链表末尾插入之前实例化好的Observation中。
在没有传入NotificationName的情况和上面的过程类似，只不过是直接根据object去对应的链表而已。如果既没有传入NotificationName，也没有传入object，则这个观察者会添加到wildcard链表中。




#NSNotificationCenter 发送通知的流程

发送通知一般是调用postNotificationName:object:userInfo:方法来实现。该方法内部会实例化一个NSNotification来保存传入的各种参数，包括name、object和userinfo。
  发送通知的流程总体来说就是根据NotificationName查找到对应的Observer链表，然后遍历整个链表，给每个Observer结点中保存的对象及SEL，来向对象发送消息。具体流程如下：

首先会定义一个数组ObserversArray来保存需要通知的Observer。之前在添加观察者的时候把既没有传入NotificationName，也没有传入object的，保存在了wildcard。因为这样观察者会监听所有NotificationName的通知，所以先把wildcard链表遍历一遍，将其中的Observer加到数组ObserversArray中。
找到以object为key的Observer链表。这个过程分为：在Named Table中查找，以及在UNamed Table中查找。然后将遍历找到的链表，同样加入到最开始创建的数组ObserversArray中。
至此，所有关于NotificationName的Observer（wildcard + UNamed Table + Named Table）已经加入到了数组ObserversArray中。接下来就是遍历这个ObserversArray数组，一次取出其中的Observer结点。因为这个结点保存了观察者对象以及selector。所以最终调用形式如下：
[observerNode->observer performSelector: o->selector withObject: notification];
这个方式也就能说明，发送通知的线程和接收通知的线程都是同一个线程。



在多线程应用程序中，[通知总是在发出通知的线程中传递]，而该线程不一定是观察者观察者的那个线程。


#KVO “键值监听”
KVO是Key-value observing的缩写
KVO是Objective-C对观察者设计模式的一种实现
Apple使用了isa混写（isa-swizzling）来实现KVO
俗称“键值监听” ，用来监听某个属性值的改变


# KVO机制的实现原理

当一个对象被观察时，系统会动态地生成一个派生类，并将被观察对象的isa指针指向该派生类。
这个派生类重写了被观察对象的setter方法，在setter方法中，除了进行属性值的赋值操作，还会通知观察者对象属性值的变化

# KVO的本质
利用RuntimeAPI动态生成一个子类，并且让instance对象的isa指向这个全新的子类[NSKVONotifying_ClassName]
当修改instance对象的属性时，会调用Foundation的[_NSSetXXXValueAndNotify]函数


# KVO实现过程总结

在addObserver:forKeyPath:options:context:context调用的时候，会自动生成并注册一个该对象（被观察的对象）对应类的子类，取名NSKVONotify_Class,并且将该对象的isa指针指向这个新的类。
并且在该类的初始化方法中，调用了一个叫做_NSSetObjectValueAndNotify()的函数，用于实现属性改变的通知。

a) 首先会调用 willChangeValueForKey

b) 然后给属性赋值

c) 最后调用 didChangeValueForKey

d) 最后调用 observer 的 observeValueForKeyPath 去告诉监听器属性值发生了改变 .




手动触发KVO

碰过这样一道面试题：使用下划线直接访问成员变量的方式给变量赋值，会不会触发KVO监听？
答案是：不会。因为KVO重写的是set方法（setAge:）。直接给成员变量赋值不会走set方法，因此也不会触发KVO监听

然后又会问，那能不能手动触发KVO监听？

[self willChangeValueForKey:@"name"];
[self didChangeValueForKey:@"name"];




#问：通过kvc设置value，kvo能否生效？

可以
KVC改变属性值，会进入属性值的setter方法，从而触发KVO

#问：通过成员变量直接赋值value，kvo能否生效？

不可以
但，可以通过手动修改setter方法，触发KVO

[self willChangeValueForKey:@"name"];
[super setName:name];
[self didChangeValueForKey:@"name"];

使用setter方法改变值，KVO会生效
使用setValue:forKey:改变值，KVO会生效
[成员变量]直接修改需[手动添加]某些代码，KVO才会生效





#KVC 俗称“键值编码”
KVC是Key-value coding的缩写。
俗称“键值编码”，可以通过一个key来访问某个属性


1、在执行setValue:forKey:的时候
2、按照setKey、_setKey:顺序查找方法
3、找到方法就传递参数，调用方法
4、没找到方法，会看一下 accessInstanceVariablesDirectly方法的 return（默认return YES）
5、如果 accessInstanceVariablesDirectly方法的 return NO，就会走setValue:forUndefinedKey:，并抛出异常NSUnknownKeyException
6、否则的话
此时会按照_key、_isKey、key、isKey的顺序查找成员变量，找到了就直接赋值




1、在执行valueForKey:的时候
2、按照getKey、key、isKey、_key顺序查找方法
3、找到方法就传递参数，调用方法
4、没找到方法，会看一下 accessInstanceVariablesDirectly方法的 return（默认return YES）
5、如果 accessInstanceVariablesDirectly方法的 return NO，就会走setValue:forUndefinedKey:，并抛出异常NSUnknownKeyException
6、否则的话
此时会按照_key、_isKey、key、isKey的顺序查找成员变量，找到了就直接赋值



问：KVC是否有违面向对象思想

KVC只要知道某个对象的私有变量名称key，可以在外部将其value进行修改，也就是有违面向对象思想的。






#问：如果valueForKey:没有找到对应的value，会怎样？

如果valueForKey:没有找到对应的value，会调用valueForUndefinedKey:
从而造成崩溃

YZPerson *person1 = [[YZPerson alloc] init];
NSLog(@"person1.age = %@", [person1 valueForKey:@"age"]);

#哪些情况下使用 kvo 会崩溃，怎么防护崩溃？
removeObserver 一个未注册的keyPath，导致错误：Cannot remove an observer
A for the key path "str", because it is not registered as an observer. 17)ETS
法：根据实际情况，增加一个添加keyPath的标记，在dealloc中根据这个标记，
删除观察者。
•添加的观察者已经销毁，但是并未移除这个观察者，当下次这个观察的keyPath发
生变化时，kvo中的观察者的引用变成了野指针，导致crash。解决办法：在观察
者即将销毁的时候，先移除这个观察者。


#如何手动关闭 KVO？
1. 重写被观察对象的 automaticallyNotifiesObserversForkey 方法，返回 NO
2. 重写 automaticallyNotifiesObserversOf ，返回NO。
注意：关闭 kvo 后，需要手动在赋值前后添加 willChangeValueForkey 和
didChangeValueForkey ，才可以收到观察通知。

#================




#Runtime-消息机制-objc_msgSend() [消息发送]、[动态方法解析]、[消息转发]

消息机制-objc_msgSend的执行流程，分为[消息发送]、[动态方法解析]、[消息转发]三个阶段，

消息发送
先cache

Class-方法缓存(cache_t)
Class内部结构中有个方法缓存（cache_t），用散列表（哈希表）来缓存曾经调用过的方法，可以提高方法的查找速度。（使用空间换时间的方式来提升速度）

如果是在class_rw_t中查找方法：

1、已经排序的，二分查找
2、没有排序的，遍历查找
如果消息接收者的类和所有父类中都没有找到方法实现。则进入动态方法解析阶段。



2.1 forwardInvocation:自定义逻辑

在[动态方法解析]阶段，+resolveClassMethod:、resolveInstancMethod 方法是可以给消息接受者[动态增加]一个`方法实现

在[消息转发]阶段，forwardingTargetForSelector:方法是可以重新返回一个[消息接受者]，相当于是让另一个人来处理这个方法。

但是，来到[方法签名][methodSignatureForSelector:]方法后，可以使用[方法签名]自定义更复杂的业务




#Method Swizzling-坑点总结

1、子类方法和父类方法替换导致父类调用异常

首先创建一个demo。自定义一个类Animal和继承自Animal的子类Dog。父类有个实例方法parentInstanceMethod，子类有个方法childInstanceMethod，对这两个方法进行替换



当运行的时候子类Dog调用parentInstanceMethod没有崩溃，父类Animal调用parentInstanceMethod崩溃了，为什么?

代码解析：
首先因为Dog继承了Animal，所以相当于说Dog两个方法childInstanceMethod和parentInstanceMethod都有，
但是Animal没有方法childInstanceMethod，所以在方法替换的时候，
子类方法指向了父类方法parentInstanceMethod的实现，
父类方法parentInstanceMethod指向了子类方法childInstanceMethod的实现，
因此父类在调用parentInstanceMethod方法时，实际调用的是子类方法childInstanceMethod的实现，
而此时子类中通过childInstanceMethod调用原先的父类方法，
根据消息发送流程，实际上是向父类发送childInstanceMethod消息，
但是父类方法列表中并没有childInstanceMethod方法，
而在消息发送流程中，方法寻找过程是由子类向父类移动的，
而方法childInstanceMethod存在于子类，所以就出现崩溃。那这个方法怎么解决呢？

解决方法：方法交换前先尝试为当前类添加要被替换的方法


如果父类和子类都没没有实现parentInstanceMethod方法会有什么问题呢？

要替换的两个方法都判空，没有的话就先添加一个


上述描述如下：

#坑点1：多次进行方法交换，会将方法替换为原来的实现
解决方法：利用单利进行限制，只进行一次方法交换

// 解决坑点1
+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [RuntimeTool wsk_methodSwizzlingWithClass:self oriSEL:@selector(wsk_oriFunction) swizzledSEL:@selector(wsk_swiMethodFunction)];
    });
}


#坑点2：交换的旧方法，子类未实现，父类实现
出现的问题：父类在调用旧方法时，会崩溃
解决方法：先进行方法添加，如果添加成功则进行替换<repleace>，反之，则进行交换<exchange>

#坑点3：进行交换的方法，子类、父类均未实现
出现的问题：出现死循环
解决方法：如果旧方法为nil，则替换后将swizzeldSEL复制一个不做任何操作的空实现。

代码如下：

#import "RuntimeTool.h"
#import <objc/runtime.h>

@implementation RuntimeTool
+ (void)wsk_methodSwizzlingWithClass:(Class)cls oriSEL:(SEL)oriSEL swizzledSEL:(SEL)swizzledSEL{
    if (!cls) NSLog(@"传入的交换类不能为空");
    
    Method oriMethod = class_getInstanceMethod(cls, oriSEL);
    Method swiMethod = class_getInstanceMethod(cls, swizzledSEL);
    
    // 解决坑点3
    if (!oriMethod) {
        // 在oriMethod为nil时，替换后将swizzledSEL复制一个不做任何事的空实现,代码如下:
        class_addMethod(cls, oriSEL, method_getImplementation(swiMethod), method_getTypeEncoding(swiMethod));
        method_setImplementation(swiMethod, imp_implementationWithBlock(^(id self, SEL _cmd){ }));
    }
    
    // 一般交换方法: 交换自己有的方法 -- 走下面 因为自己有意味添加方法失败
    // 交换自己没有实现的方法:
    //   首先第一步:会先尝试给自己添加要交换的方法 :personInstanceMethod (SEL) -> swiMethod(IMP)
    //   然后再将父类的IMP给swizzle  personInstanceMethod(imp) -> swizzledSEL
    //oriSEL:personInstanceMethod
    // 解决坑点2
    BOOL didAddMethod = class_addMethod(cls, oriSEL, method_getImplementation(swiMethod), method_getTypeEncoding(swiMethod));
    if (didAddMethod) {
        class_replaceMethod(cls, swizzledSEL, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
    }else{
        method_exchangeImplementations(oriMethod, swiMethod);
    }
}
@end




#iOS中对unrecognized selector的防御


整理下思路：

1、创建一个接收未知消息的类，暂且称之为 Protector
2、创建一个 NSObject 的分类
3、在分类中重写** forwardingTargetForSelector: **，在这个方法中截获未实现的方法，转发给 Protector。并为 Protector 动态的添加未实现的方法，最后返回 Protector 的实例对象。
在分类中新增一个安全的方法实现，来作为 Protector 接收到的未知消息的实现
上代码：

4、创建一个Protector类，没必要new文件出来，动态生成一个就可以了。注意，如果这个方法被执行到两次，连续两次创建同一个类一定会崩溃，所以我们要加一层判断：

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    
    Class protectorCls = NSClassFromString(@"Protector");
    if (!protectorCls)
    {
        protectorCls = objc_allocateClassPair([NSObject class], "Protector", 0);
        objc_registerClassPair(protectorCls);
    }
}


https://www.jianshu.com/p/521dd19d4406
以下是 **forwardTargetForSelector: **完整的代码
// 重写消息转发方法
- (id)forwardingTargetForSelector:(SEL)aSelector
{
    NSString *selectorStr = NSStringFromSelector(aSelector);
    // 做一次类的判断，只对 UIResponder 和 NSNull 有效
    if ([[self class] isSubclassOfClass: NSClassFromString(@"UIResponder")] ||
        [self isKindOfClass: [NSNull class]])
    {
        NSLog(@"PROTECTOR: -[%@ %@]", [self class], selectorStr);
        NSLog(@"PROTECTOR: unrecognized selector \"%@\" sent to instance: %p", selectorStr, self);
        // 查看调用栈
        NSLog(@"PROTECTOR: call stack: %@", [NSThread callStackSymbols]);

        // 对保护器插入该方法的实现
        Class protectorCls = NSClassFromString(@"Protector");
        if (!protectorCls)
        {
            protectorCls = objc_allocateClassPair([NSObject class], "Protector", 0);
            objc_registerClassPair(protectorCls);
        }
        
        // 检查类中是否存在该方法，不存在则添加
        if (![self isExistSelector:aSelector inClass:protectorCls])
        {
            class_addMethod(protectorCls, aSelector, [self safeImplementation:aSelector],
                            [selectorStr UTF8String]);
        }
        
        Class Protector = [protectorCls class];
        id instance = [[Protector alloc] init];
        
        return instance;
    }
    else
    {
        return nil;
    }
}


// 判断某个class中是否存在某个SEL
- (BOOL)isExistSelector: (SEL)aSelector inClass:(Class)currentClass
{
    BOOL isExist = NO;
    unsigned int methodCount = 0;
    Method *methods = class_copyMethodList(currentClass, &methodCount);
    
    for (int i = 0; i < methodCount; i++)
    {
        Method temp = methods[i];
        SEL sel = method_getName(temp);
        NSString *methodName = NSStringFromSelector(sel);
        if ([methodName isEqualToString: NSStringFromSelector(aSelector)])
        {
            isExist = YES;
            break;
        }
    }
    return isExist;
}

// 一个安全的方法实现
- (IMP)safeImplementation:(SEL)aSelector
{
    IMP imp = imp_implementationWithBlock(^()
    {
        NSLog(@"PROTECTOR: %@ Done", NSStringFromSelector(aSelector));
    });
    return imp;
}









#MVC、MVP、MVVM区别 持有关系等


[MVC]
Model层：负责数据的持久化存储以及读取操作
View层：负责视图数据的展示和交互
Controller层：充当中介者，负责连接model层和view层。
它将数据从model层传递到view层，同时将view层的交互传递到model层从而改变模型存储的数据。

优点
1. 代码总量少。
基本上，MVC大量的逻辑和视图代码都集中在ViewController层，Model层只是实现简单的数据存储，View层主要负责视图数据的展示和交互。
2. 简单易懂。MVC的设计模式可以让开发者很容易熟悉以及上手。

缺点
MVC的缺点也很明显，大量的代码都集中在了Controller层。
1. 代码过于集中。ViewController层集合了视图的交互、视图的更新、布局、Model数据的获取以及更新、网络请求等业务逻辑等大量的代码。
2. 难以进行测试。大量的代码都堆积在了ViewController层，高度耦合难以测试。
3. Model层过于简单。相比ViewController的庞大代码，Model 层只是定义几个属性在 Objective-C 的.m 实现文件中，更是几乎看不到代码。
4. 网络请求逻辑无从安放。网络层放在 Model中，网络请求一般是异步调用的，
那如果网络请求的周期比Model对象的生命周期还要长，那么就会使Model层的逻辑变得很复杂，
若是将网络层放在ViewController中，则耦合进一步加剧，以上缺点更会被放大。


[MVP]
View层：这里的View层是包含View以及Controller的。主要负责视图的布局以及一部分的视图交互。
Model层：依然是负责数据的持久化存储以及读取。
Presenter层：负责接收来自View层的交互，并更新数据到Model层，当Model层数据变更时，负责通知View层更新视图。

1. View层和Controller层都持有presenter层，而视图交互逻辑主要在presenter层，那么内部实现应该是View层将视图交互通知到presenter层，但是本身View层创建出的视图是被addSubView进Controller层的根视图的，所以Controller层又会持有View层，那么另一种实现可以是：Controller层作为View层的代理，View层将处理视图交互的操作定义在协议里，将交互事件传递给Controller层，而Controller层本身持有presenter层，那么就调用presenter层实现的对于视图交互的方法。
2. 要注意的是，Controller层始终是核心层，它负责对于各个层主要的连接以及管理。


简单理一下用户交互的事件传递流程：
用户点击View视图 -> View视图触发交互事件 -> 交互事件传递代理Controller层 ->
Controller层调用Presenter层实现好的交互操作 -> 发起网络请求更新持有的model数据->
model层更新完毕之后通过代理或者通知到Presenter层 -> Presenter层再通过代理或通知通知到Controller层或者View层。


优点
1. 相比于MVC，减轻了Controller层的负担，耦合度大大降低
缺点
view的所有交互都要传给Presenter处理，从而一旦功能增加了，View的代码和Presenter的代码都会增加，
相比于MVC在ViewController一个文件里面直接解决，MVP的总代码量可能会翻倍，
这样App的维护成本和文件都会增大。因此在MVC的基础上又衍生出了一种新的模式MVVM。


[MVVM]
在View层跟View Model层之间是[双向的]，但这不是相互持有的关系，这是一种类似于通知的方法，当View的数据发生变化会自动通知到View Model，当View Model的数据发生变化，也会自动通知到View，所以总的来说，MVVM模式就是在MVP模式上新增了双向绑定。
目前主流的[双向绑定方案主要有RAC以及KVO]
View/Controller 持有 View Model，View Model持有Model，那说明View Model的职责在于分担Controller层的视图交互、网络请求、更新Model模型数据等的业务逻辑。
尽管在MVVM模式下，没有明确指出Controller层的指责划分，但是我们仍然是将Controller层充当Manager的身份，管理各个层以及将业务逻辑分配到View Model层。

优点
相比于MVP模式，代码量大大减少。
缺点
利用RAC实现双向绑定需要引入第三方响应式框架，而且因为属性观察环环相扣，调用栈变大，Debug起来会比较痛苦。





#利用NSInvocation实现performSelector传递无限参数

可以直接调用方法的方式有两种：performSelector:withObject: 和 NSInvocation。
performSelector:withObject:使用简单，但缺点是只能传一个参数，大于2个参数就无法使用；NSInvocation就不一样，功能更加强大

NSInvocation是一个消息调用类，它包含了所有OC消息的成分：target、selector、参数以及返回值。
NSInvocation可以将消息转换成一个对象，消息的每一个参数能够直接设定，





#内存泄漏的检测方法
为了有效地检测内存泄漏，Swift提供了多种工具和技术。以下是一些常用的检测方法：

使用Xcode的内存调试器：Xcode的内存调试器可以帮助开发者实时观察应用的内存使用情况，识别异常的内存增长，并找到潜在的泄漏源。

利用LeakSanitizer：LeakSanitizer是一个静态分析工具，它可以集成到Xcode中，并在编译时检查代码中的潜在内存泄漏问题。

性能分析工具：Time Profiler和Allocations是Xcode Instruments中的工具，它们可以帮助开发者分析应用的性能问题，包括内存使用情况。



#为什么要设计元类

苹果公司在设计Objective-C语言时引入了元类（Meta Class）的概念，主要是为了支持Objective-C的动态性、消息转发机制以及类别（Categories）等特性。元类在Objective-C中扮演着至关重要的角色，其主要作用和设计理念包括：

1. **动态方法解析**：Objective-C是一种动态类型的语言，对象在接收到一条消息（method call）时，运行时系统首先会查找该对象所属类的方法列表。如果没有找到相应的方法实现，元类在此过程中发挥作用，它保存了类方法（class method）的信息，同时也参与动态方法解析过程，即当对象方法不存在时，会尝试在继承链中查找并可能动态添加方法。

2. **类别支持**：在Objective-C中，可以为已有类添加新的方法而不需修改原有类的定义，这就是通过类别（Category）实现的。类别扩展了类的功能，而元类则负责管理和协调类别带来的新增方法以及原有类定义中的方法。

3. **对象和类的关系表示**：在Objective-C中，每个类都有一个与之对应的元类，元类保存了关于类自身的方法和属性。而每个对象的isa指针指向其类对象，类对象的isa指针又指向其元类，以此形成了一个完整的类层级关系。

4. **消息转发机制的基础**：当运行时找不到方法实现时，元类还会参与消息转发（message forwarding）过程，这是Objective-C语言的重要特性之一，使得开发者可以灵活处理未知消息。

总结来说，苹果公司设计元类是为了更好地支持Objective-C的动态特性，强化面向对象编程的能力，并在运行时阶段提供更多的灵活性和可扩展性。通过元类，Objective-C能够实现其他静态类型语言难以做到的运行时动态行为，比如动态添加方法、动态交换方法实现（Method Swizzling）等。





person有个+test方法，实现输出persion test，student继承persion，头文件定义-test方法，但没实现，student *obj=new student [obj test] 结果是啥？# 崩溃



#======================



#iOS开发中常用的锁有如下几种

来比较一下遇到加锁的情况：

1. @synchronized 关键字加锁 

2. NSLock 对象锁 
3. NSCondition  信号量
4. NSConditionLock 条件锁 
5. NSRecursiveLock 递归锁 
6. pthread_mutex 互斥锁（C语言） 
7. dispatch_semaphore 信号量实现加锁（GCD） 

自旋锁
自旋锁是为了防止多处理器并发而引入的一种锁，它是为实现保护共享资源而提出一种锁机制。其实，自旋锁与互斥锁比较类似，它们都是为了解决对某项资源的互斥使用。无论是互斥锁，还是自旋锁，在任何时刻，最多只能有一个保持者，也就说，在任何时刻最多只能有一个执行单元获得锁。

 8. OSSpinLock 
最终的结论就是，除非开发者能保证访问锁的线程全部都处于同一优先级，这个自旋锁存在优先级反转的问题,否则 iOS 系统中所有类型的自旋锁都不能再使用了。

9.

OSSpinLock的性能最好（不建议使用），GCD的dispatch_semaphore紧随其后； 
NSConditionLock和@synchronized性能较差；


nonatomic：非原子属性，线程不安全的，效率高
atomic：原子属性，线程安全的？？？？，效率相对低。
原子属性是一种单(线程)写多(线程)读的多线程技术,不过可能会出现脏数据

，为什么要把atomic和线程安全联系在一起去探究；atomic只是对属性的getter/setter方法进行了加锁操作，这种安全仅仅是get/set的读写安全，仅此之一，但是线程安全还有除了读写的其他操作,比如：当一个线程正在get/set时，另一个线程同时进行release操作，可能会直接crash。很明显atomic的读写锁不能保证线程安全。 


atomic属性内部的锁称为 自旋锁
凡是线程安全的对象，内部肯定会加锁。


#自旋锁和互斥锁 
相同点：都能保证同一时间只有一个线程访问共享资源。都能保证线程安全。
不同点： 
互斥锁：如果共享数据已经有其他线程加锁了，线程会进入[休眠]状态等待锁。一旦被访问的资源被解锁，则等待资源的线程会被唤醒。
自旋锁：如果共享数据已经有其他线程加锁了，线程会以[死循环]的方式等待锁，一旦被访问的资源被解锁，则等待资源的线程会立即执行。
[自旋锁的效率高于互斥锁]。

所有属性都声明为nonatomic
尽量避免多线程抢夺同一块资源
尽量将加锁、资源抢夺的业务逻辑交给服务器端处理，减少移动客户端的压力



#知道哪些锁？（说了自旋锁和互斥锁） 说说它们的区别

自旋锁设计的初衷是在短期内进行轻量级的锁定(后面介绍自旋锁的特点就能清楚的明白为什么是在短期内了)，它将一段临界区代码进行锁定，保证当前线程/进程执行这段临界区代码的时候不会被其他线程/进程中断，避免因为竞争导致共享资源被破坏。

对于自旋锁来说，B进程会"原地旋转"，即执行循环，去检测锁是否已经被释放；
对于互斥锁来说，B进程直接进入sleep休眠状态，将CPU的使用权交由其他进程处理，等待锁被释放是被唤醒。

自旋锁等待过程中耗费CPU，而互斥锁不会（原因：自旋锁等待锁的过程中循环检测锁的状态，）
自旋锁常用在临界区较为短小的场景下 （原因：等待自旋锁的时间过长，会浪费过多CPU）
自旋锁中等待的进程/线程获取锁的灵敏度较高（原因：自身循环检测）
自旋锁在非抢占式的单核处理器中不起作用。（原因：等待线程在循环等待，但是又不允许抢占，会导致CPU卡主，所以这种架构的处理器中自旋锁被实现为空）
自旋锁和互斥锁都只允许一次只有一个进程/线程进入临界区。
自旋锁在"唤醒"时不需要进行上下文切换，而互斥锁需要进行上下文切换，切换成本较高

#读写锁
对共享数据的操作进行读操作较多，写操作很少；由于在读数据的时候不会产生脏数据，所以多线程同时对数据进行读操作是没有问题的。所以在这种场景下如果一味的使用互斥锁，会导致对数据的操作效率很低。因此这种情况下产生了读写锁，读写锁与互斥锁类似，也是对进程/线程进入一段临界区的访问控制。
读写锁有三种状态：添加读锁，添加写锁，未加锁

只要没有添加写锁，所有读线程都允许进入临界区进行操作。（允许多读，写的时候不允许读）
只有在未加锁状态下，才允许写线程进入临界区。（只允许一个进程写，写的过程中不允许有其他任何操作）
Linux中pthread_rwlock_t读写锁本质上是一个自旋锁。
尽量在读多写少的场景下使用读写锁
在读和写操作进行竞争锁的时候，写操作优先获得锁。

pthread_rwlock：读写锁
等待锁的线程会进入休眠

#import "ViewController.h"
#import <pthread.h>

@interface ViewController ()
@property (nonatomic, assign) pthread_rwlock_t lock;
@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化锁
    pthread_rwlock_init(&_lock, NULL);
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
@end

dispatch_barrier_async：异步栅栏调用

#================

#iOS应用的内存优化

1、避免循环引用

循环引用会导致内存泄漏。使用 weak 或 unowned 关键字打破循环引用，特别是在闭包和代理模式中。

2、使用 unowned 引用

在生命周期中始终存在的情况下使用 unowned，避免额外的内存开销。

class A {
    var b: B?
}

class B {
    unowned var a: A // 使用 unowned 以减少内存开销
}

2. 内存泄漏检测

2.1 使用 Instruments
Leaks：检测内存泄漏。
Allocations：监控对象分配和释放情况，识别内存高占用点。
2.2 静态分析工具
Xcode 静态分析：在编译时检测潜在的内存问题和代码缺陷。

3. 图像优化
3.1 使用合适的图像格式和大小

选择合适的图像格式（如 PNG、JPEG）和适当的分辨率，减少内存占用。

3.2 按需加载图像

避免一次性加载大量图像到内存，使用异步加载和缓存技术。


4. 缓存和懒加载

4.1 使用 NSCache

使用 NSCache 缓存频繁使用的数据或对象，避免重复创建和加载。

let imageCache = NSCache<NSString, UIImage>()

4.2 懒加载

在需要时才加载资源或初始化对象，减少初始内存使用。

lazy var expensiveResource: ExpensiveResource = {
    return ExpensiveResource()
}()


5. 大数据处理

5.1 分块读取和处理

避免一次性加载所有数据到内存，分块读取和处理大数据。

func processLargeFile(url: URL) {
    if let fileHandle = try? FileHandle(forReadingFrom: url) {
        while let data = try? fileHandle.read(upToCount: 1024) {
            // 处理数据块
        }
        fileHandle.closeFile()
    }
}

5.2 内存映射文件

使用内存映射技术处理特别大的文件，减少内存占用。

let fileURL = URL(fileURLWithPath: "/path/to/large/file")
if let fileData = try? Data(contentsOf: fileURL, options: .mappedIfSafe) {
    // 处理文件数据
}

6. 内存警告处理

6.1 释放不必要的资源

在收到内存警告时，释放不必要的资源。

override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // 释放不必要的资源
    imageCache.removeAllObjects()
}


7. 引用类型与值类型选择

7.1 使用值类型（struct、enum）

对于不可变数据或轻量级数据结构，使用值类型减少内存开销。

struct Point {
    var x: Double
    var y: Double
}

7.2 使用引用类型（class）

对于需要共享状态或复杂生命周期管理的数据结构，使用引用类型。

class SharedData {
    static let shared = SharedData()
    var value: Int = 0
    
    private init() {}
}


8. 手动内存管理

8.1 使用 @autoreleasepool

在需要时手动管理自动释放池，及时释放临时对象。

for i in 0..<1000 {
    autoreleasepool {
        // 创建和使用临时对象
    }
}


9. 优化算法

9.1 优化数据处理算法

选择时间复杂度更低、内存占用更少的算法。

// 使用高效的排序算法
let sortedArray = array.sorted()

10. 使用高效的框架和库

10.1 高效的网络库

选择高效的网络库，如 Alamofire，减少内存占用和网络请求开销。

import Alamofire

Alamofire.request("https://api.example.com/getData").responseJSON { response in
    if let json = response.result.value {
        print("JSON: \(json)")
    }
}


11. 重用大开销对象
一些objects的初始化很慢，比如NSDateFormatter和NSCalendar。然而，你又不可避免地需要使用它们，比如从JSON或者XML中解析数据。


12. 避免反复处理数据

许多应用需要从服务器加载功能所需的常为JSON或者XML格式的数据。在服务器端和客户端使用相同的数据结构很重要。在内存中操作数据使它们满足你的数据结构是开销很大的。

比如你需要数据来展示一个table view,最好直接从服务器取array结构的数据以避免额外的中间数据结构改变。

13. 优化Table View
正确使用`reuseIdentifier`来重用cells

· 尽量使所有的view opaque，包括cell自身

· 避免渐变，图片缩放，后台选人

· 缓存行高

· 如果cell内现实的内容来自web，使用异步加载，缓存请求结果

· 使用`shadowPath`来画阴影

· 减少subviews的数量

· 尽量不适用`cellForRowAtIndexPath:`，如果你需要用到它，只用一次然后缓存结果

· 使用正确的数据结构来存储数据

· 使用`rowHeight`, `sectionFooterHeight`和 `sectionHeaderHeight`来设定固定的高，不要请求delegate

14. 选择是否缓存图片

常见的从bundle中加载图片的方式有两种，一个是用`imageNamed`，二是用`imageWithContentsOfFile`，第一种比较常见一点。

既然有两种类似的方法来实现相同的目的，那么他们之间的差别是什么呢？

`imageNamed`的优点是当加载时会缓存图片。`imageNamed`的文档中这么说:这个方法用一个指定的名字在系统缓存中查找并返回一个图片对象如果它存在的话。如果缓存中没有找到相应的图片，这个方法从指定的文档中加载然后缓存并返回这个对象。

相反的，`imageWithContentsOfFile`仅加载图片。



#性能优化-异步绘制与异步底层View处理

异步绘制：
UIButton、UILabel、UITableView等空间是同步绘制在主线程上的，也就是说，如果这些控件在业务上表现很复杂，那么有可能就会导致界面卡顿。好在系统开了一个口子可以让我们自己去绘制，当然是在子线程上处理然后回到主线程上显示。

大致原理就是UIView作为一个显示类，它实际上是负责事件与触摸传递的，真正负责显示的类是CALayer。只要能控制layer在子线程上绘制，就完成了异步绘制的操作。

1.原理：

按照以下顺序操作：

继承于CALayer创建一个异步Layer。由于Label的表征是text文本，ImageView的表征是image图像，那可以利用Context去绘制文本、图片等几何信息。
创建并管理一些线程专用于异步绘制。
每次针对某个控件的绘制接受到了绘制信号（如设置text，color等属性）就绘制。

#异步绘制流程


1、首先 UIView 调用 setNeedsDisplay 方法
2、其实是调用其 layer 属性的同名方法（view.layer setNeedsDisplay）
3、这时 layer 并不会立刻调用 display 方法,而是要等到当前 runloop 即将结束的时候调用 display，进入到绘制流程。
4、在 UIView 中 layer.delegate 就是 UIView 本身，UIView 并没有实现 displayLayer: 方法，所以进入系统的绘制流程，我们可以通过实现 displayLayer: 方法来进行异步绘制。
所以去实现 displayLayer 方式，实现开启异步绘制入口

在“异步绘制入口”去开辟子线程，然后在子线程中实现和系统类似的绘制流程。

首先在主线程调用 setNeedsdispay 方法
系统会在 runloop 将要结束的时候调用 [CAlayer display] 方法
如果我们的[代理实现了dispayLayer 这个方法]，会调用 dispayLayer 这个方法。

我们可以去子线程里面进行异步绘制。子线程主要做的工作：
[创建上下文]
[UI控件的绘制工作]
[生成对应的图片（bitmap）]
主线程可以做其他工作
异步绘制完事之后，回到主线程，把绘制的 bitmap 赋值 view.layer.contents 属性中


#我们调用 [UIView setNeedsDisplay] 方法的时候，不会立马发送对应视图的绘制工作，为什么？

调用 [UIView setNeedsDisplay] 后，
然后会调用系统的同名方法 [view.layer setNeedsDisplay] 方法并在当前 view 上面打上一个[脏标记]
[当前 Runloop 将要结束]的时候才会调用 [CALyer display] 方法，然后进入到视图真正的绘制工作当中。


#是否知道异步绘制？如何进行异步绘制？

基于系统开的口子 [layer.delegate dispayLayer:] 方法。
并且实现/遵从了 dispayLayer 这个方法，我们就可以进行异步绘制：
1）代理负责生产对应的 bitmap
2）设置 bitmap 作为 layer.contents 属性的值


#异步绘代码 --- [示例]

--------------------------------------------
import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AsyncDrawLabel : UIView

@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) UIFont *font;

@end

NS_ASSUME_NONNULL_END

------------------------------------

import "AsyncDrawLabel.h"
import <CoreText/CoreText.h>

@implementation AsyncDrawLabel

- (void)setText:(NSString *)text {
    _text = text;
}

- (void)setFont:(UIFont *)font {
    _font = font;
}


// 除了在drawRect方法中, 其他地方获取context需要自己创建
 
- (void)displayLayer:(CALayer *)layer {
    CGSize size = self.bounds.size;
    CGFloat scale = [UIScreen mainScreen].scale;
    
    // 异步绘制，切换至子线程
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIGraphicsBeginImageContextWithOptions(size, NO, scale);
        
        // 获取当前上下文
        CGContextRef context = UIGraphicsGetCurrentContext();
        [self draw:context size:size];
        
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        // 子线程完成工作，切换至主线程显示
        dispatch_async(dispatch_get_main_queue(), ^{
            self.layer.contents = (__bridge id)image.CGImage;
        });
    });
}

- (void)draw:(CGContextRef)context size:(CGSize)size {
    // 将坐标系上下翻转，因为底层坐标系和 UIKit 坐标系原点位置不同。
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    // 文本沿着Y轴移动
    CGContextTranslateCTM(context, 0, size.height); // 原点为左下角
    // 文本反转成context坐标系
    CGContextScaleCTM(context, 1, -1);
    // 创建绘制区域
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, size.width, size.height));
    // 创建需要绘制的文字
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:self.text];
    [attrStr addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, self.text.length)];
    // 根据attStr生成CTFramesetterRef
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attrStr);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, attrStr.length), path, NULL);
    // 将frame的内容绘制到content中
    CTFrameDraw(frame, context);
}

------------------------------------
简单的调用：

import "ViewController.h"
import "AsyncDrawLabel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    AsyncDrawLabel *label = [[AsyncDrawLabel alloc] initWithFrame:CGRectMake(100, 100, 200, 100)];
    label.backgroundColor = [UIColor yellowColor];
    label.text = @"异步绘制text";
    label.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:label];
    [label.layer setNeedsDisplay]; // 不调用的话不会触发displayLayer方法
}

@end
----------------------------------------




#layoutSubviews()方法

layoutSubviews():当一个视图“认为”应该重新布局自己的子控件时，它便会自动调用自己的layoutSubviews方法，在该方法中“刷新”子控件的布局.这个方法并没有系统实现，需要我们重新这个方法，在里面实现子控件的重新布局。这个方法很开销很大，因为它会在每个子视图上起作用并且调用它们相应的layoutSubviews方法.系统会根据当前run loop的不同状态来触发layoutSubviews调用的机制,并不需要我们手动调用。以下是他的触发时机：

直接修改 view 的大小时会触发
调用addSubview会触发子视图的layoutSubviews
用户在 UIScrollView 上滚动（layoutSubviews 会在UIScrollView和它的父view上被调用）
用户旋转设备
更新视图的 constraints
这些方式都会告知系统view的位置需要被重新计算，继而会调用layoutSubviews.当然也可以直接触发layoutSubviews的方法。
setNeedsLayout()方法

#setNeedsLayout()
方法的调用可以触发layoutSubviews,调用这个方法代表向系统表示视图的布局需要重新计算。
不过调用这个方法只是为当前的视图打了一个脏标记，
告知系统runloop在[即将休眠时]更新控件的布局。
也就是调用setNeedsLayout()后会有一段时间间隔，然后触发layoutSubviews.
当然这个间隔不会对用户造成影响，因为永远不会长到对界面造成卡顿。

#layoutIfNeeded()方法

layoutIfNeeded()方法的作用是告知系统，当前打了脏标记的视图需要立即更新，[不要等到下一次run loop到来时在更新],
此时该方法会立即触发layoutSubviews方法。
当然但如果你调用了layoutIfNeeded之后，并且没有任何操作向系统表明需要刷新视图，那么就不会调用layoutsubview。

#setNeedsDisplay()方法

这个方法类似于布局中的setNeedsLayout。它会给有内容更新的视图设置一个内部的标记，但在视图重绘之前就会返回。然后在run loop将要结束时，系统会遍历所有已标记的视图，并调用它们的drawRect:方法。大部分时候，在视图中更新任何 UI 组件都会把相应的视图标记为“dirty”，通过设置视图“内部更新标记”，在run loop将要结束时会重绘，而不需要显式的调用setNeedsDisplay.


#请简述什么是离屏渲染，以及在 iOS 中如何避免过度使用离屏渲染。

离屏渲染指的是将需要渲染的内容绘制到一个离屏的缓冲区，然后再将缓冲区中的内容绘制到屏幕上。
在 iOS 中，离屏渲染是通过 GPU 完成的，GPU 会使用纹理贴图等方式将需要渲染的内容保存到离屏缓冲区中，然后再将缓冲区中的内容绘制到屏幕上。

离屏渲染往往发生在需要进行特定图形操作（如裁剪、遮罩、多重混合模式等）或使用某些特定属性（如圆角、阴影、透明度等）的场景中。离屏渲染可能导致性能下降，因为它涉及到额外的图形资源分配、上下文切换、数据复制等开销，尤其是在频繁触发或硬件资源受限的情况下

圆角（Rounded Corners）：给 UIView 或其子类设置 cornerRadius 属性时，如果视图同时具有不透明背景色或复杂的背景图像，可能会触发离屏渲染。
阴影（Shadows）：设置 layer.shadow* 属性（如 shadowColor、shadowOffset、shadowRadius 等）会产生阴影效果，通常需要离屏渲染。
透明度（Opacity）：当视图的 alpha 值小于 1 或使用了 CALayer 的 opacity 属性时，如果有复杂混合层级，可能触发离屏渲染。
遮罩（Masking）：使用 CALayer 的 mask 属性或 UIView 的 maskView 时，遮罩效果通常需要离屏渲染。

[混合模式（Blend Modes）]：

当视图或图层使用非默认的混合模式（如 multiply、screen、overlay 等）时，系统可能需要在离屏缓冲区中进行混合操作。
[多重渲染目标（Multiple Render Passes）]：

需要多次渲染才能完成的效果，如复杂动画、多重叠加效果等，可能需要离屏缓冲区进行中间结果的存储和合并。


#如何避免过度使用离屏渲染

iOS Simulator：在 Simulator 中开启 Debug > Color Off-screen Rendered 选项，触发离屏渲染的视图会以黄色高亮显示。
Instruments：使用 Xcode 中的 Instruments 工具，尤其是 Core Animation 分析器，可以详细查看离屏渲染的发生情况及相关性能指标。


避免不必要的圆角：对于静态内容，可以预先将图片裁剪为带圆角的版本；对于动态内容，考虑使用 UIBezierPath 或 Core Graphics 绘制圆角，或使用 maskView 替代 cornerRadius。

简化阴影效果：减少阴影的模糊半径、调整阴影颜色以降低 alpha 值、避免在频繁变动的视图上使用阴影，或者使用模拟阴影的视觉技巧（如渐变背景）替代。

调整透明度与混合模式：尽量避免不必要的透明度设置，尤其是对于大面积或层级较深的视图。对于混合模式，评估是否可以使用视觉效果相近但性能更好的模式，或者避免在性能敏感区域使用非默认混合模式。

使用硬件加速功能：如 shouldRasterize 属性可以让图层内容预先渲染为位图，减少后续绘制时的计算量。但要注意过度使用可能导致内存增加，需权衡利弊。

布局与层级优化：减少不必要的视图层级和重叠部分，避免深度过大的视图结构，这有助于减少离屏渲染的需求。

长列表优化：对于滚动列表，使用 UICollectionView 或 UITableView，并结合 cell prefetching、estimatedItemSize、dequeueReusableCell 等技术，减少不必要的视图创建和销毁，降低离屏渲染的概率。

适时使用异步绘制：对于复杂的绘制任务，可以利用 drawRect: 方法的异步版本（drawRect:withParameters:isTransparent:completionHandler:）进行异步绘制，避免阻塞主线程。



#====================
#iOS中UIView和CALayer的区别？
相互依赖：UIView 与 CALayer 之间存在相互依赖的关系。
每个 UIView 内部都有一个对应的 CALayer（称为“backing layer”），作为其内容的呈现载体。
UIView 依赖 CALayer 来绘制和显示内容，而 CALayer 依赖 UIView 提供的容器环境来展示这些内容。

前者主要负责用户交互、布局管理以及与高层UI框架的集成，
后者专注于内容绘制、视觉效果呈现以及硬件加速动画。


#什么是锚点（Anchor Point）？

锚点是一个定义图层旋转和缩放的中心点的属性。它是一个CGPoint，取值范围是[0, 1]，默认值是(0.5, 0.5)，即图层的中心。
如何更改视图的锚点？

可以通过设置视图图层的anchorPoint属性来更改锚点，例如：
view.layer.anchorPoint = CGPointMake(0, 0);
锚点默认值是多少？

锚点的默认值是(0.5, 0.5)，即图层的中心。

#如何在锚点更改时保持视图的位置不变？(没啥用，回不去）

在更改锚点之前保存视图的frame或center，更改锚点后重新设置视图的位置。(没有用）
CGPoint originalCenter = view.center;
view.layer.anchorPoint = CGPointMake(0, 0);
view.center = originalCenter;

#更改锚点会对视图的frame和center产生什么影响？

更改锚点会导致视图的frame和center属性发生变化，因为锚点的更改会导致视图的相对位置发生变化。

#在动画中使用锚点时需要注意哪些问题？

使用锚点进行动画时，可能会导致视图跳动或位置不一致。为避免这种现象，可以在更改锚点之后立即调整视图的位置。
CGPoint originalCenter = view.center;
view.layer.anchorPoint = CGPointMake(0, 0);
view.center = originalCenter;
[UIView animateWithDuration:1.0 animations:^{
    view.transform = CGAffineTransformMakeRotation(M_PI);
}];

#如何通过更改锚点实现视图从特定点进行缩放的效果？

更改锚点到指定位置，然后应用缩放变换。
view.layer.anchorPoint = CGPointMake(1, 1);
[UIView animateWithDuration:1.0 animations:^{
    view.transform = CGAffineTransformMakeScale(2.0, 2.0);
}];


#===================

#什么是Hit-Test？
当我们点击界面的时候，iOS是如何知道我们点击的是哪一个View？
 其实这个过程就是由Hit-Test来完成的。通过Hit-Test ，App 可以知道由那个 view 来响应事件。
 
hit-testing 是怎么运作的
当你点击了屏幕上的某个view，这个动作由硬件层传导到操作系统，
UIKit 就会打包出一个 UIEvent 对象，然后会把这个Event分发给当前正在活跃的 App ，
告知当前活动的App有事件之后，UIApplication 单例就会从[事件队列中去取最新的事件]，
然后分发给能够处理该事件的对象。UIApplication 获取到Event之后，
Application就纠结于到底要把这个事件传递给那个View来响应这个事件，这时候就要依靠HitTest来决定了。

iOS中，Hit-Test的作用就是找出这个触摸点下面的View是什么，
HitTest会检测这个点击的点是不是发生在这个View上，
如果是的话，就会去遍历这个View的subviews，直到找到最小的能够处理事件的view，
如果整了一圈没找到能够处理的view，则返回自身
 然后从sub View 又开始找。 就是你添加 SubView 的[逆序来遍历]的，换句话说就是从最顶层的 SubView 开始找。


用户点击View D，hit-test view流程如下:

A是UIWindow的根视图，因此，UIWindow对象会首先对A进行hit-test；
显然用户点击的范围是在A的范围内，因此，[pointInside:withEvent:返回了YES]，这时会继续检查A的子视图；
B view分支的pointInside:withEvent:返回NO，对应的[hitTest:withEvent:返回nil]；
点击的范围在C内，即C的pointInside:withEvent:返回YES；这时候有D和E两个分支：点击的范围再D view内，因此D view的pointInside:withEvent:返回YES，对应的hitTest:withEvent:返回DView；


#事件传递机制（Event Handling） -- [向下：找到第一触发者/响应者】
iOS的事件传递系统将触摸和其他事件（如动作、手势）发送到视图层次结构中的适当对象。
在事件传递过程中，系统通常从根视图开始查找，并递归向下查找以找到最适合处理该事件的视图。

传递流程

1、[事件的产生]：
用户通过手势或是触摸等其他操作与设备交互，生成事件，系统将事件传递给应用的UIApplication实例，以开始事件分发

2、[UIApplication事件分发]：
UIApplication负责顶层管理所有用户输入事件。
它将事件传递给当前活动的UIWindow对象，以进一步查找适合的响应者。

3、[UIWindow事件分发]：
当前活动的UIWindow对象接收事件并通过hitTest:withEvent:方法开始寻找适当的视图。
UIWindow遍历整个视图层次结构，以找到最合适的视图来响应事件。
4、[命中测试（Hit-Testing）]：
hitTest:withEvent:是寻找第一响应者的核心方法。

它通过以下步骤工作：
检查当前视图的userInteractionEnabled、hidden和alpha属性以确保视图可交互。

当视图隐藏属性hidden=NO、交互userInteractionEnabled=YES、透明度alpha>0.01三者同时满足才拥有响应能力。

调用[pointInside:withEvent:]，确定触摸点是否在当前视图的边界范围内。

[从后往前遍历子视图]，递归调用子视图的hitTest:withEvent:方法。

如果找到合适的子视图，它将返回该子视图作为第一响应者；否则返回当前视图自身。

[PS: 事件传递的目的就是为了让我们找到第一响应者]



#响应者链---【向上】

找到第一响应者之后并且识别出手势后，我们就要确定由谁来响应这个事件了，如何理解这句话呢？
第一响应者不一定能响应事件，因为他可能并没有实现触摸事件

响应者链的响应流程
判断当前视图能否响应，再去判断当前视图的nextResponder，如果是VC的View，那么nextResponder就是VC
如果不是控制器的 View，上一个响应者就是SuperView

响应的大致的过程 第一响应者 –> super view –> ……–> view controller –> window –>Application


#先【向下】找第一响应者，在【向上】找响应事件者

当触摸事件发生后，系统会自动生成一个UIEvent对象,记录事件产生的时间和类型
然后系统会将UIEvent事件加入到一个由UIApplication管理的事件队列中
然后UIApplication将事件分发给UIWindow，主窗口会在视图层次结构中找到一个最合适的视图来处理触摸事件
不断递归调用hitTest方法来找到第一响应者

如果第一响应者无法响应事件，那么按照响应者链往上传递，也就是传递给自己的父视图
一直传递直到UIApplication，如果都无法响应则事件被丢弃


#============================

#修饰变量的关键字：（const，static，extern）
常量const
常量修饰符，表示不可变，可以用来修饰右边的基本变量和指针变量（[放在谁的前面修饰谁]（基本数据变量p，指针变量p））。
常用写法例如：


const 类型 * 变量名a：可以改变指针的指向，不能改变指针指向的内容。
const放 号的前面约束参数，表示a只读。只能修改地址a,不能通过a修改访问的内存空间

int x = 12;
int new_x = 21;
const int *px = &x; 
px = &new_x; // 改变指针px的指向，使其指向变量y


类型 * const 变量名：可以改变指针指向的内容，不能改变指针的指向。 
const放后面约束参数，表示a只读，不能修改a的地址，只能修改a访问的值，不能修改参数的地址

int y = 12;
int new_y = 21;
int * const py = &y;
(*py) = new_y; // 改变px指向的变量x的值


#常量（const）和宏定义（define）的区别:

使用宏和常量所占用的内存差别不大，宏定义的是常量，常量都放在常量区，只会生成一份内存

缺点：
编译时刻：[宏是预编译]（编译之前处理），[const是编译阶段]。
导致使用宏定义过多的话，随着工程越来越大，编译速度会越来越慢
宏不做检查，不会报编译错误，只是替换，const会编译检查，会报编译错误。

优点：
宏能定义一些函数，方法。 const不能。

#常量 static
static关键字的三个作用：

可以修饰局部变量，将局部变量存储到静态存储区。
可以修饰全局变量，限定全局变量只能在当前源文件中访问。
可以修饰函数，限定该函数只能在当前源文件调用。

#常量 extern
只是用来获取全局变量(包括全局静态变量)的值，不能用于定义变量。先在当前文件查找有没有全局变量，没有找到，才会去其他文件查找（优先级）。

static与const联合使用
声明一个静态的全局只读常量。开发中声明的全局变量，有些不希望外界改动，只允许读取。
iOS中staic和const常用使用场景，是用来代替宏，把一个经常使用的字符串常量，定义成静态全局只读变量.

// 开发中经常拿到key修改值，因此用const修饰key,表示key只读，不允许修改。
static  NSString * const key = @"name";

// 如果 const修饰 *key1,表示*key1只读，key1还是能改变。
static  NSString const *key1 = @"name";



#============================

#面向对象与面向协议编程

面向对象(Object Oriented Programming, 简称OOP)
面向协议（Protocol Oriented Programming, 简称POP）

面向对象的三大特征：封装，继承和多态。


#面向对象的三大困境

[横切关注点]

假设我们有一个ViewController,它继承自UIViewController,我们向其中添加一个myMethod：

class ViewCotroller: UIViewController
{
    // 继承
    // view, isFirstResponder()...
    
    // 新加
    func myMethod() {
    }
}
如果这个时候我们又有一个继承自UITbaleViewController的AnotherViewController,我们也想向其中添加同样的myMethod:

class AnotherViewController: UITableViewController
{
    // 继承
    // tableView, isFirstResponder()...
    
    // 新加
    func myMethod() {        
    }
}
这时，我们迎来了OOP的第一个大困境，那就是我们很难在不同的继承关系的类里共用代码。用“专业术语”来说叫"横切关注点"。我们的关注点myMethod位于两条继承链（UIViewController ->ViewContoller 和 UIViewContoller -> UITableViewContoller -> AnotherViewController）的横切面上。面向对象是一种不错的抽象方式，但是肯定不是最好的方式。它无法描述两个不同事物具有某个不同特性这一点。在这里，特性的组合要继承更贴切事物的本质。

想要解决这个问题，我们有几个方案：

[Copy & Paste]
这时一个比较糟糕的解决方案，但是演讲现场还是有不少朋友选择了这个方案，特别是在工期比较紧，无暇优化的情况下。这里诚然可以理解，但是这也是坏代码的开头。我们应该尽量避免这种做法。

[引入BaseViewController]
在一个继承自UIViewController的BaseViewController上添加需要共享的代码，或者干脆在UIViewContoller上添加extension。
看起来这是一个稍微靠谱的做法，但是如果不断这么做，会让所谓的Base很快变成垃圾堆。
职责不明确，任何东西都能扔进Base,你完全不知道哪些类走了Base，而这个[“超级类”]对代码的影响也会不可预估。

[依赖注入]
通过外界传入一个带有myMethod的对象，用新的类型来提供这个功能。这是一个稍好的方式，但是引入额外的依赖关系，可能也是我们不太愿意看到的。

[多继承]
当然Swift不支持多继承，不过如果有多继承的话，我们确实可以从多个父类进行继承。并将myMehtod添加到合适的地方。有一些语言选择了支持多继承（比如C++），但是它会带来面向对象中另外一个著名的问题：[菱形缺陷]。



#菱形缺陷

上面的例子中，如果我们有多继承，那么ViewController和AnotherViewController的关系可能会是这样的：


在这种拓扑结构中，我们只需要在ViewController中实现myMethod，在AnotherViewController中也就可以继承并使用它了。
看起来很完美，我们避免了重复。
但是多继承有一个无法回避的问题，就是两个父类都实现了同样的方法时，子类该怎么办?
我们很难确定应该继承哪一个父类的方法。因为多继承的拓扑结构是一个菱形，
所以这个问题又被叫做[菱形缺陷]。
像是C++这样的语言选择粗暴地将菱形缺陷的问题交给程序员处理，这无疑非常复杂，而且增加了人为错误的可能性。
而绝大多数现代语言对多继承这个特性选择避而远之。








#iOS后台行，一般有两种方式：

1.UIBackgroundTaskIdentifier后台任务标记时,

2.设置后台运行模式，需要有voip，location功能的才行。不然app上线审核肯定是过不了的。


1） Background Task仅用于执行短时间的任务，APP切换到后台后，可以通过beginBackgroundTaskWithExpirationHandler申请一段时间的后台时间，你的任务应该在这段时间内执行完成，否则会被系统杀死。

2） Background Task的持续时间并不是一个固定值，在不同性能的设备上差别巨大。在iPhone 10上为30秒，这个是我自己测试的，据说，在高性能的设备上则达到180秒。最长持续时间似乎还和当前的资源占用情况有关。

3）beginBackgroundTask和endBackgroundTask必须成对出现如果使用全局的UIBackgroundTaskIdentifier记录后台任务，需要注意每次执行beginBackgroundTask都会生成新的UIBackgroundTaskIdentifier。旧的UIBackgroundTaskIdentifier会被覆盖，则上一个UIBackgroundTaskIdentifier就没有机会执行endBackgroundTask。此时会出现beginBackgroundTask和endBackgroundTask不配对的情况，可能会被系统杀死。




#队列一定会创建线程吗?

答：不，同步执行方式是不创建新线程的，就在当前线程嗨。
线程按执行方式分为同步、异步，按队列管理分为串行并行，这样有四种组合，加上常说的主线程主队列，那么结合执行方式就有六种组合。
同步串行，不创建线程，所以还是在当前线程一个一个做
同步并行，不创建线程，所以就算是并行，也还是在当前线程一个一个做
异步串行，开辟多一条线程，任务在新开辟的一条线程里面一个一个做
异步并行，开辟多条线程，任务在新开辟的线程里面一起做
同步主队，阻塞
异步主队，同异步串行，因为主队就是串行，但是不开辟新线程，因为主线程是全局的单例的



#PerformSelector & NSInvocation优劣对比
相同点: 有相同的父类NSObject 
区别： 在参数个数<= 2的时候performSelector：的使用要简单一些，但是在参数个数 > 2的时候NSInvocation就简单一些。



#gcd 的使用，能不能取消？
dispatch_block_cancel可以取消尚未执行的任务。已经在运行的，用代码中断


#iOS NSOperation 是如何终止/取消任务的?

正在执行的任务，NSOperation也是不能取消的，可以考虑用一个条件来做，满足条件则执行此任务，不满足则不执行



#TCP,HTTP,WebSokect 区别
IP协议（网络层协议）
TCP：传输控制协议，主要解决数据如何在网络中传输，面向连接，可靠。（传输层协议）
UDP：用户数据报协议，面向数据报，不可靠。
HTTP：主要解决如何包装数据。（应用层协议）
Socket：是对TCP/IP协议的封装，Socket本身并不是协议，而是一个调用接口（API），通过Socket，我们才能使用TCP/IP协议。（传输层协议）

HTTP连接：短连接，客户端向服务器发送一次请求，服务器端响应连接后会立即端掉。
Socket连接：长连接，理论上客户端和服务器端一旦建立连接将不会主动端掉。

建立Socket连接至少需要一对套接字，其中一个运行于客户端，称为ClientSocket，另一个运行于服务器端，称为ServerSocket。
套接字之间的连接过程分为三个步骤：服务器监听，客户端请求，连接确认。

WebSocket是双向通信协议，模拟Socket协议，可以双向发送或接受信息。HTTP是单向的。
Socket是传输控制层协议，WebSocket是应用层协议。


#TCP与UDP

信息的可靠传递方面不同：
TCP 是面向连接的传输控制协议，而UDP 提供了无连接的数据报服务；
TCP 具有高可靠性，确保传输数据的正确性，不出现丢失或乱序；
UDP 在传输数据前不建立连接，不对数据报进行检查与修改，无须等待对方的应答，所以会出现分组丢失、重复、乱序，应用程序需要负责传输可靠性方面的所有工作；
UDP 具有较好的实时性，工作效率较 TCP 协议高；
UDP 段结构比 TCP 的段结构简单，因此网络开销也小；
TCP 协议可以保证接收端毫无差错地接收到发送端发出的字节流，为应用程序提供可靠的通信服务。对可靠性要求高的通信系统往往使用 TCP 传输数据。

拥塞控制：
TCP 除了可靠传输服务外，另一个关键部分就是拥塞控制。
TCP 让每一个发送方根据所感知到的网络拥塞程度来限制其能向连接发送流量的速率。
可能有三个疑问：

TCP 发送方如何感知网络拥塞？
某个段超时了（丢失事件 ）：拥塞
超时时间到，某个段的确认没有来
原因1：网络拥塞（某个路由器缓冲区没空间了，被丢弃）概率大
原因2：出错被丢弃了（各级错误，没有通过校验，被丢弃）概率小
一旦超时，就认为拥塞了，有一定误判，但是总体控制方向是对的

有关某个段的3次重复ACK：轻微拥塞
段的第1个ack，正常，确认绿段，期待红段
段的第2个重复ack，意味着红段的后一段收到了，蓝段乱序到达
段的第2、3、4个ack重复，意味着红段的后第2、3、4个段收到了 ，橙段乱序到达，同时红段丢失的可能性很大（后面3个段都到了， 红段都没到）
网络这时还能够进行一定程度的传输，拥塞但情况要比上面好

将 TCP 发送方的丢包事件定义为：要么出现超时，要么收到来自接收方的 3 个冗余 ACK。

当出现过度的拥塞时，路由器的缓存会溢出，导致一个数据报被丢弃。丢弃的数据报接着会引起发送方的丢包事件。那么此时，发送方就认为在发送方到接收方的路径上出现了网络拥塞。



TCP 发送方如何限制其向连接发送流量的速率？
发送方感知到网络拥塞时，采用何种算法来改变其发送速率？


2.TCP 发送方如何限制其向连接发送流量的速率

当出现丢包事件时：应当降低 TCP 发送方的速率。
当对先前未确认报文段的确认到达时，即接收到非冗余 ACK 时，应当增加发送方的速率。

3.发送方感知到网络拥塞时，采用何种算法来改变其发送速率

即 TCP 拥塞控制算法（TCP congestion control algorithm）
包括三个主要部分：慢启动、拥塞避免、快速恢复，其中快速恢复并非是发送方必须的，慢启动和拥塞避免则是 TCP 强制要求的


#链表和数组有什么区别

数组和链表有以下不同：
（1）存储形式：数组是一块连续的空间，声明时就要确定长度。链表是一块可不连续的动态空间，长度可变，每个节点要保存相邻结点指针；
（2）数据查找：数组的线性查找速度快，查找操作直接使用偏移地址。链表需要按顺序检索结点，效率低；
（3）数据插入或删除：链表可以快速插入和删除结点，而数组则可能需要大量数据移动；
（4）越界问题：链表不存在越界问题，数组有越界问题。

数组便于查询，链表便于插入删除。数组节省空间但是长度固定，链表虽然变长但是占了更多的存储空间。



#在一个HTTPS连接的网络中，输入账号和密码并单击登陆按钮后，到服务器返回这个请求前，这期间经历了什么？
1 客户端打包请求。

       其中包括URL、端口、账号和密码等。使用账号和密码登陆应该用的是POST方式，所以相关的用户信息会被加载到body中。这个请求应该包含3个方面：网络地址、协议和资源路径。注意：这里用的是HTTPS，即HTTP+SSL/TLS，在HTTP上又加了一层处理加密信息的模块（相当于加了一个锁）。这个过程相当于客户端请求钥匙。

2 服务器端接受请求。

        一般客户端的请求会先被发送到DNS服务器中。DNS服务器负责将网络地址解析成IP地址，这个IP地址对应网上的一台计算机。这其中可能发生Hosts Hijack和ISP failure的问题。过了DNS这一关，信息就到服务器端，此时客户端和服务端的端口之间会建立一个socket连接。socket一般都是以file descriptor的方式解析请求的。这个过程相当于服务器端分析是否要想客户端发送钥匙模板。

3 服务器端返回数字证书。

       服务器端会有一套数字证书（相当于一个钥匙模板），这个证书会先被发送个客户端。这个过程相当于服务端向可独断发送钥匙模板。

4 客户端生成加密信息。

        根据收到的数字证书（钥匙模板），客户端就会生成钥匙，并把内容锁起来，此时信息已经被加密。这个过程相当于客户端生成钥匙并锁上请求。

5 客户端方发送加密信息。

       服务器端会收到由自己发送的数字证书加密的信息。这个时候生成的钥匙也一并被发送到服务端。这个过程相当于客户端发送请求。

6 服务端解锁加密信息。

         服务端收到加密信息后，会根据得到的钥匙进行解密，并把要返回的数据进行对称加密。这个过程相当于服务器端解锁请求，生成、加锁回应信息。

7 服务器端向客户端返回信息。

         客户端会收到相应的加密信息。这个过程相当于服务器端向客户端发送回应信息。

8 客户端解锁返回信息。

        客户端会用刚刚生成的钥匙进行解密，将内容显示在浏览器上。


#####为什么只在主线程刷新 UI？
1. UIKit 并不是一个线程安全的类，UI操作涉及到渲染访问各种View对象的属性，
如果异步操作下会存在读写问题，而为其加锁则会耗费大量资源并拖慢运行速
度。
2. 另一方面因为整个程序的起点 UIApplication是在主线程进行初始化，所有的用户
事件都是在主线程上进行传递（如点击、拖动），所以view只能在主线程上才能
对事件进行响应。而在渲染方面由于图像的渲染需要以60帧的刷新率在屏幕上
同时更新，在非主线程异步化的情况下无法确定这个处理过程能够实现同步更
新。



#集成相关三方库检测 卡顿

三方库常用的分析方法有三类。

第一类是监控FPS。
一般来说，我们约定60FPS即为流畅。那么反过来，如果App在运行期间出现了掉帧，即可认为出现了卡顿。
监控FPS的方案几乎都是基于CADisplayLink实现的。简单介绍一下CADisplayLink：CADisplayLink是一个和屏幕刷新率保持一致的定时器，一但 CADisplayLink 以特定的模式注册到runloop之后，每当屏幕需要刷新的时候，runloop就会调用CADisplayLink绑定的target上的selector。
可以通过向RunLoop中添加CADisplayLink，根据其回调来计算出当前画面的帧数。FPS的好处就是直观，小手一划后FPS下降了，说明页面的某处有性能问题。坏处就是只知道这是页面的某处，不能准确定位到具体的堆栈。

第二类是监控RunLoop。
RunLoop在BeforeSources和AfterWaiting后会进行任务的处理。可以通过信号量阻塞监控线程并设置超时时间，若超时后RunLoop的状态仍为BeforeSources或AfterWaiting，表明此时RunLoop仍然在处理任务，主线程发生了卡顿。

使用了 DispatchSemaphore 来等待主线程空闲，然后在主线程空闲时记录时间，并在一定时间内等待主线程事件的到来。如果主线程没有在规定时间内处理完事件，就记录超时次数，并输出日志。

第三类是Ping主线程。
Ping主线程的核心思想是添加主线程异步任务和自定义时间间隔，在自定义时间间隔过后如果主线程异步里面的任务没有执行，那么可以确认是主线程发生了卡顿。

OC项目常用的检测库有LXDAppFluecyMonitor，是通过检测Runloop实现的。swift项目常用的库有ANREye。是通过Ping主线程实现的。

2.2.使用Time Profiler进行检测

这是instruments自带的工具，但是使用起来会有些卡顿，体验不是很好，建议使用三方库进行检测。


#Swift的协议和Objective-C的代理有啥区别
1、在Swift中，协议可以被类、结构体和枚举遵循，而Objective-C的代理通常是由类实现的。
2、Swift支持类遵循多个协议，从而实现多重继承的效果。而在Objective-C中，一个类只能有一个代理，并且通过委托模式进行通信。
3、在Objective-C的代理中，很多方法都是可选的，即代理对象可以选择性地实现这些方法。而在Swift中，协议可以使用@optional关键字来定义可选的方法，但是Swift更加鼓励使用协议扩展（Protocol Extension）来提供默认实现，从而避免了在遵循协议的类中实现所有方法。
4、Objective-C的代理方法使用动态派发，而Swift中的协议方法可以使用静态派发。静态派发的特点是在编译时确定调用的方法，这使得Swift的协议方法调用更加高效。




#系统静态库和动态库区别
静态库在编译期被链接到目标代码中，动态库在运行期被载入到代码中。
动态库只有一份，多个程序共用。静态库则是会在每个app中拷贝一份。

使用静态库后可执行文件比使用动态库的可执行文件包可能更大，因为静态库提前（编译期）被全部添加到了可执行文件中
而动态库在不同的程序中,打包时并没有打包进去,只在程序运行时才会被你连接载入,如系统框架(UIKit,,Foundation等)
所以体积会小很多,但是苹果不让使用自己的动态库,否则审核就无法通过

静态库在链接时会被完整的复制到可执行文件中，当静态库被多次使用时，会进行多次复制，从而出现拷贝冗余，造成内存浪费。
优点：不受外部环境的影响，即使删除了静态库，对可执行文件不会造成影响，因为静态库在链接时就已经打包到了可执行文件中，成为 App 的一部分。
缺点：浪费内存空间。如果静态库进行了修改，可执行文件也需要重新编译生成。
 注意：.a是一个纯二进制文件，而.framework中除了有二进制文件之外还有资源文件。
 
 
动态库在链接时不会直接复制，打包时并没有打包进去,而只会存储指向动态库的引用，等到程序运行时才被载入到内存中，以供使用。
优点：只加载到内存中一次，内存共享，节约内存空间。可以独立于 App 进行更新，因为它并不是 App 的一部分。
缺点：运行时载入会造成性能损失，而且可执行文件依赖外部环境，一旦动态库进行了修改而出现了错误，则会导致程序出现问题。

#设计模式
1、Observer，观察者模式：定义对象间一对多的依赖关系，当一个对象的状态发生改变时，所有依赖于它的对象都得到通知自动更新。
2、代理模式：为其他对象提供一种代理以控制对这个对象的访问；
3、单例模式：确保一个类只有一个实例，并提供对该实例的全局访问。
4、装饰模式：动态地给一个对象添加一些额外的职责。就扩展功能来说，装饰模式相比生成子类更为灵活。



#为什么Swift能比OC更好的支持面向协议编程？
swift通过协议来定义接口，并通过扩展和默认实现来提供具体的实现。这样就使得类型之间的耦合度更低，代码更加容易重构和扩展;
扩展是Swift中另一个非常强大的特性，它允许我们在不改变原有类型定义的情况下，添加新的方法和属性。使用扩展可以使得代码的组织方式更加清晰、易于理解，同时也能提高代码的复用性。
Swift中协议可以继承和组合，我们可以通过定义多个协议来实现更加精细的接口定义


#iOS循环引用常见场景和解决办法

1、委托

遵守一个规则，委托方持有代理方的强引用，代理方持有委托方的弱引用。

实际场景中，委托方会是一个控制器对象，代理方可能是一个封装着网络请求并获取数据的对象。

2、Block
block捕获外部变量（一般是控制器本身或者控制器的属性）会导致循环引用

3、线程与计时器
不正确是使用 NSThread 和 NSTimer对象也可能导致循环引用


#atomic为什么不是线程安全

1、原子操作对线程安全并无任何安全保证。被atomic修饰的属性(不重载设置器和访问器)只保证了对数据读写的完整性，也就是原子性，但是与对象的线程安全无关。

2、线程安全已经有保障情况下、对性能也有要求的情况下可使用nonatomic替代atomic，当然也可以一直使用atomic。



atomic只是对属性的getter/setter方法进行了加锁操作，这种安全仅仅是get/set的读写安全，仅此之一，但是线程安全还有除了读写的其他操作,比如：当一个线程正在get/set时，另一个线程同时进行release操作，可能会直接crash。很明显atomic的读写锁不能保证线程安全。 

nonatomic在线程间切换操作属性的时候容易造成crash，是不安全的。

atomic在线程间切换操作属性可以保证不会crash，也会get到合法的有效数据，但是并不能保证获取的数据就是你的预期值。也是不安全的。



#iOS 单例实现与销毁

通过不同的途径获取对象，并不能保证对象的唯一性，，所以我们就需要封锁用户通过alloc和init以及copy来构造对象这条道路。
+ (PerfectSharedInstanceClass *)sharedInstance {
    static PerfectSharedInstanceClass *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //_sharedInstance = [[self alloc] init];
        _sharedInstance = [[super allocWithZone:NULL] init];
    });
    return _sharedInstance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self sharedInstance];
}

- (id)copyWithZone:(nullable NSZone *)zone {
    return [PerfectSharedInstanceClass sharedInstance];
}



/////
+ (instancetype)shareSM {

    static SMObject *class = nil;
    static dispatch_once_t predicate;

    NSLog(@"1:%ld", predicate);

    dispatch_once(&predicate, ^{
        NSLog(@"2:%ld", predicate);
        class = [[SMObject alloc] init];
    });

    NSLog(@"3:%ld", predicate);
    return class;
}


dealocSM 方法如何实现的呢？

+ (void)deallocSM {
    predicate = 0;
    class = nil;
}

//必须把static dispatch_once_t onceToken; 这个拿到函数体外,成为全局的.
同时 , 这两部分需要 从 shareSM 中提取出来，放到类中：

static SMObject *class = nil;
static dispatch_once_t predicate;

这样，就可以实现单例的销毁。




#app store显示的包大小是实际大小么，

比如boundle里面有个zip, 包含是解压后还是解压前

用户在 app store 上看到的包大小，
是：.app 文件的二进制部分被加壳后再经过 app slicing（程序切片）的大小


#包体积大小优化方案，优化大小最多的是那方面：主要是资源大小

查看无用的第三方库、单个功能是否可以剥离
查看是否有无用的资源
查看无用的图片\重复图片
查看是否有过大的图片；
已废弃业务，代码还在;

资源优化：废弃资源删除、图片压缩（本地、网络）
先删除无效资源，在处理压缩资源；

大于100KB就不要放入xcassets中了。大的图片可以考虑将图片转成WebP;
WebP在CPU消耗和解码时间上会比PNG高2倍，所以我们要在性能和体积上做取舍;

可以使用fdupes工具进行重复文件扫描，该工具的原理是通过校验所有的资源的MD5值，筛选出项目中重复的资源;

由于历史原因，存在很多僵尸类以及资源文件，逐步删除就行了，删除的时候可以利用一些检测工具批量删除，无用的类删除后，对应的资源也可以一起删除。

Build Settings->Optimization Level有几个编译优化选项，release版应该选择Fastest,Smalllest，这个选项会开启那些不增加代码大小的全部优化，并让可执行文件尽可能小，当然这些编译项早期是在工程生成时候xcode默认给工程配置好了

类/方法名长度：不太重要，一般才几百K

舍弃架构armv7，因为armv7用于支持4s和3gs, xcode14已经默认不支持了

音\视频压缩
符号剥离

strip在iOS中的作用是 剥掉目标文件中一些符号信息和调试信息，使文件变小。
strip：移除指定符号。在Xcode中默认strip是在Archive的时候才会生效，移除对应符号


分离第三方库的架构

性能检测：WBBlades
无用图片检测：LSUnusedResources
图片压缩：ImageOptim、tinypng、Webp
查看Mach-O内容：MachOView
静态检测代码：LinkMap结合Mach-O 或 Appcode静态检测

#CPU & GPU？
CPU（中央处理器）：对象的创建和销毁，对象属性的调整、布局计算、文本的计算和排版、图片格式转码和解码、图像的绘制（Core Graphics）。
GPU（图形处理器）：纹理的渲染（OpenGL）。


发出垂直同步信号（VSync）时，即将显示一页的数据。水平同步信号（HSync）发出时，就一行一行的显示。
按照60FPS的刷帧率，每隔16ms就会有一次VSync信号。
CPU计算时间正常或慢，GPU渲染时间长，这时来了VSync，
而这一帧还没有渲染完，那么就会出现掉帧现象，屏幕回去显示上一帧的画面。这样就产生了卡顿



# 一张图片到显示都干了什么
>>>>总结：
图片文件只有在确认要显示时，CPU 才会对其进行解压缩。因为解压缩是非常耗时性能的事情，解压过的图片就不会重复解压，会缓存起来。

图片渲染到屏幕的过程：
读取文件 -> 计算 Frame -> 图片解码 -> 解码后纹理图片位图数据通过数据总线交给 GPU 
-> GPU获取图片 Frame -> 顶点变换计算 -> 光栅化 -> 
根据纹理坐标获取每个像素点的颜色值（如果出现透明值需要将每个像素点的颜色*透明值度）-> 渲染到帧缓存区 -> 渲染到屏幕


CPU：计算 frame，图片解码，通过数据总线将需要绘制的纹理图片交给GPU。
GPU：纹理混合，顶点变换与计算，像素点的填充计算，渲染到帧缓冲区。

从磁盘中加载一张图片，这个时候的图片并没有解压缩
然后将生成的 UIImage 赋值给 UIImageView；
Core Animation对图片进行 copy 操作；

分配内存缓冲区用于管理文件 IO 和解压缩操作；
将文件数据从磁盘堵到内存中；
将压缩的图片数据解码成未压缩的位图形式（这是一个非常耗时的 CPU 操作）；
最后 Core Animation 中 CALayer 使用未压缩的位图数据渲染 UIImageView 的图层；
CPU 计算好图片的 Frame，对图片解压之后，就会交给 GPU 来做图片渲染。


渲染流程：

GPU 获取图片的坐标
将坐标交给顶点着色器（顶点计算）
将图片光栅化（获取图片对应屏幕上的像素点）
片元着色器计算（计算每个像素点的最终显示的颜色值）
从帧缓存区中渲染到屏幕上

由于图片压缩是一个非常耗时的 CPU 操作，并且它是默认在主线程中执行，
当需要加载的图片比较多的时候，就会对应用性能造成严重影响，尤其是在快速滑动列表时，这个问题尤其明显。


位图就是一个像素数组，数组中的每个像素点就代表图片中的一个点。
我们经常接触到的 JPEG 和 PNG 图片就是位图，而他们事实上是一种压缩的位图图形格式，
只不过 PNG 是无损压缩，并且支持 alpha 通道，而 JPEG 图片则是有损压缩，可以指定 0-100%的压缩比。
因此，在将磁盘中的图片渲染到屏幕之前，必须先要得到图片的原始像素数据，才能执行后续的绘制操作


解压缩原理
当未解压缩的图片将要渲染到屏幕时，系统会在主线程对图片进行解压缩，
而如果图片已经解压缩了，系统就不会再对图片进行解压缩，
而解压缩十分消耗性能，我们不希望让它在主线程执行，
因此就有了业内常用的解决方案，在子线程提前对图片进行解压缩。
强制解压缩的原理就是对图片进行重新绘制，得到一张新的解压缩后的位图。
其中用到的最核心的函数就是 CGBitmapContextCreate ：


#项目重构出发点，解决什么问题，怎么解决的，最后成果？

整体重构与部分重构；
使项目运行得更好，运行稳定，性能更好，更容易维护与管理，梳理一些混乱的业务逻辑；
项目性能优化，业务功能梳理合并，无效功能移除，整理代码逻辑；

代码风格统一，命名方式等；
调整目录划分，业务模块聚合等；
整理资源文件：删除无效图片、代码类
分离功能模块：重复功能组件、提示弹窗等；
公共管理类的调整优化合并；
常量宏等文件的聚合与分类：如颜色、字符串等处理；
启动加速：梳理启动时的网络请求、三方配置等；
性能排查优化，主要是富文本显示，动态高度，耗时操作等；
接口业务重构，提升响应，优化错误提示，是否有大数据请求；
UI界面风格统一，颜色、字体、按钮风格等；
减少功能的耦合性；
依赖三方相关的升级；



#设计一个组件 从哪些方面考虑

代码复用：相识功能或重复功能，考虑抽离处理；
完整独立性，组件上尽量不依赖其他外部设置：如宏、字体大小、颜色等；
使用性：简单易用，复杂功能可以支持数据模型配置控制；
维护扩展性：一些控制不要放在方法上，设置一个相关的数据配置模型等，尽量减少更新维护时需要大面积修改使用的地方；
事件回调：是否需要支持数据回调考虑；
暴露必要的接口，减少过多接口暴露，影响使用；
功能代码注释、及使用方法实例等；
接口隔离等；


#APP启动都干了什么？

1、main() 函数执行前；
加载可执行文件（App 的 .o 文件的集合）；
加载动态链接库，进行 rebase 指针调整和 bind 符号绑定；
Objc 运行时的初始处理，包括 Objc 相关类注册、category 注册、selector 唯一性检查等；
初始化，包括了执行 +load() 方法、attribute((constructor)) 修饰函数的调用、创建 C++ 静态全局变量；

2、main() 函数执行后；
main() 函数执行后的阶段，指的是从 main() 函数执行开始到 appDelegate 的 didFinishLaunchingWithOptions 方法里首屏渲染相关方法执行完成。
首页的业务代码都是要在这个阶段，也就是首屏渲染前执行的，主要包括了：
* 首屏初始化所需要配置文件的读写操作；
* 首屏列表大数据的读取；
* 首屏渲染的大量计算等；


一些必须的网络数据请求；
一些三方的初始化；
埋点数据；

3、首屏渲染完成后；
相关配置业务请求，如广告、消息、


#并发大怎么处理？

通过增加服务器数量来分担用户请求的压力，使用负载均衡实现请求的分发和处理，

采用异步处理方式，将耗时的操作放入消息队列等待处理，从而提高系统的并发处理能力

将系统拆分成多个小的服务单元，每个服务单元独立部署和扩展，从而有效分散高并发带来的压力

数据库读写分离：将读和写操作分开处理，通过主从复制或分布式数据库进行读写分离，提高数据库的并发性能。

数据库垂直切割：将数据按照业务模块划分，将不同模块的数据存储在不同的数据库中，减轻单一数据库的压力。

使用缓存：通过缓存技术（如Redis、Memcached）存储热点数据，减轻数据库的访问压力。

返回数据字段、业务等梳理，去掉无效相关业务的数据字段与查询

页面缓存：将静态页面缓存到内存中，减少后端查询和渲染的时间。
数据缓存：将经常访问的数据缓存到内存中，减轻数据库的压力。
分布式缓存：使用分布式缓存技术，将缓存数据分散到多台服务器上。
缓存更新策略：通过设置合理的缓存失效时间，在数据更新时及时更新缓存。

并发安全：在多线程环境中保证数据操作的原子性和一致性。
懒加载和延迟初始化：将不常用的资源或对象的加载和初始化延迟到真正需要时进行。
资源重用：合理使用连接池、线程池等资源池技术，避免频繁的资源创建和销毁。


#Cocoapods干了什么？
第三方包的一个包依赖管理工具
通过CocoaPods配置文件，可方便引入所需第三方开源库
第三方库版本管理简单，升级容易
Podfile 文件来描述项目的依赖关系，然后自动下载和集成所需的库
Podfile.lock文件控制管理三方库的版本
三方库的校验和，校验和的算法是对当前安装版本的三方库的podspec文件求SHA1
pod是通过各个库的podspec文件找到对应依赖的


#Cocoapod 怎么控制版本？具体用一个库流程
1.1 新创建工程，第一次引入pod库时。
此时会按照Podfile中给出的约束条件下载所需要的pod库，获得符合约束条件的最新版本。
将创建Podfile.lock文件，记录当前使用的所有pod库和版本

修改了Podfile文件，添加或删除了所依赖的pod库时
建议此时一定要使用pod install获取新的pod库或删除不要的pod库，若使用pod update其他库也会受到影响。
Podfile.lock会做相应的修改，记录当前使用的所有pod库和版本。
对于Podfile.lock中已有记录的其他pod库不会发生任何变化，不去检查是否有更新版本，即使有新的可用版本也不会更新。

需要将某个pod库更新到最新版本时，使用pod update PODNAME


而官网极其不推荐的做法，直接使用pod update
等价于对所有pod库执行一遍pod update PODNAME。
若有pod库的版本发生变更，则会更新Podfil.lock文件记录当前本地库的状态。 
不推荐的原因是所有库只要有新版本，都会发生更新，有可能导致整个工程变得不稳定；
另外，由于每个团队成员执行该命令的时间不一样，一旦中间有某个依赖库发布了新版本，这将导致团队内不同成员获得的pod库代码并不相同。


1、第一次获取pod库时，应使用pod install。
2、需要更新依赖库时，先使用pod outdated查看有哪些库有更新，再使用pod update PODNAME有目的的更新指定库。
3、提交代码时，请注意一定同时提交Podfile.lock文件，以便其他人能同步到与你相同的pod库版本。


#=====================

#UIWebView、WKWebView对比

UIWebView存在两个问题，一个是内存消耗比较大，另一个是性能很差。
WKWebView相对于UIWebView来说，性能要比UIWebView性能要好太多，刷新率能达到60FPS。内存占用也比UIWebView要小。

WKWebView是一个多进程组件，Network、UI Render都在【独立的进程中完成】。
由于WKWebView和App【不在同一个进程】，【如果WKWebView进程崩溃并不会导致应用崩溃】，仅仅是页面白屏等异常。
页面的载入、渲染等消耗内存和性能的操作，都在WKWebView的进程中处理，
处理后再将结果交给App进程用于显示，所以App进程的性能消耗会小很多。
WKWebView与 UIWebView 机制不同：加载过程中所有的请求都不经过 NSURLProtocol，也就是WKWebView无法拦截响应数据，


代理方法
WKWebView和UIWebView的代理方法发生了一些改变，WKWebView的流程更加细化了。
例如之前UI结束请求后，会立刻渲染到webView上。
而WKWebView则会在渲染到屏幕之前，会回调一个代理方法，代理方法决定是否渲染到屏幕上。
这样就可以对请求下来的数据做一次校验，防止数据被更改，或验证视图是否允许被显示到屏幕上。

除此之外，WKWebView相对于UIWebView还多了一些定制化操作。
重定向的回调，可以在请求重定向时获取到这次操作。
当WKWebView进程异常退出时，可以通过回调获取。
自定义处理证书。
更深层的UI定制操作，将alert等UI操作交给原生层面处理，而UI方案UIAlertView是直接webView显示的。



#WKWeb加载大文件会崩溃吗
不会崩溃，显示空白，为什么？

WKWebView 在运行时，[核心模块运行在独立进程中]，[与 App 进程独立]。
在一个客户端 App 中，多个 WKWebView 使用中会共享一个 UI 进程(与 App 进程共享)、共享一个 Networking 进程、每个 WKWebView 实例独享一个 WebContent 进程。


WKWebView(WebKit) 包含 3 种进程：UI Process, Networking Process, WebContent Process。
1、[UI Process]：[即 App 进程]，WKWebView(WebKit) 中部分模块运行在此进程，会负责启动其它进程。
2、[Networking Process]：即网络模块进程，主要负责 WKWebView 中网络请求相关功能；[此进程 App 中只会有启动一次]，多个 WKWebView 间共享。
3、[WebContent Process]：即 Web 模块进程，主要负责 WebCore, JSCore 相关模块的运行，是 WKWebView 的核心进程。此进程在 App 中会启动多次，每个 WKWebView 会有自己独立的 WebContent 进程。
各个进程之间通过 CoreIPC 进程通信。



NetworkProcess进程： 
主要负责 网络请求加载 ，所有的网页共享这一进程。与原生网络请求开发一致， NetworkProcess 也是通过封装的 NSURLSession 发起并管理网络请求的。但不同的是，这一过程中有较多的网络进度的回调工作以及各类网络协议管理，比如资源缓存协议、HSTS 协议、cookie 管理协议等。

WebContent进程： 
主要负责 页面资源的管理 ，包含前进后退历史， pageCache ，页面资源的解析、渲染。并把该进程中的各类事件通过代理方式通知给 UIProcess 。

UIProcess进程： 
主要负责 与 WebContent 进 行交互 ，与 APP 在同一进程中，可以进行 WebView 的功能配置，并接收来自 WebContent 进程的各类消息，配合业务代码执行任务的决策，例如是否发起请求，是否接受响应等。


#WKWebView 白屏问题(与处理）

WKWebView 白屏的原因在于 WebContent Process 的 crash，
当 WKWebView 在单独进程占用较大内存时，就会导致白屏，
此时 WKWebView.URL 会变成 nil，此时调用 reload 方法刷新已经失效。

WKWebView 白屏的原因在于 WebContent Process 的 crash，当 WKWebView 在单独进程占用较大内存时，就会导致白屏，此时 WKWebView.URL 会变成 nil，此时调用 reload 方法刷新已经失效。 解决方案
1、 [WKNavigtionDelegate 代理]
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView API_AVAILABLE(macosx(10.11), ios(9.0)) {
    [webView reload];
}
当 WKWebView 总体内存占用过大，页面即将白屏的时候，系统会调用上面的回调函数，
我们在该函数里执行[webView reload](这个时候 webView.URL 取值尚不为 nil）解决白屏问题。
在一些高内存消耗的页面可能会频繁刷新当前页面，H5侧也要做相应的适配操作。

2、[检测 webView.title是否为空] 
并不是所有H5页面白屏的时候都会调用上面的回调函数，
比如，在一个高内存消耗的H5页面上 present 系统相机，拍照完毕后返回原来页面的时候出现白屏现象
（拍照过程消耗了大量内存，导致内存紧张，WebContent Process 被系统挂起），但上面的回调函数并没有被调用。
在WKWebView白屏的时候，另一种现象是 webView.titile 会被置空, 
因此，可以在 viewWillAppear 的时候检测 webView.title 是否为空来 reload 页面。
综合以上两种方法可以解决绝大多数的白屏问题。


#WKWebView加载过程（DNS）

通过域名的方式请求服务器，请求前浏览器会做一个DNS解析，并将IP地址返回给浏览器。
浏览器使用IP地址请求服务器，并且开始握手过程。TCP是三次握手，如果使用https则还需要进行TLS的握手，握手后根据协议字段选择是否保持连接。
握手完成后，浏览器向服务端发送请求，获取html文件。
服务器解析请求，并由CDN服务器返回对应的资源文件。
浏览器收到服务器返回的html文件，交由html解析器进行解析。
解析html由上到下进行解析xml标签，过程中如果遇到css或资源文件，都会进行异步加载，遇到js则会挂起当前html解析任务，请求js并返回后继续解析。因为js文件可能会对DOM树进行修改。
解析完html，并执行完js代码，形成最终的DOM树。通过DOM配合css文件找出每个节点的最终展示样式，并交由浏览器进行渲染展示
结束链接。


#WKWeb怎么与原生交互：


#WKWeb怎么拦截网络请求、优化：



复用池
WKWebView第一次初始化的时候，会先启动webKit内核，并且有一些初始化操作，这个操作是非常消耗性能的。所以，复用池设计的第一步，是在App启动的时候，初始化一个全局的WKWebView。


类似热更新：
已有方案及其不足
1、NSURLProtocol 拦截：目前通过搜索引擎可以检索到的类似方案使用 NSURLProtocol 拦截 WKWebView 请求并进行替换。但是，由于 WKWebView 独立进程的特点，拦截其请求需要使用私有接口，存在兼容性风险以及上架被拒的风险。

WKWebView ，在 iOS 开发中高效的引入 Web 内容实现 Hybrid 应用成为可能。
驱动 Hybrid 方案大行其道的根本原因还是 Hybrid 应用实在 「太香了」：

发挥前端超强的表现能力
光明正大地实现热更新
合理设计的情况下降低跨平台开发成本
当然，Hybrid 应用目前仍然是不完美的，其中存在最显著的问题就是“资源加载”带来的开销。

实际应用情况显示，受到用户网络状况影响，即便使用CDN，完全从网络加载一个500KB左右大小的Web App到本地WebView中展示，用户还是能明显感受到界面展示的延迟。介绍的方案即解决以上述问题作为目标。


[实现思路：离线包]
前端项目静态资源打包成「离线包」，在 App 运行时 下载（解压）至用户本地。WKWebView 从用户本地加载所需资源。

一、离线包的分发
已经指出，在该方案中，所有的静态资源均在离线包中提供，App 运行时下载离线包。为了节约流量、提高效率，对于离线包的分发和下载应该引入版本控制策略。此处以我使用的方案举例介绍、作为参考，具体情况需要具体分析。
对象存储存储及CDN实现离线包的分发，在对象存储中放置离线包文件和一个额外的 info.json 文件：
{
    "packageName": "kernel-b7e36791-2092-443b-8c49-d934c3aed6ad.zip",
    "fileList": [
        "index.html",
        "logo.a0a62428.png",
        "main.8bfaf9c9.js",
        "main.fd6a9d49.css",
        "manifest.json"
    ]
}
其中的 packageName 字段表示当前最新的离线包名称。
App 会在合适的时机（每次启动时）请求 info.json，获取当前最新的离线包名称，可以通过离线包名称组合出离线包的下载地址。

#WKWebView - 拦截网络请求 && 离线化

WKURLSchemeHandler 协议的使用，以及如何加载离线化资源。
由于WebKit内部限制，我们无法拦截 https/http 等协议，会导致崩溃，原因在于 WebKit 有内置协议白名单，这次协议由内部进行处理。
// 下面代码会崩溃
[webViewConfiguration setURLSchemeHandler:
    [[MyWKURLSchemeHandler alloc] init] forURLScheme:@"https"];

解决方案： iOS 11 系统提供了 handlesURLScheme 方法，判断 WKWebView 是否能处理 urlScheme ，我们可以 【hook 此方法】，来支持自己处理 http/https 请求。
/* @abstract Checks whether or not WKWebViews handle the given URL scheme by default.
 @param scheme The URL scheme to check.
 */
+ (BOOL)handlesURLScheme:(NSString *)urlScheme API_AVAILABLE(macos(10.13), ios(11.0));


[将webView的请求修改为herald-hybrid开头]

例如你跟后台约定，在url中包含/myhybrid/字段的请求，都需要拦截
那你就需要判断你的url是否包含该字段，然后替换http开头为herald-hybrid，这样你的其他请求就不会被拦截
NSString *urlStr = @"http://hybrid.myseu.cn/myhybrid/index.html";

if ([urlStr containsString:MOJI_URL_WORD_KEY]) {
    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"http" withString:MOJI_URL_SCHEME_KEY];
}

[self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];



需求，拦截WKWebview中的所有网络请求，并且对亲够Request的httpheader中添加字段token，等信息。
实现技术，利用NSURLProtocol。
首先实现一个继承自NSURLProtocol的自定义类：MYSchemeURLProtocol,完整的代码实现如下：
        
在需要进行拦截的WebViewController中，注册MYSchemeURLProtocol




#==================
#内存泄漏场景：

#排查问题场景：

#IPv4、IPv6
IPv4采用32位地址长度，只有大约43亿个地址，基本早就被分配完毕，而IPv6采用128位地址长度，几乎可以不受限制地提供地址。

在IPv6的设计过程中除解决了地址短缺问题以外，还考虑了在IPv4中解决不好的其它一些问题，主要有端到端IP连接、服务质量（QoS）、安全性、多播、移动性、即插即用等。
与IPv4相比，IPv6主要有如下一些优势。第一，明显地扩大了地址空间。IPv6采用128位地址长度，几乎可以不受限制地提供IP地址，从而确保了端到端连接的可能性。第二，提高了网络的整体吞吐量。由于IPv6的数据包可以远远超过64k字节，应用程序可以利用最大传输单元（MTU），获得更快、更可靠的数据传输，同时在设计上改进了选路结构，采用简化的报头定长结构和更合理的分段方法，使路由器加快数据包处理速度，提高了转发效率，从而提高网络的整体吞吐量。第三，使得整个服务质量得到很大改善。报头中的业务级别和流标记通过路由器的配置可以实现优先级控制和QoS保障，从而极大改善了IPv6的服务质量。第四，安全性有了更好的保证。


#==============
#什么是DNS解析？
域名到IP地址的映射，DNS解析请求采用UDP数据报且明文的。
解析过程，客户端向DNS服务发送域名请求，D
NS服务根据域名返回对应的IP地址，客户端根据IP地址请求Server端服务器。


#说说DNS的过程（提到了本地缓存

DNS，全称Domain Name System，域名系统，
是一个记录域名和Ip地址相互映射的一个系统，能够将用户访问互联网时使用的域名地址转换成对应的IP地址，
而不用使用者去记住数量众多的IP地址。通过域名得到域名对应的IP地址的过程被称为域名解析。
DNS运行于[UDP协议之上]，使用的端口为53

1、首先客户端位置是一台电脑或手机，在打开浏览器以后，比如输入http://www.zdns.cn的域名，
它首先是由浏览器发起一个DNS解析请求，
如果本地缓存服务器中找不到结果，则首先会向根服务器查询，
根服务器里面记录的都是各个顶级域所在的服务器的位置，
当向根请求http://www.zdns.cn的时候，根服务器就会返回.cn服务器的位置信息。

2、递归服务器拿到.cn的权威服务器地址以后，就会寻问cn的权威服务器，
知不知道http://www.zdns.cn的位置。
这个时候cn权威服务器查找并返回http://zdns.cn服务器的地址。

3、继续向http://zdns.cn的权威服务器去查询这个地址，由http://zdns.cn的服务器给出了地址：202.173.11.10
4、最终才能进行http的链接，顺利访问网站。
5、这里补充说明，一旦递归服务器拿到解析记录以后，就会在本地进行缓存，
如果下次客户端再请求本地的递归域名服务器相同域名的时候，就不会再这样一层一层查了，
因为本地服务器里面已经有缓存了，这个时候就直接把http://www.zdns.cn的A记录返回给客户端就可以了。



#DNS的查询方式有两种：
分别为递归查询（recursion）和迭代查询（iteration）。
递归查询：
客户端发起一个DNS解析请求，若本地DNS服务器若不能为客户端直接解析域名
，则域名服务器会代替客户端（下级服务器）向域名系统中的各分支的上下级服务器进行递归查询，
直到有服务器响应回答了该请求后，将该请求结果返回客户端。在此期间，客户端将一直处于等待状态。

迭代查询：
客户端（下级服务器）发起一个DNS解析请求后，若上级DNS服务器并不能直接提供该DNS的解析结果，
则该上级DNS服务器会告知客户端（下级服务器）另一个可能查询到该DNS解析结果的DNS服务器IP，
客户端（下级服务器）再次向这个DNS服务器发起解析请求，如此类推，直到查询到对应的结果为止。

#DNS劫持问题：
因为DNS解析使用UDP数据报且是明文的。
客户端发送域名请求时，容易被钓鱼DNS劫持返回错误的IP地址。

#DNS劫持与HTTP有什么关系？
没有关系，DNS劫持是在HTTP建立连接之前。 DNS解析通过UDP数据报，访问53端口。


#DNS 劫持解决方案：
1、HTTPDNS服务器，绕过运营商Local DNS，避免域名劫持问题，
基于HTTP协议的设计适用于几乎所有的网络环境，同时保留了鉴权、HTTPS等更高安全性的扩展能力，避免恶意攻击劫持行为。
商业化的HTTPDNS服务缓存管理有严格的SLA保障，避免了Local DNS的缓存污染问题。
由于HttpDNS是通过 IP直接请求http获取服务器A记录地址，不存在向本地运营商询问Domain解析过程，所以从根本避免了劫持问题。
HttpDNS的原理非常简单，主要有两步：

A、客户端直接访问HttpDNS接口，获取业务在域名配置管理系统上配置的访问延迟最优的IP。（基于容灾考虑，还是保留次选使用运营商LocalDNS解析域名的方式）
B、客户端向获取到的IP后就向直接往此IP发送业务协议请求。以Http请求为例，通过在header中指定host字段，向HttpDNS返回的IP发送标准的Http请求即可。

2、长连接。


#DNS缓存存在哪？有效期多少？可以设置吗？
    
DNS缓存设置的时间长度可以根据不同场景和需求进行调整，一般范围从几分钟到48小时不等。
其中一个关键参数是缓存记录的“生存时间”（TTL，Time-To-Live）、它指示了DNS记录在缓存中保存的时长之前需要进行刷新。
[TTL]的设定对网站的访问速度和域名解析的灵敏性均有影响。
这通常在DNS记录创建时通过域名管理界面进行设置，并会被DNS服务器遵守。
例如，如果TTL设置为1800秒（即30分钟），则意味着每30分钟DNS信息就会被刷新一次。


#什么是DNS缓存
DNS缓存是指存储在客户端、服务器或路由器上的DNS信息，它有助于减少DNS查询次数，提高网站访问速度。
DNS缓存包含了网站的域名和对应的IP地址记录，当用户尝试访问一个网站时，系统会首先检查本地的DNS缓存，如果找到了对应的记录，就不必去向DNS服务器发起请求，从而节省了解析时间。

#如何设置DNS缓存的TTL
DNS缓存的TTL设置通常在创建DNS记录时进行。操作流程涉及访问域名注册商的管理平台或直接在DNS服务器上进行设置。

设置过程
域名所有者会通过域名注册商提供的控制面板来设置DNS记录的TTL。在控制面板中，可以找到DNS管理或类似命名的选项，进入后可以看到所有的DNS记录。选择要修改的记录，输入新的TTL值，然后保存。这个值表示DNS记录在其他服务器的缓存中存放的最大时限。

TTL的选择
选择TTL时需要权衡性能和灵活性。较短的TTL可以确保在DNS记录需要变更时快速生效，但这也意味着更频繁的DNS查询和潜在的性能影响。较长的TTL减少了查询次数，但在需要变更DNS时可能导致延迟较长的时间才会生效。


#DNS缓存的作用
减少延迟：DNS解析过程中的查询需要时间，有了缓存，用户访问之前已解析过的网址不需要再次完整的查询过程，从而减少了延迟。
减轻服务器压力：DNS服务器在响应大量并发请求时压力较大，通过缓存可以显著减少对服务器的请求量，从而降低了服务器的工作负荷。

#DNS缓存的风险及管理
虽然DNS缓存有诸多好处，但它也带来了一些潜在的风险。
不正确的DNS信息如果被缓存：那么在TTL到期之前，所有依赖该缓存的客户端都会受到影响。
DNS缓存有被污染的风险：即缓存了错误的或恶意的域名解析结果。

风险管理
定期清理本地缓存：用户和管理员可以通过重启路由器、清除本地DNS缓存等方式减少缓存相关风险。
使用安全的DNS解析服务：选用具有安全防护和即时更新能力的DNS服务提供商，可以避免很多缓存污染问题。


对于稳定不变的服务
如果服务的IP地址很少变动，可以采用较长的TTL设置，例如24小时或者更长，这样可以减少DNS查询的频率，加快用户访问速度。

对于经常变动的服务
若服务需要经常变更IP地址，如动态云服务，应设置较短的TTL，比如5分钟到1小时之间，以确保变更可以快速生效。


#DNS缓存的设置方式有哪些？
DNS缓存的设置方式主要有两种：本地DNS缓存设置和服务器DNS缓存设置。
本地DNS缓存设置是指在客户端设备上设置DNS缓存的时效，而服务器DNS缓存设置是指在DNS服务器上设置缓存的过期时间。

#DNS缓存的时效一般有多长时间？
DNS缓存的时效是根据缓存的过期时间来决定的，该过期时间一般由DNS服务器的管理员来设置。
具体的时效时间可以根据实际需求和网络环境来进行调整，通常在数小时到数天之间。
较短的缓存时效可以提供更快的DNS解析速度，但可能增加DNS服务器的负载；
较长的缓存时效可以减少DNS解析请求，但可能导致DNS记录信息不及时更新。


#如何优化DNS缓存的设置？要优化DNS缓存的设置，可以考虑以下几点：
根据网络环境和访问需求，合理设置缓存时效。
根据网站的更新频率和重要程度，可以将缓存时效分配给不同类型的DNS记录，以获得更好的性能和可靠性。
定期监控和更新DNS缓存。及时清除过期的DNS缓存，并确保新的DNS记录能够及时生效，以防止出现解析错误或访问延迟。
考虑使用内容分发网络（CDN）。CDN可以通过将网站内容缓存在全球分布的节点上，提供更快的DNS解析和访问速度，从而改善用户体验。
配置本地DNS缓存。在客户端设备上启用本地DNS缓存可以减少对远程DNS服务器的依赖，提供更快的响应时间和更好的访问性能。


#直接使用HttpDNS问题

1、HTTP请求头HOST字段设置 
要求所有的请求都必须传递HOST头部，HOST头部值为域名。
如果使用IP地址对URL中的域名进行了替换，那么网络库会将IP地址作为HOST头部的内容，会导致服务端的解析异常(服务端认可的是您的域名信息，而非IP信息)。
为了解决这个问题，可以主动设置HTTP请求HOST字段的值，以HttpUrlConnection为例：

// 在header中增加域名，防止运营商懵逼
[mutableRequest setValue:url.host forHTTPHeaderField:@"HOST"];

2、HTTP请求头cookie字段设置

由于使用IP地址对host进行了替换，根据iOS已有的cookie携带规则，
iOS找不到替换之后的host对应的cookie，从而不会将请求原URL的cookie设置到请求头中。

iOS对URL查找cookie的规则是：If the domain does not start with a dot, then the cookie is only sent to the exact host specified by the domain. If the domain does start with a dot, then the cookie is sent to other hosts in that domain as well, subject to certain restrictions. See [RFC 6265](https://tools.ietf.org/html/rfc6265.html) for more detail
所以需要我们自己在请求头部加上cookie。

// 获取符合规则的第一个cookie
- (NSString *)getRequestCookieHeaderForURL:(NSURL *)URL {
    NSArray *cookieArray = [self getCookiesForURL:URL];
    if (cookieArray != nil && cookieArray.count > 0) {
        NSDictionary *cookieDic = [NSHTTPCookie requestHeaderFieldsWithCookies:cookieArray];
        if ([cookieDic objectForKey:@"Cookie"]) {
            NSString *returnString = cookieDic[@"Cookie"];
            return returnString;
        }
    }
    return nil;
}

- (NSArray <NSHTTPCookie *> *)getCookiesForURL:(NSURL *)URL
{
    NSMutableArray *cookieArray = [NSMutableArray array];
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [cookieStorage cookies]) {
        // filterBlock为根据URL选择cookie的方式，与iOS选择cookie方式保持一致
        if (filterBlock(cookie, URL)) {
            [cookieArray addObject:cookie];
        }
    }
    return cookieArray;
}

客户端验证服务器证书domain不匹配[1]
发送HTTPS请求首先要进行SSL/TLS握手，握手过程大致如下：
    1.    客户端发起握手请求，携带随机数、支持算法列表等参数。
    2.    服务端收到请求，选择合适的算法，下发公钥证书和随机数。
    3.    客户端对服务端证书进行校验，并发送随机数信息，该信息使用公钥加密。
    4.    服务端通过私钥获取随机数信息。
    5.    双方根据以上交互的信息生成session ticket，用作该连接后续数据传输的加密密钥。
上述过程中，和HTTPDNS有关的是第3步，客户端需要验证服务端下发的证书，验证过程有以下两个要点：
    1.    客户端用本地保存的根证书解开证书链，确认服务端下发的证书是由可信任的机构颁发的。
    2.    客户端需要检查证书的domain域和扩展域，看是否包含本次请求的host。
    
如果上述两点都校验通过，就证明当前的服务端是可信任的，
否则就是不可信任，应当中断当前连接。
当客户端使用HTTPDNS解析域名时，请求URL中的host会被替换成HTTPDNS解析出来的IP，
所以在证书验证的第2步，会出现domain不匹配的情况，导致SSL/TLS握手不成功。

针对domain不匹配问题，可以采用如下方案解决：hook证书校验过程中第2步，将IP直接替换成原来的域名，再执行证书验证。
【注意】基于该方案发起网络请求，若报出SSL校验错误，比如iOS系统报错kCFStreamErrorDomainSSL, -9813; The certificate for this server is invalid，Android系统报错System.err: javax.net.ssl.SSLHandshakeException: java.security.cert.CertPathValidatorException: Trust anchor for certification path not found.，请检查应用场景是否为SNI（单IP多HTTPS域名）。

方法为在客户端收到服务器的质询请求代理方法
-URLSession:task:didReceiveChallenge:completionHandler:中，
首先从header中获取host(第一点注意事项：HTTP请求头HOST字段设置)，
从header中如果没有取到host，就去URL中获取host(降级为LocalDNS解析时不进行替换)，
然后拿着host在自己的方法-evaluateServerTrust:forDomain:中创建SSL Policy证书校验策略，然后对证书进行校验。

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * __nullable credential))completionHandler
{
    if (!challenge) {
        return;
    }
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    NSURLCredential *credential = nil;
    /*
     * 获取原始域名信息。
     */
    NSString* host = [[self.request allHTTPHeaderFields] objectForKey:@"host"];
    if (!host) {
        host = self.request.URL.host;
    }
    // 检查质询的验证方式是否是服务器端证书验证，HTTPS的验证方式就是服务器端证书验证
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        if ([self evaluateServerTrust:challenge.protectionSpace.serverTrust forDomain:host]) {
            disposition = NSURLSessionAuthChallengeUseCredential;
            credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        } else {
            disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        }
    } else {
        disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    }
    // 对于其他的challenges直接使用默认的验证方案
    completionHandler(disposition,credential);
}

- (BOOL)evaluateServerTrust:(SecTrustRef)serverTrust
                  forDomain:(NSString *)domain {
    /*
     * 创建证书校验策略
     */
    NSMutableArray *policies = [NSMutableArray array];
    if (domain) {
        [policies addObject:(__bridge_transfer id)SecPolicyCreateSSL(true, (__bridge CFStringRef)domain)];
    } else {
        [policies addObject:(__bridge_transfer id)SecPolicyCreateBasicX509()];
    }
    /*
     * 绑定校验策略到服务端的证书上
     */
    SecTrustSetPolicies(serverTrust, (__bridge CFArrayRef)policies);
    /*
     * 评估当前serverTrust是否可信任，
     * 官方建议在result = kSecTrustResultUnspecified 或 kSecTrustResultProceed
     * 的情况下serverTrust可以被验证通过，https://developer.apple.com/library/ios/technotes/tn2232/_index.html
     * 关于SecTrustResultType的详细信息请参考SecTrust.h
     */
    SecTrustResultType result;
    SecTrustEvaluate(serverTrust, &result);
    return (result == kSecTrustResultUnspecified || result == kSecTrustResultProceed);
}

服务器使用多个域名和证书问题SNI[1]


#=================

#说说Http、Https、SSL、三次握手、四次挥手
参考：../LearnDemo/netRsaFile.md

#=================

TCP的拥塞控制 慢开始 

#请简述TCP的慢启动过程？

建立连接后，会先只发1条， 然后发2条，接着再发4条，逐步增加。
这个过程叫[“慢启动”]。
这个1、2、4递增的数量被称之为拥塞窗口cwnd

当到达慢启动门限ssthreshold时，会变成每次都增加1条。
这个过程叫拥塞避免过程， 也有叫他拥塞避免算法的
可以理解为tcp感觉到有风险了，于是开始慢慢地、小心翼翼地1条1条地添加发送条数。

随着每次发送的数量越发越多， 最终会超出带宽限制，于是就会有某条报文发生超时。
有可能是发的中途丢了， 亦或者是返回的数据全阻塞住了，一条都回不来。
当发送端检测到发生超时时，就会让慢启动门限为当前窗口的<一半>
[ssthreshold = 当前拥塞窗口cwnd/2]

接着cwnd 重新置为1，从新开始 慢启动算法。
这样的好处在于可以检测到每次发送的上限，动态调整发送窗口。
上面的过程叫做超时重传。
[注意发生超时重传时， cwnd会重置成1]


#那么TCP客户端是怎么判断报文发送超时的呢？（拥塞）
每次发送数据包的时候， 都会有一个相应的计时器，一旦超过 RTO(超时时间） 而没有收到 ACK， TCP就会重发该数据包。
没收到 ACK 的数据包都会存在重传缓冲区里，等到 ACK 后，就从缓冲区里删除。


#上面提到的超时时间RTO是怎么来的？万一设得太大可能导致很迟才能反应过来， 设得太小则可能导致每条都超时

通过“每次报文的往返时间样本”和“之前样本的偏差值”动态计算出来的。
RTO ： 超时重传时间
等于平均往返时间 加上 4倍偏差值


#上面提到的ACK超时判断会不会太久了？ 假如只是发的时候丢了中间部分报文而已， 但大部分报文ACK还能正常返回，也要一直等超时吗？

如果能正常接收其他报文的ACK， 只是中间的部分报文丢了， 则有另一个办法。（轻微拥塞）
接收端有一个冗余确认机制：
    •发送端A 发送 1、2、3、4、5四条
    •但是B接收端只收到1、2、4、5，而3因为网络拥塞丢了。
    •于是B会发送ack=3而不是ack=5 给A。这就是冗余确认机制，只发送缺失那部分的ack，后面的4和5都不管。
    •A收到ack=3后， 继续发送3、4、5、6、7， 结果3还是丢了。
    •于是B又发送ack=3。
当A发现连续3次收到了ack=3时，就会觉察到不对劲，我都发3次了你还是说没收到，可你又能正常返回其他ACK给我，是不是我发的太多了？
上面这个判断3次的重传算法叫“快重传”。

[快速重传：]
当发送方连续收到相同的确认序号（即，接收方对同一个数据包进行重复确认）时，发送方可以推断某个数据包丢失了。在这种情况下，发送方不等待超时定时器的触发，而是立即重传该丢失的数据包。这种快速重传机制能够更快地恢复丢失的数据包，减少等待时间和传输延迟。

于是A会马上进入 “快速恢复”。
和之前类似，慢启动门限ssthreshold = 当前拥塞窗口cwnd/2
但是！！ 新的拥塞窗口cwnd会设置成ssthreshold/2[当前的四分之一]， 而不是1。
而且不会走慢启动倍增的那种，而是走拥塞避免， [逐步+1]的那种。

#前面“超时重传”的时候，是变成从1开始慢启动， 为什么这个“快重传”却是从ssthreshold/2开始，并且走拥塞避免？ 为什么会有这个区别？

发生超时重传时： 是比较严重的情况， 超时时间内一个ACK都没收到。就好像来回数据都凭空消失了。
快速重传发生时： 还是能收到部分ack的， 只是丢失了部分数据， 说明拥塞没那么严重，于是可以大胆一点将cwnd削减到1/4， 而不是直接从1开始。


#为什么需要快重传和快恢复，什么场景下使用
快速重传和快速恢复
有时发送端可能接收到重复的确认报文段，如TCP报文段丢失 或者接收端收到乱序的TCP报文段并重排的时候，拥塞控制算法需要判断当收到重复确认的报文。网络是否真的拥塞 或者TCP报文段是否真的丢失。
具体的做法是当发送端连续收到三个重复的确认报文段 就认为是拥塞发生。就会启动快速重传和快速恢复算法来吃处理拥塞

#拥塞控制的目的是：
提高网络利用率
降低丢包率
保证网络资源对每条数据流的公平性


拥塞控制标准文档是RFC 5861 四个部分：
慢启动（slow start）
拥塞避免(congestion avoidance)
快速重传(fast retransmit)
快速恢复（fast recovery）



#====================

#操作系统的内存管理 分页、分段段页式

基本分页存储管理的基本概念

将内存空间分为一个个大小相等的分区（比如:每个分区4KB），每个分区就是一个**“页框”，或称“页帧”、“内存块”、“物理块”。
每个页框有一个编号，即“页框号”(或者“内存块号”、“页帧号”、“物理块号”)页框号从o开始。**

将用户进程的地址空间也分为与页框大小相等的一个个区域，称为“页”或“页面”。
每个页面也有一个编号，即“页号”，页号也是从o开始。
（注:进程的最后一个页面可能没有一个页框那么大。因此，页框不能太大，否则可能产生过大的内部碎片)

操作系统以页框为单位为各个进程分配内存空间。
进程的每个页面分别放入一个页框中。也就是说，进程的页面与内存的页框有一一对应的关系。
各个页面不必连续存放，也不必按先后顺序来，可以放到不相邻的各个页框中。

分段
进程的地址空间:按照程序自身的逻辑关系划分为若干个段，每个段都有一个段名(在低级语言中，程序员使用段名来编程)，每段从0开始编址
内存分配规则:以段为单位进行分配，每个段在内存中占据连续空间，但各段之间可以不相邻。

段表
程序分多个段，各段离散地装入内存，为了保证程序能正常运行，就必须能从物理内存中找到各个逻辑段的存放位置。为此，需为每个进程建立一张段映射表，简称**“段表”。**
每个段对应一个段表项，其中记录了该段在内存中的起始位置（又称“基址”）和段的长度。
各个段表项的长度是相同的。例如:某系统按字节寻址，采用分段存储管理，逻辑地址结构为（段号16位,段内地址16位)，因此用16位即可表示最大段长。物理内存大小为4GB（可用32位表示整个物理内存地址空间)。


#堆和栈的区别:
1，栈区（stack）由编译器自动分配释放，存放函数（方法）的参数值，局部变量的值等，栈是由高地址向低地址扩展的数据结构，是一块连续的内存区域。栈顶的地址和栈的最大容量是系统预先规定好的。
2，堆（heap）一般有程序员分配释放，是由低地址向高地址扩展的数据结构，是不连续的内存区域（堆获得的空间比较灵活）。
3，全局区：全局变量和静态变量的存储是放在一块的，初始化的全局变量和静态变量在一块，未初始化的在相邻的另一块区域，程序结束后由系统释放。
4，文字常量区：常量字符串存在此处。由系统释放
5.程序代码区：存放代码的二进制代码。
注意：
1，碎片问题：由于堆是不连续的内存区间，如果频繁的开辟／删除，会造成内存空间的不连续，从而造成大量的碎片，导致程序效率降低。对于栈来说，总从先进后出，有次序的一一对应，不会导致内存碎片。
2，内存分配方式：堆都是动态分配的，没有静态分配的堆。栈有两种分配方式，静态和动态，静态分配是由编译器完成的，比如局部变量的分配，动态分配是由alloca函数进行分配，但是栈的动态分配也是由编译器进行释放，无需我们手工进行。



#什么情况下会stackoverflow//堆栈什么时候真的溢出？
堆栈溢出（Stack Overflow）
通常是指程序中局部变量、函数调用栈等内存分配方式导致的内存溢出。
当程序中的堆栈空间不足以容纳当前函数调用所需的所有数据时，就会发生堆栈溢出。

堆栈溢出的常见原因包括：
1、递归调用过深：递归函数在执行时会不断调用自身，如果递归层数过多，就会导致堆栈溢出。
2、局部变量过多或过大：函数中声明的局部变量会存储在堆栈中，如果一个函数中声明了太多或太大的局部变量，就会导致堆栈溢出。
3、堆栈空间限制较小：某些操作系统或编程环境可能设置了较小的堆栈空间限制，导致程序无法分配足够的堆栈空间。

堆栈溢出的应用场景包括：
网站开发：网站开发中常常会使用递归或大量局部变量，容易导致堆栈溢出。
游戏开发：游戏开发中常常会使用递归或大量局部变量，容易导致堆栈溢出。
数据结构和算法：某些数据结构和算法的实现可能会导致堆栈溢出，例如递归实现的排序算法。



#iOS/Mac栈的大小是多少？
1. iOS上主线程栈空间大小为1MB
2. iOS上子线程栈空间大小为512KB
3. Mac OS上主线程栈大小为8MB
PS：对于子线程，线程的栈大小是在线程创建的时候就创建好的，但是只有实际使用到的时候才会分配到具体内存；同时，子线程能够允许的最小栈大小为16KB，且栈的大小必须是4KB的整数倍。

1.栈上变量直接分配内存长度超过栈空间大小,如下
int buf[1024*1024] = {0}
对应的崩溃日志，一般情况下遇见有"Stack Guard"的关键字，就表示程序发生栈溢出导致闪退了

2.间接使用操作栈上内存超限的函数，包括但不限于以下函数
void *memcpy(void *__dst, const void *__src, size_t __n);
void *memmove(void *__dst, const void *__src, size_t __len);
char *strcpy(char *__dst, const char *__src);
char *strncpy(char *__dst, const char *__src, size_t __n);

3.无限递归调用


#怎么避免栈溢出崩溃、优化？
优化代码：通过优化代码结构、减少递归层数、减少局部变量数量等方式来避免堆栈溢出。
增加堆栈空间：在某些编程环境中，可以通过增加堆栈空间限制来避免堆栈溢出。
1.栈上申请内存不要超过512KB，建议超过100KB以上的内存申请，都使用堆上的内存分配方式，“malloc”,“calloc”等
2. 使用操作内存读写的系统函数时，保证大内存的内存操作在堆上进行
3. 避免使用递归，所有的递归都可以使用循环实现。



#进程与线程的区别，切换开销 

根本区别：进程是操作系统资源分配的基本单位，而线程是任务调度和执行的基本单位；

开销方面：每个进程都有独立的代码和数据空间（程序上下文），程序之间的切换会有较大的开销；
线程可以看做轻量级的进程，同一类线程共享代码和数据空间，每个线程都有自己独立的运行栈和程序计数器（PC），线程之间切换的开销小。

所处环境：在操作系统中能同时运行多个进程（程序）；
而在同一个进程中有多个线程同时执行（通过CPU调度，在每个时间片中只有一个线程执行）；

内存分配：系统在运行的时候会为每个进程分配不同的内存空间；
而对线程而言，除了CPU外，系统不会为线程分配内存（线程所使用的资源来自其所属进程的资源），线程组之间只能共享资源；

包含关系： 操作系统中的每一个进程中都至少存在一个线程,
一个进程可拥有多个线程,一个线程只属于一个进程,线程也被称为轻权进程或者轻量级进程；



#什么是虚拟内存?
虚拟内存是操作系统为每个进程提供的一种抽象，
每个进程都有属于自己的、私有的、地址连续的虚拟内存，
当然我们知道最终进程的数据及代码必然要放到物理内存上，
那么必须有某种机制能记住虚拟地址空间中的某个数据被放到了哪个物理内存地址上，
这就是所谓的[地址空间映射]，也就是虚拟内存地址与物理内存地址的映射关系，

那么操作系统是如何记住这种映射关系的呢，
答案是[页表]，页表中记录了虚拟内存地址到物理内存地址的映射关系，

有了页表就可以将虚拟地址转换为物理内存地址了，这种机制就是虚拟内存。
每个进程都有自己的虚拟地址空间，进程内的所有线程共享进程的虚拟地址空间。


#为什么进程切换开销大,线程切换开销低呢?

进程都有自己的虚拟地址空间，把虚拟地址转换为物理地址需要查找页表，
页表查找是一个很慢的过程，因此通常使用Cache来缓存常用的地址映射，
这样可以加速页表查询，这个Cache就是TLB，
我们不需要关心这个名字只需要知道TLB本质上就是一个cache，是用来加速页表查找的。

由于每个进程都有自己的虚拟地址空间，那么显然每个进程都有自己的页表，
那么当进程切换后页表也要进行切换，页表切换后TLB就失效了，
Cache失效了导致命中率降低，那么虚拟地址转换为物理地址就会变慢，表现出来的就是程序运行会变慢,

而线程切换则不会导致TLB失效，因为线程线程无需切换地址空间，因此我们通常说线程切换要比较进程切换块，原因就在这里。



#进程通信方式（管道、共享内存、信号量、socket）：

无名管道：速度慢，容量有限，只有父子进程能通讯；
FIFO（命名管道）：任何进程间都能通讯，但速度慢；
消息队列：容量受到系统限制，且要注意第一次读的时候，要考虑上一次没有读完数据的问题；
共享内存：能够很容易控制容量，速度快，但要保持同步，比如一个进程在写的时候，另一个进程要注意读写的问题；相当于线程中的线程安全，当然，共享内存区同样可以用作线程间通讯，不过没这个必要，线程间本来就已经共享了同一进程内的一块内存
信号：有入门版和高级版两种，区别在于入门版注重动作，高级版可以传递消息。只有在父子进程或者是共享内存中，才可以发送字符串消息；
信号量：不能传递复杂消息，只能用来同步。用于实现进程间的互斥与同步，而不是用于存储进程间通信数据。


#说说共享内存的原理
虚拟内存是进程直接操作的地址，不同进程间可以存在想通的内存地址，并且它们是不会相互干扰的。
进程内的虚拟地址是连续的，但实际映射在物理地址上，却不是连续的。
通常来说各进程之间不会共用物理内存地址;


进程A和进程B各自的私有内存，分别映射在实际物理内存的不同区域上。
那么，[共享内存就是改变这种映射关系]，让不同的进程“共用物理内存”。


这个时候，进程A的第3块虚拟内存，与进程B的第1块虚拟内存，就指向同一块物理内存了。也就是它们共享内存了。
之后，其中一个改写了这块内存的内容，另一个就可以直接读到，省去了中间（系统内核）的数据拷贝。
这就是所谓“共享内存效率最高”的原因。

但从中我们不难看出，共享内存也是有缺点的，那就是大家都是读写同一块内存，很容易不同步或者冲突。
所以，共享内存通常还需要搭配其它同步机制使用。

使用方法
共享内存的使用并不难，就是改变内存映射，获取到一个指向公共内存的地址，然后读写数据。
同步和互斥
之前提到过共享内存的不足。
由于多个进程可以同时访问共享内存，需要使用同步和互斥机制来确保数据的一致性和正确性。
常见的同步机制包括信号量、互斥锁和条件变量等。在这里就不再展开了。



#客户端埋点实现

iOS 开发中常见的埋点方式，主要包括[代码埋点]、[无侵入埋点]和[可视化埋点]这三种；

代码埋点：客户端开发，在业务代码中直接添加埋点代码的方式，就是代码埋点
这种方式能很精确的，在需要埋点的业务代码处加上埋点代码；可以很方便的记录当前环境的变量值、方便调试、并跟踪埋点内容；但是存在开发工作量大、埋点代码到处都是、后期难以维护等问题。

无侵入埋点：并不是不需要埋点，而更确切地说是"全埋点"，埋点代码不会出现在业务代码中，便于管理和维护
它的缺点在于埋点成本高，后期的解析也比较复杂，再加上 view_path 的不确定性；这种方案并不能解决所有的埋点需求，但对于大量通用的埋点需求来说，能够节省大量的开发和维护成本。
可视化埋点：这种埋点方式结合无侵入埋点，将埋点需求的生成过程可视化；比如允许开发以外的同学，通过可视化的界面、按照既定的规则生成埋点需求，将这些需求通过服务器下发给手机客户端；手机客户端解析埋点需求，然后将需要的埋点数据上报。
这种方式将埋点的增加和修改的工作可视化，提升了增加埋点的体验；
但是缺点也很明显，前期工作量巨大；埋点生成规则、解析规则需要生成端及客户端实时同步，否则生成的埋点需求客户端不能解析；添加埋点的同学需要熟悉整个思路及过程，以便能够独立的添加埋点需求。
