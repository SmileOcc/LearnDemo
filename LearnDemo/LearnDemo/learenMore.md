
#命令函数
swift中函数派发查看方式：可将swift代码转换为SIL(中间码)
swiftc -emit-silgen -O example.swift

#4种派发机制：

1、内联（inline）最快
2、静态派发（Static Dispatch）
3、函数表派发（Virtual Dispatch）
4、动态派发（Dynamic Dispatch）(最慢）


#Swift的派发方式总结：

值类型 ： 静态派发
final、扩展 ：静态派发
引用类型：函数表派发
协议 ：函数表派发（单独的函数表派发）
dynomic + @objc ：走消息机制

dynamic 关键字可以用于修饰变量或函数，它的意思也与 Objective-C 完全不同。它告诉编译器使用动态分发而不是静态分发。Objective-C 区别于其他语言的一个特点在于它的动态性，任何方法调用实际上都是消息分发，而 Swift 则尽可能做到静态分发。
因此，标记为 dynamic 的变量或函数会隐式的加上 @objc 关键字，他会使用 Objective-C 的 runtime 机制。
@objc 修饰符：可以将 Swift 类型文件中的类、属性和方法等，暴露给Objective-C 类使用



#如何在Swift中使用动态派发和静态派发？

动态派发（消息转发，函数表派发）
可以使用继承，重写父类的方法 -> 函数表派发
使用dynamic + @objc，方法公开给OC runtime使用 -> 消息机制
在这种类型的派发中，在运行时而不是编译时选择实现方法，会增加运行时的性能开销。
优势：具有灵活性(大多数的OOP语言都支持动态派发，因为它允许多态)

静态派发
final 关键字
static 关键字
优势：和动态派发相比，非常快。编译器可以在编译器定位到函数的位置。因此函数被调用时，编译器能通过函数的内存地址，直接找到它的函数实现。极大的提高了性能，可以达到类型inline的编译期优化


函数表派发：

函数表派发是编译型语言实现动态行为最常见的实现方式. 函数表使用了一个数组来存储类声明的每一个函数的指针. 大部分语言把这个称为 "virtual table"(虚函数表), Swift 里称为 "witness table". 每一个类都会维护一个函数表, 里面记录着类所有的函数, 如果父类函数被 override 的话, 表里面只会保存被 override 之后的函数. 一个子类新添加的函数, 都会被插入到这个数组的最后. 运行时会根据这一个表去决定实际要被调用的函数.

#如何在Swift中使用动态派发和静态派发？

1、要实现动态派发，可以使用继承，重写父类的方法。另外我们可以使用dynamic关键字，并且需要在方法或类前面加上关键字@objc，以便方法公开给OC runtime使用

2、要实现静态派发，我们可以使用final和static关键字，保证不会被覆写


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



#RunLoop的主要作用
保持程序的持续运行；
处理App中的各种事件（比如：触摸事件、定时器事件、Selector事件）
节省CPU资源，提高程序性能：该做事时做事，该休息时休息


#RunLoop与线程的关系
每条线程都有唯一一个与之对应的RunLoop对象
【RunLoop保存在一个全局的Dictionary里，线程作为key，RunLoop作为value】
线程刚创建时并没有RunLoop对象，RunLoop会在第一次获取它时创建
RunLoop会在线程结束时自动销毁
主线程的RunLoop已经默认获取并开启，子线程是 默认没有开启RunLoop

当runloop休眠的时候，是从用户态切换到了内核态，当有消息唤醒时，就从内核态再切换到用户态中


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



#什么是自动释放池

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
unloop会自动开启autorelease
1.主程序在事件循环的每个循环开始时在主线程上创建一个自动释放池
2.并在结束时将其排空，从而释放在处理事件时生成的任何自动释放对象


#autorelease对快速大量创建对象时

for循环中大量创建对象时，使用 autorelease 可以有效控制内存的快速增长（虽然不添加autorelease也会调用delloc销毁对象，但是这样的释放没有创建快，内存虽然最后也会降下来，但是如果加autorelease 可以减少内存峰值）
for (int i = 0; i<100000000; i++) {
    @autoreleasepool {
        NSLog(@"%d",i);
        __autoreleasing LZPerson *p =[LZPerson new];
    }
}


#OC中的Block
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


##--------------

#weak底层原理

weak 关键字的作用是弱引用，所引用对象的计数器不会加1，并在引用对象被释放的时候自动被设置为 nil。
weak的原理在于底层维护了一张weak_table_t结构的hash表，key是所指对象的地址，value是weak指针的地址数组。
对象释放时，调用clearDeallocating函数根【对象地址】获取所有weak指针地址的数组，
然后遍历这个数组把其中的数据设为nil，最后把这个entry从weak表中删除，最后清理对象的记录。



weak是弱引用，所引用对象的计数器不会加一，并在引用对象被释放的时候自动被设置为nil。
weak表其实是一个hash（哈希）表 (字典也是hash表)，Key是所指对象的地址，Value是weak指针的地址集合。 它用于解决循环引用问题。

Runtime维护了一个weak表，用于存储指向某个对象的所有weak指针。weak表其实是一个hash（哈希）表，Key是所指对象的地址，Value是weak指针的地址（这个地址的值是所指对象指针的地址，就是地址的地址）集合(当weak指针的数量小于等于4时，是数组， 超过时，会变成hash表)。

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


#runtime 如何实现weak属性？
runtime 如何实现 weak 属性具体流程大致分为 3 步：

1、初始化时：runtime 会调用 objc_initWeak 函数，初始化一个新的 weak 指针指向对象的地址。
2、添加引用时：objc_initWeak 函数会调用 objc_storeWeak() 函数，objc_storeWeak() 的作用是更新指针指向（指针可能原来指向着其他对象，这时候需要将该 weak 指针与旧对象解除绑定，会调用到 weak_unregister_no_lock()，如果指针指向的新对象非空，则创建对应的弱引用表，将 weak 指针与新对象进行绑定，会调用到 weak_register_no_lock。在这个过程中，为了防止多线程中竞争冲突，会有一些锁的操作。
3、释放时：调用 clearDeallocating 函数，clearDeallocating 函数首先根据对象地址获取所有 weak 指针地址的数组，然后遍历这个数组把其中的数据设为 nil，最后把这个 entry 从 weak 表中删除，最后清理对象的记录。



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
