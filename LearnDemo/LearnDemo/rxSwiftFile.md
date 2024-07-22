
#  合并 Observable (combineLatest 和 zip)

combineLast 把多个observables 中的{当前事件} 合成一个事件，最多接收7个参数，
也可以合并事件类型不同的 Sub Observables。

        let bag = DisposeBag ()
        
        let queueA = PublishSubject<String>()
        let queueB = PublishSubject<String>()
        
        let sequece = Observable.combineLatest(queueA, queueB)
        sequece.subscribe(onNext: { (str) in
            print(str)
        }, onError: nil, onCompleted: {
            print("onCompleted")
        }) {
            print("onDisposed")
        }.disposed(by: bag)
        
        queueA.onNext("A1")
        queueB.onNext("B1")
        queueA.onNext("A2")
        queueB.onNext("B2")
    
        queueA.onCompleted()
        queueB.onCompleted()


***********(A1,B1)*****(A2,B1)*****(A2,B2)*********

当queue中发生A1时，由于queue中没有事件发生，所以不会触发 combineLatest 。
只有在每一个Sub-observable 中[都发生过一个事件之后]，combineLatest 才会触发 OnNext 的 closure。

于是在 queueB 发生 B1后，combineLatest 触发了 closure， （A1,B1）生成。
继续走下去， queueA 发生了 A2, 此时queueB 当前事件还是 B1。（A2,B1）生成。
最后 queueB 发出了 B2 ，此时 queueA 的当前事件还是 A2。（A2,B2）生成。


#zip： 只合并{最新}事件，它的用法和combineLatest 几乎一样

        queueA.onNext("A1")
        queueB.onNext("B1")
        queueA.onNext("A2")
        queueB.onNext("B2")
    
        queueA.onCompleted()
        queueB.onCompleted()

***********(A1,B1)*****(A2,B2)********************

每次合并完之后，所有Sub-observable 中的事件可以理解为被消费掉了。 
只有当下次所有序列中[都产生新的事件]，才会进行下一次合并。于是 就只能订阅到 （A1,B1）（A2,B2）。

另外和combineLatest 不同的是， zip 合成中的observable中， 
其中任何一个Sub-observable 发生了 Completed 事件，整个observable 就完成了。

