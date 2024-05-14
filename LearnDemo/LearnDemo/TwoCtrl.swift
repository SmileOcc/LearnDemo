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
