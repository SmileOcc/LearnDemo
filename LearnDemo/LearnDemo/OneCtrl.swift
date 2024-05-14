//
//  OneCtrl.swift
//  LearnDemo
//
//  Created by odd on 5/12/24.
//

import UIKit

class OneCtrl: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        

    }
    
    func testaaa() {
        // 调用静态属性和方法
        Message.staticProperty = 5
        print("Static Property: \(Message.staticProperty)")
        Message.staticMethod()

        // 调用类属性和方法
        print("Class Property: \(Message.classProperty)")
        Message.classMethod()

        // 调用子类的类方法
        Chat.classMethod()
        
        Chat.staticMethod()
        
        let numbers = [1, 2, 3, 4, 5]
        let sum = numbers.reduce(0, { $0 + $1 })
        print(sum) // 输出 15

//        flatMap 函数用于对集合中的每个元素应用一个转换闭包，并将结果拼接成一个新的集合
        
        //返回解包一层数据
        let nestedArray = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
        let flatArray = nestedArray.flatMap { $0 }
        print(flatArray) // 输出 [1, 2, 3, 4, 5, 6, 7, 8, 9]

        //丢掉nil
        let nestedArrayq = [[1, 2, 3], [4, 5, 6], [7, 8, 9],nil]
        let flatArrayq = nestedArrayq.flatMap { $0 }
        print(flatArrayq) // 输出 [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
        
        //解包一层
        let nestedArrayaa = [[[1, 2, 3]], [[4, 5, 6]], [[7, 8, 9]]]
        let flatArrayaa = nestedArrayaa.flatMap { $0 }
        print(flatArrayaa) // 输出 [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
        
        let strings = ["1", "2", "3", "hello", "5"]
        let numbersss = strings.compactMap { Int($0) }
        print(numbersss) // 输出 [1, 2, 3, 5]
        
        let aaa01 = AA1()
        
        //没有写init
//        aaa01.name = "11"
//        sub 0 willSet
//        p 0 willSet
//        p 0 didset
//        sub 0 didset
        
        
        
//        override init() {
//            print("---sub init")
//
//            super.init()
//            self.name = "qqqq"
//        }
//        ---sub init
//        sub 0 willSet
//        p 0 willSet
//        p 0 didset
//        sub 0 didset
        
        
        let bbb01 = BBB01()
//        bbb01.name = "111"
        
//        bbb sub 0 willSet
//        bbb  p 0 willSet
//        bbb  p 0 didset
//        bbb sub 0 didset
        
        
        var cco = CCCC()
        cco.name = "dfd"
        
        var bbb02 = BBB02()
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

class Message {
    // 使用 static 关键字声明静态属性
    static var staticProperty: Int = 0
    // 使用 class 关键字声明类属性
    class var classProperty: Int {
        get {
            return 10
        }
        set {
            print("Setting class property to \(newValue)")
        }
    }
    // 使用 static 关键字声明静态方法 不可以重写
    static func staticMethod() {
        print("This is a static method")
    }
    // 使用 class 关键字声明类方法
    class func classMethod() {
        print("This is a class method")
    }
    
    //class 不能修饰存储属性 class 修饰的计算属性可以被重写,static 修饰的不能被重写
    //Class stored properties not supported in classes; did you mean 'static'?
    //class var mmm: String = "1111"
}

class Chat: Message {
    // 重写类属性
    override class var classProperty: Int {
        get {
            return 100
        }
        set {
            print("Setting class property to \(newValue)")
        }
    }
    // 重写类方法
    override class func classMethod() {
        print("This is a subclass's class method")
    }
    
    //Cannot override static method
//    override static func staticMethod() {
//        print("This is a static method")
//    }
}


extension Int {
    func squared() -> Int {
        return self * self
    }
}

let number = 5
let squaredNumber = number.squared() // 25


extension Double {
    var squared: Double {
        return self * self
    }
}

let doubleNumber = 3.0
let squaredDouble = doubleNumber.squared // 9.0


extension String {
    init(repeating character: Character, count: Int) {
        var string = ""
        for _ in 0..<count {
            string.append(character)
        }
        self = string
    }
}

let repeatedString = String(repeating: "A", count: 5) // "AAAAA"


protocol CustomProtocol {
    func customMethod()
}

extension Int: CustomProtocol {
    func customMethod() {
        print("Custom method called on Int")
    }
}

class AA {
    var name:String? {
        didSet {
            print("p 0 didset")
        }
        willSet {
            print("p 0 willSet")

        }
    }
}

class AA1: AA {
    override var name: String? {
        didSet {
            print("sub 0 didset")
        }
        willSet {
            print("sub 0 willSet")

        }
    }
    
    override init() {
        print("---sub init")
        
        super.init()
        self.name = "qqqq"
    }
}

class BBB:NSObject {
    var name:String? {
        didSet {
            print("bbb  p 0 didset")
        }
        willSet {
            print("bbb  p 0 willSet")

        }
    }
}

class BBB01: BBB {
    override var name: String? {
        didSet {
            print("bbb sub 0 didset")
        }
        willSet {
            print("bbb sub 0 willSet")

        }
    }
    
    override init() {
        print("-- init bb")
        super.init()
//        aaa()
        self.name = "yyy"
    }
    
    func aaa() {
        print("------")
        self.name = "sss"
    }
}

class BBB02 {
    var name:String? {
        didSet {
            print("bbb02  p 0 didset")
        }
        willSet {
            print("bbb02  p 0 willSet")

        }
    }
    
    init() {
        print("====== bbb02 init")
        //self.name = "2222"  //这个不能触发didset
        self.canDidSet()  //这个可以
    }
    
    func canDidSet() {
        self.name = "2222"
    }
}

struct CCCC {
    var name:String? {
        didSet {
            print("cccc  p 0 didset")
        }
        willSet {
            print("gggg  p 0 willSet")

        }
    }
}



//let numberr = 10
//numberr.customMethod() // 输出: Custom method called on Int

//[1, 2, 3].map{"\($0)"}// 数字数组转换为字符串数组
//["1", "2", "3"]

//["1", "@", "2", "3", "a"].flatMap{Int($0)}
//// [1, 2, 3]
//["1", "@", "2", "3", "a"].map{Int($0) ?? -1}
////[Optional(1), nil, Optional(2), Optional(3), nil]
//
//
//func someFunc(_ array:[Int]) -> [Int] {
//    return array
//}
//[[1], [2, 3], [4, 5, 6]].map(someFunc)
//// [[1], [2, 3], [4, 5, 6]]
//[[1], [2, 3], [4, 5, 6]].flatMap(someFunc)
//// [1, 2, 3, 4, 5, 6]
