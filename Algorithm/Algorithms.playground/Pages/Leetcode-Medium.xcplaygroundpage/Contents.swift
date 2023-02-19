import Foundation

//Array and Strings
//1. Set matric zeros
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
        
        print(matrix)
        
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

//2. Increasing triplet subsequence
class Solution {
    func increasingTriplet(_ nums: [Int]) -> Bool {
        guard nums.count >= 3 else { return false }
        var firstSmallest = Int.max
        var secondSmallest = Int.max
        for num in nums {
            if num <= firstSmallest {
                firstSmallest = num
            } else if num <= secondSmallest {
                secondSmallest = num
            } else {
                return true
            }
        }
        return false
    }

    func continuousTriplet(_ nums: [Int]) -> Bool {
        guard nums.count >= 3 else { return false }
        var count = 0
        var prev = Int.min
        for num in nums {
            if num > prev {
                count += 1
                if count == 3 { return true }
            } else {
                count = 1
            }
            prev = num
        }
        return false
    }
}

//3. Missing ranges
class Solution {
    func findMissingRanges(_ nums: [Int], _ lower: Int, _ upper: Int) -> [String] {
        var result = [String]()
        guard !nums.isEmpty else {
            if let range = createRange(lower, upper, .both) {
                result.append(range)
            }
            return result
        }
        if let lowerRange = createRange(lower, nums[0], .left) { result.append(lowerRange) }
        for i in 0..<nums.count-1 {
            if let range = createRange(nums[i], nums[i+1], .none) {
                result.append(range)
            }
        }
        if let upperRange = createRange(nums[nums.count-1], upper, .right) { result.append(upperRange) }
        return result
    }
    
    enum inclusiveType {
        case left, right, both, none
    }
    
    func createRange(_ num1: Int, _ num2: Int, _ type: inclusiveType) -> String? {
        switch type {
            case .none:
                guard num2 - num1 >= 2 else { return nil }
                if num2 - num1 == 2 { return "\(num1 + 1)" }
                return "\(num1 + 1)->\(num2 - 1)"
            case .both:
                if num1 == num2 { return "\(num1)"}
                return "\(num1)->\(num2)"
            case .left:
                if num1 == num2 { return nil }
                if num2 - num1 == 1 { return "\(num1)" }
                return "\(num1)->\(num2 - 1)"
            case .right:
                if num1 == num2 { return nil }
                if num2 - num1 == 1 { return "\(num2)" }
                return "\(num1+1)->\(num2)"
        }
    }
}

//4. Count and Say


// LinkedList:

public class ListNode {
    public var val: Int
    public var next: ListNode?
    public init(_ val: Int) {
        self.val = val
        self.next = nil
    }
}

//1.  Add two numbers:
class Solution {
    func addTwoNumbers(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
        var l1: ListNode? = l1
        var l2: ListNode? = l2
        var list: ListNode? = ListNode(-1)
        var head = list
        var carry = 0
        while l1 != nil || l2 != nil {
            var sum = (l1?.val ?? 0) + (l2?.val ?? 0) + carry
            if sum >= 10 {
                carry = 1
                sum -= 10
            } else {
                carry = 0
            }
            let newNode = ListNode(sum)
            list?.next = newNode
            list = list?.next
            if l1 != nil { l1 = l1?.next }
            if l2 != nil { l2 = l2?.next }
        }
        if carry == 1 {
            list?.next = ListNode(carry)
        }
        return head?.next
    }
}

//2. Odd Even List
class Solution {
    func oddEvenList(_ head: ListNode?) -> ListNode? {
        guard head != nil else { return nil }
        var oddHead = head
        var odd = head
        var even = head?.next
        var evenHead = head?.next
        
        while even != nil && even?.next != nil {
            odd?.next = even?.next
            odd = odd?.next
            even?.next = odd?.next
            even = even?.next
        }
        odd?.next = evenHead
        return oddHead
    }
}

//3. Intersection of two linked list
class Solution {
    func getIntersectionNode(_ headA: ListNode?, _ headB: ListNode?) -> ListNode? {
        var headA = headA
        var headB = headB
        var currA = headA
        var currB = headB
        while currA != nil && currB != nil {
            if currA === currB { return currA }
            currA = currA?.next
            if currA == nil {
                currA = headB
                headB = nil
            }
            currB = currB?.next
            if currB == nil {
                currB = headA
                headA = nil
            }
        }
        return nil
    }
}


// Tree:
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

// 1. Binary Tree ZigZag level Order
class Solution1 {
    func zigzagLevelOrder(_ root: TreeNode?) -> [[Int]] {
        guard root != nil else { return [] }
        var levels: [[Int]] = []
        
        func dfs(_ node: TreeNode?, _ level: Int, _ right: Bool) {
            guard node != nil else { return }
            if levels.count == level {
                levels.append([ ])
            }
            if right {
                levels[level].append(node!.val)
            } else {
                levels[level].insert(node!.val, at: 0)
            }
            
            dfs(node?.left, level + 1, !right)
            dfs(node?.right, level + 1, !right)
        }
        
        dfs(root, 0, true)
        return levels
    }
}

//2. Populating next right pointer
class Solution2 {
    func connect(_ root: Node?) -> Node? {
        guard root != nil else { return root }
        var root = root
        var queue: [Node?] = []
        queue.append(root)
        
        while !queue.isEmpty {
            let size = queue.count
            
            //at each time, the size of the queue will be all the nodes in one level
            for i in 0..<size {
                var node = queue.removeFirst()
                
                // since we dont need to point next of the last element
                if i < size - 1 {
                    node?.next = queue.first!
                }
                
                if let left = node?.left {
                    queue.append(left)
                }
                if let right = node?.right {
                    queue.append(right)
                }
            }
        }
        return root
    }
}

// 3. Inorder successor in BST
class Solution3 {
    func inorderSuccessor(_ root: TreeNode?, _ p: TreeNode?) -> TreeNode? {
        var result: [TreeNode?] = []
        func inorderTraversal(_ node: TreeNode?) {
            guard node != nil else { return }
            inorderTraversal(node?.left)
            result.append(node)
            inorderTraversal(node?.right)
        }
        
        inorderTraversal(root)
        for (i, node) in result.enumerated() {
            if node === p && i != result.count - 1 {
                return result[i+1]
            }
        }
        return nil
    }
}

// Dynamic Programming
//1. Jump game

class Solution {
    func canJump(_ nums: [Int]) -> Bool {
        var n = nums.count
        guard n >= 2 else { return true }
        
        var dp: [Bool] = Array(repeating: false, count: n)
        dp[n-1] = true //always can reach here
        
        for i in (0...n-2).reversed() {
            if nums[i] == 0 { continue }
            
            for jump in 1...nums[i] where i + jump < n {
                dp[i] = dp[i] || dp[i+jump]
                if dp[i] { break }
            }
        }
        
        return dp[0]
    }
}

//2. Unique paths
class Solution {
    func uniquePaths(_ m: Int, _ n: Int) -> Int {
        var dp: [[Int]] = Array(repeating: (Array(repeating: 1, count: n)), count: m)
        for i in 1..<m {
            for j in 1..<n {
                dp[i][j] = dp[i-1][j] + dp[i][j-1]
            }
        }
        return dp[m-1][n-1]
    }
}

//3. Coin change
class Solution {
    func coinChange(_ coins: [Int], _ amount: Int) -> Int {
        guard !coins.isEmpty else { return -1 }
        var n = coins.count
        var infinite = Int.max - 1
        var dp: [[Int]] =  Array(repeating: Array(repeating: 0, count: amount+1), count: n+1)
        
        for i in 0...n {
            for j in 0...amount {
                if i == 0 && j == 0 { dp[i][j] = infinite }
                else if i == 0 { dp[i][j] = infinite }
                else if j == 0 { dp[i][j] = 0 }
                else if coins[i-1] > j {
                    dp[i][j] = dp[i-1][j]
                } else {
                    dp[i][j] = min( 1 + dp[i][j-coins[i-1]], dp[i-1][j])
                }
            }
        }
        
        return dp[n][amount] == infinite ? -1 : dp[n][amount]
    }
}


// Others
//1. Majority Element
class Solution {
    
    //Time: O(n), Space: O(n)
    func majorityElementUsingMap(_ nums: [Int]) -> Int {
        var mappedItems = nums.map { ($0, 1) }
        var n = nums.count
        var dict = Dictionary(mappedItems, uniquingKeysWith: +)
        for each in dict {
            if each.value > Int(n/2) { return each.key }
        }
        return -1
    }
    
    // Time: O(nLogn), Space: O(1)
    func majorityElementUsingSort(_ nums: [Int]) -> Int {
        var nums = nums.sorted()
        return nums[nums.count/2]
    }
}

//2. Find Celebrity
class Solution : Relation {
    func findCelebrity(_ n: Int) -> Int {
        guard n > 1 else { return n }
        var c = 0
        for i in 0..<n {
            if knows(c, i) {
                // c knows i, so c cant be a celebrity
                c = i
            }
        }
        
        // now we found a c which can be a celebrity, lets verify that by checking in degree and outdegree
        for i in 0..<n {
            if i != c && (knows(c, i) == true || knows(i, c) == false) {
                // Oops, c cant be a celebrity
                return -1
            }
        }
        return c
    }
}

// Sorting and Searching
//1. Sort colors
class Solution {
    func sortColors(_ nums: inout [Int]) {
        guard !nums.isEmpty else { return }
        var p0 = 0
        var p2 = nums.count - 1
        var curr = 0
        while curr < p2 {
            if nums[curr] == 2 {
                nums.swapAt(curr, p2)
                p2 -= 1
            } else if nums[curr] == 0 {
                nums.swapAt(curr, p0)
                p0 += 1
                curr += 1
            } else {
                curr += 1
            }
        }
    }
}

//2. Search a 2D matrix II
class Solution {
    func searchMatrix(_ matrix: [[Int]], _ target: Int) -> Bool {
        guard !matrix.isEmpty else { return false }
        var rows = matrix.count
        var cols = matrix[0].count
        var i = 0
        var j = cols - 1
        while i <= rows - 1 && j >= 0 {
            if matrix[i][j] == target {
                return true
            } else if matrix[i][j] < target {
                i += 1
            } else {
                j -= 1
            }
        }
        
        return false
    }
}

//3.
