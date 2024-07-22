//
//  SeeRunLoopTime.swift
//  LearnDemo
//
//  Created by odd on 7/13/24.
//

import Foundation

var timeoutCount = 0
let timeoutInterval = 1.0 // 超时阈值，单位为秒

let semaphore = DispatchSemaphore(value: 0)
let timeInterval = timeoutInterval / 10.0

func checkMainThreadBlock() {
    
    DispatchQueue.main.async {
        semaphore.signal()
    }
    while true {
        let startTime = CFAbsoluteTimeGetCurrent()
        let interval = CFAbsoluteTimeGetCurrent() - startTime
        if interval > timeoutInterval {
            timeoutCount += 1
            print("检测到卡顿：\(timeoutCount)次")
        }
        _ = semaphore.wait(timeout: DispatchTime.now() + timeInterval)
    }
}

func startCheckMainThread() {
    DispatchQueue.global(qos: .background).async {
        
        let observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, CFRunLoopActivity.allActivities.rawValue, true, 0) { observer, activity -> Void in
//            switch activity {
//            case .entry:
//                print("RunLoop did enter a new loop cycle")
//            case .beforeTimers:
//                print("RunLoop is about to process timers")
//            case .beforeSources:
//                print("RunLoop is about to process sources (i.e. input sources)")
//            case .beforeWaiting:
//                print("RunLoop is about to wait for the timer to fire")
//            case .afterWaiting:
//                print("RunLoop just woke up from waiting")
//            case .exit:
//                print("RunLoop is exiting")
//            default:
//                break
//            }
        }
         
        
//        let observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault,
//                                                           CFRunLoopActivity.allActivities.rawValue,
//                                                           true,
//                                                          0, <#((CFRunLoopObserver?, CFRunLoopActivity) -> Void)?#>)
        
        CFRunLoopAddObserver(CFRunLoopGetMain(), observer, .commonModes)
        checkMainThreadBlock()
        CFRunLoopRemoveObserver(CFRunLoopGetMain(), observer, .commonModes)
    }
}



//第二种

class RunLoopMonitor {
    private init() {}
    
    static let shared: RunLoopMonitor = RunLoopMonitor.init()
    
    var timeoutCount = 0
    
    var runloopObserver: CFRunLoopObserver?
    var runLoopActivity: CFRunLoopActivity?
    var dispatchSemaphore: DispatchSemaphore?
    
    // 原理：进入睡眠前方法的执行时间过长导致无法进入睡眠，或者线程唤醒之后，一直没进入下一步
    func beginMonitor() {
        let uptr = Unmanaged.passRetained(self).toOpaque()
        let vptr = UnsafeMutableRawPointer(uptr)
        var context = CFRunLoopObserverContext.init(version: 0, info: vptr, retain: nil, release: nil, copyDescription: nil)
        
        runloopObserver = CFRunLoopObserverCreate(kCFAllocatorDefault,
                                                  CFRunLoopActivity.allActivities.rawValue,
                                                  true,
                                                  0,
                                                  observerCallBack(),
                                                  &context)
        CFRunLoopAddObserver(CFRunLoopGetMain(), runloopObserver, .commonModes)
        
        // 初始化的信号量为0
        dispatchSemaphore = DispatchSemaphore.init(value: 0)
        
        DispatchQueue.global().async {
            while true {
                // 方案一：可以通过设置单次超时时间来判断 比如250毫秒
        // 方案二：可以通过设置连续多次超时就是卡顿 戴铭在GCDFetchFeed中认为连续三次超时80秒就是卡顿
                let st = self.dispatchSemaphore?.wait(timeout: DispatchTime.now() + .milliseconds(80))
                
                if st == .timedOut {
                    guard self.runloopObserver != nil else {
                        self.dispatchSemaphore = nil
                        self.runLoopActivity = nil
            self.timeoutCount = 0
                        return
                    }
                    
                    if self.runLoopActivity == .afterWaiting || self.runLoopActivity == .beforeSources {
            self.timeoutCount += 1
                        
                        if self.timeoutCount < 3 { continue }
                        
                        print("------------卡顿时方法栈:\n \n")
                        DispatchQueue.global().async {
                            //第三方Crash收集组件PLCrashReporter
//                            let config = PLCrashReporterConfig.init(signalHandlerType: .BSD, symbolicationStrategy: .all)
//                            guard let crashReporter = PLCrashReporter.init(configuration: config) else { return }
//                            let data = crashReporter.generateLiveReport()
//
//                            do {
//                                let reporter = try PLCrashReport.init(data: data)
//
//                                let report = PLCrashReportTextFormatter.stringValue(for: reporter, with: PLCrashReportTextFormatiOS) ?? ""
//
//                                NSLog("------------卡顿时方法栈:\n \(report)\n")
//                            } catch _ {
//                                NSLog("解析crash data错误")
//                            }
                        }
                    }
                }
            }
        }
    }
    
    func end() {
        guard let _ = runloopObserver else { return }
        
        CFRunLoopRemoveObserver(CFRunLoopGetMain(), runloopObserver, .commonModes)
        runloopObserver = nil
    }
    
    private func observerCallBack() -> CFRunLoopObserverCallBack {
        return { (observer, activity, context) in
            let weakself = Unmanaged<RunLoopMonitor>.fromOpaque(context!).takeUnretainedValue()
            
            weakself.runLoopActivity = activity
            weakself.dispatchSemaphore?.signal()
        }
    }
}
