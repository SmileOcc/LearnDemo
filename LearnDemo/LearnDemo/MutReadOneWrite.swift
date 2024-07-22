import Foundation

//使用 Grand Central Dispatch (GCD) 实现多读单写的属性
//首先需要确保在多线程环境下的线程安全性。
//可以使用 GCD 提供的读写锁机制 dispatch_rwlock_t 或者 dispatch_queue_t 来实现这个功能。
class SQIObject<T> {
    private var _threadSafeProperty: T
    private let queue = DispatchQueue(label: "io.sqi.threadSafeProperty", attributes: .concurrent)
    
    init(threadSafeProperty: T) {
        self._threadSafeProperty = threadSafeProperty
    }
    
    var threadSafeProperty: T {
        get {
            return queue.sync {
                return _threadSafeProperty
            }
        }
        set {
            queue.async(flags: .barrier) {
                // 如果计算属性的 setter 没有定义表示新值的参数名，则可以使用默认名称 newValue
                self._threadSafeProperty = newValue
            }
        }
    }
}

