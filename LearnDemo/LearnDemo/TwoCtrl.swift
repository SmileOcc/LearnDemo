//
//  TwoCtrl.swift
//  LearnDemo
//
//  Created by odd on 5/13/24.
//

import UIKit

class TwoCtrl: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

    func teatC() {
        self.teststru()
        self.testClas()
        self.testPro()
        self.testColseBlock()
        
        
        var i = 0
        let closure = {
            print("\(i)")//1
            i += 1
        }
        i += 1
        print("\(i)")//1
        closure()
        print("\(i)")//2
        print("=====捕获")
        
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
        print("=====不捕获")
//        0
//        0
//        2
        
    }
    
    func teststru() {
        var list = [SPerson(name: "aaa"),SPerson(name: "bbbb")]
        
        //第一种修改是直接从list中取到Struct类型的元素
        list[0].name = "a001"
        
        //拷贝一份赋值给变量
        var person = list[1]
        person.name = "b0001"
        print(list.map{$0.name})
        //["a001", "bbbb"]
        
    }
    
    func testClas() {
        var list = [CPerson(name: "aaa"),CPerson(name: "bbbb")]
        
        list[0].name = "a001"
        let person = list[1]
        person.name = "b0001"
        print(list.map{$0.name})
        //["a001", "b0001"]

    }
    
    func testPro() {
        var drawables:[Drawable] = [Point(x: 1, y: 2),Line(x1: 1, y1: 2, x2: 2, y2: 3)] //遵守了Drawable协议的类型集合，可能是point或者line
        for d in drawables {
            d.draw()
            d.cross()
            if let mm = d as? Point {
                mm.cross()
            }
        }
//        ===point
//        ====cross
//        ====cross Point
//        ===Line
//        ====cross
        print("===")
        
        _ = MyAAClass()
        MyAAClass.someTypeMethod()
    }

    func makeIncrementer(forIncrement amount: Int) -> () -> Int {
        var total = 0
        return {
            total += amount // 引用捕获
            return total
        }
    }
    func testColseBlock() {
        

        let incrementByTen = makeIncrementer(forIncrement: 10)
        print(incrementByTen()) // 输出 10
        print(incrementByTen()) // 输出 20

//        闭包捕获了外部变量 total 的引用，因此每次调用 incrementByTen 闭包时，都会修改外部作用域中的 total 变量
    }
}

struct SPerson {
    var name:String
    init(name:String){
        self.name = name
    }
}

class CPerson {
    var name:String
    init(name:String) {
        self.name = name
    }
}


protocol Drawable { func draw()}
extension Drawable {
    func cross() {
        print("====cross")
    }
}

struct Point :Drawable {
    var x, y:Double
    func draw() {print("===point")}
    func cross() {
        print("====cross Point")
    }
}
struct Line :Drawable {
    var x1, y1, x2, y2:Double
    func draw() { print("===Line") }
    func cross() {
        print("====cross Line")
    }
}


protocol AnotherProtocol {
    static var someTypeProperty: Int { get set }
    //类型方法 使用 static 关键字
    static func someTypeMethod()
}

class MyAAClass: AnotherProtocol {
    //类型 存储 属性 在class 中 只能用 static
    static var someTypeProperty: Int = 0
    //类型计算属性 可以用 class
    class var name: String {
        return ""
    }
    //可以使用 class 关键字
    class func someTypeMethod() {
        print("===== someTypeMethod")
    }
}


func testDefer() {
    defer {
        print("44 方法中defer内容")
    }
    if true {
        defer {
            print("22 if 中defer内容")
        }
        print("11 if中最后的代码")
    }
    print("33 方法中的代码")
    if true {
        return
    }
    print("方法结束前最后一句代码")
    
    defer {
        print("55 方法中defer内容 return 之后的不执行")
    }
    //testDefer()
//    11 if中最后的代码
//    22 if 中defer内容
//    33 方法中的代码
//    44方法中defer内容

    
}


