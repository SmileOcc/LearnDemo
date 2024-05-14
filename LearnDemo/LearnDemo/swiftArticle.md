
# Swift 的派发方式总结

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


#Swift Any、AnyObject和Generics区别

[Any：]
Any 是 Swift 中的⼀种类型擦除（type erasure）的概念，是⼀个协议（protocol）。
使用 Any 声明的变量可以存储任何类型的值，包括值类型和引⽤类型。
Any 是 Swift 中的一个特殊类型，用于表示任意类型的实例。
使⽤ Any 时， Swift 编译器会[放弃类型检查]，因此需要⼩⼼使⽤，避免类型错误。

[AnyObject：]
AnyObject 是 Swift 中的⼀个协议（ protocol ），表示任何类[引⽤类型]类型的实例。
使用 AnyObject 声明的变量可以存储任何类类型的实例，但不能存储结构体、枚举或其他类型的实例。
AnyObject 是一个协议类型，所有类都隐式地遵循了 AnyObject 协议。

[Generics：]
泛型是 Swift中的⼀种编程技术，⽤于编写可以处理任意类型的代码。
泛型允许在编译时编写灵活的代码，以便在使用时指定类型。
使用泛型可以编写更加灵活和可重用的代码，而不需要在编译时知道确切的类型。
泛型可以用于函数、方法、类、结构体和枚举等地方，使得这些实体可以与任意类型一起工作。
泛型代码在编译时会进⾏类型检查，避免了使⽤ Any 时的类型不确定性问题。
<泛型类型由于在调用时能够确定具体的类型>[声明确定 运行时确定]
泛型的具体类型的确定是在程序运行时，而模板的实例化是在编译时确定的
例如：
func swapTwoValues<T>(_ a: inout T, _ b: inout T) {
    let temp = a
    a = b
    b = temp
}

var intValue1 = 42
var intValue2 = 10
swapTwoValues(&intValue1, &intValue2)
print("intValue1: \(intValue1), intValue2: \(intValue2)") // 输出: intValue1: 10, intValue2: 42

var stringValue1 = "Hello"
var stringValue2 = "World"
swapTwoValues(&stringValue1, &stringValue2)
print("stringValue1: \(stringValue1), stringValue2: \(stringValue2)") // 输出: stringValue1: World, stringValue2: Hello

简而言之，Any 和 AnyObject 是用于处理不同类型的实例的机制，【而泛型则是一种编写灵活、可重用代码的机制】。
Any 可以表示任何类型的实例，
而 AnyObject 只能表示类类型的实例。
Generics 允许在编译时编写灵活的代码，以处理不同类型的数据。



#泛型类型

泛型类型使用 [Value Witness Table] 进行生命周期管理，Value Witness Table 由编译器生成;
其存储了该类型的 size、aligment（对齐方式）以及针对该类型的基本内存操作;
[编译器会尽量在编译时为每一个类型生成一个 (类型元信息对象——Type Metadata)];

[Type Metadata（类型元数据）]
对于泛型类型来说，通过 Type Metadata 也可以索引到 Value Witness Table! 
携带的类型元信息主要包含：类型的 Value Witness Table、类型的反射信息。

[每一种类型，在全局只有一个 Type Metadata，供全局共享]
对于内建基本值类型，如：Integer，编译器会在标准库中生成对应的 Type Metadata 。
其中Value Witness Table 是针对小的值类型 Value Witness Table。

对于引用类型，如：UIView，编译器也会在标准库中生成 Type Metadata。
其中Value Witness Table 是针对引用类型的标准 Value Witness Table。

对于自定义的引用类型，Type Metadata 会在我们的程序中生成，Value Witness Table 则由所有引用类型共享。
编译后的代码是如何使用 Type Metadata 的。如下所示为两种类型对 f<T> 的调用
struct MyStruct {
    var a: UInt8 = 0
    var b: UInt8 = 0
}

f(123)

f(MyStruct())
当使用 int 类型和 MyStruct 类型调用 f<T> 时，编译器生成的代码如下所示
 int val = 123;
 extern type *Int_metadata;
 f(&val, Int_metadata);


 MyStruct val;
 type *MyStruct_metadata = { ... };
 f(&val, MyStruct_metadata);
 
通过上述代码可以发现 两者的区别在于： 
[int 类型使用标准库中的 Type Metadata；] 
[自定义类型则使用针对自身生成的 Type Metadata。]

上述 Type Metadata 之所以能够在编译时生成，是因为我们在[调用时就能通过类型推导得出其类型]。
如果，[在调用时无法推断其类型]，则需要在]运行时动态生成 Type Metadata!】

对于泛型类型，编译器会在编译时生成一个 Metadata Pattern。 
Metadata Pattern 与 Type Metadata 的关系其实就是类与对象的关系。

以如下自定义泛型类结构为例:
 struct Pair<T> {
     var first: T
     var second: T
 }

 let pa = Pair(first: 1, second: 5)
[运行时根据绑定类型的 Type Metadata，结合 Metadata Pattern，生成最终的确定类型的 Type Metadata。]

在泛型类型调用方法时， Swift 会将泛型绑定为具体的类型。
[在编译时就能推导出泛型类型，编译器则会进行优化，]提高运行性能!
在运行时避免通过传递 Type Metadata 来查找各个域的偏移，从而提高运行性能!因此该实现的是静态多态。
在调用时能够确定具体的类型，所以不需要使用 Extential Container。

[但在协议类型调用方法时]，类型是 Existential Container，需要在方法内部进一步根据 [Protocol Witness Table] 进行方法索引，因此协议实现的是动态多态。
泛型特化是何时发生的?
在使用优化时，调用方需要进行类型推断，这里需要知晓类型的上下文，例如类型的定义和内部方法实现。
[如果调用方和类型是单独编译的]，就无法在调用方推断类型的内部实行，就无法使用优化。

为保证这些代码一起进行编译，这里就用到了[whole module optimization]。
而whole module optimization是对于调用方和被调用方的方法在不同文件时，对其进行泛型特化优化的前提。
[whole module optimization (全模块优化)]
whole module optimization是用于Swift编译器的优化机制，从 Xcode 8 开始默认开启。
全模块优化的优势:
    •    编译器掌握所有方法的实现，可以进行内联和泛型特化等优化，通过计算所有方法的引用，移除多余的引用计数操作。
    •    通过知晓所有的非公共方法，如果方法没有被使用，就可以对其进行消除。
那么弊端则是会增加编译时间



#Swift 的 static和class 区别

static 和 class 关键字都可以用来声明类型级别的属性和方法


静态属性和方法的使用方式：
static：可以用在类、结构体和枚举中，用来声明类型级别的属性和方法。
在类中，static 修饰的属性和方法可以被子类继承。
class：只能用在类中，用来声明类型级别的属性和方法。
在类中，class 修饰的属性和方法可以被子类继承、重写。
[class 不能修饰存储属， class 修饰的计算属性可以被重写,static 修饰的不能被重写 ]

注：如果你需要在子类中重写方法或属性，应该使用 class 关键字。
如果不需要重写，并且希望在类、结构体或枚举中统一处理类型级别的属性和方法，那么可以使用 static 关键字。



#Swift中 Struct 和 Class的区别是什么？ 你分别在什么时候使用？

[Struct是不能继承的] 而Class是能继承的，所以当我们需要继承父类的属性 方法等 需要使用Class。
Class是引用类型，Struct是值类型，当我们赋值给一个变量的时候Class是浅拷贝 只拷贝了引用，Struct是深拷贝 拷贝了一个新的实例。

内存管理上Class在堆上 是通过ARC进行管理，Struct在栈上 赋值到一个变量上时 会和变量的生命周期相同。

初始化上  class有一个默认的初始化函数，它会自动初始化类中所有的属性。
而对于struct来说，则需要手动实现初始化函数。此外，class还可以使用deinit函数来进行清理工作，而struct则没有deinit函数。

在Swift中，struct（结构体）是值类型，而类（Class）是引用类型。
这意味着struct遵循值类型的特性，即它们在赋值和传递时会进行复制。

而类则遵循引用类型的特性，即它们通过引用来处理实例的赋值和传递，多个引用可以指向类的同一个实例。
由于这两种类型的根本区别，Swift不支持为struct提供类似于类中的继承特性。
这是因为struct是值类型，它们的副本是独立的实体，而类的副本共享同一个实例。
如果struct可以继承，那么它们的复制行为可能会变得混乱和不可预测。


因此Swift不支持struct的继承。
但是，[你可以通过协议（Protocol）来实现类似于继承的行为]，协议定义了一组方法、属性和其他的要求，符合协议的类型必须实现这些要求。
这样，你可以通过扩展协议来提供默认实现，或者通过其他类型来提供额外的功能。这样做可以提供一定程度的灵活性和重用性。

struct与class的差异
Swift中类和结构体非常类似，都具有定义和使用属性、方法、下标和构造器等面向对象特性，
[但结构体不具有继承性，也不具备运行时强制类型转换、使用使用析构器和引用计数等能力！]
Swift中struct是值类型，而class是引用类型。
值类型的变量直接包含他们的数据，引用类型的变量存储对他们的数据引用，因此后者称为对象，
因此对一个变量操作可能影响另一个变量所有引用的对象。
对于值类型都有自己的数据副本，因此对一个变量操作不可能影响另一个变量

2. mutating关键字
// 在不修改class和struct的情况下添加一个Method：modifyCoderName(newName:）

// 类
extension ClassCoder {
    func modifyCoderName(newName:String) {
        
        self.name = newName
    }
}

// 结构体
extension StructCoder{
    mutating func modifyCoderName(newName:String) {
        self.name = newName
    }
}
[struct在func里面需要司改property的时候需要加上mutating关键字]，而class就不用。



内存分配：struct内存是分配到栈上，class内存是分配到堆上
栈内存的存储结构比较简单，可以理解为push到栈底pop出来，而要做的就是[通过移动栈针来分配和销毁内存]。
堆内存相比于栈，有着更为负责的存储结构。它的分配方式可以理解为[在堆中寻找合适大小的空闲内存块来分配内存]，把内存块重新插入堆里销毁内存。
当然然这些仅仅是堆内存相比栈内存消耗大的一方面，更重要的是[堆内存支持多线程操作]，响应就要通过同步等方式保证线程安全。

扩展：
数组越界为什么会崩溃，因为地址是连续的，取的地址有其他内容；
字典读取未知key不会崩溃


#Swift中的常量和OC中的常量有啥区别？
OC中的常量（const）是编译期决定的，Swift中的常量（let）是[运行时确定]的
 Swift 中 let 只是表明常量（只能赋值一次），其类型和值既可以是静态的，也可以是一个动态的计算方法，它们在 [runtime 运行时确定的]。



#String 与 NSString 的关系与区别？
1）本质区别：String是结构体，NSString是类，结构体是值类型，值类型被赋予给一个变量、常量或者被传递给一个函数的时候，其值会被拷贝。



#什么时候使用 final？

1）final关键字可以在class、func和var前修饰，表示不能被继承或重写，否则编译器会报错， 
可以将类或者类中的部分实现保护起来，从而避免子类破坏。

2）它可以显示的指派函数的派发机制。 直接派发
限制类的继承：通过在类的定义前加上 final 关键字，可以防止其他类继承该类。
这样做可以确保类的实现不会被修改或扩展，从而提高代码的安全性和稳定性。

限制属性的重写：通过在属性的定义前加上 final 关键字，可以防止子类重写该属性。这样做可以确保父类的属性在子类中保持不变。
限制方法的重写：通过在方法的定义前加上 final 关键字，可以防止子类重写该方法。这样做可以确保父类的方法在子类中保持不变。
final 关键字用于限制类、属性和方法的继承和重写，从而提高代码的安全性和稳定性。特别是在框架或库中希望确保类的⾏为不被修改时⾮常有⽤


#Swift 的 extension
extension（扩展）允许你在不修改原始代码的情况下，扩展现有类型的功能，包括类、结构体、枚举和协议
添加新的方法：可以在已有的类型上添加新的实例方法或类型方法。
添加新的计算属性：可以在已有的类型上添加新的计算属性。
定义新的初始化方法：可以在已有的类型上定义新的初始化方法
遵循协议：可以使已有的类型遵循新的协议。
提供默认实现：可以在协议的扩展中为协议中的方法提供默认实现。


#Swift的Copy On Write机制了解过吗？

1）Swift中参数传递是值类型传递，它会对值类型进行copy操作，当传递一个值类型变量时（变量赋值，函数传参），
它传递的是一份新的copy值，两个变量指向不同的内存区域。如果频繁操作的变量占内存较大，会产生性能问题。

2）Copy On Write是一种优化值类型copy的机制，
对String、Int、Float等非集合数据类型，赋值直接拷贝，对于Array等集合类型数据，只有传递的内容值[改变后才进行拷贝操作]。
3）Copy On Write的实现：set函数中[判断是否存在多个引用]，只有存在多个引用的情况下才会进行拷贝操作。
另外，自定义结构体是不支持Copy On Write的。

Swift中的CopyOnWrite(COW)技术是一种内存优化技术，其原理是在需要修改数据时才进行拷贝，以避免不必要的内存消耗。
COW的实现主要依赖于Swift中的结构体和类的特性。
对于结构体而言，它是值类型，每次赋值都会使用新的内存地址；
而类则是引用类型，每次赋值只是改变了指向内存地址的指针。

通过这些特性，Swift 可以在需要修改数据时，先判断数据是[否被其他地方引用]，如果[没有]，则在[原有的内存]上进行修改；
如果有，则先进行拷贝，再在新内存上进行修改。这样，只有在实际需要修改数据时，才会进行内存拷贝，从而避免了不必要的内存开销。

因此，COW 技术在 Swift 中是一种非常有效的内存优化技术，可以帮助我们在保证效率的同时，最大程度地节约内存。

``var names = ["aa","bb","cc","dd"]
    
    var firstName = names[0]

    names[0] = "aa01" //直接改
    firstName = "aa02"
    
    print(names) //["aa01", "bb", "cc", "dd"]
    print(firstName)``
    
    
#In-Out（inout关键字）参数了解过吗？

默认情况下，函数参数默认是常量，试图从函数体中去改变一个函数的参数值会报编译错误。
如果希望函数修改参数值，并在函数调用结束后仍然保留。这个时候就需要用到inout关键字。
inout关键字修饰的变量传递过程：
1）函数被调用，参数值会被拷贝
2）在函数体中，修改的是拷贝的值
3）函数返回时，拷贝的值会赋值给原参数
注意事项：
[inout关键字只能修饰变量]，无法修饰常量，因为常量和字面量不能被修改。
inout参数不能有默认值，可变参数不能标记为inout。
调用函数的时候，应该在变量名前放置&符号表示该变量可以由函数修改。
    
// 可变参数
func funcName4(names: String..., address: String) -> String {
    var str = "学生"
    for name in names[0...] {
        str.append(name)
        str.append(" ")
    }
    str.append("住在")
    str.append(address)
    return str
}
//print(funcName4(names: "小明", "小红", "小黑", address: "和磡村"))
// 打印 学生小明 小红 小黑 住在和磡村

- <!--@START_MENU_TOKEN@-->``Symbol``<!--@END_MENU_TOKEN@-->
