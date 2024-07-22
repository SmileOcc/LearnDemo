//
//  LeetCodeCtrl.swift
//  LearnDemo
//
//  Created by odd on 7/15/24.
//

import UIKit

class LeetCodeCtrl: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    let tesSoul = Solution()
    
    class func createNodeList(_ list:[Int])->ListNode {
        
        var resultNode:ListNode? = nil
        var tempNode:ListNode?
        
        for value in list {
            if resultNode == nil {
                resultNode = ListNode(value)
                tempNode = resultNode
            } else {
                tempNode!.next = ListNode(value)
                tempNode = tempNode!.next
                
            }
        }
        return resultNode ?? ListNode()
    }
    
    class func test() {
        let tesSoulL = Solution()

        tesSoulL.compareVersion2(str: "3.2.1", str2: "4.3.2.1")
        
        
        var personFloor:[Int] = [0 ,2 , 3, 5, 10, 8, 6]
        var result = tesSoulL.dianTcompute(person: personFloor, maxFloor: 6)
        print("FlyElephant-走的最小的路层--(\(result.0))--最佳楼层---(\(result.1))")

        var result2 = tesSoulL.dianTcompute2(person: personFloor, maxFloor: 6)
        print("FlyElephant-走的最小的路层--(\(result2.0))--最佳楼层---(\(result2.1))")
        
        var kk = tesSoulL.longestCommonSubsequence("abcde", "acfe")
        print(kk)
        
        let kkk = tesSoulL.findDuplicate([1,5,3,2,4,2])
        print(kkk)
        
        var list = ["9","4","8","6","7"]
        tesSoulL.quickSort(arr: &list, left: 0, right: 4)
        
        testWrite()
        
//        tesSoulL.subarraySum([1,2,3,-1,1,2,1], 3)
//        print("==和为 K 的子数组:\(tesSoulL.subarraySum([1,2,3,-1,1,2,1], 3))")
//        print("==和为 K 的子数组22:\(tesSoulL.subarraySum([0,3,0,3,-1,-1,-1,3], 3))")
        print("==和为 K 的子数组33:\(tesSoulL.subarraySum([0,2,-1,-1,2], 2))")//怎么算出五个了， [0,2],[0,2,-1,-1,2],[2],[2,-1,-1,2] //应该是4个啊

        let maxHeade = tesSoulL.longestCommonPrefix(["flower","flow","flight"])
        print("====最长公共前缀:\(maxHeade)")
        
        let node = tesSoulL.mergeTwoLists(createNodeList([1,2,3]),createNodeList([1,3,4]))
        
        print("====括号生成:\(tesSoulL.generateParenthesis(3))")
        
        print("====二进制求和：\(tesSoulL.addBinary("1010", "1011"))")
        
        print("====不同路径：\(tesSoulL.uniquePaths(3, 7))")
        
        print("====不同路径 故障：\(tesSoulL.uniquePathsWithObstacles([[0,0,0,0],[0,1,0,0],[0,0,0,0]]))")

        print("====不同路径 故障：\(tesSoulL.uniquePathsWithObstacles2([[0,0,0,0],[0,1,0,0],[0,0,0,0]]))")

        print("====加一： \(tesSoulL.plusOne([9,9,9]))")
        
        print("====爬楼梯： \(tesSoulL.climbStairs(3))")
        
        print("====最小覆盖子串：\(tesSoulL.minWindow("ADOBECODEBANC", "ABC"))")//BANC

        print("====子集：\(tesSoulL.subsets2([1,2,3]))")
        
        print("====N 皇后：\(tesSoulL.solveNQueens(4))")

        print("====最后一个单词：\(tesSoulL.lengthOfLastWord2("abc 123 "))")
        

    }
    
    static func testWrite() {
        
        //MARK: - 重小到大4321->1234
        func quictStartMinMax(source:String) -> String {
            var result = ""

            //方式一
            var list = Array(source)
            list.sort(by: <)
            result = String(list)
            print("==== \(result)")
            
            //方式二
            var listt = source.map { value in
                Int(String(value)) ?? 0
            }
            
            func quictSort(_ source:inout[Int],left:Int,right:Int) {
                var iLeft = left
                var jRight = right
                
                if left >= right {return}
                
                let base = source[jRight]
                while(iLeft != jRight) {
                    while( iLeft < jRight && source[iLeft] <= base) {
                        iLeft = iLeft + 1
                    }
                    
                    while(iLeft < jRight && source[jRight] >= base) {
                        jRight = jRight - 1
                    }
                    if iLeft != jRight {
                        source.swapAt(iLeft, jRight)
                    }
                }
                if right != iLeft {
                    source.swapAt(right, iLeft)
                }

                quictSort(&source, left: left, right: jRight - 1)
                quictSort(&source, left: iLeft + 1, right: right)
                
            }
            
            quictSort(&listt, left: 0, right: listt.count-1)
            
            result = listt.reduce(into: "", { partialResult, value in
                partialResult.append(String(value))
            })
            print("====从小到大：\(result)")
            return result
        }
        let _ = quictStartMinMax(source: "3587924") //2345789
        
        //MARK: 重小到大3587924->9875432
        func quictStartMaxMin(_ source:String) -> String {
            var reslut = ""
            var list = source.compactMap { value in
                Int(String(value))
            }
            
            func quickSort(_ sourceList:inout[Int], left:Int, right:Int) {
                if left >= right {return}
                var iLeft = left
                var iRight = right
                let base = sourceList[right]
                
                while (iLeft != iRight) {
                    while iLeft < iRight && sourceList[iLeft] >= base {
                        iLeft = iLeft + 1
                    }
                    while iLeft < iRight && sourceList[iRight] <= base {
                        iRight = iRight - 1
                    }
                    if iLeft != iRight {
                        sourceList.swapAt(iLeft, iRight)
                    }
                }
                if iLeft != right {
                    sourceList.swapAt(iLeft, right)
                }
                quickSort(&sourceList, left: left, right: iRight-1)
                quickSort(&sourceList, left: iLeft+1, right: right)
            }
            
            quickSort(&list, left: 0, right: list.count-1)
            reslut = list.reduce(into: "", { partialResult, value in
                partialResult.append(String(value))
            })
            print("====从大到小：\(reslut)")
            return reslut
        }
        
        let _ = quictStartMaxMin("3587924")//9875432
        
        //MARK: 有些花括号{}[]()
        func isValidDoubleMark(_ source:String) -> Bool {
            
            let conditDic:[Character:Character] = ["{":"}","[":"]","(":")"]
            //let list = Array(source)
            var charList = Array<Character>()
            for c in source {
                if let value = conditDic[c] {
                    charList.append(value)//进
                } else {
                    if let listValue = charList.last,listValue == c {
                        charList.removeLast()//出
                    } else {
                        return false
                    }
                }
            }
            if charList.isEmpty {
                return true
            }
            
            return false
        }
        
        print("====是否有些花括号：\(isValidDoubleMark("{{}}[]"))")
        
        //MARK: 找出数组中的con'众数’集合 如n/3
        func moreNTimes(_ sourceList:[Int],_ input:Int) {
            let count = sourceList.count / input
            var resultList = [Int]()
            
            //var coudDic = [Int:Int]()
            let coudDic = sourceList.reduce(into: [Int:Int]()) { partialResult, value in
                partialResult[value, default: 0] += 1
            }
            
            coudDic.forEach { (k,value) in
                if value >= count {
                    resultList.append(k)
                }
            }
            
            print("=====数组中的con'众数’集合 如n/3: \(resultList)")
        }
        moreNTimes([3,2,5,4,2,2,3,5],3)

        //MARK: 三数之和 0 或 N
        func threadSum(_ sourceList:[Int],sum:Int) -> [[Int]] {
            
            let tempSource = sourceList.sorted{$0<$1}
            var result = [[Int]]()
            
            for i in 0..<tempSource.count {
                
                if i > 0 && tempSource[i] == tempSource[i - 1] {
                    continue
                }
                if tempSource[0] == tempSource[1] {
                    continue
                }
                
                var left = i + 1
                var right = tempSource.count - 1
                
                while left < right{
                    
                    let tempValue = tempSource[i] + tempSource[left] + tempSource[right]
                    if tempValue < sum {
                        left += 1
                    } else if tempValue > sum {
                        right -= 1
                    } else {
                        //更新左右位置
                        result.append([tempSource[i],tempSource[left],tempSource[right]])
                        while left < right && tempSource[left] != tempSource[left+1] {
                            left += 1
                        }
                        while left < right && tempSource[right] != tempSource[right-1] {
                            right -= 1
                        }
                        left += 1
                        right -= 1
                    }
                }
            }
            
            print("====三数之和\(sum)：\(result)")
            return result
        }
        
        let _ = threadSum([2,3,1,5,3,2,6,1,0,-1,-3,-6,4], sum: 2)
        
        //MARK:  最长连续序列
        func maxCommList(_ sourceList:[Int]) -> [Int]{
            
            //不排序
            if sourceList.count <= 1{
                return sourceList
            }
            var maxCounts = 1
            
            var oldNums = [Int]()
            for value in sourceList {
                var tempCounts = 1

                if oldNums.contains(value) {
                    continue
                }
                var left = value - 1
                var right = value + 1
                while sourceList.contains(left) {
                    oldNums.append(left)
                    left -= 1
                    tempCounts += 1
                }
                while sourceList.contains(right) {
                    oldNums.append(right)
                    right += 1
                    tempCounts += 1
                }
                maxCounts = max(maxCounts, tempCounts)
            }
            
            print("====最长连续序列: 长度：\(maxCounts)")
            return sourceList

            
            //排序方式
            if sourceList.count <= 1{
                return sourceList
            }
            var results = [Int]()
            var tempResultList = [Int]()
            //排序
            let tempList = sourceList.sorted{$0<$1}
            var maxCount = 1
            var tempCount = 1
            var starValue = tempList.first!
            
            tempResultList.append(starValue)
            for i in 1..<tempList.count {
                if tempList[i] - 1 == starValue {
                    starValue = tempList[i]
                    tempCount += 1
                    tempResultList.append(starValue)
                } else if tempList[i] - 1 != starValue {
                    if maxCount < tempCount {
                        results = tempResultList
                    }
                    maxCount = max(maxCount, tempCount)
                    tempCount = 1
                    tempResultList.removeAll()
                }
                
                starValue = tempList[i]
                
                if i == tempList.count - 1 && tempCount != 1{
                    if maxCount < tempCount {
                        results = tempResultList
                    }
                    maxCount = max(maxCount, tempCount)
                    tempResultList.removeAll()

                }
                
            }
            
            print("====最长连续序列:\(results)  : \(maxCount)")
            
            return results
        }
        
        let _ = maxCommList([200,1,300,2,4,8,3,5])
        
        //MARK:  数组 两数之和下标
        func twoNumberIndex(_ source:[Int],_ sum:Int) -> [[Int]] {
            var results = [[Int]]()
//            for (i,value) in source.enumerated() {
//                let tempValue = sum - value
//                if let index = source.firstIndex(of: tempValue),index != i {
//                    results.append([i,index])
//                }
//            }
            
            var map = [Int:Int]()
            for (i,value) in source.enumerated() {
                if let index = map[sum - value] {
                    results.append([i,index])
                } else {
                    map[value] = i
                }
            }
            print("=====数组 两数之和下标:\(results)")
            return results
        }
        
        let _ = twoNumberIndex([1,3,2,8,9,5], 10)
        
        //MARK: 无重复字符的最长子串 (滑动窗口）
        func noRepeatStrMax(_ sourceStr:String) -> String {
            
            //方式一：只计算最大长度
            var maxLength = 0
            var start = 0
            var mapLengthDic = [Character:Int]()
            for (i,value) in Array(sourceStr).enumerated() {
                if let oldLength = mapLengthDic[value] {
                    start = max(start, oldLength)
                }
                mapLengthDic[value] = i + 1
                maxLength = max(maxLength, i - start + 1)
                
            }
            let resutlss = NSString(string: sourceStr).substring(with: NSRange(location: start + 1 - maxLength, length: maxLength))
            print("=====无重复字符的最长子串 (滑动窗口）:\(resutlss) 开始位置：\(start + 1 - maxLength) 最大长度：\(maxLength)")
            
            
            //方式一：输出最大长度内容
            //起始位置
            if sourceStr.isEmpty {
                return ""
            }
            let list = Array<Character>(sourceStr)
            var result = String(list.first!)
            var maxCount = 1
            
            for (startIndex,value) in list.enumerated() {
                var tempStr = String(value)
                
                if list.count - startIndex < maxCount {
                    break
                }
                var nextIndex = startIndex + 1
                while nextIndex < list.count && tempStr.contains(list[nextIndex]) == false  {
                    tempStr.append(String(list[nextIndex]))
                    nextIndex += 1
                }
                if maxCount < nextIndex - startIndex {
                    result = tempStr
                }
                maxCount = max(maxCount, nextIndex - startIndex)
            }
            print("====无重复字符的最长子串 (滑动窗口）: \(result)")
            return result
        }
        
        let _ = noRepeatStrMax("abcbdefeh")//cbdef
        
        
        //MARK: 盛最多水的容器
        func maxWaterNumber(_ sourceList:[Int]) -> Int {
            if sourceList.count <= 1 {
                return 0
            }
            
            var result = 0
            var left = 0
            var right = sourceList.count - 1
            
            while left != right {
                result = max(result, (right - left) * min(sourceList[left], sourceList[right]))
                if sourceList[left] < sourceList[right] {
                    left += 1
                } else {
                    right -= 1
                }
            }
            print("===== 盛最多水的容器:\(result)")
            
            return result
        }
        
        let _ = maxWaterNumber([1,8,6,2,5,4,8,3,7])//49
        
        
        //MARK: 最大子数组和
        func maxSubListSum(_ sourceList:[Int]) -> Int {
            var results = 0
            var tempSum = 0
            for value in sourceList {
//                tempSum += value
//                if tempSum <= 0{
//                    tempSum = 0
//                }
                //与上基本等价【前面的和】+ 【当前值】> 【当前值】，有效追加，不然就从【当前值开始】
                tempSum = max(tempSum + value, value)
                results = max(results, tempSum)
                
                
            }
            print("====最大子数组和:\(results)")
            return results
        }
        
        let _ = maxSubListSum([-2,1,-3,4,-1,2,1,-5,4])//[4,-1,2,1] = 6
        
        //MARK: 和为 K 的子数组
        func subListSumK(_ sourceList:[Int],inputK:Int) -> Set<[Int]> {
            var results = Set<[Int]>() //去重复
            var commResults = [[Int]]()
            
            var tempValue = 0
            var mapDic = [Int:Int]()
            var count = 0
            for (i,value) in sourceList.enumerated() {
                tempValue = value
                
                if tempValue == inputK {
                    // 有重复的，除非可以重复子数组
                    mapDic[i,default: 0] += 1
                    results.insert([value])
                    commResults.append([value])
                }
                
                for j in (i+1)..<sourceList.count {
                    tempValue += sourceList[j]
                    
                    if tempValue == inputK {
                        mapDic[i,default: 0] += 1
                        results.insert([Int](sourceList[i...j]))
                        commResults.append([Int](sourceList[i...j]))

                    }
                }
                count += mapDic[i] ?? 0
                
            }
            
            print("========:和为 K 的子数组:个数：\(results.count)  集合：\(results)")
            print("========:和为 K 的子数组 不去重:个数：\(commResults.count)  集合：\(commResults)")

            return results
        }
        
//        _ = subListSumK([1,2,3,-1,1,2,1], inputK: 3)
        _ = subListSumK([0,3,0,3,-1,-1,-1,3], inputK: 3)
        _ = subListSumK([0,2,-1,-1,2], inputK: 2)//[[0, 2], [2, -1, -1, 2], [0, 2, -1, -1, 2], [2],[2]

        
        //MARK: 移动零
        func zeorMove(_ sourceList:inout [Int]) {
            var start = 0
            for value in sourceList {
                if value != 0 {
                    sourceList[start] = value
                    start += 1
                }
            }
            
            for _ in start..<sourceList.count {
                sourceList[start] = 0
            }
        }
        
        var lisss = [3,0,2,1,0,0]
        zeorMove(&lisss)
        print("=====移动零：\(lisss)")
        
        //MARK: 寻找两个正序数组的中位数
        func findMedianSortedArrays(_ nums1: [Int], _ nums2: [Int]) -> Double {
            var tempList = [Int]()
            tempList.append(contentsOf: nums1)
            tempList.append(contentsOf: nums2)
            tempList.sort(by: <)
            if tempList.count%2 == 0 {
                return Double((tempList[tempList.count/2-1] + tempList[tempList.count/2])) / 2.0
            } else {
                return Double(tempList[tempList.count/2])
            }
        }
        
        print("====寻找两个正序数组的中位数:\(findMedianSortedArrays([1,3,4], [2,5,6]))")

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


class Solution {
    
    //MARK:数字重大到小324324=》443322
    func quickSort(arr:inout[String],left:Int,right:Int) {
        if(left >= right) {return}
        var i = left
        var j = right
        let base = arr[j]
        
        while(i != j) {
            while(i<j && arr[i] >= base) {
                i = i + 1 //往后走
            }
            while(i<j && arr[j] <= base) {
                j = j - 1 //j往前走
            }
            arr.swapAt(i, j)
        }
        arr.swapAt(right, i)
        
        quickSort(arr:&arr,left:left,right:i-1)
        quickSort(arr: &arr, left: i+1, right: right)
        print(arr)
            
    }
    
    func quickSort22(_ str:String) -> String {
        var list = Array(str)
        list.sort(by: > )
        //let list1 = list.sorted{ $0 > $1 }
        let result = String(list)
        return result
    }
    
    //MARK: 合并两个有序数组
//    1）初始化nums1 和 nums2的元素数量分别为 m 和 n
//    2）你可以假设 nums1 有足够的空间（控件大小大于或等于 m+n）来保存 nums2 中的元素
    func merge(_ nums1: inout [Int], _ m: Int, _ nums2: [Int], _ n: Int) {
        /*
         合并后排序
         */
        nums1 = [Int](nums1[0..<m])
        nums1.append(contentsOf: nums2)
        nums1 = nums1.sorted()
        print(nums1)

//        for num in nums2 {
//            nums1.append(num)
//        }
    }
    
    
    
//    解法二：从前往后排序
//    思想：比较两个数组的第一个元素，然后加入新的数组，移除旧数组中的，最后判断是否有剩下的，若有全部加入新数组，最后将新数组赋值给nums1
    func merge2(_ nums1: inout [Int], _ m: Int, _ nums2: [Int], _ n: Int) {
            /*
             从前往后排序
             */
            if m==0 {
                nums1 = nums2
            }
            var num = [Int]()
            var newNum1 = [Int](nums1[0..<m])
            var nums2 : [Int] = nums2
        
            while !newNum1.isEmpty && !nums2.isEmpty {
                if newNum1.first! <= nums2.first!{
                    num.append(newNum1.first!)
                    newNum1.removeFirst()
                }else{
                    num.append(nums2.first!)
                    nums2.removeFirst()
                }
                if newNum1.isEmpty {
                    num.append(contentsOf: nums2)
                    nums1 = num
                }
                if nums2.isEmpty{
                    num.append(contentsOf: newNum1)
                    nums1 = num
                }
            }
            print(nums1)
            
        }

//    解法三：从后往前排序
//
//    思想：利用双指针，将最大的数加入nums1，依次循环
    func merge3(_ nums1: inout [Int], _ m: Int, _ nums2: [Int], _ n: Int) {
            //双指针 从后往前
            var p1 = m-1
            var p2 = n-1
            var p = m+n-1
            while p1>=0 && p2>=0 {
                if  nums1[p1] <= nums2[p2]{
                    nums1[p] = nums2[p2]
                    p2 -= 1
                    p -= 1
                }else{
                    nums1[p] = nums1[p1]
                    p1 -= 1
                    p -= 1
                    
                }
            }
            while p2 >= 0 {
                nums1[p] = nums2[p2]
                p -= 1
                p2 -= 1
            }
        }

    //MARK: 找出数组中的“众数”（出现次数大于数组长度1/3的数）（1.直接遍历存到哈希表，然后计数。2.摩尔投票。）
//    思想：利用字典存储每个数字出现的次数，最后取出每个数字的字数与 比较，次数大于它的即为众数
//
//    时间复杂度：O(n)

    func majorityElement(_ nums : [Int])->Int{
        
        /*
         哈希表
         */
        
        if nums.count == 0{
            return 0
        }
        let count = nums.count / 3
        var dic : [Int:Int] = [Int:Int]()
        for num in nums {
            if dic[num] == nil {
                dic[num]  = 1
            }else{
                dic[num] = dic[num]! + 1
            }
        }
        for (key, value) in dic {
            if value > count{
                return key
            }else{
                return 0
            }
        }
        return 0
    }

    
    //MARK: ----- 哈希
    //MARK:  数组 两数之和下标

//    给定一个整数数组 nums 和一个整数目标值 target，请你在该数组中找出 和为目标值 target  的那 两个 整数，并返回它们的数组下标。
//    你可以假设每种输入只会对应一个答案。但是，数组中同一个元素在答案里不能重复出现。
//    你可以按任意顺序返回答案。
//    示例 1：
//
//    输入：nums = [2,7,11,15], target = 9
//    输出：[0,1]
//    解释：因为 nums[0] + nums[1] == 9 ，返回 [0, 1] 。
    func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
        // 值: 下标
        var map = [Int: Int]()
        for (i, e) in nums.enumerated() {
            if let v = map[target - e] {
                return [v, i]
            } else {
                map[e] = i
            }
        }
        return []
    }
    //MARK:  字母异位词


//    给你一个字符串数组，请你将 字母异位词 组合在一起。可以按任意顺序返回结果列表。
//    字母异位词 是由重新排列源单词的所有字母得到的一个新单词。
//输入: strs = ["eat", "tea", "tan", "ate", "nat", "bat"]
//输出: [["bat"],["nat","tan"],["ate","eat","tea"]]
    
    func groupAnagrams(_ strs: [String]) -> [[String]] {
        var group = [String: [String]]()
        for str in strs {
            group[String(str.sorted()), default: []].append(str)
        }
        return Array(group.values)
    }
    
    
    
    //MARK:  最长连续序列
    //给定一个未排序的整数数组 nums ，找出数字连续的最长序列（不要求序列元素在原数组中连续）的长度。
    
//    输入：nums = [100,4,200,1,3,2]
//    输出：4
//    解释：最长数字连续序列是 [1, 2, 3, 4]。它的长度为 4。
    
//    此处撰写解题思路 1
//    把集合数组转换成集合。
//    遍历所有元素，设当前元素为item，寻找item - 1 , item + 1是否在集合中，循环查找
//    记录已经查找过的数，下次遇见不予重复查找
//    去所有值中最大值。

    
    func longestConsecutive(_ nums: [Int]) -> Int {
        let setCollect = Set(nums)
        var cs = Set<Int>()
        var ans = 0
        for item in setCollect{
            //统计过的数，不再统计
            if cs.contains(item){
                continue
            }
            
            //双指针寻找左右两边的数是否存在
            var left = item - 1
            var right = item + 1
            
            var count = 1
            cs.insert(item)
            //左边的数是否存在
            while setCollect.contains(left){
                cs.insert(left)
                left -= 1
                count += 1
            }
            //右边的数是否存在
            while setCollect.contains(right){
                cs.insert(right)
                right += 1
                count += 1
            }
            //取最大值
            ans = max(ans,count)
        }
        
        return ans
    }

    
//    此处撰写解题思路 2
//
//    把集合数组转换成集合。
//    遍历所有元素，设当前元素为item，寻找item - 1 不在集合中的数。那么此item就是连续数字中最左边的数。
//    在item的基础上，在集合中循环+1寻找其后面的数。并记录长度。
//    去所有值中最大值。

    func longestConsecutive2(_ nums: [Int]) -> Int {
        let setCollect = Set(nums)
        var ans = 0
        //for item in nums 用这一句跑用例400ms+，用下面遍历集合的方式跑用例，160ms左右。这性能差的有点大
        for item in setCollect{
            if setCollect.contains(item - 1){
                continue
            }
            
            var index = item
            var count = 0
            while setCollect.contains(index){
                index += 1
                count += 1
            }
            ans = max(ans,count)
        }
        
        return ans
    }
    
    //MARK: 移动零
    //给定一个数组 nums，编写一个函数将所有 0 移动到数组的末尾，同时保持非零元素的相对顺序。

    //请注意 ，必须在不复制数组的情况下原地对数组进行操作。


//    示例 1:
//
//    输入: nums = [0,1,0,3,12]
//    输出: [1,3,12,0,0]

    func moveZeroes(_ nums: inout [Int]) {
            // 新的数组计数
            var n = 0
            // 遍历老数组
            for i in 0 ..< nums.count {
                // 将不是0的值赋值到新数组
                if nums[i] != 0 {
                    nums[n] = nums[i]
                    n += 1
                }
            }
            // 后面位置补齐0
            while n < nums.count {
                nums[n] = 0
                n += 1
            }
        }

    //MARK: 盛最多水的容器
//    给定一个长度为 n 的整数数组 height 。有 n 条垂线，第 i 条线的两个端点是 (i, 0) 和 (i, height[i]) 。
//
//    找出其中的两条线，使得它们与 x 轴共同构成的容器可以容纳最多的水。
//
//    返回容器可以储存的最大水量。
//
//    说明：你不能倾斜容器。
//    输入：[1,8,6,2,5,4,8,3,7]
//    输出：49
//    解释：图中垂直线代表输入数组 [1,8,6,2,5,4,8,3,7]。在此情况下，容器能够容纳水（表示为蓝色部分）的最大值为 49。

    func maxArea(_ height: [Int]) -> Int {
        var left = 0, right = height.count - 1
        var maxWater = 0
        while left < right {
            maxWater = max(maxWater, (right - left) * min(height[left], height[right]))
            if height[left] < height[right] {
                left += 1
            } else {
                right -= 1
            }
        }
        return maxWater
    }

    
    //MARK: 三数之和【双指针法】
    // 双指针法
    func threeSum(_ nums: [Int]) -> [[Int]] {
        var res = [[Int]]()
        var sorted = nums
        sorted.sort()//先排序
        
        for i in 0..<sorted.count {
            
            if sorted[i] > 0 {
                return res
            }
            if i > 0 && sorted[i] == sorted[i - 1] {
                continue
            }
            var left = i + 1
            var right = sorted.count - 1
            while left < right {
                
                //三数相加
                let sum = sorted[i] + sorted[left] + sorted[right]
                if sum < 0 {
                    left += 1
                } else if sum > 0 {
                    right -= 1
                } else {
                    res.append([sorted[i], sorted[left], sorted[right]])
                    
                    //相同位置移动
                    while left < right && sorted[left] == sorted[left + 1] {
                        left += 1
                    }
                    while left < right && sorted[right] == sorted[right - 1] {
                        right -= 1
                    }
                    
                    left += 1
                    right -= 1
                }
            }
        }
        return res
    }

    //MARK: 无重复字符的最长子串 (滑动窗口）
//    给定一个字符串 s ，请你找出其中不含有重复字符的 最长子串的长度。
//输入: s = "abcabcbb"
//输出: 3
//解释: 因为无重复字符的最长子串是 "abc"，所以其长度为 3。
    
    func lengthOfLongestSubstring(_ s: String) -> Int {
        var maxLen = 0
        var start = 0
        var map = Dictionary<Character, Int>()
        let chars = Array(s)
        
        //每个字符对应一个长度
        for (end, c) in chars.enumerated() {
            if let pos = map[c] {
                start = max(start, pos)
            }
            map[c] = end + 1
            maxLen = max(maxLen, end - start + 1)
        }
        return maxLen
    }
    
    //MARK: 找到字符串中所有字母异位词 ???
//    给定两个字符串 s 和 p，找到 s 中所有 p 的 异位词 的子串，返回这些子串的起始索引。不考虑答案输出的顺序。
//
//    异位词 指由相同字母重排列形成的字符串（包括相同的字符串）。
//输入: s = "cbaebabacd", p = "abc"
//输出: [0,6]
//解释:
//起始索引等于 0 的子串是 "cba", 它是 "abc" 的异位词。
//起始索引等于 6 的子串是 "bac", 它是 "abc" 的异位词。

    func findAnagrams(_ s: String, _ p: String) -> [Int] {
            let s = [Character](s)
            let pLength = p.count
            var needCount = pLength
            
            var need = [Character: Int]()
            for ch in p {
                need[ch, default: 0] += 1
            }
            
            var res = [Int]()
     
            var left = 0
            for index in 0..<s.count {
                
                //判断是否在目标集合内
                let str = s[index]
                
                if let val = need[str] {
                    if val > 0 {
                        needCount -= 1
                    }
                    need[str, default: 0] -= 1
                }
                
                if needCount == 0 {
                    // 收缩左侧
                    while left < index && (need[s[left]] == nil || need[s[left]]! < 0) {
                        if need[s[left]] != nil {
                            need[s[left], default: 0] += 1
                        }
                        left += 1
                    }
                    
                    if index - left + 1 == pLength {
                        res.append(left)
                    }
                    
                    // l右移一位
                    need[s[left], default: 0] += 1
                    left += 1
                    needCount += 1
                }
            }
            
            return res
        }
    
    //MARK: 和为 K 的子数组 这个很巧妙 【注意可以重复子集】[1,1] [1,1] 位置不同 ###
//    给你一个整数数组 nums 和一个整数 k ，请你统计并返回 该数组中和为 k 的子数组的个数 。
//
//    示例 1：
//
//    输入：nums = [1,1,1], k = 2
//    输出：2  【注意可以重复子集】[1,1] [1,1] 位置不同
//    示例 2：
//
//    输入：nums = [1,2,3], k = 3
//    输出：2
//    子数组是数组中元素的连续非空序列。
    func subarraySum(_ nums: [Int], _ k: Int) -> Int {
        var prefixSum=0//初始化当前前缀和

        var countPreSum=[Int:Int]()//此字典用来存放，每个前缀和值出现的次数.key为prefixSum，value为此前缀和出现的次数

        var count=0//符合条件的子数组个数

        //遍历nums数组，构建前缀和数组
        //这句话很重要
        //因为这样才能确保nums[j...i]=nums[0...i]-nums[0...j-1]=k,当j=0时,nums[0...-1]=0
        //（nums[j...i]后面的方括号表示从 j到i nums的和）
        countPreSum[0]=1
        for value in nums {
            prefixSum += value
            if let pre=countPreSum[prefixSum-k]{
                count+=pre
            }
            //重复和要加-,如:第一次[1,2]和为3算一个,后续出现和第二次[1,2,-1,-2,1,2]和为3,这又增加算两个([1,2,-1,-2,1,2],[1,2]),以此累加
            countPreSum[prefixSum,default: 0]+=1

        }
        return count
    }
    
    //[0,2,-1,-1,2], 2)
//    func subarraySum(_ nums: [Int], _ k: Int) -> Int {
//        var result: Int = 0
//        var presum: [Int: Int] = [:]
//        var sum: Int = 0
//
//        for i in 0 ..< nums.count {
//            sum += nums[i]
//            if sum == k { result += 1 }
//            if let count = presum[sum - k] { result += count }
//            presum[sum, default: 0] += 1
//        }
//
//        return result
//    }


    //[1,2,3,-1,1,2,1], 3 ========6
    
    
    //MARK: 最大子数组和
    
//    给你一个整数数组 nums ，请你找出一个具有最大和的连续子数组（子数组最少包含一个元素），返回其最大和。
//
//    子数组
//    是数组中的一个连续部分。
//    输入：nums = [-2,1,-3,4,-1,2,1,-5,4]
//    输出：6
//    解释：连续子数组 [4,-1,2,1] 的和最大，为 6 。
    
    //我们要求 和最大，且 元素连续。 因为 元素存在负数，所以我们要尽可能的去掉边缘 负数

    func maxSubArray(_ nums: [Int]) -> Int {
        
        //! 累加和，用来判断 加上这个数字，是否有利于前面的和
        var pre = 0
        //! 最大和
        var maxSum = nums[0]
        
        for value in nums {
            pre = max(pre + value, value)
            maxSum = max(pre, maxSum)
        }
        
        return maxSum
    }
    
    //MARK: 合并区间 数组
    
//    以数组 intervals 表示若干个区间的集合，其中单个区间为 intervals[i] = [starti, endi] 。请你合并所有重叠的区间，并返回 一个不重叠的区间数组，该数组需恰好覆盖输入中的所有区间 。
//    示例 1：
//
//    输入：intervals = [[1,3],[2,6],[8,10],[15,18]]
//    输出：[[1,6],[8,10],[15,18]]
//    解释：区间 [1,3] 和 [2,6] 重叠, 将它们合并为 [1,6].
    
    func merge(_ intervals: [[Int]]) -> [[Int]] {
        if intervals.count == 1 {
            return intervals
        }
        
        //排序区间小序号在前
        let sortedArr = intervals.sorted { $0[0] < $1[0] }
        
        var ret:[[Int]] = [sortedArr[0]]
        var idx = 1
        while idx < sortedArr.count {
            let interval = sortedArr[idx];
            
            //取当前结果集合最后一组
            let retLast = ret.last!;
            
            //当前与上一次最后一个比,当前集合start < 上次end
            //上次end < 当前start
            if interval[0] <= retLast[1] {
                if retLast[1] < interval[1] {
                    //改变上一个之前集合的end大小
                    ret[ret.count - 1][1] = interval[1]
                }
                idx += 1
                continue
            }
            ret.append(interval)
            idx += 1
        }
        
        return ret;
    }

    
    //MARK:寻找重复数
//    给定一个包含 n + 1 个整数的数组 nums ，其数字都在 [1, n] 范围内（包括 1 和 n），可知至少存在一个重复的整数。
//
//    假设 nums 只有 一个重复的整数 ，返回 这个重复的数 。
    //判断环形链表原理
    
    //快慢指针
    func findDuplicate(_ nums: [Int]) -> Int {
        var slow = 0
        var fast = 0

        slow = nums[slow]
        fast = nums[nums[fast]]
        
        while slow != fast {
            slow = nums[slow]
            fast = nums[nums[fast]]
        }
        
        fast = 0
        
        while slow != fast {
            slow = nums[slow]
            fast = nums[fast]
        }
        
        return slow
    }
    
    
    //MARK: 只出现一次的数字
//    给你一个 非空 整数数组 nums ，除了某个元素只出现一次以外，其余每个元素均出现两次。找出那个只出现了一次的元素。
//
//    你必须设计并实现线性时间复杂度的算法来解决此问题，且该算法只使用常量额外空间。
    
    //异或
    func singleNumber(_ nums: [Int]) -> Int {
        //  第一反应用map
        //  考虑到不适用额外空间，用异或
        //  a ^ 0 = a
        //  a ^ a = 0
        //  a ^ b ^ a = a ^ a ^ b = 0 ^ b = b
        return nums.reduce(0) { $0 ^ $1 }
    }

//    func singleNumber(_ nums: [Int]) -> Int {
//        var result = 0
//        for num in nums {
//            result = result ^ num
//        }
//        return result
//    }

    
    
    //MARK: 最长公共子序列 (动态规划)  ????
//    给定两个字符串 text1 和 text2，返回这两个字符串的最长 公共子序列 的长度。如果不存在 公共子序列 ，返回 0 。
//
//    一个字符串的 子序列 是指这样一个新的字符串：它是由原字符串在不改变字符的相对顺序的情况下删除某些字符（也可以不删除任何字符）后组成的新字符串。
//
//    例如，"ace" 是 "abcde" 的子序列，但 "aec" 不是 "abcde" 的子序列。
//    两个字符串的 公共子序列 是这两个字符串所共同拥有的子序列。
//
//    示例 1：
//
//    输入：text1 = "abcde", text2 = "ace"
//    输出：3
//    解释：最长公共子序列是 "ace" ，它的长度为 3

    
//    dp[i][j] 表示text1的前i个元素与text2的前j个元素的最长公共子序列长度;
//    如果text1[i-1] == text2[j-1]，那么dp[i][j] = dp[i-1][j-1] + 1;
//    如果text1[i-1] != text2[j-1]，那么dp[i][j] = max(dp[i-1][j], dp[i][j-1]);

//    放到坐标系里,text1的为colu,text2的为row
    
    func longestCommonSubsequence(_ text1: String, _ text2: String) -> Int {
        
        var dp: [[Int]] = Array(repeating: Array(repeating: 0, count: text2.count + 1), count: text1.count + 1)
        
        let array1 = Array(text1)
        let array2 = Array(text2)
        
        for i in 1...array1.count {
            for j in 1...array2.count {
                if array1[i - 1] == array2[j - 1] {
                    dp[i][j] = dp[i - 1][j - 1] + 1
                } else {
                    dp[i][j] = max(dp[i][j - 1], dp[i - 1][j])
                }
            }
        }
        
        return dp[text1.count][text2.count]
    }
    
    
    
    
    
    //MARK:
    
//    给定一个只包括 '('，')'，'{'，'}'，'['，']' 的字符串 s ，判断字符串是否有效。
//
//    有效字符串需满足：
//
//    左括号必须用相同类型的右括号闭合。
//    左括号必须以正确的顺序闭合。
//    每个右括号都有一个对应的相同类型的左括号。
//
//
//    示例 1：
//
//    输入：s = "()"
//    输出：true
//    示例 2：
//
//    输入：s = "()[]{}"
//    输出：true
    
//    利用栈后进先出的特性，来实现匹配
//
//    奇数可以直接返回，肯定不匹配
//    使用一个dic，存储左右括号的对应关系
//    遍历字符串
//    4. 如果是左括号（即是dic中的key），那么入栈
//    如果是右括号，查看其与栈顶元素是否匹配
//    6.栈空或不匹配，直接返回false
//    7.匹配，栈顶元素出栈，继续遍历
//    最后返回，栈是否为空，栈空才true
//    几点注意：
//
//    栈本质就是只有一端可操作的线性表，因此在swift中直接用普通的array就可以实现
//    popLast和removeLast作用相同，但是popLast可以对处理栈空的情况

    
    func isValid(_ s: String) -> Bool {
            //偶数直接返回false
            guard s.count%2 == 0 else {
                return false
            }
            // 哈希表存储左右对应的括号
            let map:[Character:Character] = [ "(":")",
                        "[":"]",
                        "{":"}"
            ]
            var stack = [Character]()
            for char in s {
                //左括号直接入栈
                if map[char] != nil {
                    stack.append(char)
                }else {//右括号与栈顶匹配,查看是否成功
                    if stack.isEmpty  {//栈为空，返回false
                        return false
                    }else if map[stack.last!] != char{//右括号与栈顶元素不匹配，返回false
                        return false
                    }else {//右括号与栈顶匹配，出栈，继续遍历
                        stack.popLast()
                    }
                }
            }
            return stack.isEmpty
            
        }
    
    
    //MARK: ----- 二叉树
    
    
    //MARK: 二叉树的中序遍历
    func inorderTraversal(_ root: TreeNode?) -> [Int] {
        guard let root = root else { return [] }
        
        var seq: [Int] = []
        seq += inorderTraversal(root.left)
        seq.append(root.val)
        seq += inorderTraversal(root.right)
        
        return seq
    }
    


    //MARK: 翻转二叉树
    // 前序遍历-递归
    func invertTree(_ root: TreeNode?) -> TreeNode? {
        guard let root = root else {
            return root
        }
        let tmp = root.left
        root.left = root.right
        root.right = tmp
        let _ = invertTree(root.left)
        let _ = invertTree(root.right)
        return root
    }

    // 层序遍历-迭代
    func invertTree1(_ root: TreeNode?) -> TreeNode? {
        guard let root = root else {
            return nil
        }
        var queue = [TreeNode]()
        queue.append(root)
        while !queue.isEmpty {
            let node = queue.removeFirst()
            let tmp = node.left
            node.left = node.right
            node.right = tmp
            if let left = node.left {
                queue.append(left)
            }
            if let right = node.right {
                queue.append(right)
            }
        }
        return root
    }

    
    //MARK: 二叉树中的最大路径和】递归分治
    
//    二叉树中的 路径 被定义为一条节点序列，序列中每对相邻节点之间都存在一条边。同一个节点在一条路径序列中 至多出现一次 。该路径 至少包含一个 节点，且不一定经过根节点。
//
//    路径和 是路径中各节点值的总和。
//
//    给你一个二叉树的根节点 root ，返回其 最大路径和 。
    
    func maxPathSum(_ root: TreeNode?) -> Int {
        var pathMax = Int.min
        // 递归计算左右子节点的最大贡献值
        func dfs(_ root: TreeNode?) -> Int{
            // check
            guard let element = root else { return 0 }
            // Divide
            let leftMax = dfs(element.left)
            let rightMax =  dfs(element.right)
            // Conquer
            // 节点的最大路径和取决于该节点的值与该节点的左右子节点的最大贡献值
            //只有在最大贡献值大于 0 时，才会选取对应子节点
            let res = max(max(leftMax , rightMax) + element.val, element.val)
                    pathMax = max(pathMax, max(res,leftMax + rightMax + element.val))

                return res

        }
        dfs(root)
        return pathMax
    }

    
    //MARK: ----- 链表
    
    //MARK: 反转链表
    
    /* 迭代法
            依次遍历每个结点，将该结点 next 指向上一个结点
            用一个临时变量保存上一个结点
        
        时间复杂度：O(n)，因为涉及到遍历
        空间复杂度：O(1)，没有额外开销
        */
    func reverseList(_ head: ListNode?) -> ListNode? {
        // 保存上一个结点
        var pre: ListNode?
        // 当前遍历的结点
        var head = head
        
        while head != nil {
            // 当前结点的下一个结点
            let next = head!.next
            // 将当前结点 next 指向上一个结点
            head!.next = pre
            // 向后移动上一个结点和当前结点
            pre = head
            head = next
        }
        
        return pre
    }

    
    /* 递归法
            反转 n1->n2->...->nm，相当于反转 n1->(nil<-n2<-...<-nm)
            所以最小单位为只有两个结点的链表的反转
            而反转 nk->n(k+1) 即为 nk.next.next = nk
            子链表反转完毕后将头结点指向 null
            
        时间复杂度：O(n)，因为涉及到遍历
        空间复杂度：O(n)，因为递归的深度会有额外开销
        */
        
        func reverseList2(_ head: ListNode?) -> ListNode? {
            // 终止条件，只剩下一个结点
            guard let h = head, let next = h.next else { return head }
            
            // 先反转当前结点之后的所有结点
            let node = reverseList2(next)
            // 反转当前结点和下一个结点
            next.next = head
            // 将当前结点指向 null
            h.next = nil
            
            return node
        }
    
    
    //MARK: 第一个不重复字母
    
//    给定一个字符串 s ，找到 它的第一个不重复的字符，并返回它的索引 。如果不存在，则返回 -1 。
//    示例 1：
//
//    输入: s = "leetcode"
//    输出: 0
//    示例 2:
//
//    输入: s = "loveleetcode"
//    输出: 2
    
//定义一个字典:[字符串的每个字符为key:value是记录每个字符出现的次数]
//第一次遍历字符串：记录每个字符出现的次数
//第二次遍历字符串：找到出现次数为1的字符下标

    func firstUniqChar(_ s: String) -> Int {
        let dict = s.reduce(into: [Character:Int]()) { $0[$1, default: 0] += 1 }
        for (i, c) in s.enumerated() {
            if dict[c] == 1 {
                return i
            }
        }
        return -1
    }
    
    
    func firstUniqChar1(_ s: String) -> Int {
        
        var map:[Character: Int] = [:]
        for char in s {
            if var value = map[char] {
                value = value + 1
                map[char] = value
            } else {
                map[char] = 1
            }
        }
        for(i, char) in s.enumerated() {
            if map[char] == 1 {
                return i
            }
        }
        return -1
    }

    
    //MARK: 电梯调度
//    电梯在高峰时间，每层都有人上下，电梯每层都停，在繁忙的上下班时间，每次电梯从一层往上走时，假设只允许电梯停在其中的某一层。所有乘客从一楼上电梯，到达某层后，电梯停下来，所有乘客再从这里爬楼梯到自己的目的层。在一楼的时候，每个乘客选择自己的目的层，电梯则计算出应停的楼层。
//    问：电梯停在哪一层楼，能够保证这次乘坐电梯的所有乘客爬楼梯的层数之和最少？

    //暴力for循环
    
    func dianTcompute(person:[Int],maxFloor:Int) -> (Int,Int) {

        var minFloor:Int = 0
        var targetFloor:Int = 0
        
        for i in 1...maxFloor { // 电梯停留在i层
            var temp:Int = 0
            for j in 1...maxFloor {
                temp += person[j] * abs(i - j)
            }
            
            if i == 1 {
                minFloor = temp
                targetFloor = 1
            } else {
                if temp < minFloor {
                    minFloor = temp
                    targetFloor = i
                }
            }
        }
        
        return (minFloor,targetFloor)
    }
    
//    假设N1为第i层以下的乘客数，N2为第i层的乘客数，N3为第i层以上的乘客数，已知乘客在第i层的nFloor值为count
//    如果电梯改停在i-1层时，那么此时nFloor值为count-N1+（N2+N3）
//    如果电梯改停在i+1层时，此时nFloor值为count+N1+N2-N3
//    由此可见N1+N2<N3时，停i+1层更好，这样我们先计算第一层时的N1、N2、N3的值，时间复杂度为O(n).

    func dianTcompute2(person:[Int],maxFloor:Int) -> (Int,Int) {
        var n1:Int = 0 // 第i层以下的人数
        var n2:Int = person[1] // 第i层的人数
        var n3:Int = 0 // 第i层以上的人数
        
        var countFloor:Int = 0 // 第i层的时候所走的楼层总数
        var targetFloor:Int = 1

        for i in 2...maxFloor {
            countFloor += person[i] * (i - 1)
            n3 += person[i]
        }
        
        // 如果楼层变为i-1层 总层为 count + (n2 + n3 - n1)
        // 如果楼层变为i+1层 总层为 count + (n1 + n2 - n3)
        for i in 2...maxFloor {
            if n1+n2 < n3 {
                targetFloor = i
                countFloor += n1 + n2 - n3
                n1 += n2 //n1 增加
                n2 = person[i]
                n3 -= person[i] // n3 减少
            } else {
                break
            }
        }
        
        return (countFloor,targetFloor)
    }
    
    
    //MARK:165. 比较版本号 (直接compare比较）
    func compareVersion(_ version1: String, _ version2: String) -> Int {
       
       let version1 = version1.split(separator: ".").map({String($0)})
       let version2 = version2.split(separator: ".").map({String($0)})
       
       var n1 = 0 , n2 = 0
       
       while n1<version1.count || n2<version2.count {
           var count1 = 0
           if n1<version1.count {
               count1 = Int(version1[n1])!
           }
           
           var count2 = 0
           if n2<version2.count {
               count2 = Int(version2[n2])!
           }
           
           if count1 > count2 {
               return 1
           }
           
           if count1 < count2 {
               return -1
           }
           
           n1 += 1
           n2 += 1
       }
       return 0
       
   }

   //去掉.字符，转数字，如果长度不同，处理成相同长度，比较数字大小
    func compareVersion2(str:String, str2:String) -> Int {
        
        //直接用comare
        let isMax = str.compare(str2)//orderedAscending
        let isMax2 = str2.compare(str)//orderedDescending

        let isCmpare = "123".compare("123") //orderedSame
        let isCmpare2 = "123".compare("1230") //orderedAscending
        let isCmpare3 = "v223".compare("v1230") //orderedDescending

        let tempStr = str.replacingOccurrences(of:".", with: "")
        let tempStr2 = str2.replacingOccurrences(of:".", with: "")
        let count = abs(tempStr.count - tempStr2.count)
        
        var strint = Int(tempStr) ?? 0
        var str2Int = Int(tempStr2) ?? 0
        
        if tempStr.count > tempStr2.count {
            str2Int = str2Int * count * 10
        }
        
        if tempStr.count < tempStr2.count {
            strint = strint * count * 10
        }
        
        if strint > str2Int {
            return 1
        }
        if strint < str2Int {
            return 2
        }
        return 0
    }
    
    //MARK: 整数反转 123->321
    func intReverse(_ x:Int) -> Int {
        var res = 0
        var tempX = x
        while tempX != 0 {
            res = res * 10 + tempX % 10
            tempX = tempX / 10
            if res > Int32.max || res < Int32.min {
                return 0
            }
        }
        
        return res
    }
    
    //MARK: 最长公共前缀
    func longestCommonPrefix(_ strs: [String]) -> String {
        var result = ""
        if strs.count > 0 {
            if let firstObjc = strs.first {
                if strs.count > 1 {
                    
                    //排序后比较第一个与最后一个
                    let numbers = strs.sorted()
                    //                print(numbers)
                    let first = numbers.first!
                    let last = numbers.last!
                    
                    let lastArray = Array(last)
                    for (index, firstChar) in first.enumerated() {
                        if lastArray[index] != firstChar {
                            return result
                        }
                        
                        result += String(firstChar)
                    }
                } else {
                    result = firstObjc
                }
            }
        }
        return result
    }
    
    //MARK: 四数之和
//    给你一个由 n 个整数组成的数组 nums ，和一个目标值 target 。请你找出并返回满足下述全部条件且不重复的四元组 [nums[a], nums[b], nums[c], nums[d]] （若两个四元组元素一一对应，则认为两个四元组重复）
    func fourSum(_ nums: [Int], _ target: Int) -> [[Int]] {
        //不足四个就返回
        guard nums.count >= 4 else { return [] }
        //最外层去重
        var temp1 = Int.max
        
        let nums = nums.sorted(by: <)
        var array = [[Int]]()
        
        for i in 0..<nums.count-3 {
            //如果最外层重复就返回
            guard nums[i] != temp1 else { continue }
            temp1 = nums[i]
            var temp2 = Int.max
            for k in i+1..<nums.count-2 {
                //第二层去重复
                guard nums[k] != temp2 else { continue }
                temp2 = nums[k]
                //最里层，即左指针和右指针
                var left = k + 1
                var right = nums.count-1
                var tempL = 0
                var tempR = 0
                
                while(right > left) {
                    tempL = nums[left]
                    tempR = nums[right]
                    if temp1 + temp2 + tempR + tempL > target {
                        right -= 1
                        //右指针移动去重
                        while(right > left && nums[right] == tempR) {
                            right -= 1
                        }
                    } else if temp1 + temp2 + tempR + tempL < target {
                        left += 1
                        //左指针移动去重
                        while(right > left && nums[left] == tempL) {
                            left += 1
                        }
                    } else {
                        array.append([temp1, temp2, tempL, tempR])
                        right -= 1
                        //左右都需要去重
                        while(right > left && nums[right] == tempR) {
                            right -= 1
                        }
                        left += 1
                        while(right > left && nums[left] == tempL) {
                            left += 1
                        }
                    }
                }
            }
        }
        return array
    }
    
    //MARK: 合并两个有序链表
//    将两个升序链表合并为一个新的 升序 链表并返回。新链表是通过拼接给定的两个链表的所有节点组成的。
    func mergeTwoLists(_ list1: ListNode?, _ list2: ListNode?) -> ListNode? {
        if list1 == nil {
            return list2
        }
        if list2 == nil {
            return list1
        }
        
        let retHead: ListNode? = ListNode()
        var retLast = retHead
        var current1 = list1
        var current2 = list2
        
        while (current1 != nil && current2 != nil) {
            if (current1!.val <= current2!.val) {
                retLast?.next = current1
                current1 = current1?.next
            } else {
                retLast?.next = current2
                current2 = current2?.next
            }
            retLast = retLast?.next
        }

        retLast?.next = current1 == nil ? current2 : current1
        return retHead
    }


    func mergeTwoLists2(_ list1: ListNode?, _ list2: ListNode?) -> ListNode? {
        
        guard let firstList = list1 else {return list2}
        guard let lastList = list2 else {return list1}
        
        var resultNode:ListNode? = nil
        var tempArray = [ListNode]()
        
        tempArray.append(firstList)
        tempArray.append(lastList)

        var tempFirst:ListNode? = firstList.next
        var tempLast:ListNode? = lastList.next
        
        while tempFirst != nil {
            tempArray.append(tempFirst!)
            tempFirst = tempFirst!.next
        }
        
        while tempLast != nil {
            tempArray.append(tempLast!)
            tempLast = tempLast!.next
        }
        
        //tempList.sorted{$0.val < $1.val}
        tempArray.sort { $0.val < $1.val }
        
        var tempNodel:ListNode?
        for value in tempArray {
            if resultNode == nil {
                resultNode = value
                tempNodel = resultNode
            } else {
                tempNodel!.next = value
                tempNodel = tempNodel!.next
            }
        }
        
        return resultNode
    }
    
    //MARK: 22 括号生成
//    数字 n 代表生成括号的对数，请你设计一个函数，用于能够生成所有可能的并且 有效的 括号组合。
//
//    示例 1：
//
//    输入：n = 3
//    输出：["((()))","(()())","(())()","()(())","()()()"]

    func generateParenthesis(_ n:Int) ->[String] {
        var results = [String]()
        
        func generate(_ left:Int,_ right:Int,n:Int,str:String) {
            if left == n && right == n {
                results.append(str)
                return
            }
            if left < n {
                generate(left+1, right, n: n, str: str + "(")
            }
            if left > right {
                generate(left, right+1, n: n, str: str + ")")
            }
        }
        
        generate(0, 0, n: n, str: "")
        return results
    }
    
    //MARK: 26.删除排序数组中的重复项（双指针法）
//    更改数组 nums ，使 nums 的前 k 个元素包含唯一元素，并按照它们最初在 nums 中出现的顺序排列。nums 的其余元素与 nums 的大小不重要。
//    返回 k 。
    func removeDuplicates(_ nums: inout [Int]) -> Int {
        if nums.count == 0 {
            return 0
        }
        
        var left = 0
        var right = 1
        while right < nums.count {
            if nums[left] != nums[right] {
                left += 1
                nums[left] = nums[right]
            }
            
            right += 1
        }
        
        return left + 1
    }
    
    //MARK: 27. 移除元素
//    给你一个数组 nums 和一个值 val，你需要 原地 移除所有数值等于 val 的元素。元素的顺序可能发生改变。然后返回 nums 中与 val 不同的元素的数量。
//
//    假设 nums 中不等于 val 的元素数量为 k，要通过此题，您需要执行以下操作：
//
//    更改 nums 数组，使 nums 的前 k 个元素包含不等于 val 的元素。nums 的其余元素和 nums 的大小并不重要。
//    返回 k。
    
    func removeSmaleElement(_ nums: inout [Int], _ val: Int) -> Int {
        var cur = 0
        for num in nums {
            if num != val {
                nums[cur] = num
                cur += 1
            }
        }
        return cur
        
    }
    
    //MARK: 28. 找出字符串中第一个匹配项的下标
    func strStr(_ haystack: String, _ needle: String) -> Int {
        guard needle != "" else { return 0 }
        let arr = haystack.components(separatedBy: needle)
        return arr.count > 1 ? Array(arr[0]).count : -1
    }
    
    
    //MARK: 29. 两数相除
//    给你两个整数，被除数 dividend 和除数 divisor。将两数相除，要求 不使用 乘法、除法和取余运算。
//
//    整数除法应该向零截断，也就是截去（truncate）其小数部分。例如，8.345 将被截断为 8 ，-2.7335 将被截断至 -2 。
//
//    返回被除数 dividend 除以除数 divisor 得到的 商 。
//
//    注意：假设我们的环境只能存储 32 位 有符号整数，其数值范围是 [−231,  231 − 1] 。本题中，如果商 严格大于 231 − 1 ，则返回 231 − 1 ；如果商 严格小于 -231 ，则返回 -231 。
    
    /**
     1.解题思路
     1、除数一直双倍的加，直到最接近被除数并且小于被除数为止。
     2、然后在把被除数减去之前得到的最接近的值，在继续上一步的操作。计算总共加了多少次，就是最后结果。

     
     计算 ：60/8

     8+8=16(加了2次)==>16+16=32(加了4次)=>32+32=64>60退出循环，这次循环加了4次，接近60的值是32

     60-32=28继续上步操作 8+8=16(记录加了2次)=>16+16=32>28退出循环，这次循环加了2次，接近28的值为16

     28-16=12继续上步操作 8(记录加了1次) =>8+8=16>12退出循环，这次循环加了1次，接近12的值为8

     12-8 继续上步操作，被除数小于除数，返回0。

     所以，总共加了4+2+1=7 =》60/8=7

     2.临界值判断

     被除数为0时，直接返回0；
     除数为1时，直接返回本身值；
     除数为-1时，如果被除数比边界值最小值还小，除以-1之后，就会比边界值还大，所以此时返回最大边界值，其他情况，返回相反数
     */
    
    func divide(_ dividend: Int, _ divisor: Int) -> Int {
        
        func div(_ a: Int, _ b: Int) -> Int {
            if a < b {
                return 0
            }
            
            var count = 1
            var result = b
            while result + result <= a {
                count += count
                result += result
            }
            
            return count + div(a-result, b)
        }
        
        if dividend == 0 {
            return 0
        }
        
        if divisor == 1 {
            return dividend
        }
        
        if divisor == -1 {
            // 如果被除数比最小值还小，除以-1之后，就会比边界值还大，所以此时返回最大边界值，其他情况，返回相反数
            if dividend > Int(Int32.min) {
                return -dividend
            }
            return Int(Int32.max)
        }
        // 结果是正数还是负数标志
        let sign = dividend > 0 && divisor > 0 || dividend < 0 && divisor < 0
        let a = dividend > 0 ? dividend : -dividend
        let b = divisor > 0 ? divisor : -divisor
        let res = div(a, b)
        
        return sign ? res : -res
    }
    
    //MARK: 51. N 皇后
    /*
     按照国际象棋的规则，皇后可以攻击与之处在同一行或同一列或同一斜线上的棋子。

     n 皇后问题 研究的是如何将 n 个皇后放置在 n×n 的棋盘上，并且使皇后彼此之间不能相互攻击。

     给你一个整数 n ，返回所有不同的 n 皇后问题 的解决方案。

     每一种解法包含一个不同的 n 皇后问题 的棋子放置方案，该方案中 'Q' 和 '.' 分别代表了皇后和空位。
     */
    //回溯
    func solveNQueens(_ n: Int) -> [[String]] {
        
        func solve(_ res: inout [[String]], _ chess: [[String]], _ row: Int) {
            // 终止条件：当最后一行走完，说明找到了一组，加入到结果中
            if row == chess.count {
                // 先把chess二维数组转成一维数组
                res.append(convert(chess))
                return
            }
            
            for col in 0..<chess.count {
                if valid(chess, row, col) {
                    var chess = chess
                    chess[row][col] = "Q"
                    // 递归下一行
                    solve(&res, chess, row + 1)
                    chess[row][col] = "."
                }
            }
        }
        
        // 判断当前位置是否可以放皇后
        func valid(_ currentChess: [[String]], _ row: Int, _ column: Int) -> Bool {
            // 第一步：判断当前列，有没有皇后
            for i in 0..<currentChess.count {
                if currentChess[i][column] == "Q" {
                    return false
                }
            }
            
            for i in stride(from: 0, through: 0, by: -1) {//[0..0)
                print("====00M:\(i)")//输出0
            }
            
//            for i in stride(from: row-1, through: 0, by: -1) {
//                print("====M:\(i)")
//            }
//
//            for i in (0..<row).reversed() {//或这种反向
//                print("====MMM::\(i)")
//
//            }
            
            // 第二步：判断当前位置的左上角有没有皇后
            var j = column - 1
//            let letfIndexs = stride(from: row-1, through: 0, by: -1)//[row-1,row-1-1,....,0)//不包含0
//            for i in letfIndexs {
            for i in (0..<row).reversed() {//或这种反向
                if j >= 0 {
                    if currentChess[i][j] == "Q" {
                        return false
                    }
                    j -= 1
                }
            }
            
            // 第三步：判断当前位置的右上角有没有皇后
            j = column + 1
//            let rightIndexs = stride(from: row-1, through: 0, by: -1)
//            for i in rightIndexs {
            for i in (0..<row).reversed() {
                if j < currentChess.count {
                    if currentChess[i][j] == "Q" {
                        return false
                    }
                    j += 1
                }
            }
            
            return true
        }
        
        // 把二维数组转成一维数组
        func convert(_ chess: [[String]]) -> [String] {
            var temp = [String]()
            for i in 0..<chess.count {
                var s = ""
                for j in 0..<chess[i].count {
                    s += chess[i][j]
                }
                temp.append(s)
            }
            return temp
        }

        
        let chess = Array(repeating: Array(repeating: ".", count: n), count: n)
        var results = [[String]]()
        solve(&results, chess, 0)
        return results
    }


    func solveNQueens1(_ n: Int) -> [[String]] { //还有问题，
        var results = [[String]]()
        var points = [[String]](repeating: [String](repeating: ".", count: n), count: n)
        
        func findChild(_ i:Int, _ j:Int, _ k:Int, points:inout [[String]], path:[(Int,Int,String)]) {
            
            

            var path = path
            if k > n {
                var currentPoints = [String]()
                for value in path {
                    let tempValue = NSString("....").replacingCharacters(in: NSRange.init(location: 0, length: value.0), with: value.2)
                    currentPoints.append(tempValue)
                }
                results.append(currentPoints)
                return
            }
            if i < 0 || j < 0 {
                return
            }
            
            
            points[i][j] = "Q"
            findChild(i+1, j, k-1, points: &points, path: [])
            findChild(i+1, j+1, k-1, points: &points, path: [])
            points[i][j] = "."

            
        }
        
        for i in 0..<n {
            
            for j in 0..<n {
                
                findChild(i, j, 1, points: &points, path: [])
            }
        }
        return results
    }
    
    //MARK: 58. 最后一个单词的长度
    
    /*
     给你一个字符串 s，由若干单词组成，单词前后用一些空格字符隔开。返回字符串中 最后一个 单词的长度。

     单词 是指仅由字母组成、不包含任何空格字符的最大
     子字符串
     。

    
     示例 1：

     输入：s = "Hello World"
     输出：5
     解释：最后一个单词是“World”，长度为 5。
     示例 2：

     输入：s = "   fly me   to   the moon  "
     输出：4
     解释：最后一个单词是“moon”，长度为 4。
     */
    
    func lengthOfLastWord(_ s: String) -> Int {
        //移除左右空，在分割
        let strArr = s.trimmingCharacters(in: .whitespaces).components(separatedBy: " ")
        return Array(strArr[strArr.count - 1]).count
    }
    
    //1、最后单词长度，首先考虑逆序遍历
    //2、遍历时有字符开始+1计算，遇到" ",即结束
    func lengthOfLastWord2(_ s: String) -> Int {
        
        var cound = 0
        
//        for i in stride(from: s.count - 1, to: -1, by: -1) {//逆序遍历
        for i in (0..<s.count).reversed() {//逆序遍历
            let ch = s[s.index(s.startIndex, offsetBy: i)]
            if ch == " "{//遇到空格
                if cound > 0 {//已经开始计算，末尾首个单词结束
                    return cound
                }
            } else {
                cound += 1
            }
        }
        return cound
    }

    
    //MARK: 67. 二进制求和 对齐进位
    /*
     给你两个二进制字符串 a 和 b ，以二进制字符串的形式返回它们的和。

     示例 1：

     输入:a = "11", b = "1"
     输出："100"
     示例 2：

     输入：a = "1010", b = "1011"
     输出："10101"

     */
    func addBinary(_ a: String, _ b: String) -> String {
        let aArr = Array(a.reversed())
        let bArr = Array(b.reversed())
        var reArr: [String] = Array()
        //是否有进位
        var temp = 0
        for idx in 0..<max(aArr.count, bArr.count) {
            let aC = idx < aArr.count ? (Int(String(aArr[idx])) ?? 0) : 0
            let bC = idx < bArr.count ? (Int(String(bArr[idx])) ?? 0) : 0
            let sum = aC + bC + temp
            reArr.insert(String(sum%2), at: 0)
            temp = sum/2
        }
        if temp > 0 {
            reArr.insert(String(temp), at: 0)
        }
        return reArr.joined()
    }

    //MARK: 62. 不同路径
    /*
     一个机器人位于一个 m x n 网格的左上角 （起始点在下图中标记为 “Start” ）。

     机器人每次只能向下或者向右移动一步。机器人试图达到网格的右下角（在下图中标记为 “Finish” ）。

     问总共有多少条不同的路径？
     */
    
    // dp[i] = dp[i] + dp[i-1]
    func uniquePaths2(_ m: Int, _ n: Int) -> Int {
        var dp = [Int](repeating: 1, count: m)
        for _ in 1..<n {
            for col in 1..<m {
                dp[col] = dp[col] + dp[col-1]
            }
        }
        return dp[m-1]
    }

    
    //     p[i][j] = p[i-1][j] + p[i][j-1]

    func uniquePaths(_ m: Int, _ n: Int) -> Int {
        var dp = [[Int]](repeating: [Int](repeating: 0, count: m), count: n)
        
        for col in 0..<m {
            dp[0][col] = 1
        }
        
        for row in 0..<n {
            dp[row][0] = 1
        }
        
        for row in 1..<n {
            for col in 1..<m {
                dp[row][col] = dp[row-1][col] + dp[row][col-1]
            }
        }
        return dp[n-1][m-1]
    }

    //MARK: 63. 不同路径 II(有障碍物）
    /*
     一个机器人位于一个 m x n 网格的左上角 （起始点在下图中标记为 “Start” ）。

     机器人每次只能向下或者向右移动一步。机器人试图达到网格的右下角（在下图中标记为 “Finish”）。

     现在考虑网格中有障碍物。那么从左上角到右下角将会有多少条不同的路径？

     网格中的障碍物和空位置分别用 1 和 0 来表示。
     */
    
    func uniquePathsWithObstacles(_ obstacleGrid: [[Int]]) -> Int {
        let m = obstacleGrid.count, n = obstacleGrid[0].count
        var dp = [[Int]](repeating: [Int](repeating: 0, count: n), count: m)
        for i in 0..<m {
            if obstacleGrid[i][0] == 0 {
                dp[i][0] = 1
            } else {
                break
            }
        }
        for j in 0..<n {
            if obstacleGrid[0][j] == 0 {
                dp[0][j] = 1
            } else {
                break
            }
        }
        if m == 1 || n == 1 { return dp[m - 1][n - 1] }
        for i in 1..<m {
            for j in 1..<n {
                if obstacleGrid[i][j] == 1 { continue }
                dp[i][j] = dp[i][j - 1] + dp[i - 1][j]
            }
        }
        return dp[m - 1][n - 1]
    }

    
    func uniquePathsWithObstacles2(_ obstacleGrid: [[Int]]) -> Int {
        if obstacleGrid[0][0] == 1 { return 0 }
        var dp = Array(repeating: Array(repeating: 0, count: obstacleGrid[0].count), count: obstacleGrid.count)
        dp[0][0] = 1
        for i in 0..<obstacleGrid.count {
            for j in 0..<obstacleGrid[0].count {
                if i == 0 && j == 0 { continue }
                if i == 0 { dp[i][j] = obstacleGrid[i][j] == 1 ? 0 : dp[i][j] + dp[i][j-1]; continue }
                if j == 0 { dp[i][j] = obstacleGrid[i][j] == 1 ? 0 : dp[i][j] + dp[i-1][j]; continue }
                dp[i][j] = obstacleGrid[i][j] == 1 ? 0 : dp[i-1][j] + dp[i][j-1]
            }
        }
        
        return dp.last!.last!
    }

    //MARK: 64 最小路径和
    
    /*
     给定一个包含非负整数的 m x n 网格 grid ，请找出一条从左上角到右下角的路径，使得路径上的数字总和为最小。

     说明：每次只能向下或者向右移动一步。
     
     输入：grid = [[1,3,1],[1,5,1],[4,2,1]]
     输出：7
     解释：因为路径 1→3→1→1→1 的总和最小。
     示例 2：

     输入：grid = [[1,2,3],[4,5,6]]
     输出：12
     */
    
    func minPathSum(_ grid: [[Int]]) -> Int {
        var dp = [[Int]](repeating:[Int](repeating: 0, count: grid[0].count), count: grid.count)
        
        dp[0][0] = grid[0][0]
        
        for i in 0..<grid.count {
            for j in 0..<grid[0].count {
                if i > 0 && j > 0 {
                    dp[i][j] = min(dp[i-1][j],dp[i][j-1]) + grid[i][j]
                } else if i > 0 {
                    dp[i][j] = dp[i-1][j] + grid[i][j]
                } else if j > 0{
                    dp[i][j] = dp[i][j-1] + grid[i][j]
                }
            }
        }
        
        return dp.last!.last!
    }

    //MARK: 66. 加一
    
    /*
     给定一个由 整数 组成的 非空 数组所表示的非负整数，在该数的基础上加一。
     最高位数字存放在数组的首位， 数组中每个元素只存储单个数字。
     你可以假设除了整数 0 之外，这个整数不会以零开头。

      

     示例 1：

     输入：digits = [1,2,3]
     输出：[1,2,4]
     解释：输入数组表示数字 123。
     */
    
    func plusOne(_ digits: [Int]) -> [Int] {
        var results = [Int]()
        
        var perCount = 1
        for i in (0..<digits.count).reversed() {
            let value = digits[i] + perCount
            //results[i] = value % 10
            //digits[i] = value % 10 直接修改
            results.insert(value % 10, at: 0)
            perCount = value / 10 //判断后续是否可以进1
        }
        
        //判断最高位是进一了
        if perCount != 0 {
            results.insert(perCount, at: 0)
        }
        
        return results
    }
    
    //MARK: 69. x 的平方根
    
    /*
     给你一个非负整数 x ，计算并返回 x 的 算术平方根 。

     由于返回类型是整数，结果只保留 整数部分 ，小数部分将被 舍去 。

     注意：不允许使用任何内置指数函数和算符，例如 pow(x, 0.5) 或者 x ** 0.5 。
     */
    
    //使用二分法，不停的逼近 正确的平方根
    
    func mySqrt(_ x: Int) -> Int {
        
        if x <= 1 {
            return x
        }
        
        var left = 1
        var right = x
        while left<=right {
            let mid = left + (right-left)/2
            if mid * mid > x {
                right = mid-1
            } else {
                left = mid+1
            }
        }
        
        return right
    }
    
    //牛顿迭代法
    func mySqrt2(_ x: Int) -> Int {
        
        if x <= 1 {
            return x
        }
        
        var res = x
        
        while res*res>x {
            res = (res+x/res)/2
        }
        return res
    }

    
    //MARK: 70. 爬楼梯
//    可以爬 1 或者 2 个台阶，也就是 调到 第 n 个台阶的时候，他可能是从 n-1 或者 n -2 跳上来的。
//
//    f(n) = f(n-2)+f(n-1)
    
    /*
     我们假设 n = 4， 那么它可能是从 第二台阶，跨 2步 到 4台阶，或者 从 第三台阶 跨 1步 到4台阶.

     也就是说 我们只需要用到前两个的结果， 所以我们可以用滑动窗口的形式保存临时的值，并让 尾递归 变成 迭代。

     */
    func climbStairs(_ n: Int) -> Int {
        if n <= 3 {
            return n
        }

        var f2 = 2
        var f3 = 3

        for _ in 4...n {
            let f4 = f2+f3
            f2 = f3
            f3 = f4
        }

        return f3
        
    }
    
    func climbStairs2(_ n: Int) -> Int {
        if n <= 2{
            return n
        }
        var dp: [Int] = Array(repeating: 0, count: n + 1)
        dp[0] = 1
        dp[1] = 1
        for i in 2..<n+1 {
            dp[i] = dp[i-1] + dp[i-2]
        }
        return dp[n]
    }


    //普通递归
    func climbStairs3(_ n: Int) -> Int {
        var results = 0
        
        func steps(_ fls:Int) -> Int {
            if fls <= 3 {return fls}
            
            let oneStep = steps(fls - 1)
            let twoStep = steps(fls - 2)
            
            return oneStep + twoStep
        }
        results = steps(3)
        return results
    }
    
    //MARK: - 71. 简化路径
    
    /**
     给你一个字符串 path ，表示指向某一文件或目录的 Unix 风格 绝对路径 （以 '/' 开头），请你将其转化为更加简洁的规范路径。

     在 Unix 风格的文件系统中，一个点（.）表示当前目录本身；此外，两个点 （..） 表示将目录切换到上一级（指向父目录）；两者都可以是复杂相对路径的组成部分。任意多个连续的斜杠（即，'//'）都被视为单个斜杠 '/' 。 对于此问题，任何其他格式的点（例如，'...'）均被视为文件/目录名称。

     请注意，返回的 规范路径 必须遵循下述格式：

     始终以斜杠 '/' 开头。
     两个目录名之间必须只有一个斜杠 '/' 。
     最后一个目录名（如果存在）不能 以 '/' 结尾。
     此外，路径仅包含从根目录到目标文件或目录的路径上的目录（即，不含 '.' 或 '..'）。
     返回简化后得到的 规范路径 。

      

     示例 1：

     输入：path = "/home/"
     输出："/home"
     解释：注意，最后一个目录名后面没有斜杠。
     示例 2：

     输入：path = "/../"
     输出："/"
     解释：从根目录向上一级是不可行的，因为根目录是你可以到达的最高级。
     示例 3：

     输入：path = "/home//foo/"
     输出："/home/foo"
     解释：在规范路径中，多个连续斜杠需要用一个斜杠替换。
     示例 4：

     输入：path = "/a/./b/../../c/"
     输出："/c"
     
     "/home/user/Documents/../Pictures"
     "/home/user/Pictures"
     
     "/.../a/../b/c/../d/./"
     "/.../b/d"
     
     
     思路与算法

     我们首先将给定的字符串 path 根据 / 分割成一个由若干字符串组成的列表，记为 names。根据题目中规定的「规范路径的下述格式」，names 中包含的字符串只能为以下几种：

     空字符串。例如当出现多个连续的 /，就会分割出空字符串；

     一个点 .；

     两个点 ..；

     只包含英文字母、数字或 _ 的目录名。

     对于「空字符串」以及「一个点」，我们实际上无需对它们进行处理，因为「空字符串」没有任何含义，而「一个点」表示当前目录本身，我们无需切换目录。

     对于「两个点」或者「目录名」，我们则可以用一个栈来维护路径中的每一个目录名。当我们遇到「两个点」时，需要将目录切换到上一级，因此只要栈不为空，我们就弹出栈顶的目录。当我们遇到「目录名」时，就把它放入栈。

     这样一来，我们只需要遍历 names 中的每个字符串并进行上述操作即可。在所有的操作完成后，我们将从栈底到栈顶的字符串用 / 进行连接，再在最前面加上 / 表示根目录，就可以得到简化后的规范路径。

     作者：力扣官方题解
     链接：https://leetcode.cn/problems/simplify-path/
     来源：力扣（LeetCode）
     著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。

     */
    
    func simplifyPath(_ path: String) -> String {
        if path.count <= 1 {
            return path
        }
        
        func removeMoreline(_ source:String) -> String {
            if source.contains("//"){
                return removeMoreline(source.replacingOccurrences(of: "//", with: "/"))
            }
            return source
        }
        
        let tPath = removeMoreline(path)
        
        var result:[String] = Array()
        let sperList:[String] = tPath.components(separatedBy: "/")
        
        for value in sperList {
            if value == ".."{
                if result.count > 0 {
                    result.removeLast()
                }
            } else if value.isEmpty == false && value != "." {
                result.append(String(value))
            }
        }
        
        return "/" + result.joined(separator: "/")
    }
    

    //MARK: 76. 最小覆盖子串 ###
    
    /*
     输入：s = "ADOBECODEBANC", t = "ABC"
     输出："BANC"
     解释：最小覆盖子串 "BANC" 包含来自字符串 t 的 'A'、'B' 和 'C'。

     */
    //滑动窗口思路
    func minWindow(_ s: String, _ t: String) -> String {
        let sArr = [Character](s)
        // 窗口的字典
        var windowDict = [Character: Int]()
        // 所需字符的字典
        var needDict = [Character: Int]()
        for c in t {
            needDict[c, default: 0] += 1
        }
        
        // 当前窗口的左右两端
        var left = 0, right = 0
        // 匹配次数，等于needDict的key数量时代表已经匹配完成
        var matchCnt = 0
        // 用来记录最终的取值范围
        var start = 0, end = 0
        // 记录最小范围
        var minLen = Int.max
        
        while right < sArr.count {
            // 开始移动窗口右侧端点
            let rChar = sArr[right]
            right += 1
            // 右端点字符不是所需字符直接跳过
            if needDict[rChar] == nil { continue }
            // 窗口中对应字符数量+1
            windowDict[rChar, default: 0] += 1
            // 窗口中字符数量达到所需数量时，匹配数+1
            if windowDict[rChar] == needDict[rChar] {
                matchCnt += 1
            }
            
            // 如果匹配完成，开始移动窗口左侧断点, 目的是为了寻找当前窗口的最小长度
            while matchCnt == needDict.count {
                // 记录最小范围
                if right - left < minLen {
                    start = left
                    end = right
                    minLen = right - left
                }
                let lChar = sArr[left]
                left += 1
                if needDict[lChar] == nil { continue }
                // 如果当前左端字符的窗口中数量和所需数量相等，则后续移动就不满足匹配了，匹配数-1
                if needDict[lChar] == windowDict[lChar] {
                    matchCnt -= 1
                }
                // 减少窗口字典中对应字符的数量
                windowDict[lChar]! -= 1
            }
        }
        
        return minLen == Int.max ? "" : String(sArr[start..<end])
    }
    
    
    func minWindowxx(_ s: String, _ t: String) -> String {
        //这个错误
        if t.count > s.count {return ""}
        
        
        var result = ""
        
        //这个两个都可以从 map 里面取
        var left = 0
        var startValue = ""
        
        var minLength = Int.max
        //记录对应每个有些的字母的起始位置，及后续对应拼接内容
        var mapDic = [Int:(Int,String,String)]()
        
        for (i,value) in s.enumerated() {
            if t.contains(value) && startValue == "" {
                left = i
                startValue = String(value)
                mapDic[0] = (i,startValue,startValue)
                
            } else if t.contains(value) && String(value) == startValue {
                left = i
                startValue = String(value)
                mapDic[0] = (i,startValue,startValue)
                mapDic[1] = nil

            } else if t.contains(value) {
                
                mapDic[0]?.2.append(value)

                if mapDic[1] == nil {
                    mapDic[1] = (i,String(value),String(value))
                    
                } else if let secValue = mapDic[1], secValue.1 == String(value) {
                    mapDic[1] = (i,String(value),String(value))
                } else {
                    mapDic[1]?.2.append(value)
                    
                    if minLength > i - left + 1 { //最小直大于后面的，替换
                        result = mapDic[0]!.2
                        minLength = i - left + 1
                    }
                    
                    
                    mapDic[0] = mapDic[1]
                    mapDic[1] = (i,String(value),String(value))
                    left = mapDic[0]?.0 ?? 0
                    startValue = mapDic[0]?.1 ?? ""
                    
                }
                
            } else {
                if startValue.count > 0 {
                    
                    mapDic[0]?.2.append(value)
                    mapDic[1]?.2.append(value)

                }
            }
        }
        
        return result
    }
    
    
    //MARK: 78. 子集
    
    /*
     给你一个整数数组 nums ，数组中的元素 互不相同 。返回该数组所有可能的
     子集
     （幂集）。

     解集 不能 包含重复的子集。你可以按 任意顺序 返回解集。

     示例 1：

     输入：nums = [1,2,3]
     输出：[[],[1],[2],[1,2],[3],[1,3],[2,3],[1,2,3]]
     示例 2：

     输入：nums = [0]
     输出：[[],[0]]
     */
    
    /**
     遍历法

     重点要理解个这个

     多一个新元素, 相当于在原来每个元素形成旧数组里面多加个新元素

     例如:

     [1, 2]
     则有 [1], [1, 2], [2]

     [1, 2, 3]
     则有 [1], [1, 2], [1, 3], [1, 2, 3], [2], [2, 3], [3]

     相对于之前的 [1], [1, 2], [2]
     是不是只多出了[1, 3], [1, 2, 3], [2, 3], [3]

     其他同理, 按照这个规律我们有
     */
    func subsets(_ nums: [Int]) -> [[Int]] {
        
        // 定义数组为每次循环之后的结果数组
        var result = [[Int]]()
        
        // 循环num中每一个元素
        for i in nums {
            
            // 定义temp为当前 新元素形成的单一数组
            let temp = [i]
            
            // 循环上一轮形成的数组
            for arr in result {
                
                // 上一轮每一个数组拼接个新元素添加进新数组
                result.append(arr + temp)
            }
            
            // 新元素形成的单一数组别忘记添加
            result.append(temp)
        }
        
        // 最后添加空数组
        result.append([])
        
        // 返回结果
        return result
    }

    //迭代
    func subsets2(_ nums: [Int]) -> [[Int]] {
        var res = [[Int]]()
        res.append([Int]())
        
        for num in nums {
            var list = [[Int]]()
            for item in res {
                //多一个新元素, 相当于在原来每个元素形成旧数组里面多加个新元素
                list.append(item + [num])
            }
            res.append(contentsOf: list)
        }
        
        return res
    }

    //MARK: 79. 单词搜索
    
    /*
     给定一个 m x n 二维字符网格 board 和一个字符串单词 word 。如果 word 存在于网格中，返回 true ；否则，返回 false 。

     单词必须按照字母顺序，通过相邻的单元格内的字母构成，其中“相邻”单元格是那些水平相邻或垂直相邻的单元格。同一个单元格内的字母不允许被重复使用。
     输入：board = [["A","B","C","E"],["S","F","C","S"],["A","D","E","E"]], word = "ABCCED"
     输出：true
     */
    
    //回溯法
    func exist(_ board: [[Character]], _ word: String) -> Bool {
        
        func search(_ board: [[Character]], _ word: [Character], _ i: Int, _ j: Int, _ k: Int, _ dp:inout[[Bool]])-> Bool {
            if i<0 || j<0 || i>=board.count || j>=board[0].count {
                return false
            }
            if k>=word.count {
                return false
            }
            if dp[i][j] == false {
                return false
            }
            if board[i][j] != word[k] {
                return false
            }
            if k == word.count-1 {
                return true
            }
            dp[i][j] = false
            let b1 = search(board, word, i+1, j, k+1, &dp)
            let b2 = search(board, word, i-1, j, k+1, &dp)
            let b3 = search(board, word, i, j-1, k+1, &dp)
            let b4 = search(board, word, i, j+1, k+1, &dp)
            
            dp[i][j] = true
            return b1 || b2 || b3 || b4
        }
        
        
        for i in 0..<board.count {
            for j in 0..<board[0].count {
                var dp = [[Bool]](repeating:[Bool](repeating: true, count: board[0].count) , count: board.count)
                let flag = search(board, Array(word), i, j, 0, &dp)
                if flag {
                    return true
                }
            }
        }
        return false
    }
    
    //MARK: 100. 相同的树
    
    /*
     给你两棵二叉树的根节点 p 和 q ，编写一个函数来检验这两棵树是否相同。

     如果两个树在结构上相同，并且节点具有相同的值，则认为它们是相同的。
     输入：p = [1,2,3], q = [1,2,3]
     输出：true

     输入：p = [1,2], q = [1,null,2]
     输出：false
     */
    
    ////前序遍历
    func isSameTree(_ p: TreeNode?, _ q: TreeNode?) -> Bool {
        var isSame = true
        
        func pkChildNode(_ p:TreeNode?, _ q:TreeNode?, _ isSame:inout Bool) {
            if p == nil && q == nil {
                return
            }
            if (p == nil && q != nil) || (p != nil && q == nil) || (p?.val != q?.val) {
                isSame = false
                return
            }
            
            pkChildNode(p?.left, q?.left, &isSame)
            if isSame {
                pkChildNode(p?.right, q?.right, &isSame)
            }
        }
        pkChildNode(p, q, &isSame)
        
        return isSame
    }
    
    //递归 时间复杂度：O(n)，n 为树的节点个数
    func isSameTree2(_ p: TreeNode?, _ q: TreeNode?) -> Bool {
        if p == nil && q == nil { return true }
        return p?.val == q?.val &&
        isSameTree(p?.left, q?.left) &&
        isSameTree(p?.right, q?.right)
    }

}



 public class TreeNode {
      public var val: Int
      public var left: TreeNode?
      public var right: TreeNode?
      public init() { self.val = 0; self.left = nil; self.right = nil; }
      public init(_ val: Int) { self.val = val; self.left = nil; self.right = nil; }
      public init(_ val: Int, _ left: TreeNode?, _ right: TreeNode?) {
          self.val = val
          self.left = left
          self.right = right
      }
  }
 


public class ListNode {
     public var val: Int
     public var next: ListNode?
     public init() { self.val = 0; self.next = nil; }
     public init(_ val: Int) { self.val = val; self.next = nil; }
     public init(_ val: Int, _ next: ListNode?) { self.val = val; self.next = next; }
 }
 
