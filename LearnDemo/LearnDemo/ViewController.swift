//
//  ViewController.swift
//  LearnDemo
//
//  Created by odd on 5/12/24.
//

import UIKit

typealias USERID = String


//MARK：线程保活
var thread: Thread?
//停止 设置超时时间
var isStopped: Bool = false

func createLiveThread() {
  thread = Thread.init(block: {
    let port = NSMachPort.init()
        RunLoop.current.add(port, forMode: .default)
//        RunLoop.current.run()
      
      while !isStopped {
           RunLoop.current.run(mode: .default, before: Date.distantFuture)
      }
  })
  thread?.start()
}


//func stop() {
//  self.perform(#selector(self.stopThread), on: thread!, with: nil, waitUntilDone: false)
//}
//
//@objc func stopThread() {
//  self.isStopped = true
//  RunLoop.current.run(mode: .default, before: Date.init())
//    self.thread = nil
//}

class ViewController: UIViewController {

        
    //MARK: - 力扣算法
    func testLeetCode() {
        LeetCodeCtrl.test()
    }
    
    //MARK: -
    
    var userId: USERID?
    
    @objc func testaction() {
        let vc = OneViewCtrl()
        self.present(vc, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white

        testLeetCode()
        return;
        
        OneViewCtrl.testaa()
        
        let tbn = UIButton(type: .custom)
        tbn.frame = CGRect(x: 100, y: 100, width: 80, height: 40)
        tbn.backgroundColor = UIColor.blue
        tbn.setTitle("---", for: .normal)
        tbn.addTarget(self, action: #selector(testaction), for: .touchUpInside)
        self.view.addSubview(tbn)
        
        self.view.backgroundColor = UIColor.gray
    
        
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
        
        
        let tttModel = OCTestModel()
        tttModel.testAfterDelay()
        
        
        var mutableArray = [1,2,3]
//        for _ in mutableArray {
//          mutableArray.removeLast()//不会崩溃
//        }
        
        for _ in mutableArray {
          mutableArray.removeAll()//不会崩溃
        }
        
//        var anchorView = UIView(frame: CGRect.init(x: 100, y: 100, width: 100, height: 100))
//        anchorView.backgroundColor = .orange
//        self.view.addSubview(anchorView)
//
//        //没啥用
//        var tmepCent = anchorView.center
//        anchorView.layer.anchorPoint = CGPoint.init(x: 0, y: 0)
//        anchorView.center = tmepCent
//        tmepCent = anchorView.center
        
    

        // 示例使用
        let demo = SQIObject(threadSafeProperty: 0)

        // 多读示例
        DispatchQueue.concurrentPerform(iterations: 10) { index in
            print("Read \(index): \(demo.threadSafeProperty)")
        }

        // 单写示例
        DispatchQueue.global().async {
            demo.threadSafeProperty = 42
            print("ThreadSafeProperty updated to 42")
        }

        // 确保程序不会立即退出
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            print("Final threadSafeProperty: \(demo.threadSafeProperty)")
        }

        
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



func testaaa() {
    let qutoedString = "如果句子里面有\"双引号\"就很尴尬"
    // 输出： 如果句子里面有"双引号"就很尴尬

    let escapeString = "如果句子里面有\\转义符号反斜杆\\也很尴尬"
    // 输出： 果句子里面有\转义符号反斜杆\也很尴尬
    
    let newQutoedString = #"如果句子里面有"双引号"就很尴尬"#
    // 输出： 如果句子里面有"双引号"就很尴尬

    let newEscapeString = #"如果句子里面有\转义符号反斜杆\也很尴尬"#
    // 输出： 果句子里面有\转义符号反斜杆\也很尴尬
    
    
    
    //如果字符串声明被 # 号包裹，字符串中的 \ ” 不再需要转义了。
    //相对的字符串中的参数占位符也要修改为 \#(参数)：

    let escapeCharacter = #"\"#
    let newParamString = #"如果句子里面有\#(escapeCharacter)转义符号反斜杆\#(escapeCharacter)也很尴尬"#

    let multiLineText = #"""
       "\"
    一切正常
    """#
    
    
    //新的问题

    //使用井号表示的字符串结尾的字符是 "#，如果句子中出现了 "# 则不可避免引起歧义，所以需要一种新的方式转义。区别于传统的在需要转义的字符前加反斜杆的方式，Swift 中采用的是在将首尾的 # 替换为 ##：

    let escapeHashCharacter = ##"如果刚好有个字符 "# 呵呵和结束符意义就尴尬了"##

    let regex1 = "\\\\[A-Z]+[A-Za-z]+\\.[a-z]+"

    let regex2 = #"\\[A-Z]+[A-Za-z]+\.[a-z]+"#

}



protocol ContentCell { }

class IntCell: UIView, ContentCell {
    required init(value: Int) {
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class StringCell: UIView, ContentCell {
    required init(value: String) {
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//工厂方法的实现是这样的：
func createCell(type: ContentCell.Type) -> ContentCell? {
    if let intCell = type as? IntCell.Type {
        return intCell.init(value: 5)
    } else if let stringCell = type as? StringCell.Type {
        return stringCell.init(value: "xx")
    }
    return nil
}

let intCell = createCell(type: IntCell.self)

//当然我们也可以使用类型推断，再结合泛型来使用：
func createCell<T: ContentCell>() -> T? {
    if let intCell = T.self as? IntCell.Type {
        return intCell.init(value: 5) as? T
    } else if let stringCell = T.self as? StringCell.Type {
        return stringCell.init(value: "xx") as? T
    }
    return nil
}

// 现在就根据返回类型推断需要使用的元类型
let stringCell: StringCell? = createCell()


//在 Reusable 中的 tableView 的 dequeue 采用了类似的实现：

//func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath, cellType: T.Type = T.self) -> T
//    where T: Reusable {
//      guard let cell = self.dequeueReusableCell(withIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
//        fatalError("Failed to dequeue a cell")
//      }
//      return cell
//  }
//dequeue 的时候就可以根据目标类型推断，不需要再额外声明元类型：
//
// class MyCustomCell: UITableViewCell, Reusable
//tableView.register(cellType: MyCustomCell.self)
//
//let cell: MyCustomCell = tableView.dequeueReusableCell(for: indexPath)


