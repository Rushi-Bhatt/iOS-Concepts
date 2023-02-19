// Array:

// 1. Two Sum
class Solution {
    func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
        var map: [Int : (Int, Int)] = [:]
        var results: [Int] = []
        for i in 0..<nums.count {
            let diff = target - nums[i]
            if let previousElement = map[diff] {
                results.append(previousElement.1)
                results.append(i)
                return results
            } else {
                map[nums[i]] = (diff, i)
            }
        }
        return results
    }
}

// 2. Best Time to Buy and Sell Stock II
class Solution {
    func maxProfit(_ prices: [Int]) -> Int {
        var i = 0
        var j = 0
        var n = prices.count
        var profit = 0
        while(i+1 < n) {
            while (i+1 < n && prices[i+1] < prices[i]) {
                i += 1
            }
            j = i+1
            guard j < n else { return profit }
            while (j+1 < n && prices[j+1] > prices[j]) {
                j += 1
            }
            profit += prices[j] - prices[i]
            i = j + 1
        }
        return profit
    }
}

// 3. Remove Duplicates from Sorted Array
class Solution {
    func removeDuplicates(_ nums: inout [Int]) -> Int {
        var i = 0
        var j = i + 1
        while j < nums.count {
            if nums[j] == nums[i] {
                j += 1
            } else {
                nums.swapAt(i+1, j)
                i += 1
                j += 1
            }
        }
        return i+1
    }
}

// 4. Contains duplicate
class Solution {
    func containsDuplicate(_ nums: [Int]) -> Bool {
        guard nums.count >= 2 else { return false }
        var nums = nums
        nums.sort()
        for i in 0..<nums.count-1 {
            if nums[i+1] == nums[i] {
                return true
            }
        }
        return false
    }
}

// 5. Product of Array except self
class Solution {
    func productExceptSelf(_ nums: [Int]) -> [Int] {
        var n = nums.count
        var solution: [Int] = Array(repeating: 1, count: n)
        var pre = 1
        var post = 1
        for i in 0..<n {
            solution[i] *= pre
            pre *= nums[i]
            solution[n-i-1] *= post
            post *= nums[n-i-1]
        }
        return solution
    }
}

// 6. Maximum Subarray
class Solution {
    func maxSubArray(_ nums: [Int]) -> Int {
        var current = nums[0]
        var best = nums[0]
        for i in 1..<nums.count {
            current = max(nums[i], current + nums[i])
            best = max(current, best)
        }
        return best
    }
}

// 7. Maximum Product Subarray
class Solution {
    func maxProduct(_ nums: [Int]) -> Int {
        var n = nums.count
        var minSoFar = nums[0]
        var maxSoFar = nums[0]
        var result = nums[0]
        for i in 1..<n {
            var current = nums[i]
            var tempMax = max(current, minSoFar*current, maxSoFar*current)
            minSoFar = min(current, minSoFar*current, maxSoFar*current)
            maxSoFar = tempMax
            
            result = max(maxSoFar, result)
        }
        return result
    }
}

// 8. Find minimum in rotated sorted array
class Solution {
    func findMin(_ nums: [Int]) -> Int {
        guard !nums.isEmpty else { return 0 }
        var start = 0
        var end = nums.count - 1
        while start <= end {
            var mid: Int = (start + end)/2
            let prev = (mid + nums.count - 1) % nums.count
            let next = (mid + 1) % nums.count
            print(nums[prev], nums[mid], nums[next])
            if nums[mid] <= nums[prev] && nums[mid] <= nums[next] {
                return nums[mid]
            } else if nums[start] >= nums[mid] {
                end = mid - 1
            } else if nums[mid] >= nums[end] {
                start = mid + 1
            }
        }
        return nums[0]
    }
}

// 9. Search in Rotated Sorted Array
func search(_ nums: [Int], _ target: Int) -> Int {
    var start = 0
    var end = nums.count - 1
    var result = 0
    while start <= end {
        var mid: Int = (start + end)/2
        var prev = (mid + nums.count - 1) % nums.count
        var next = (mid + 1) % nums.count
        if nums[mid] <= nums[prev] && nums[mid] <= nums[next] {
            result = mid
            break
        } else if nums[start] >= nums[mid] {
            end = mid - 1
        } else if nums[end] <= nums[mid] {
            start = mid + 1
        }
    }
    print("result", result)
    var ar1 = Array(nums[..<result])
    var ar2 = Array(nums[result...])
    var r1 = binarySearch(arr: ar1, n: target, order: <)
    var r2 = binarySearch(arr: ar2, n: target, order: <)
    return r1 != -1 ? r1 : r2
}

// 10. 3 Sum
class Solution {
    func threeSum(_ nums: [Int]) -> [[Int]] {
        let nums = nums.sorted()
        var result: [[Int]] = []
        var i = 0
        var j = 0
        var k = 0
        for i in 0..<nums.count {
            if nums[i] > 0 { return result }
            if i != 0 && nums[i-1] == nums[i] { continue }
            j = i+1
            k = nums.count - 1
            while j < k {
                let sum = nums[i] + nums[j] + nums[k]
                if sum == 0 {
                    result.append([nums[i],nums[j],nums[k]])
                    j += 1
                    while j < k && nums[j-1] == nums[j] {
                        j += 1
                    }
                } else if sum > 0 {
                    k -= 1
                } else {
                    j += 1
                }
                
            }
        }
        return result
    }
}

//11. Contaier with water
class Solution {
    func maxArea(_ height: [Int]) -> Int {
        var left = 0
        var right = height.count - 1
        var maxArea = 0
        while left <= right {
            let min_height = min(height[left], height[right])
            maxArea =  max(maxArea, min_height * (right - left))
            if height[left] < height[right] {
                left += 1
            } else {
                right -= 1
            }
        }
        return maxArea
    }
}

// LinkedList:
public class ListNode {
    public var val: Int
    public var next: ListNode?
    public init() {
        self.val = 0
        self.next = nil
    }
    
    public init(_ val: Int) {
        self.val = val
        self.next = nil
    }
    
    public init(_ val: Int, _ next: ListNode) {
        self.val = val
        self.next = next
    }
}

// 1. Reverse a linked list
class Solution {
    func reverseList(_ head: ListNode?) -> ListNode? {
        guard let head = head else { return head }
        var current: ListNode? = head
        var prev: ListNode? = nil
        while current != nil {
            let next: ListNode? = current?.next
            current?.next = prev
            prev = current
            current = next
        }
        return prev
    }
}

// 2. Detect cycle
class Solution {
    func hasCycle(_ head: ListNode?) -> Bool {
        guard let head = head else { return false }
        var p1: ListNode? = head
        var p2: ListNode? = head
        while p1?.next != nil && p2?.next?.next != nil {
            p1 = p1?.next
            p2 = p2?.next?.next
            if p1 === p2 {
                print("Found cycle")
                return true
            }
        }
        return false
    }
}

// 3. Merge 2 sorted lists
class Solution {
    func mergeTwoLists(_ list1: ListNode?, _ list2: ListNode?) -> ListNode? {
        if list1 == nil { return list2 }
        if list2 == nil { return list1 }
        var l1 = list1
        var l2 = list2
        var head = ListNode(0)
        var temp: ListNode? = head
        
        while l1 != nil && l2 != nil {
            let v1 = l1!.val
            let v2 = l2!.val
            if v1 <= v2 {
                temp?.next = l1
                l1 = l1?.next
            } else {
                temp?.next = l2
                l2 = l2?.next
            }
            temp = temp?.next
        }
        temp?.next = l1 ?? l2
        return head.next
    }
}

// 4. Merge K sorted lists
func mergeKLists(_ lists: [ListNode?]) -> ListNode? {
    guard lists.count > 0 else { return nil }
    var start = 0
    var end = lists.count - 1
    var lists = lists
    while end > 0 {
        var start = 0
        while start < end {
            lists[start] = mergeTwoLists(lists[start], lists[end])
            start += 1
            end -= 1
        }
    }
    return lists[0]
}

// 5. Remove nth node from the end of list
class Solution {
    func removeNthFromEnd(_ head: ListNode?, _ n: Int) -> ListNode? {
        guard head != nil else { return nil }
        var totalCount = 0
        var curr: ListNode? = head
        while curr != nil {
            curr = curr?.next
            totalCount +=  1
        }
        var k = totalCount - n
        
        curr = head
        var prev: ListNode? = nil
        while k != 0 {
            prev = curr
            curr = curr?.next
            k -= 1
        }
        if prev == nil { return curr?.next }
        prev?.next = curr?.next
        return head
    }
}

// 6. Reorder List
class Solution {
    
    func reorderList(_ head: ListNode?) {
        guard head != nil else { return }
        var head1 = head
        //finding the middle of the list
        var slow = head
        var fast = head
        while fast != nil && fast?.next != nil {
            slow = slow?.next
            fast = fast?.next?.next
        }
        var middle = slow
        
        //Reversing the 2nd list
        var head2: ListNode? = middle?.next
        middle?.next = nil
        
        var prev: ListNode? = nil
        var curr = head2
        while curr != nil {
            var next = curr?.next
            curr?.next = prev
            prev = curr
            curr = next
        }
        var reversedHead2: ListNode? = prev
        
        // merge 2 sorted lists
        var arr1 = head1
        var arr2 = reversedHead2
        var temp: ListNode?
        while arr1 != nil && arr2 != nil {
            temp = arr1?.next
            arr1?.next = arr2
            arr1 = temp
            
            temp = arr2?.next
            arr2?.next = arr1
            arr2 = temp
        }
    }
}

// 7. Intersection of 2 linked list
class Solution {
    func intersectionOf(_ head1: ListNode?, _ head2: ListNode?) -> ListNode? {
        if head1 == nil || head2 == nil {
            return nil
        }
        var h1 = head1
        var h2 = head2
        while h1 !== h2 {
            h1 = h1 == nil ? h2 : h1?.next
            h2 = h2 == nil ? h1 : h2?.next
        }
        return h1
    }
}

// 8. odd even linked list
class Solution {
    func oddEvenLinkedList(_ head: ListNode?) -> (ListNode?, ListNode?) {
        guard head != nil else { return (nil, nil) }
        var curr = head
        var odd: ListNode? = ListNode(0)
        var even: ListNode? = ListNode(0)
        while curr != nil {
            if curr!.val.isMultiple(of: 2) {
                even?.next = curr
            } else {
                odd?.next = curr
            }
            curr = curr?.next
        }
        return (odd?.next, even?.next)
    }
}

// Strings
// 1. Longest sunstring with no repeating character
class Solution {
    
    func uniqueCharactersCount(_ s: String) -> Int {
        return Set(s).count
    }
    func lengthOfLongestSubstring(_ s: String) -> Int {
        guard !s.isEmpty else { return 0 }
        var str = ""
        var i = 0
        var j = 0
        var n = s.count
        var ans = 0
        while j < n {
            str = str + String(s[j])
            if uniqueCharactersCount(str) > j - i + 1 {
                // Not possible
                j += 1
            } else if uniqueCharactersCount(str) == j - i + 1  {
                // Found a candidate
                ans = max(ans, str.count)
                j += 1
            } else if uniqueCharactersCount(str) < j - i + 1 {
                while uniqueCharactersCount(str) < j - i + 1 {
                    str.removeFirst()
                    i += 1
                }
                j += 1
            }
        }
        return ans
    }
}

extension String {
    subscript(offset: Int) -> Character {
        return self[index(startIndex, offsetBy: offset)]
    }
}

// 2. Longest Repeating Character Replacement
class Solution {
    func characterReplacement(_ s: String, _ k: Int) -> Int {
        guard !s.isEmpty else { return 0 }
        var map: [Character: Int] = [:]
        var i = 0
        var j = 0
        var maxFrequency: Int = 0
        var ans: Int = 0
        var n = s.count
        while j < n {
            if let count = map[s[j]] {
                map[s[j]] = count + 1
                maxFrequency = max(maxFrequency, count+1)
            } else {
                map[s[j]] = 1
                maxFrequency = max(maxFrequency, 1)
            }
            if (j-i+1) - maxFrequency <= k {
                // Found candidate
                // valid window, try to expand
                ans = max(ans, j-i+1)
                j += 1
            } else {
                // Not a valid window
                // try to move i but only by 1 :
                // here we are keeping the window size constant
                if let count = map[s[i]] {
                    map[s[i]] = count == 1 ? nil : count - 1
                }
                i += 1
                j += 1
            }
        }
        return ans
    }
}

extension String {
    subscript(offset: Int) -> Character {
        return self[index(startIndex, offsetBy: offset)]
    }
}

// 3. Minimum window substring
class Solution {
    func minWindow(_ s: String, _ t: String) -> String {
        guard !s.isEmpty, !t.isEmpty, t.count <= s.count else { return "" }
        if s.count == t.count { return t == s ? s : "" }
        var i = 0
        var j = 0
        var n = s.count
        var final = 0
        var ans = Int.max
        var mappedItem = t.map { ($0, 1) }
        var map = Dictionary(mappedItem, uniquingKeysWith: +)
        
        while j < n {
            if let count = map[s[j]] {
                map[s[j]] = count - 1
                if count - 1  == 0 { final += 1 }
            }
            
            if final < t.count {
                j += 1
            } else if final == t.count {
                // found a valid candidate
                ans = min(ans, j-i+1)
                
                // try and optimize
                while final == t.count {
                    if let count = map[s[i]] {
                        if count < 0 {
                            // we have characters in s[i] that we can remove
                            map[s[i]] = count + 1
                            i += 1
                        } else {
                            break
                        }
                    } else {
                        i += 1
                    }
                }
                j += 1
            }
        }
        
        let start = s.index(s.startIndex, offsetBy: i)
        let end = s.index(s.startIndex, offsetBy: j)
        return String(s[start..<end])
        
    }
}

extension String {
    subscript(offset: Int) -> Character {
        return self[index(startIndex, offsetBy: offset)]
    }
}

// 4. Valid Anagram
class Solution {
    func isAnagram(_ s: String, _ t: String) -> Bool {
        guard s.count == t.count else { return false }
        guard !s.isEmpty else { return true }
        var mappedItem = s.map { ($0, 1) }
        var map: [Character: Int] = Dictionary(mappedItem, uniquingKeysWith: +)
        
        for i in 0..<t.count {
            if let count = map[t[i]] {
                if count == 1 {
                    map[t[i]] = nil
                } else {
                    map[t[i]] = count - 1
                }
            } else {
                return false
            }
        }
        return true
    }
}

extension String {
    subscript(offset: Int) -> Character {
        return self[index(startIndex, offsetBy: offset)]
    }
}

// 5. Group Anagrams
class Solution {
    func groupAnagrams(_ strs: [String]) -> [[String]] {
        guard !strs.isEmpty else { return  [[""]] }
        var map =  [String: [String]]()
        for s in strs {
            let key = String(s.sorted())
            if map[key] != nil {
                map[key]?.append(s)
            } else {
                map[key] = [s]
            }
        }
        
        return map.map { (key, value) -> [String] in
            return value
        }
    }
}

extension String {
    subscript(i: Int) -> Character {
        self[index(startIndex, offsetBy: i)]
    }
}

// 6. Valid Parentheses
class Solution {
    func isValid(_ s: String) -> Bool {
        var stack = [Character]()
        var match: [Character: Character] = ["(": ")", "[": "]", "{": "}"]
        for char in s {
            if match[char] != nil {
                stack.append(char)
            } else {
                guard let last = stack.last else {  return false }
                if match[last] == char {
                    stack.removeLast()
                } else {
                    return false
                }
            }
        }
        return stack.isEmpty
    }
}

// 7. Valid Palindrome
class Solution {
    func isPalindrome(_ s: String) -> Bool {
        var s = s.lowercased()
        s = s.filter {  ("a"..."z").contains($0) || ("0"..."9").contains($0) }
        return s == String(s.reversed())
    }
}

// 8. Longest Palindrome Substring
func longestPalindrome(_ s: String) -> String {
    // if we find longest common substring between string and its reversed, that will be longest palindrome substring
    return longesCommonSubstring(s, String(s.reversed()))
}

func longesCommonSubstring(_ s: String, _ t: String) -> String {
    var l1 = s.count + 1
    var l2 = t.count + 1
    var dp: [[Int]] = Array(repeating: Array(repeating: -1, count: l2), count: l1)
    var lcs = ""
    var maxLength = 1
    for i in 0..<l1 {
        for j in 0..<l2 {
            if i == 0 || j == 0 {
                dp[i][j] = 0
            } else if s[i-1] == t[j-1] {
                dp[i][j] = dp[i-1][j-1] + 1
                maxLength = max(maxLength, dp[i][j])
            } else {
                dp[i][j] = 0
            }
        }
    }
    
    var i = s.count
    var j = t.count
    while i > 0 && j > 0 {
        print(i, j)
        if s[i-1] == t[j-1] {
            lcs.append(s[i-1])
            i -= 1
            j -= 1
        } else if dp[i-1][j] > dp[i][j-1] {
            // Move sideways
            i-=1
        } else {
            // Move up
            j-=1
        }
    }
    return lcs
}
}
extension String {
    subscript(offset: Int) -> Character {
        return self[index(startIndex, offsetBy: offset)]
    }
}

// 9. Palindrome Substrings
class Solution {
    func countSubstrings(_ s: String) -> Int {
        var n = s.count
        guard n > 0 else { return 0 }
        var dp: [[Bool]] = Array(repeating: (Array(repeating: false, count: n+1)), count: n + 1)
        var i = 0
        var ans = 0
        
        //base case: single letter substrings
        for i in 0..<n {
            dp[i][i] = true
            ans += 1
        }
        
        guard n >= 2 else { return ans }
        
        // double letter substrings:
        for i in 0..<n-1 {
            if s[i] == s[i+1] {
                dp[i][i+1] = true
                ans += 1
            }
        }
        
        guard n >= 3 else { return ans }
        
        // all other cases: substrings of length 3 to n
        for len in 3...n {
            var i = 0
            var j = i + len - 1
            while j < n {
                dp[i][j] = dp[i+1][j-1] && s[i] == s[j]
                if dp[i][j] {
                    ans += 1
                }
                i += 1
                j += 1
            }
        }
        return ans
    }
}

// 10. Encode Decode String
class Codec {
    func encode(_ strs: [String]) -> String {
        var symbol: Character = "?"
        guard !strs.isEmpty else { return "" }
        var result = ""
        for str in strs {
            var count = str.count
            result += "\(count)\(symbol)\(str)"
        }
        print(result)
        return result
    }
    
    func decode(_ s: String) -> [String] {
        var symbol: Character = "?"
        var n = s.count
        var i = 0
        var s = Array(s)
        var result = [String]()
        while i < n {
            var j = i
            var count = ""
            while s[j] != symbol {
                count.append(s[j])
                j += 1
            }
            let lenghtOfWord = Int(count)!
            let actualWord = String(s[(j+1..<j+1+lenghtOfWord)])
            result.append(actualWord)
            i = j+1+lenghtOfWord
        }
        
        return result
    }
}

// Intervals

// 1. Insert Interval
class Solution {
    func insert(_ intervals: [[Int]], _ newInterval: [Int]) -> [[Int]] {
        if intervals.count == 0 {
            return [newInterval]
        }
        var new = newInterval
        var result = [[Int]]()
        
        for curr in intervals {
            if curr.last! < new.first! {
                result.append(curr)
            } else if new.last! < curr.first! {
                result.append(new)
                new = curr
            } else {
                new = [
                    min(curr.first!, new.first!),
                    max(curr.last!, new.last!)
                ]
            }
        }
        result.append(new)
        return result
    }
}

// 2. Merge Interval
class Solution {
    func merge(_ intervals: [[Int]]) -> [[Int]] {
        guard !intervals.isEmpty else { return [[]] }
        var sorted = intervals.sorted { $0.first! < $1.first! }
        var result = [sorted.first!]
        for i in 1..<sorted.count {
            var prev = result.last!
            var curr = sorted[i]
            if prev.last! >= curr.first! && prev.last! <= curr.last! {
                // overlap
                // [1,4][2,6]
                result.removeLast()
                result.append([ prev.first!, curr.last! ])
            } else if prev.last! <= curr.first! {
                // [1,4][5,6]
                result.append(curr)
            } else {
                // [1,4][2,3]
                // do nothing
            }
        }
        return result
    }
}

// 3. Non-Overalapping interval
// [1,4][5,7] <- no overlap, prev = curr, count same
// [1,4][2,3] <- go for smaller, prev = curr , count += 1
// [1,4][2,5] <- go for earlier (greedy choice), prev = prev, count+= 1

class Solution {
    func eraseOverlapIntervals(_ intervals: [[Int]]) -> Int {
        guard !intervals.isEmpty else { return 0 }
        var sorted = intervals.sorted { $0.first! < $1.first! }
        
        var prev = sorted.first!
        var count = 0
        for i in 1..<sorted.count {
            var curr = sorted[i]
            if  prev.last! <= curr.first! {
                prev = curr
            } else if prev.last! > curr.first! {
                if prev.last! >= curr.last! {
                    prev = curr
                }
                count += 1
            }
        }
        return count
    }
}

// 4. Meeting Room 1
class Solution {
    func canAttendMeetings(_ intervals: [[Int]]) -> Bool {
        guard intervals.count > 1 else { return true }
        var sorted = intervals.sorted { $0.first! < $1.first! }
        var prev = sorted.first!
        for i in 1..<sorted.count {
            var curr = sorted[i]
            if prev.last! > curr.first! {
                return false
            }
            prev = curr
        }
        return true
    }
}

// 5. Meeting Room 2
class Solution {
    func minMeetingRooms(_ intervals: [[Int]]) -> Int {
        guard intervals.count > 1 else { return intervals.count }
        var startTimings = intervals.map { $0.first! }.sorted()
        var endTimings = intervals.map { $0.last! }.sorted()
        print(startTimings)
        print(endTimings)
        var sp = 0
        var ep = 0
        var usedRooms = 0
        while sp < intervals.count {
            print(usedRooms)
            if startTimings[sp] >= endTimings[ep] {
                usedRooms -= 1
                ep += 1
            }
            usedRooms += 1
            sp += 1
        }
        return usedRooms
    }
}

// Tree
public class TreeNode {
    public var val: Int
    public var left: TreeNode?
    public var right: TreeNode?
    public init() {
        self.val = 0
        self.left = nil
        self.right = nil
    }
    public init(_ val: Int, _ left: TreeNode?, _ right: TreeNode?) {
        self.val = val
        self.left = left
        self.right = right
    }
}

// 0. BFS, DFS
class Solution {
    func bfs(_ root: TreeNode?) {
        if root == nil { return }
        var queue: [TreeNode] = [root!]
        var result: [TreeNode] = []
        
        while !queue.isEmpty {
            var node = queue.removeFirst()
            result.append(node)
            
            if let left = node.left {
                queue.append(left)
            }
            
            if let right = node.right {
                queue.append(right)
            }
        }
    }
}

// 1. Maximum depth of binary tree
class Solution {
    func maxDepth(_ root: TreeNode?) -> Int {
        if root == nil {
            return 0
        } else {
            return 1 + max(maxDepth(root?.left), maxDepth(root?.right))
        }
    }
}

// 2. Same Tree
class Solution {
    func isSameTree(_ p: TreeNode?, _ q: TreeNode?) -> Bool {
        if p == nil && q == nil { return true }
        if p?.val != q?.val { return false }
        return isSameTree(p?.left, q?.left) && isSameTree(p?.right, q?.right)
    }
}

// 3. Invert Tree
class Solution {
    func invertTree(_ root: TreeNode?) -> TreeNode? {
        if root == nil { return root }
        if root?.left == nil && root?.right == nil { return root }
        let left = root?.left
        root?.left = root?.right
        root?.right = left
        invertTree(root?.left)
        invertTree(root?.right)
        return root
    }
}

// 3. Binary tree maximum sum path: https://leetcode.com/problems/binary-tree-maximum-path-sum/solutions/2827786/binary-tree-maximum-path-sum/

class Solution {
    func maxPathSum(_ root: TreeNode?) -> Int {
        var maxPath = Int.min
        
        func gainFromSubtree(_ node: TreeNode?) -> Int {
            guard let node = node else { return 0 }
            var gainFromLeft = max(0, gainFromSubtree(node.left))
            var gainFromRight = max(0, gainFromSubtree(node.right))
            
            maxPath = max(maxPath, gainFromLeft + node.val + gainFromRight)
            
            return max(
                gainFromLeft + node.val,
                gainFromRight + node.val
            )
        }
        
        gainFromSubtree(root)
        return maxPath
    }
}


// 4. Level Order Traversal
class Solution {
    func levelOrder(_ root: TreeNode?) -> [[Int]] {
        guard root != nil else { return [] }
        var levels = [[Int]]()
        
        func levelOrderRecursive(_ node: TreeNode?, _ level: Int) {
            guard let node = node else { return }
            if levels.count == level {
                // create new level
                levels.append([])
            }
            levels[level].append(node.val)
            if node.left != nil {
                levelOrderRecursive(node.left, level + 1)
            }
            if node.right != nil {
                levelOrderRecursive(node.right, level + 1)
            }
        }
        
        levelOrderRecursive(root, 0)
        return levels
    }
}

// 5. SubTree of another tree

// Note: Serialization of node can be done by multiple ways, but we need to add "#" or "nil" to identify nil nodes. Without that, only preorder or postorder traversal cant identify the unique tree.
// to uniquely identify a tree, you need:
// 1) either of the (preorder, inorder) or (postorder, inorder) traversal [incorrect with duplicates]
// 2) just preorder or postorder traversal with null node replaced as "#"
// only inorder traversal with "#" cant idetify a unique tree
// we also need to differentiate value with "v" or some symbol for cases like:  2, 22 => 2##, 22##, so s1 is substring of s2, but tree1 is not substree of tree2 in real, so to differentiate that: ^2##, ^22## -> not substring

class Solution {
    func isSubtree(_ root: TreeNode?, _ subRoot: TreeNode?) -> Bool {
        if root == nil && subRoot == nil { return true }
        if root == nil || subRoot == nil {
            return false
        }
        var rootString = convertToString(root)
        var subRootString = convertToString(subRoot)
        return rootString.contains(subRootString)
    }
    
    func convertToString(_ node: TreeNode?) -> String {
        guard let node = node else {
            return "#"
        }
        return "v" + String(node.val) + "_l" + convertToString(node.left) + "_r" + convertToString(node.right)
    }
    
    
    // DFS approach
    func isSubtree(_ root: TreeNode?, _ subRoot: TreeNode?) -> Bool {
        
        func isIdentical(_ node1: TreeNode?, _ node2: TreeNode?) -> Bool {
            if node1 == nil || node2 == nil { return node1 == nil && node2 == nil }
            return node1?.val == node2?.val && isIdentical(node1?.left, node2?.left) && isIdentical(node1?.right, node2?.right)
        }
        
        func dfs(_ node: TreeNode?) -> Bool {
            if node == nil { return false }
            else if isIdentical(node, subRoot) { return true }
            return dfs(node?.left) || dfs(node?.right)
        }
        
        return dfs(root)
    }
    
}

// 6. Construct binary tree from preorder and inorder traversal (only works with unique values)
class Solution {
    func buildTree(_ preorder: [Int], _ inorder: [Int]) -> TreeNode? {
        guard !preorder.isEmpty else { return nil }
        var preOrderIndex = 0
        var inorderMap : [Int: Int] = [:]
        for (index, value) in inorder.enumerated() {
            inorderMap[value] = index
        }
        
        func arrToTree(left: Int, right: Int) -> TreeNode? {
            if left > right {
                return nil
            }
            var rootValue = preorder[preOrderIndex]
            var rootNode = TreeNode(rootValue)
            preOrderIndex += 1
            rootNode.left = arrToTree(left: left, right: inorderMap[rootValue]! - 1)
            rootNode.right = arrToTree(left: inorderMap[rootValue]! + 1, right: right)
            
            return rootNode
        }
        
        return arrToTree(left: 0, right: inorder.count - 1)
    }
}

// 7. Valid BST
// WRONG Solution: only checks for immediate children
class Solution {
    func isValidBST(_ root: TreeNode?) -> Bool {
        guard let root = root else { return true }
        var isLeftValid = true
        var isRightValid = true
        if let left = root.left {
            isLeftValid = left.val < root.val && isValidBST(left)
        }
        if let right = root.right {
            isRightValid = right.val > root.val && isValidBST(right)
        }
        return isLeftValid && isRightValid
    }
}


// RIGHT Solution: Range bound, to validate each node
class Solution {
    func isValidBST(_ root: TreeNode?) -> Bool {
        func validate(_ node: TreeNode?, _ low: Int, _ high: Int) -> Bool {
            guard let node = node else { return true }
            if node.val <= low || node.val >= high { return false }
            return validate(node.left, low, node.val) && validate(node.right, node.val, high)
        }
        return validate(root, Int.min, Int.max)
    }
}

// 8. Kth smallest element in BST
class Solution {
    func kthSmallest(_ root: TreeNode?, _ k: Int) -> Int {
        var result: [Int] = []
        // inorder traversal gives you sorted array in ascending order
        func inOrderTraversal(_ node: TreeNode?) {
            guard let node = node else { return }
            inOrderTraversal(node.left)
            result.append(node.val)
            inOrderTraversal(node.right)
        }
        inOrderTraversal(root)
        
        return result[k-1]
    }
}

// 9.Lowest Common ancestor of BST
class Solution {
    func lowestCommonAncestor(_ root: TreeNode?, _ p: TreeNode?, _ q: TreeNode?) -> TreeNode? {
        guard let root = root, let p = p, let q = q else { return nil }
        if root.val == p.val { return p }
        if root.val == q.val { return q }
        var (n1, n2) = p.val < q.val ? (p,q) : (q,p)
        if (n1.val...n2.val).contains(root.val) {
            return root
        }
        if n1.val < root.val {
            // both in left subtree
            return lowestCommonAncestor(root.left, p, q)
        } else {
            // both in right subtree
            return lowestCommonAncestor(root.right, p, q)
        }
        return root
    }
}

// 10. Implement Trie (Prefix tree)
class Trie {
    
    var root: TrieNode
    
    init() {
        root = TrieNode()
    }
    
    func insert(_ word: String) {
        var node = root
        for ch in word {
            node = node.createOrReturn(ch)
        }
        node.isFinal = true
    }
    
    func search(_ word: String) -> Bool {
        var node = root
        for ch in word {
            if node.children[ch] != nil {
                node = node.children[ch]!
            } else {
                return false
            }
        }
        return node.isFinal
    }
    
    func startsWith(_ prefix: String) -> Bool {
        var node = root
        for ch in prefix {
            if node.children[ch] != nil {
                node = node.children[ch]!
            } else {
                return false
            }
        }
        return true
    }
}

class TrieNode {
    var children: [Character: TrieNode] = [:]
    var isFinal: Bool = false
    func createOrReturn(_ ch: Character) -> TrieNode {
        if let node = children[ch] {
            return node
        }
        let newNode = TrieNode()
        children[ch] = newNode
        return newNode
    }
}

// 11. Add and search word
class WordDictionary {
    var root: TrieNode
    
    init() {
        root = TrieNode()
    }
    
    func addWord(_ word: String) {
        var node = root
        for ch in word {
            node = node.createOrReturn(ch)
        }
        node.isFinal = true
    }
    
    func search(_ word: String) -> Bool {
        var node = root
        
        func searchInNode(_ word: String, _ node: TrieNode) -> Bool {
            if word.isEmpty { return true }
            var node = node
            for (i,ch) in word.enumerated() {
                if node.children[ch] == nil {
                    if ch == "." {
                        for child in node.children.values {
                            let start = word.index(word.startIndex, offsetBy: i+1)
                            let end = word.endIndex
                            let remainingWord = String(word[start..<end])
                            if !child.isFinal && searchInNode(remainingWord, child) {
                                return true
                            }
                        }
                    }
                    return false
                } else {
                    node = node.children[ch]!
                }
            }
            return node.isFinal
        }
        
        return searchInNode(word, node)
    }
}

// 12. Word Search II


// Graph:
public class Node {
    public var val: Int
    public var neighbors: [Node?]
    public init(_ val: Int) {
        self.val = val
        self.neighbors = []
    }
}

extension Node: Hashable {
    public static func == (lhs: Node, rhs: Node) -> Bool {
        return lhs.val == rhs.val && Set(lhs.neighbors) == Set(rhs.neighbors)
    }
}

// 1. deep copy of the graph
// Maintain a visited map of node <-> clonedNode
// if node in map, then its already visited, so stop dfs
// iterate over the map and for each node, add neighbours

class Solution {
    func cloneGraph(_ node: Node?) -> Node? {
        guard let node = node else { return nil }
        var processed: [Node: Node] = [:]
        
        func dfs(_ node: Node?) -> Node? {
            guard let node = node else { return nil }
            if let processedNode = processed[node] {
                return processedNode
            }
            var cloneNode = Node(node.val)
            processed[node] = cloneNode // Note that as soon as you have the clone, store it in map, even without neighbors, so it can be returned during dfs
            if !node.neighbors.isEmpty {
                cloneNode.neighbors = node.neighbors.map { dfs($0) }
            }
            return cloneNode
        }
        
        return dfs(node)
    }
}

// 2. Course Schedule
// Find a cycle in directed graph, if yes -> return false
// First create an adjacency list from the edge list of the graph
// dfs traversal of the graph in post order fashion ( neightbours first, and then self)
// use visiting and visited arrays to keep track, if you encounted a node which is already visiting = true (but not visited), it means its being exlored by the neighhbors so there is a cycle
// but if the node is already visited, then theres no cycle there.
// run this dfs on every node of the graph
class Solution {
    func canFinish(_ numCourses: Int, _ prerequisites: [[Int]]) -> Bool {
        var n = numCourses
        var courses: [Int] = (0..<n).map { $0 }
        if prerequisites.isEmpty { return true }
        var graph: [[Int]] = Array(repeating: [], count: n)
        for req in prerequisites {
            graph[req[0]].append(req[1])
        }
        
        var visiting: [Bool] = Array(repeating: false, count: n)
        var visited: [Bool] = Array(repeating: false, count: n)
        var result: [Int] = []
        
        print(graph)
        
        func isCycle(at index: Int) -> Bool {
            if visiting[index] == true {
                return true //already being visited by someone, so cycle
            }
            
            if visited[index] == true {
                return false //already visited, no cycle
            }
            
            visiting[index] = true
            for neighbor in graph[index] {
                if isCycle(at: neighbor) { return true }
            }
            visiting[index] = false
            visited[index] = true
            result.append(index)
            return false
        }
        
        for course in courses {
            if isCycle(at: course) == true { return false }
        }
        
        return true
    }
}

// 3. Pacific Atlantic
// instead of starting at cell and reaching ocean, we can do reverse and start at ocean and figure out the cells
// find out pacificReachable cells as Set
// find out atlanticReachable cells as Set
// return intersection of both
// we can use dfs to traverse, and at each step, check with 4 neighbors, and ofcourse add the height constraint on top of that, i.e height of neighbor should be > height of current

class Solution {
    func pacificAtlantic(_ heights: [[Int]]) -> [[Int]] {
        guard let first = heights.first, !first.isEmpty else {
            return []
        }
        
        var rows = heights.count
        var cols = first.count
        var pacificReachable = Set<[Int]>()
        var atlanticReachable = Set<[Int]>()
        
        func dfs(_ row: Int, _ col: Int, _ reachable: inout Set<[Int]>) {
            reachable.insert([row, col])
            
            var neighbors: [[Int]] = [[0,1], [0,-1], [1,0], [-1,0]]
            for neighbor in neighbors {
                var newRow: Int = row + neighbor[0]
                var newCol: Int = col + neighbor[1]
                
                if newRow < 0 || newRow >= rows || newCol < 0 || newCol >= cols { continue }
                
                // Already marked reachable
                if reachable.contains([newRow, newCol]) { continue }
                
                // height constraint
                if heights[newRow][newCol] < heights[row][col] { continue }
                
                // [newRow, newCol] cell can be visited and marked as reachable
                dfs(newRow, newCol, &reachable)
            }
        }
        
        // loop through all the cells adjacent to ocean and start DFS
        for i in 0..<rows {
            dfs(i, 0, &pacificReachable)
            dfs(i, cols-1, &atlanticReachable)
        }
        
        for j in 0..<cols {
            dfs(0, j, &pacificReachable)
            dfs(rows-1, j, &atlanticReachable)
        }
        
        return Array(pacificReachable.intersection(atlanticReachable))
    }
}

// 4. Number of Islands
// go one by one in the grid, if char == 1, then add 1 to result
// but then visit the node, and mark it as 0
// and explore all its neighbors, find any neighbor with 1, and trigger dfs for that, before marking them as 0 as well

class Solution {
    func numIslands(_ grid: [[Character]]) -> Int {
        guard let first = grid.first,
              first.count > 0 else { return 0 }
        
        var rows = grid.count
        var cols = first.count
        var grid = grid
        var result: Int = 0
        
        func dfs(_ row: Int, _ col: Int, _ grid: inout [[Character]]) {
            grid[row][col] = Character("0")
            var neighbors: [[Int]] = [[1,0], [-1,0], [0,1], [0,-1]]
            for neighbor in neighbors {
                var newRow = row + neighbor[0]
                var newCol = col + neighbor[1]
                if newRow >= 0 && newRow < rows && newCol >= 0 && newCol < cols && grid[newRow][newCol] == Character("1") {
                    dfs(newRow, newCol, &grid)
                }
            }
        }
        for i in 0..<rows {
            for j in 0..<cols {
                if grid[i][j] == Character("1") {
                    result += 1
                    dfs(i, j, &grid)
                }
            }
        }
        return result
    }
}

// 5. Longest consecutive subsequence
// create set out of array to remove duplicates
// for each num, increatement it by 1 and see if its in the set
// if not, then go to next num
// if yes, then go till curr + 1 is in set, and increment result count
// finaly return maximum

// optimization:
// if curr - 1 is in set, then ignore curr, because it was already counted in prev. streak

class Solution {
    func longestConsecutive(_ nums: [Int]) -> Int {
        guard !nums.isEmpty else { return 0 }
        var set = Set(nums)
        var result = 0
        for num in set {
            if !set.contains(num - 1) {
                var currStreak = 1
                var curr = num
                while set.contains(curr + 1) {
                    currStreak += 1
                    curr += 1
                }
                result = max(result, currStreak)
            }
        }
        return result
    }
}

// 6. Aliens Dictionary




// 7. Graph Valid Tree
// No cycles
// DFS should visit every node
class Solution {
    func validTree(_ n: Int, _ edges: [[Int]]) -> Bool {
        guard n >= 2 else { return true }
        guard !edges.isEmpty else { return false }
        var graph: [[Int]] = Array(repeating: [], count: n)
        for edge in edges {
            graph[edge[0]].append(edge[1])
            graph[edge[1]].append(edge[0])
        }
        print(graph)
        var visited = Set<Int>()

        func dfs(_ index: Int, _ parent: Int) -> Bool {
            if visited.contains(index) {
                return false
            }

            visited.insert(index)

            for neighbor in graph[index] {
                if neighbor == parent { continue }
                if dfs(neighbor, index) == false {
                    return false
                }
            }

            return true
        }
        
        return  dfs(0, -1) && visited.count == n
     
    }
}



// 8. Number of connected components in Undirected graph
// apply dfs, keep track of visited nodes
// everytime you need to trigger dfs, thats one more component
class Solution {
    func countComponents(_ n: Int, _ edges: [[Int]]) -> Int {
        guard !edges.isEmpty else { return n }
        var components = 0
        var graph: [[Int]] = Array(repeating: [], count: n)
        for edge in edges {
            graph[edge[0]].append(edge[1])
            graph[edge[1]].append(edge[0])
        }
        print(graph)
        var visited: [Bool] = Array(repeating: false, count: n)
        
        func dfs(index: Int) {
            visited[index] = true
            for neighbor in graph[index] {
                if visited[neighbor] == false {
                    dfs(index: neighbor)
                }
            }
        }
        
        for i in 0..<n {
            if visited[i] == false {
                components += 1
                dfs(index: i)
            }
        }
        
        return components
    }
}

// Union find approach for above question:
class Solution {
    func countComponents(_ n: Int, _ edges: [[Int]]) -> Int {
        guard n > 0 else { return 0 }
        guard !edges.isEmpty else { return n }
        
        var parent: [Int] = Array(0..<n)
        var rank: [Int] = Array(repeating: 1, count: n)
        
        func find(node: Int) -> Int {
            var node = node
            while parent[node] != node {
                node = parent[node]
            }
            return node
        }
        
        func union(node1: Int, node2: Int) -> Int {
            var p1 = find(node: node1)
            var p2 = find(node: node2)
            
            if p1 == p2 { return 0 }
            if rank[p1] > rank[p2] {
                parent[p2] = p1
                rank[p1] += rank[p2]
            } else {
                parent[p1] = p2
                rank[p2] += rank[p1]
            }
            return 1
        }
        
        var connectedComponents = n
        for edge in edges {
            connectedComponents -= union(node1: edge[0], node2: edge[1])
        }
        
        return connectedComponents
    }
}
// Heap:
//1. Merge K Sorted Lists

// 3 ways:
//0 -> Brute force ->  traverse all lists, collect all values in one giant array, sort it O(NLogN)
//1 -> use 2 pointer start and end, and for each pair, merge 2 sorted lists, till the list is just one component - O(kN)
//2 -> Use heap to get the first elements from each list, find the min, and then add it to final, increment that list by  1, and follow the process


// Matrix:

//1. set zeros in matrix
class Solution {
    func setZeroes(_ matrix: inout [[Int]]) {
        // in first iteration, set the 0th row and 0th col for cell as 0 to indicate that that entire row/col will be 0 in future
        
        // in 2nd iteration, make all 0s
        
        var rows = matrix.count
        var cols = matrix[0].count
        var firstColToSet = false
        
        for i in 0..<rows {
            if matrix[i][0] == 0 {
                firstColToSet = true
            }
            
            for j in 1..<cols {
                if matrix[i][j] == 0 {
                    matrix[0][j] = 0
                    matrix[i][0] = 0
                }
            }
        }
        
        for i in 1..<rows {
            for j in 1..<cols {
                if matrix[0][j] == 0 || matrix[i][0] == 0 {
                    matrix[i][j] = 0
                }
            }
        }
        
        //finally set the 0th row and 0th col as 0 if needed
        if matrix[0][0] == 0 {
            for j in 0..<cols {
                matrix[0][j] = 0
            }
        }
        
        if firstColToSet {
            for i in 0..<rows {
                matrix[i][0] = 0
            }
        }
    }
}

//2. WordSearch:
class Solution {
    func exist(_ board: [[Character]], _ word: String) -> Bool {
        guard !board.isEmpty else { return false }
        guard !word.isEmpty else { return true }
        var board = board
        var rows = board.count
        var cols = board[0].count
        var neighbors: [[Int]] = [[0,1], [0,-1], [1,0], [-1,0]]
        var visited = Set<[Int]>()

        func backTrack(_ row: Int, _ col: Int, _ suffix: String) -> Bool {
            print(row, col, suffix)
            if suffix.isEmpty {
                return true
            }

            var suffix = suffix
            visited.insert([row, col])
            var ret = (board[row][col] == suffix.removeFirst())
            var neighborResult = false
            if ret {
                for neighbor in neighbors {
                    var newRow = row + neighbor[0]
                    var newCol = col + neighbor[1]
                    if newRow >= 0 && newRow < rows && newCol >= 0 && newCol < cols && !visited.contains([newRow,newCol])  {
                        neighborResult = neighborResult || backTrack(newRow, newCol, suffix)
                    }
                }
            }

            return ret && neighborResult
        }

        for i in 0..<rows {
            for j in 0..<cols {
                if backTrack(i, j, word) { return true }
            }
        }
        return false
    }
}

extension String {
    subscript(offset: Int) -> Character {
        return self[index(startIndex, offsetBy: offset)]
    }
}

//3. WordSearchII
class Solution {
    func findWords(_ board: [[Character]], _ words: [String]) -> [String] {
        var rows = board.count
        var cols = board[0].count
        var visited = Set<[Int]>()
        var neighbors = [[0,1], [0, -1], [1, 0], [-1, 0]]

        func dfs(_ row: Int, _ col: Int, _ word: String) -> Bool {
            var word = word
            if word.isEmpty { return true }
            var result = (board[row][col] == word.removeFirst())
            var neighborResult = false
            if result {
                for neighbor in neighbors {
                    var newRow = row + neighbor[0]
                    var newCol = col + neighbor[1]
                    if (0..<rows).contains(newRow) && (0..<cols).contains(newCol) && !visited.contains([newRow, newCol]) {
                        neighborResult = neighborResult || dfs(newRow, newCol, word)
                    }
                }
            }
            return result && neighborResult
        }

        var final: [String] = []
        for word in words {
            for i in 0..<rows {
                for j in 0..<cols {
                    if dfs(i, j, word) {
                        final.append(word)
                        visited = Set<[Int]>()
                        break
                    }
                }
            }
        }
        return final
    }
}

//4.




// Dynamic Programming:
//1. Longest increasing subsequence
class Solution {
    func lengthOfLIS(_ nums: [Int]) -> Int {
        guard !nums.isEmpty else { return 0 }
        var n = nums.count
        var dp = Array(repeating: 1, count: n)

        for i in 0..<n {
            for j in 0..<i {
                if nums[j] < nums[i] {
                    dp[i] = max(dp[i], dp[j]+1)
                }
            }
        }

        return dp.max()!
    }
}

//2. Longest common subsequence
class Solution {
    func longestCommonSubsequence(_ text1: String, _ text2: String) -> Int {
        var text1 = Array(text1)
        var text2 = Array(text2)
        var n1 = text1.count
        var n2 = text2.count
        var dp = Array(repeating: Array(repeating: 0, count: n2 + 1), count: n1 + 1)

        for i in 0...n1 {
            for j in 0...n2 {
                if i == 0 || j == 0 { dp[i][j] = 0 }
                else if text1[i-1] == text2[j-1] {
                    dp[i][j] = dp[i-1][j-1] + 1
                } else {
                    dp[i][j] = max(dp[i-1][j], dp[i][j-1])
                }
            }
        }

        return dp[n1][n2]
    }
}

//3. Combination sum IV (same as Coin change II) <- Use DP
// Coin change II problem considers combinations where Combination sum IV considers permutations. thats the only difference

class Solution {
    func combinationSum4(_ nums: [Int], _ target: Int) -> Int {
        guard !nums.isEmpty else { return -1 }
        var nums = nums.sorted() //optimization
    
        //DP Approach:
        var dp = Array(repeating: 0, count: target + 1)
        dp[0] = 1
        for sum in 0...target {
            for num in nums {
                if sum >= num {
                    dp[sum] += dp[sum - num]
                } else {
                    break //early stop, only possible if nums are sorted.
                }
            }
        }

        return dp[target]

//backtracking approach: Fails with memory limit exceeds
// var result = [[Int]]()
// func backTrack(comb: [Int], sum: Int) {
//     var comb = comb
//     var sum = sum
//     if sum == target {
//         result.append(comb)
//         return
//     }

//     if sum > target {
//         return
//     }

//     for i in 0..<n {
//         comb.append(nums[i])
//         sum += nums[i]
//         backTrack(comb: comb, sum: sum)
//         sum -= nums[i]
//         comb.removeLast()

//     }
// }

// backTrack(comb: [], sum: 0)
// print(result)
// return result.count
    }
}

//4. House Robber
class Solution {
    func rob(_ nums: [Int]) -> Int {
        guard !nums.isEmpty else { return 0 }
        var n = nums.count
        var dp = Array(repeating: 0, count: n)
        for i in 0..<n {
            if i == 0 { dp[i] = nums[i] }
            else if i == 1 { dp[i] = max(nums[0], nums[1]) }
            else {
                dp[i] = max(nums[i] + dp[i-2], dp[i-1])
            }
        }

        return dp[n-1]
    }
}

//5.House Robber II
class Solution {
    func rob(_ nums: [Int]) -> Int {

        func robSimple(_ nums: [Int]) -> Int {
            print(nums)
            var n = nums.count
            var dp = Array(repeating: 0, count: n)
            for i in 0..<n {
                if i == 0 { dp[i] = nums[i] }
                else if i == 1 { dp[i] = max(nums[0], nums[1]) }
                else {
                    dp[i] = max(dp[i-1], dp[i-2] + nums[i])
                }
            }

            return dp[n-1]
        }

        var nums = nums
        guard !nums.isEmpty else { return 0 }
        guard nums.count > 2 else { return nums.max()! }
        var n = nums.count
        return max(
            robSimple( Array(nums[1...]) ),
            robSimple( Array(nums[0..<n-1]) )
        )
    }
}

//6. Unique path II
class Solution {
    func uniquePathsWithObstacles(_ obstacleGrid: [[Int]]) -> Int {
        guard !obstacleGrid.isEmpty else { return 0 }
        var rows = obstacleGrid.count
        var cols = obstacleGrid[0].count
        var dp = Array(repeating: Array(repeating: 1, count: cols), count: rows)

        //1: Obstacle cell
        //0: clear cell

        //base case: obstacle at start point
        if obstacleGrid[0][0] == 1 { return 0 }

        // 1 way to reach the start index
        dp[0][0] = 1

        //check for first col where obstacle is there and mark all cols after that as obstacle.
        var rowIndex = Int.max
        for i in 0..<rows {
            if obstacleGrid[i][0] == 1 {
                rowIndex = i
            }
            if i >= rowIndex {
                dp[i][0] = 0 // #of ways 0
            }
        }

        //check for first row where obstacle is there and mark all rows after that as obstacle
        var colIndex = Int.max
        for j in 0..<cols {
            if obstacleGrid[0][j] == 1 {
                colIndex = j
            }
            if j >= colIndex {
                dp[0][j] = 0 // #of ways 0
            }
        }

        print(dp)
        //now continue for the rest of the grid
        for i in 1..<rows {
            for j in 1..<cols {
                if obstacleGrid[i][j] == 0 {
                    // no obstacle cell
                    dp[i][j] = dp[i-1][j] + dp[i][j-1]
                }  else {
                    // obstacle cell, so # of ways become 0
                    dp[i][j] = 0
                }
            }
        }

        return dp[rows-1][cols-1]
    }
}



