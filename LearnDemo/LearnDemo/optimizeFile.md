#  剖析Swift性能优化

针对Swift性能提升这一问题，我们可以从概念上拆分为两个部分：
编译器：Swift编译器进行的性能优化，从阶段分为编译期和运行期，内容分为时间优化和空间优化。
开发者：通过使用合适的数据结构和关键字，帮助编译器获取更多信息，进行优化。


结构体的内存是在栈区分配的，内部的变量也是内联在栈区

高级的数据结构，比如类，分配在堆区。初始化时查找没有使用的内存块，销毁时再从内存块中清除。
因为堆区可能存在[多线程的操作]问题，为了保证线程安全，需要进行[加锁操作]，因此也是一种性能消耗。



对于频繁操作，尽量使用Struct替代Class，因为栈内存分配更快，更安全，操作更快


###引用计数总结

Class在堆区分配内存，需要使用引用计数器进行内存管理。
基本类型的Struct在栈区分配内存，无引用计数管理。
包含[强类型的Struct]通过[指针管理在堆区的属性]，对结构体的拷贝会创建新的栈内存，[创建多份引用的指针，Class只会有一份]。


使用Static dispatch代替Dynamic dispatch提升性能

我们知道Static dispatch快于Dynamic dispatch，如何在开发中去尽可能使用Static dispatch。

###inheritance constraints继承约束 
我们可以使用[final关键字]去修饰Class，以此生成的Final class，使用Static dispatch。

access control访问控制 [private关键字修饰]，使得方法或属性只对当前类可见。编译器会对方法进行Static dispatch。

编译器可以通过whole module optimization检查继承关系，对某些没有标记final的类通过计算，
如果能在编译期确定执行的方法，则使用Static dispatch。 Struct默认使用Static dispatch。


#-------------------

#App 启动优化 - 二进制重排
App启动分为 冷启动 和 热启动

冷启动：点击 App 启动前，它的进程不在系统里，需要系统新创建一个进程分配给它的情况。这是一次完整的启动过程
热启动：App 在冷启动后，用户将App 退到后台，即在App的进程还在系统里的情况下，用户重新启动进入 App 的过程，这个过程做的事情非常少，启动速度非常快。


总结来说：App 的启动主要包括三个阶段：

[main() 函数执行前]
[main() 函数执行后]
[首屏渲染完成后]


在 main() 函数执行前，系统主要会做下面几件事情：

dylib loading：[加载可执行文件]（App 的.o 文件的集合），加载动态链接库
rebase/binding：[对动态链接库]进行 rebase 指针调整和 bind 符号绑定；
Objc setup：Objc [运行时的初始化处理]，包括 Objc 相关类的注册、category 注册、selector 唯一性检查等；
initializer：[初始化]，包括了执行 +load() 方法、attribute((constructor)) 修饰的函数的调用、创建 C++ 静态全局变量。


[减少动态库加载]：每个库本身都有依赖关系，苹果公司建议使用更少的动态库，并且建议在使用动态库的数量较多时，尽量将多个动态库进行合并。
数量上，苹果公司建议最多使用 6 个非系统动态库。
[减少加载启动后不会去使用的类或者方法]。
[+load()方法里的内容]可以放到首屏渲染完成后再执行，或使用 +initialize()方法替换掉。
因为，在一个 +load() 方法里，进行运行时[方法替换]操作会带来 [4 毫秒]的消耗。
不要小看这 4 毫秒，积少成多，执行 +load() 方法对启动速度的影响会越来越大。


#二进制重排

背景：APP启动时需要优先执行的函数分散在各个 Page，就会导致多次 Page Fault 造成时间的损耗

APP 进程通过 [虚拟内存] 和 [物理内存] 之间的[映射]来进行访问（直接访问物理内存是不安全的，虚拟内存地址分配还会涉及到 ASLR），为了提高效率和方便管理，又对虚拟内存进行分页（Page）。
当进程访问一个虚拟内存Page而对应的物理内存却不存在时，会触发一次缺页中断（Page Fault），分配物理内存，有需要的话会从磁盘mmap 读入数据。


查看 Page Fault [>>>> Instruments -> System Trace]

重排
编译器在生成二进制代码的时候，[默认按照链接的 Object File(.o) 顺序写文件]，按照 Object File 内部的函数顺序写函数。


问题分析：假设我们只有两个 page：page1/page2，其中绿色的method1 和 method3 启动时候需要调用，为了执行对应的代码，系统必须进行两个 Page Fault。

但如果我们把 method1 和 method3 排布到一起，那么只需要一个Page Fault 即可，这就是二进制文件重排的核心原理。


##LinkMap

LinkMap 是iOS编译过程的中间产物，记录了二进制文件的布局，需要在Xcode的Build Settings里开启[Write Link Map File]：

选中[]编译后的app，[Show In Finder] -- [找到build目录] -- 具体路径如下:
Build/Intermediates.noindex/Spirit.build/Debug-iphonesimulator/Spirit.build/Spirit-LinkMap-normal-x86_64.txt


#Clang 插桩获取启动调用的函数符号


设置 order file

Xcode 项目选择 TARGETS -> Build Settings -> Order File 填写 order file 路径 $(SRCROOT)/trace.order

PS：配置好 order file 之后，记得清理前面 Build Settings 和 Podfile 中与 Clang 相关的配置



#一、启动优化
1、冷启动（从零开始的启动）
冷启动三个阶段

#1.1 Main函数执行前

加载可执行文件（mach-o文件）
加载动态链接库，进行rebase指针调整和bind符号绑定
Objc运行时的初始化处理，包括Objc相关类的注册、category注册、selector唯一性检查
初始化，包括执行了+load()方法、attribute((constructor))修饰的函数调用、创建C++静态全局变量
优化方案

减少动态库加载。每个库本身都有依赖关系，苹果公司建议使用更少的动态库，并且建议在使用动态库的数量较多时，尽量将多个动态库进行合并。数量上，苹果公司建议最多使用 6 个非系统动态库。
减少加载启动后不会去使用的类或者方法
+load() 方法里的内容可以放到首屏渲染完成后再执行，或使用 +initialize() 方法替换掉。 因为，在一个+load() 方法里，进行运行时方法替换操作会带来 4 毫秒的消耗。不要小看这 4 毫秒，积少成多，执行 +load() 方法对启动速度的影响会越来越大
控制 C++ 全局变量的数量

#1.2 Main函数执行后

主要是指main()函数执行开始，到Appdelegate的didFinishLaunchingWithOptions方法里首屏渲染相关方法的执行

首屏初始化所需要配置文件的读写操作
首屏列表大数据的读取
首屏渲染的大量计算
优化方案

从功能上梳理出哪些是首屏渲染必要的初始化功能，哪些是 App 启动必要的初始化功能，而哪些是只需要在对应功能开始使用时才需要初始化的。
梳理完之后，将这些初始化功能分别放到合适的阶段进行

#1.3 首屏渲染完成

从渲染完成时开始，到 didFinishLaunchingWithOptions 方法作用域结束时结束

优化方案

[功能级优化]
main() 函数开始执行后到首屏渲染完成前只处理首屏相关的业务，
其他非首屏业务的初始化、监听注册、配置文件读取等都放到首屏渲染完成后去做
[方法级优化] 
检查首屏渲染完成前主线程上有哪些耗时方法，将没必要的耗时方法滞后或者异步执行。
通常情况下，耗时较长的方法主要发生在计算大量数据的情况下，具体的表现就是加载、编辑、存储图片和文件等资源

#2、热启动
App在内存中，在后台存活着，再次点击图标进入App

3、APP启动的监控手段
定时抓取主线程上的方法调用堆栈，计算一段时间里各个方法的耗时
对 objc_msgSend 方法进行 hook 来掌握所有方法的执行耗时

#二、卡顿问题

卡顿产生的原因：当单位时间内，界面要刷新的时候，CPU或GPU由于计算量大，没有做好准备，
就会造成界面显示前一个时间段的界面，从而造成卡顿、掉帧现象

通常，60fps比较流畅，也就是60张/秒，每张图片需要的渲染时间大约是：
1s/60张 = 1000ms/60张 = 16.7ms/1张

也就是1张图像在16.7ms内出现一次，就不会造成卡顿现象。

2.1 CPU和GPU
CPU（Central processing Unit，中央处理器）

对象的创建和销毁、对象属性的调整、布局计算、文本的计算和排版、图片的格式转换和解码、图像的绘制(Core Graphics)

#CPU优化方案

尽量用轻量级的对象，比如用不到事件处理的地方，可以考虑使用CALayer取代UIView
不要频繁的修改UIView的相关属性，比如frame、bounds、transform等
尽量提前计算好布局，计算好frame，bounds等，一次性修改，不要多次修改；
使用Autolayout会比直接设置frame消耗更多的资源
图片的size最好和UIImageView的size保持一致，减少CPU资源去进行缩放操作;
控制线程的最大并发数量
尽量耗时操作放到子线程（文本尺寸、图片处理）


GPU（Graphics Processing Unit，图形处理器）

纹理的渲染，变换、合成、渲染，把渲染结果提交到帧缓冲区去，在下一次 VSync 信号到来时显示到屏幕上


#GPU优化方案

尽量减少视图数量和层级，多层次的视图绘制更占用GPU资源
尽量避免短时间内大量图片的显示，尽可能将多张图片合成一张进行显示
GPU能处理的图片的最大尺寸是4096x4096，一旦超过这个尺寸，就会占用CPU资源进行处理，所以纹理尽量不要超过这个尺寸
减少透明的视图(alpha<1)，有透明度则需要混合计算，不透明就设置opaque为YES


#2.2 离屏渲染（尽量避免出现离屏渲染）
在OpenGL中，GPU有2种渲染方式

On-Screen Rendering:当前屏幕渲染，在当前用于显示的屏幕缓冲区进行渲染操作
Off-Screen Rendering:离屏渲染，在当前屏幕缓冲区以外新开辟一个缓冲区进行渲染操作
离屏渲染消耗性能的原因

需要创建新的缓冲区
离屏渲染的整个过程，需要多次切换上下文环境，先是从当前屏幕(On-Screen)切换到离屏(Off-Screen);等到离屏渲染结束以后，将离屏缓冲区的渲染结果显示到屏幕上，又需要将上下文环境从离屏切换到当前屏幕
优化方案

光栅化，减少使用layer.shouldRasterize = YES
遮罩，减少使用layer.mask
圆角，减少同时设置layer.masksToBounds = YES、layer.cornerRadius大于0（可以考虑通过CoreGraphics绘制裁剪圆角，或者叫UI提供圆角图片）
阴影，减少使用layer.shadowXXX (如果设置了layer.shadowPath就不会产生离屏渲染)


#三、耗电优化
尽可能降低CPU、GPU功耗
少用定时器
优化I/O操作
尽量不要频繁写入小数据，最好批量一次性写入
读写大量重要数据时，考虑用dispatch_io，其提供了基于GCD的异步操作文件I/O的API。用dispatch_io系统会优化磁盘访问
数据量比较大的，建议使用数据库(比如SQLite、CoreData)



#四、网络优化

减少、压缩网络数据
如果多次请求的结果是相同的，尽量使用缓存
使用断点续传，否则网络不稳定时可能多次传输相同的内容
网络不可用时，不要尝试执行网络请求
让用户可以取消长时间运行或者速度很慢的网络操作，设置合适的超时时间
批量传输，比如，下载视频流时，不要传输很小的数据包，直接下载整个文件或者一大块一大块地下载。如果下载广告，一 次性多下载一些，然后再慢慢展示。如果下载电子邮件，一次下载多封，不要一封一封地下载


#五、定位优化
如果只是需要快速确定用户位置，最好用CLLocationManager的requestLocation方法。定位完成后，会自动让定位硬件断电
如果不是导航应用，尽量不要实时更新位置，定位完毕就关掉定位服务
尽量降低定位精度，比如尽量不要使用精度最高的kCLLocationAccuracyBest
需要后台定位时，尽量设置pausesLocationUpdatesAutomatically为YES，如果用户不太可能移动的时候系统会自动暂停位置更新
尽量不要使用startMonitoringSignificantLocationChanges，优先考虑startMonitoringForRegion:
用户移动、摇晃、倾斜设备时，会产生动作(motion)事件，这些事件由加速度计、陀螺仪、磁力计等硬件检测。在不需要检测的场合，应该及时关闭这些硬件
