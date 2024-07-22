# 生命周期
onCreate -> onWindowStageCreate[loadContent] -> onForground;
aboutToAppear -> pageShow -> BBB(aboutToAppear) -> AAA[pageHide] ->pageShow;
BBB[backPress] -> BBB[pageHide] -> AAA[pageShow] -> BBB[aboutToDisappear]

# Context (Application、AbilityStatge、UIAbility、Extension)
常用：page上下文:UIAbilityContext = getContext(this)

ApplicationContext：获取应用级别的文件路径，随应用卸载删除；
其他：获取HAP级别的应用文件路径，随HAP的卸载删除，不影响[应用级别路径文件]，除非HAP全卸载；

# Stage模型
主推模型，由于提供AbilityStage、WindowStage等，所以叫这个，
Stage模型中，多个应用组件共享一个ArkTS引擎实例，组件间可以方便的共享对象和状态，减少复杂应用对运行内存的占用；
FA模型，灭国应用独享一个ArkTS引擎实例；

# 装饰器：@State,Prop,Link
Provide -> Consume; ObjectLinke -> Observed;

# 数据存储:LocalStorage、AppStorage
LocalStorage(页面级共享)-> @LocalStorageLink \ Prop
或全局传（loadContent) 页面取（LocalStorage.getShared)，
每个页面@Entroy 支持出入一个Storage

AppStorage(全局状态共享)是进程级数据存储，进程启动时⾃动创
建了唯⼀实例， 在各个⻚⾯组件中@StorageProp和@StorageLink装饰器修饰对应
的状态变量

localStorage和appStorage数据存取都是在主线程进⾏的； 且api只提供了同步接
⼝； 存取数据时要注意数据的⼤⼩；

PersistentStorage(磁盘）AppStorage的访
问，AppStorage中的更改会⾃动同步到PersistentStorage（StorageLink）

#⽤过什么数据存储：⽤户⾸选项、 键值型数据库、关系数据库

⽤户⾸选项（Preferences）轻量级配置数据的持久化能⼒ 并⽀持订
阅数据变化的通知能⼒，不⽀持分布式同步，常⽤于保存==应⽤配置信息，⽤户偏
好设置等；

键值型数据库（值对形式的数据）当需要存储的数据没有复杂的关系模型，不支持存模型；

关系型数据库（基于SQLite组件）适⽤于存储包含复杂关系数据，需要配置数据库，创建表，SQ语句；
（relationalStore，StoreConfig配置，getRdbStore获取rdbStore）
获取数据时：上来必须调⽤⼀次goToNextRow，让游标处于第⼀条数据，

#flex 弹性布局、成⼆次渲染
flexgrow=1时， ⼦组件宽度和⼤于flex的宽度时，重新调整；
flexshrink=1时， ⼦组件宽度和⼩于flex的宽度时；
flexShrink: 当⽗容器空间不⾜时， ⼦元素的压缩⽐例；

使⽤Column/Row代替Flex、⼤⼩不需要变更的⼦组件主动设置flexShrink属性值为0；
优先使⽤layoutWeight代替
⼦组件主轴⻓度分配 使⼦组件主轴⻓度总和 等于Flex容器主轴⻓度


#ets⽂件与h5通讯

调用h5方法:webCtrl调用runJavaScriph:>>h5方法
原生注册：webCtrl注册registerjavaScriptProxy， 要webCtrl刷新一下；
Web在加载时.javaScriptProxy,将事件对象注入；

参数1：传⼊调⽤⽅法的对象；参数2:H5在使⽤该对象的名字；参数3:⽅法数组

postMessage流程：
原生端：CreateWebMessagePorts返回Ports两个消息端口集合；
Ports[1]调用onMessgageEvent监听注册回调事件；
webCtrl调用postMessage把Ports[0]发送到H5端；
使用Ports[1]发送消息数据；

H5端：window调用addEventListener接收到传来的Ports[0];
在以Ports[0]的onmessage监听数据，Ports[0]的postMessage发送数据；


#数据通信 eventHub、emitter、worker
eventHub : 普通事件发布、订阅
emitter : 处理进程内、线程间事件 , 发送事件会放到事件队列、多hap通信⽅案
worker： 处理线程间事件、 主要处理耗时事件

#promise
Promise.all 可以将多个Promise实例包装成⼀个新的Promise实例
成功的时候返回的是⼀个结果数组，数据顺序； ⽽失败的时候则返回最先被 reject 失败状态的值；

async/await+try{}catch(){}
异步提交；例如异步请求提交数据；可以封装⼀个函数来处理异步操作셈 使⽤
Promise 或者 async/await 提供异步编程的⽀持
Promise是在主线程执⾏的， 不会卡主线程， 是⼀种异步编程⽅式，⽤于处理异步操作；
await 并不会阻塞整个线程； 当遇到 await 时； 它会让出线程的执⾏； 使得其他任务可以继续执⾏


#Axios
拦截请求：interceptors config、response
async  reqUserInfoTwo():Promise<UserInfoModel>
return await new Promise((resolve, reject)


#任务池(taskPool),worker 线程间隔离、内存不共享
TaskPool：参数直接传递，异步调⽤后默认返回，⾃⾏管理⽣命周期， ⽆需关⼼任务负载⾼低，
超⻓任务⼤于3分钟 会被系统⾃动回收，
TaskPool开辟的⼦线程通过回调传递进⾏传递； 对持续订阅事件或单次订阅事件的
处理； 取消订阅事件； 发送事件到事件队列等是通过Emitter发送和处理事件的；

Worker：消息对象唯⼀参数，需要⾃⼰封装，在Worker线程中进⾏消息解析并调⽤对应⽅法，
主动发送消息 需在onmessage解析赋值，开发者需管理Worker的数量及⽣命周期，
同个进程下， 最多⽀持同时开启8个Worker线程；
Worker开辟的⼦线程需要配合postMessage和onMessage实现消息传递

#⻚⾯布局上的性能和内存上的注意事项
1、使⽤row/column+layoutweight代替flex容器使⽤；
2、scroll嵌套list/grid容器时，要设置容器的宽⾼，数组数据渲染尽量使⽤lazyforeach渲染item 
3、组件的显隐设置， 要使⽤if语句来判断， 避免使⽤visibility 
4、list/grid容器要根据具体场景来使⽤cachecount， 避免卡顿

指定number的类型；
减少变量的属性查找(全局慢与局部)，重复的访问同⼀个变量， 将造成不必要的消耗；
减少嵌套层级: 使⽤扁平化布局优化嵌套层级；

Scroll容器组件嵌套List组件加载：
1、List没有设置宽⾼，会布局List的所有⼦组件，设置就加载显示区域的；
2、List使⽤ForEach加载⼦组件时，⽆论是否设置List的宽⾼，[都会加载所有⼦组件]；
3、List使⽤LazyForEach加载⼦组件时셈 没有设置List的宽⾼，会加载所有⼦组件，设置就加载显示区域的；

# hap,har和hsp

鸿蒙项⽬的模块Module的分类: Module分为 “Ability”和“Library”两种类型；

HAP：鸿蒙Ability包，“Ability”类型的Module编译后叫做HAP；
⼀个HAP , 它是由代码、 资源、 第三⽅库及应⽤/服务配置⽂件组成；
HAP可以分为Entry和Feature两种类型；
Entry是主模块 , Feature是动态特性模块；

HAR：静态共享包，“Library”类型的Module编译后叫做HAR , 或者 HSP；
含代码、C++库、资源和配置⽂件；
HAR不同于HAP， 不能独⽴安装运⾏在设备上， 只能作为应⽤模块的依赖项被引⽤；

HSP：动态共享包，同HAR一样，
HSP不同于HAR , 可以被多个HAP同时引⽤ , HSP旨在解决多个模块，
引⽤相同的HAR， 导致APP包⼤⼩膨胀的问题；

# 三⽅应⽤调⽤系统应⽤셈 对于ability的交互和传值有什么限制
显式want和隐式want的区别；
显式Want启动： 在want参数中需要设置该应⽤bundleName和abilityName， 当需要拉起某个明确的UIAbility时，通常使⽤显式Want启动⽅式；

隐式Want启动： 不明确指出要启动哪⼀个UIAbility， 在调⽤startAbility()⽅
法时， 其⼊参want中指定了⼀系列的[entities]字段，表示⽬标UIAbility额外的类别
信息， 如浏览器、 视频播放器、 和[actions]字段 ,表示要执⾏的通⽤操作,如查看、分享、 应⽤详情等， 参数信息然后由系统去分析want， 并帮助找到合适的UIAbility来启动；


过授权的功能， 如果⽤户第⼀次拒绝授权， 第⼆次再次进去此⻚⾯，则可以直接引导⽤户调到应⽤设置界⾯
一般设置：action字段，parameters等


#项⽬中是否使⽤过泛型
泛型 Generics 是⼀种编程语⾔特性， ⽤于⽀持类型参数化，
在定义类、 接⼝和⽅法时使⽤⼀个或多个类型参数，这些参数表示⼀种或多种类型⽽⾮具体的类型，
在使⽤泛型时，可以使⽤任何符合泛型约束的类型作为类型参数，使得代码重⽤性更⾼，更安全，更可读；

在项⽬中 , 使⽤LazyForEach循环ListItem的时候 , 这个LazyForEach的
数据源必须实现IDataSource接⼝
⽽使⽤LazyForEach循环遍历的数据其实是不同数据实体对象的数组
⽽这些数组 , 都得转换为实现了IDataSource的数据源 , 所以这时候我们就
可以搞⼀个公共的数据源CommonDataSource
代码如下
export class CommonDataSource<T> implements IDataSource；

#Record 和 map 的区别
Record 是属于⼀个轻量级的 type 类型 , Map 相对 Record 是重量级，
Map 不能像 Record ⼀样直接转换为普通的对象셈 Record 主要应对只有
查询的实际问题， 只是为了频繁的查询去 new ⼀个 Map 是⼀种不必要的浪费，
如果读取数据和显示数据频繁셈 就应该采⽤ Record셆
如果增删改⽐较多， 那还是使⽤ Map；

map⽐record灵活， mas可以任意添加key和value，record就不⾏，
⼀旦定义了record， 就只能使⽤定义⾥的字段， 因此， 可以认为record是强类型的

最重要的⼀点，maps的key可以是任意数据类型， ⽽record的key只能是原⼦；

#string array map 和 object 关系
● ⼀切皆为对象 , 所以⽆论是内置对象， 还是⾃定义对象， 都是继承⾃Object
● 内置对象中有 string array map等
