//
//  ViewController.swift
//  LearnDemo
//
//  Created by odd on 5/12/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white

        var intValue1 = 42
        var intValue2 = 10
        swapTwoValues(&intValue1, &intValue2)
        print("intValue1: \(intValue1), intValue2: \(intValue2)") // 输出: intValue1: 10, intValue2: 42

        var stringValue1 = "Hello"
        var stringValue2 = "World"
        swapTwoValues(&stringValue1, &stringValue2)
        print("stringValue1: \(stringValue1), stringValue2: \(stringValue2)") // 输出: stringValue1: World, stringValue2: Hello
        
        var attt:Any?
        attt = "123"
        
        var atttn:AnyObject?
        atttn = NSObject()
        
        swapTwoValuesss(attt, atttn)

        testCopyWrite()
        
        let oneVC = OneCtrl()
        oneVC.testaaa()
        
        let twoVC = TwoCtrl()
        twoVC.teatC()
    }


    func swapTwoValues<T>(_ a: inout T, _ b: inout T) {
        let temp = a
        a = b
        b = temp
    }

    func swapTwoValuesss<T>(_ a: T, _ b: T) {
        let temp = a
        print(a)
        print(b)

    }
    
    func swapTwoValuessss<T>(_ a: T, _ b: T) {
        let temp = a
        print(a)
        print(b)

    }

}


//func test() {
//    var intValue1 = 42
//    var intValue2 = 10
//    swapTwoValues(&intValue1, &intValue2)
//    print("intValue1: \(intValue1), intValue2: \(intValue2)") // 输出: intValue1: 10, intValue2: 42
//
//    var stringValue1 = "Hello"
//    var stringValue2 = "World"
//    swapTwoValues(&stringValue1, &stringValue2)
//    print("stringValue1: \(stringValue1), stringValue2: \(stringValue2)") // 输出: stringValue1: World, stringValue2: Hello
//}
//
//
//func swapTwoValues<T>(_ a: inout T, _ b: inout T) {
//    let temp = a
//    a = b
//    b = temp
//}

func test() {
    let _ = AAstru(c: "3")
    let _ = AAstru()
}


struct AAstru {
    let a:String = "1"
    let b:String = "2"
    var c:String?
}


typealias myBlock = (_ num1: Int) -> ()

func testCopyWrite() {
    var names = ["aa","bb","cc","dd"]
    
    var firstName = names[0]

    names[0] = "aa01" //直接改
    firstName = "aa02"
    
    print(names) //["aa01", "bb", "cc", "dd"]
    print(firstName)
    
    var tttStrust:[AAstru] = []
    for i in 0...4 {
        let aa = AAstru(c: "aa==\(i)")
        tttStrust.append(aa)
    }
    var firstStruc = tttStrust[0] //赋值拷贝

    tttStrust[0].c = "aa===c01" //修改集合内的
    
    print(firstStruc)//AAstru(a: "1", b: "2", c: Optional("aa==0"))
    firstStruc.c = "aa=====c02"
    
    print(tttStrust) //[LearnDemo.AAstru(a: "1", b: "2", c: Optional("aa===c01")), ...
    
}

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

var variable: Int = 1

func changeNumber(num:inout Int) {
    num = 2
    print(num)
}

//changeNumber(num: &variable) // 2


//final class FinalClass {}
//// OtherClass: FinalClass // 编译错误，FinalClass 不能被继承
//
//class ParentClass {
//    final var finalProperty: Int = 42
//}
//
//class ChildClass: ParentClass {
//    // override var finalProperty: Int // 编译错误，finalProperty 不能被重写
//}

class ParentClass {
    final func finalMethod() {
        print("ParentClass final method")
    }
}

class ChildClass: ParentClass {
    // override func finalMethod() { // 编译错误，finalMethod 不能被重写
    //     print("ChildClass override method")
    // }
}

