import Foundation
//------------- Week1----------------- //
//1 . Two sum
class Solution {
    static func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
        guard nums.count >= 2 else { return [] }
        var map: [Int: Int] = [:]
        var result: [Int] = []
        for i in 0..<nums.count {
            let diff = target - nums[i]
            if let prevElementIndex = map[diff] {
                result.append(i)
                result.append(prevElementIndex)
                return result
            }
            map[nums[i]] = i
        }
        return result
    }
}

var c = Solution.twoSum([2,7,11,15], 9)
var c1 = Solution.twoSum([3,2,4], 6)

//2. Valid Parentheses
class Solution2 {
    static func validParentheses(_ s: String) -> Bool {
        guard !s.isEmpty else { return true }
        var parentheses: [Character: Character] = ["{":"}", "(":")", "[":"]"]
        var stack: [Character] = []
        var s = Array(s)
        for i in 0..<s.count {
            if parentheses.keys.contains(s[i]) {
                stack.append(s[i])
            } else {
                guard !stack.isEmpty else { return false }
                let last = stack.removeLast()
                if parentheses[last] != s[i] { return false }
            }
        }
        
        return stack.isEmpty
    }
}

var c2 = Solution2.validParentheses("(())[]{[]}")

// 3. Merge 2 sorted lists: directly assing l1 and l2, not create new copy
class LLNode {
    var val: Int
    var next: LLNode?
    
    init() {
        self.val = 0
        self.next = nil
    }
    
    init(_ val: Int) {
        self.val = val
        self.next = nil
    }
    
    init(_ val: Int, _ next: LLNode?) {
        self.val = val
        self.next = next
    }
}

class Solution3 {
    static func mergeTwoLists(_ head1: LLNode?, _ head2: LLNode?) -> LLNode? {
        guard head1 != nil else { return head2 }
        guard head2 != nil else { return head1 }
        var h1 = head1
        var h2 = head2
        var tempHead: LLNode = LLNode(0)
        var temp: LLNode? = tempHead
        while h1 != nil && h2 != nil {
            if h1!.val <= h2!.val {
                temp?.next = h1
                h1 = h1?.next
            } else {
                temp?.next = h2
                h2 = h2?.next
            }
            temp = temp?.next
        }
        
        temp?.next = h1 ?? h2
        return tempHead.next
    }
}

var l1 = LLNode(1, LLNode(2, LLNode(4)))
var l2 = LLNode(1, LLNode(3, LLNode(4)))
var c3 = Solution3.mergeTwoLists(l1, l2)

// 4. Best time to buy and sell stock
class Solution4 {
    func maxProfit(_ prices: [Int]) -> Int {
        if prices.count <= 1 { return 0 }
        var minSoFar = prices[0]
        var maxProfit = 0
        for i in 1..<prices.count {
            maxProfit = max(maxProfit, prices[i] - minSoFar)
            minSoFar = min(minSoFar, prices[i])
        }
        return maxProfit
    }
}

// 5. Valid Palindrome
class Solution5 {
    func isPalindrome(_ s: String) -> Bool {
        var s = s.lowercased()
        s = s.filter {  ("a"..."z").contains($0) || ("0"..."9").contains($0) }
        return s == String(s.reversed())
    }
}

// 6. Invert Binary Tree
class TreeNode {
    var val : Int
    var left: TreeNode?
    var right: TreeNode?
    init() {
        self.val = 0
        self.left = nil
        self.right = nil
    }
    
    init(_ val: Int) {
        self.val = val
        self.left = nil
        self.right = nil
    }
    
    init(_ val: Int, _ left: TreeNode?, _ right: TreeNode?) {
        self.val = 0
        self.left = left
        self.right = right
    }
    
    var hasNoChild: Bool {
        return left == nil && right == nil
    }
}

class Solution6 {
    static func invertTree(_ root: TreeNode?) -> TreeNode? {
        guard var root = root else { return nil }
        if root.hasNoChild { return root }
        
        let temp = root.left
        root.left = root.right
        root.right = temp
        
        root.left = invertTree(root.left)
        root.right = invertTree(root.right)
        
        return root
    }
}

// 7. Valid anagram
class Solution7 {
    static func validAnagram(_ s: String, _ t: String) -> Bool {
        guard s.count == t.count else { return false }
        var s = Array(s)
        var t = Array(t)
        var mappedItems = s.map { ($0, 1) }
        var map: [Character: Int] = Dictionary(mappedItems, uniquingKeysWith: +)
        
        for i in 0..<t.count {
            if let freq = map[t[i]] {
                if freq == 1 { map[t[i]] = nil }
                map[t[i]] = freq - 1
            } else {
                return false
            }
        }
        
        return true
    }
}

// 8. Binary Search
class Solution8 {
    func search(_ nums: [Int], _ target: Int) -> Int {
        guard !nums.isEmpty else { return -1 }
        var start = 0
        var end = nums.count - 1
        while start <= end {
            var mid = (start + end)/2
            if nums[mid] == target {
                return mid
            } else if nums[mid] < target {
                start = mid + 1
            } else {
                end = mid - 1
            }
        }
        return -1
    }
}

// 9. Flood fill
class Solution9 {
    func floodFill(_ image: [[Int]], _ sr: Int, _ sc: Int, _ color: Int) -> [[Int]] {
        guard !image.isEmpty else { return [] }
        var rows = image.count
        var cols = image[0].count
        var image = image
        let neighbors = [[0,1], [0,-1], [1,0], [-1,0]]

        func dfs(_ row: Int, _ col: Int, _ parentColor: Int) {
            if image[row][col] != parentColor { return }
            print(row, col)
            image[row][col] = color
            for i in neighbors {
                var newRow = row + i[0]
                var newCol = col + i[1]
                if newRow >= 0 && newRow < rows && newCol >= 0 && newCol < cols && image[newRow][newCol] != color {
                    dfs(newRow, newCol, parentColor)
                }
            }
        }

        dfs(sr, sc, image[sr][sc])
        return image
    }
}

//10. Lowest Common Ancestor
class Solution10 {
    func lca(_ root: TreeNode?, _ p: TreeNode?, _ q: TreeNode?) -> TreeNode? {
        guard let root = root, let p = p, let q = q else { return nil }
        var (n1,n2) = p.val < q.val ? (p,q) : (q,p)
        
        if (n1.val...n2.val).contains(root.val) {
            return root
        }
        if n1.val < root.val {
            return lca(root.left, p, q)
        } else {
            return lca(root.right, p, q)
        }
        return root
    }
}

//11. Balanced Binary Tree
class Solution11 {
    func isBalanced(_ root: TreeNode?) -> Bool {
        guard let root = root else { return true }

        func height(_ root: TreeNode?) -> Int {
            if root == nil { return 0 }
            return max(height(root?.left), height(root?.right)) + 1
        }
        
        let diff = height(root.left) - height(root.right)
        if abs(diff) > 1 { return false }
        return isBalanced(root.left) && isBalanced(root.right)
    }
}

//12. Linked List cycle
class Solution12 {
    func isCycle(_ head: LLNode?) -> Bool {
        guard let head = head else { return false }
        var slow: LLNode? = head
        var fast: LLNode? = head.next
        while slow !== fast {
            if fast == nil || fast?.next == nil { return false }
            slow = slow?.next
            fast = fast?.next?.next
        }
        return true
    }
}

// 13. Implement Queue using 2 stacks
class MyQueue {
    var pushStack: [Int]
    var popStack: [Int]

    init() {
        pushStack = []
        popStack = []
    }
    
    func push(_ x: Int) {
        pushStack.append(x)
    }
    
    func pop() -> Int {
        if popStack.isEmpty {
            while !pushStack.isEmpty {
                var last = pushStack.removeLast()
                popStack.append(last)
            }
        }
        return popStack.removeLast()
    }
    
    func peek() -> Int {
        if popStack.isEmpty {
            while !pushStack.isEmpty {
                var last = pushStack.removeLast()
                popStack.append(last)
            }
        }
        return popStack.last ?? -1
    }
    
    func empty() -> Bool {
        return pushStack.isEmpty && popStack.isEmpty
    }
}

//------------- Week3----------------- //
// 1.  Insert Interval
class Solution31 {
    func insertInterval(_ intervals: [[Int]], _ newInterval: [Int]) -> [[Int]] {
        guard !intervals.isEmpty else { return intervals }
        var result: [[Int]] = []
        var newInterval = newInterval
        for i in 0..<intervals.count {
            var currInterval = intervals[i]
            if currInterval[0] > newInterval[1] {
                // insert at front
                result.append(newInterval)
                newInterval = currInterval
            } else if currInterval[1] < newInterval[0] {
                // insert at back
                result.append(newInterval)
            } else {
                // overlap
                var new0 = min(newInterval[0], currInterval[0])
                var new1 = max(newInterval[1], currInterval[1])
                newInterval = [new0, new1]
            }
        }
        return result
    }
}

// 2. 01 Matrix : BFS
class Solution32 {
    func updateMatrix(_ mat: [[Int]]) -> [[Int]] {
        guard !mat.isEmpty else { return [] }
        var rows = mat.count
        var cols = mat[0].count
        var dist: [[Int]] = Array(repeating: Array(repeating: Int.max, count: cols), count: rows)

        var queue: [[Int]] = []
        for row in 0..<rows {
            for col in 0..<cols {
                if mat[row][col] == 0 {
                    dist[row][col] = 0
                    queue.append([row, col])
                }
            }
        }

        while !queue.isEmpty {
            // pop the queue
            let first = queue.removeFirst()
            let row = first[0]
            let col = first[1]
            
            //explore the neighbors
            let neighbors =  [[0,1], [0,-1], [1,0], [-1,0]]
            for neighbor in neighbors {
                var newRow = row + neighbor[0]
                var newCol = col + neighbor[1]
                if newRow >= 0 && newRow < rows && newCol >= 0 && newCol < cols {
                    if dist[newRow][newCol] > dist[row][col] + 1 {
                        dist[newRow][newCol] = dist[row][col] + 1
                        //add neighbor in the queue
                        queue.append([newRow, newCol])
                    }
                }
            }
        }
        return dist
    }
}

// 3. K closest point to origin
class Solution33 {
    func kClosest(_ points: [[Int]], _ k: Int) -> [[Int]] {
        guard k <= points.count else { return [] }
        func distanceFromOrigin(_ point: [Int]) -> Double {
            let x = Double(point[0])
            let y = Double(point[1])
            return sqrt(pow(x, 2) + pow(y, 2))
        }

        var points = points.sorted { return distanceFromOrigin($0) < distanceFromOrigin($1) }
        return Array(points[..<k])
    }
}

// 4. Longest Substring without repeating characters
class Solution34 {
    func uniqueCharacterInString(_ s: String) -> Int {
        return Set(s).count
    }
    
    func longestSubstringWithUniqueCharacters(_ s: String) -> Int {
        guard s.count > 2 else { return s.count }
        var i = 0
        var j = 0
        var n = s.count
        var result = 0
        var str = ""
        while j < n {
            str += String(s[j])
            if uniqueCharacterInString(str) == j - i + 1 {
                // found a candidate
                result = max(result, str.count)
                j += 1
            } else if uniqueCharacterInString(str) < j - i + 1 {
                // there are some duplicates
                while uniqueCharacterInString(str) < j - i + 1 {
                    str.removeFirst()
                    i += 1
                }
                j += 1
            }
        }
        
        return result
    }
}

extension String {
    subscript(offset: Int) -> Character {
        return self[index(startIndex, offsetBy: offset)]
    }
}

// 5. 3Sum
// sort array, use 3 pointers, i, j, k
// for each element, if its repeat of before, then skip so no duplicate
// for each i, use j and k for to find "-num[i]" using two sum
class Solution35 {
    func threeSum(_ nums: [Int]) -> [[Int]] {
        guard nums.count >= 3 else { return [] }
        var nums = nums.sorted()
        if nums[0] > 0 { return [] }
        var result: [[Int]] = []
        for i in 0..<nums.count {
            if i != 0 && nums[i] == nums[i-1] { continue }
            var j = i + 1
            var k = nums.count - 1
            while j < k {
                var sum = nums[i] + nums[j] + nums[k]
                if sum == 0 {
                    result.append([i, j, k])
                    j = j + 1
                    while j < k && nums[j] == nums[j-1] {
                        j += 1
                    }
                } else if sum < 0 {
                    j += 1
                } else {
                    k -= 1
                }
            }
        }
        return result
    }
}

//6. Binary tree level order traversal
class Solution36 {
    func levelOrderTraversal(_ root: TreeNode?) -> [[Int]] {
        guard let root = root else { return [] }
        var result: [[Int]] = []
        func dfs(_ node: TreeNode?, _ level: Int) {
            guard let node = node else { return }
            if result.count == level {
                result[level] = [node.val]
            } else {
                result[level].append(node.val)
            }
            dfs(node.left, level + 1)
            dfs(node.right, level + 1)
        }
        
        dfs(root, level)
        return result
    }
}

// 7. Clone Graph
class GraphNode {
    var val: Int
    var neighbors: [GraphNode?]
    
    init() {
        self.val = 0
        self.neighbors = []
    }
    
    init(_ val: Int) {
        self.val = val
        self.neighbors = []
    }
    
    init(_ val: Int, _ neighbors: [GraphNode]) {
        self.val = 0
        self.neighbors = neighbors
    }
}

// Maintain a processed map
// add node: clonedNode in map
// for each neighbor in node, add neighbor in clonedNode with same dfs applied to them
class Solution37 {
    func cloneGraph(_ node: GraphNode?) -> GraphNode? {
        guard let node = node else { return node }
        var processed: [GraphNode: GraphNode] = [:]
        
        func dfs(_ node: GraphNode?) -> GraphNode? {
            guard let node = node else { return node }
            if let processedNode = processed[node] {
                return processedNode
            } else {
                let clonedNode = GraphNode(node.val)
                processed[node] = clonedNode
                clonedNode.neighbors = node.neighbors.map { dfs($0) }
            }
        }
        return dfs(node)
    }
}

//8. Evaluate Reverse Polish Notation
class Solution38 {
    func evalRPN(_ tokens: [String]) -> Int {
        // typealias opDef = ((Int, Int) -> Int)
        guard !tokens.isEmpty else { return 0 }
        var stack: [Int] = []
        // var operators: [String: opDef] =  [
        //     "+": +,
        //     "-" : -,
        //     "*": *,
        //     "/": /
        // ]
        
        for token in tokens {
            if let digit = Int(token) {
                stack.append(digit)
            } else {
                var op2 = stack.removeLast()
                var op1 = stack.removeLast()
                if token == "+" {
                    stack.append(op1 + op2)
                }
                if token == "-" {
                    stack.append(op1 - op2)
                }
                if token == "*" {
                    stack.append(op1 * op2)
                }
                if token == "/" {
                    stack.append(op1 / op2)
                }
            }
        }

        return stack[0]
    }
}

//------------- Week4----------------- //
//1. Course Schedule
class Solution41 {
    func canFinish(_ numCourses: Int, _ prerequisites: [[Int]]) -> Bool {
        var num = numCourses
        if prerequisites.isEmpty { return true }
        var graph: [[Int]] = Array(repeating: [], count: num)
        for preReq in prerequisites {
            graph[preReq[0]].append(preReq[1])
        }
        var visiting: [Bool] = Array(repeating: false, count: num)
        var visited: [Bool] = Array(repeating: false, count: num)
        
        func isCycle(at index: Int) -> Bool {

            if visiting[index] {
                return true
            }

            if visited[index] {
                return false
            }

            visiting[index] = true
            for neighbor in graph[index] {
                if isCycle(at: neighbor) == true { return true }
            }
            visiting[index] = false
            visited[index] = true
            return false
        }
        
        for i in 0..<num {
            if isCycle(at: i) { return false }
        }
        return true
    }
}

//2. Implement Trie
class TrieNode {
    var chidren: [Character: TrieNode] = [:]
    var isFinal: Bool = false
    func createOrReturn(_ ch: Character) -> TrieNode {
        if let child = chidren[ch] {
            return child
        } else {
            let newNode = TrieNode()
            chidren[ch] = newNode
            return newNode
        }
    }
}

class Trie {
    
    var root: TrieNode
    
    init() {
        self.root = TrieNode()
    }
    
    func insert(word: String) {
        var node = root
        for char in word {
            node = node.createOrReturn(char)
        }
        node.isFinal = true
    }
    
    func search(word: String) -> Bool {
        var node = root
        for char in word {
            guard let child = node.chidren[char] else { return false }
            node = child
        }
        return node.isFinal
    }
    
    func startsWith(prefix: String) -> Bool {
        var node = root
        for char in prefix {
            guard let child = node.chidren[char] else { return false }
            node = child
        }
        return true
    }
}

//3. Coin change
class Solution {
    func coinChange(_ coins: [Int], _ amount: Int) -> Int {
        var n = coins.count
        let infinite: Int = Int.max - 1
        var dp: [[Int]] = Array(repeating: Array(repeating: 0, count: amount+1), count: n+1)
        for i in 0...n {
            for j in 0...amount {
                if i == 0 && j == 0 { dp[i][j] = infinite }
                else if i == 0 { dp[i][j] = infinite }
                else if j == 0 { dp[i][j] = 0 }
                else if coins[i-1] > j {
                    dp[i][j] = dp[i-1][j]
                } else {
                    dp[i][j] = min(1 + dp[i][j-coins[i-1]], dp[i-1][j])
                }
            }
        }
        print(dp)
        return dp[n][amount] != infinite ? dp[n][amount] : -1
    }
}

//4. Product of Array except self
// use 1 pointer but handle changes from both side, i and n-1-i
// use prefix and postfix of current
class Solution44 {
    func productExceptSelf(_ nums: [Int]) -> [Int] {
        guard !nums.isEmpty else { return [] }
        var n = nums.count
        var solution: [Int] = []
        var prefix = 1
        var postfix = 1
        for i in 0..<n {
            solution[i] *= prefix
            prefix *= nums[i]
            solution[n-i-1] *= postfix
            postfix *= nums[n-i-1]
        }
        
        return solution
    }
}

// 5.Min stack
// Use 2 stacks, push value in normal stack, but only push in minStack if its <= top value
// minStack's top will always be the min value
// while removing, remove from both places
// Make sure to add repeatative element in minstack as well ("<=", and not just "<"), i.e 1,2,4,4,6,9
class MinStack {

    var stack: [Int]
    var minStack: [Int]

    init() {
        stack = []
        minStack = []
    }
    
    func push(_ val: Int) {
        if minStack.isEmpty || val <= minStack.last! {
            minStack.append(val)
        }
        stack.append(val)
    }
    
    func pop() {
        if stack.last == minStack.last {
            minStack.removeLast()
        }
        stack.removeLast()
    }
    
    func top() -> Int {
        stack.last ?? -1
    }
    
    func getMin() -> Int {
        minStack.last ?? -1
    }
}

//6. Valid BST
class Solution46 {
    // Wrong approach, we cant just check left and right value, it has to be a range because all left should be less and all right should be more
    // failing testcase: [5,4,6,null,null,3,7]
    func isValidBSTWrong(_ root: TreeNode?) -> Bool {
        guard let root = root else { return true }
        var isLeftValid = true
        var isRightValid = true
        if let left = root.left {
            isLeftValid = left.val < root.val && isValidBSTWrong(left)
        }
        if let right = root.right {
            isRightValid = right.val > root.val && isValidBSTWrong(right)
        }
        return isLeftValid && isRightValid
    }
    
    func isValidBSTRight(_ root: TreeNode?) -> Bool {
        guard let root = root else { return true }
        
        func validate(_ root: TreeNode?, _ low: Int, _ high: Int) -> Bool {
            guard let root = root else { return true }
            guard root.val > low && root.val < high else { return false }
            return validate(root.left, low, root.val)
            && validate(root.right, root.val, high)
        }
        
        return validate(root, Int.min, Int.max)
    }
}

// 7. Number of Islands
class Solution47 {
    func numIslands(_ grid: [[Character]]) -> Int {
        guard !grid.isEmpty else { return 0 }
        var grid = grid
        var rows = grid.count
        var cols = grid[0].count
        var islands = 0
        var neighbors = [[0,1], [0,-1], [1,0], [-1,0]]
        
        func dfs(_ row: Int, _ col: Int) {
            grid[row][col] = Character("0")
            for neighbor in neighbors {
                var newRow = row + neighbor[0]
                var newCol = col + neighbor[1]
                if newRow >= 0 && newRow < rows && newCol >= 0 && newCol < cols && grid[newRow][newCol] == Character("1") {
                    dfs(newRow, newCol)
                }
            }
        }
        
        for i in 0..<rows {
            for j in 0..<cols {
                if grid[i][j] == Character("1") {
                    islands += 1
                    dfs(i, j)
                }
            }
        }
        
        return islands
    }
}

//8. Rotting Orange
// Use BFS, because we need to trigger the rotting process for all 2s simultaneously
// first iterate over the grid and add all 2s in queue
// keep marker (-1, -1) in the queue to differentiate between various levels
class Solution48 {

    func orangesRotting(_ grid: [[Int]]) -> Int {
        var grid = grid
        var rows = grid.count
        var cols = grid[0].count
        var minutes = 0
        var neighbors = [[0,1], [0,-1], [1,0], [-1,0]]
        var queue = [[Int]]()
        var freshOranges = 0
        
        for i in 0..<rows {
            for j in 0..<cols {
                if grid[i][j] == 2 {
                    queue.append([i,j])
                } else if grid[i][j] == 1 {
                    freshOranges += 1
                }
            }
        }
        
        // Mark the round / level, _i.e_ the ticker of timestamp
        queue.append([-1, -1])
        minutes = -1

        while !queue.isEmpty {
            var first = queue.removeFirst()
            var row = first[0]
            var col = first[1]
            if row == -1 {
                //you hit the marker, time to change minutes
                minutes += 1
                if !queue.isEmpty { queue.append([-1, -1]) }

            } else {
                // this is a rotten orage, contaminate the neighbors
                for neighbor in neighbors {
                    var newRow = row + neighbor[0]
                    var newCol = col + neighbor[1]
                    if newRow >= 0 && newRow < rows && newCol >= 0 && newCol < cols && grid[newRow][newCol] == 1 {
                        grid[newRow][newCol] = 2
                        freshOranges -= 1
                        queue.append([newRow, newCol])
                    }
                }
            }
        }
        return freshOranges == 0 ? minutes : -1
    }
}

//------------- Week6----------------- //
//1. Word break
// use 1D array dp, for each i in 1...str.count, check if theres any prefix j in range 0...i
// such that dp[j] is true (meaning str(0..j) is valid, and str(j..<i) is in set)
// O(n^3) time, O(n) space
class Solution61 {
    func wordBreak(_ s: String, _ wordDict: [String]) -> Bool {
        guard !s.isEmpty, !wordDict.isEmpty else { return false }
        var s = Array(s)
        var set = Set(wordDict)
        var dp: [Bool] = Array(repeating: false, count: s.count + 1)
        dp[0] = true
        for i in 1...s.count {
            for j in 0...i {
                if dp[j] == true &&  set.contains(String(s[j..<i])) {
                    dp[i] = true
                    break
                }
            }
        }
        return dp[s.count]
    }
}

//2. Partition Equal sum subset
class Solution62 {
    func canPartition(_ nums: [Int]) -> Bool {
        guard !nums.isEmpty else { return false }
        var sum = nums.reduce(0, +)
        if !sum.isMultiple(of: 2) { return false }
        var target = sum/2
        var n = nums.count
        //find subsets which are of sum target
        var dp: [[Bool]] = Array(repeating: Array(repeating: false, count: target+1), count: n + 1)

        for i in 0...n {
            for j in 0...target {
                if i == 0 && j == 0 { dp[i][j] = true } //take empty subset
                else if j == 0 { dp[i][j] =  true } //take empty subset
                else if i == 0 { dp[i][j] = false }
                else if nums[i-1] > j {
                    dp[i][j] = dp[i-1][j]
                } else {
                    dp[i][j] = dp[i-1][j] || dp[i-1][j-nums[i-1]]
                }
            }
        }
        return dp[n][target]
    }
}

//3. String to Integer(atoi)
class Solution63 {
    func myAtoi(_ s: String) -> Int {
        var s = s
        guard !s.isEmpty else { return 0 }
        var sign: Int = 1
        var num: Int = 0
        var index = 0
        var n = s.count

        var INT_MAX: Int = Int(truncating: NSDecimalNumber(decimal: pow(Decimal(2), 31))) - 1
        var INT_MIN: Int = -1 * Int(truncating: NSDecimalNumber(decimal: pow(Decimal(2), 31)))

        while index < n && s[index] == " " {
           index += 1
        }
        if index < n && s[index] == "-" || s[index] == "+"  {
            sign = s[index] == "-" ? -1 : 1
            index += 1
        }
        while index < n && isDigit(s[index]) != nil {
            var digit = isDigit(s[index])!
            print("num", num)
            if num > INT_MAX / 10 || (num == INT_MAX / 10 && digit > INT_MAX % 10) {
                // Overflow
                return sign == -1 ? INT_MIN : INT_MAX
            }
            num = num * 10 + digit
            index += 1
        }
        return sign * num
    }
}

func isDigit(_ c: Character) -> Int? {
    return Int(String(c))
}

//4. Spiral matrix
class Solution64 {
    func spiralOrder(_ matrix: [[Int]]) -> [Int] {
        guard !matrix.isEmpty else { return [] }
        var results: [Int] = []
        var rows = matrix.count
        var cols = matrix[0].count

        var right: Int = cols - 1
        var left: Int = 0
        var top: Int = 0
        var bottom: Int = rows - 1
       
        while results.count < rows * cols {
            for col in stride(from: left, through: right, by: 1)  {
                results.append(matrix[top][col])
            }

            for row in stride(from: top+1, through: bottom, by: 1)  {
                results.append(matrix[row][right])
            }

            if top != bottom { // to handle the case of only 1 row
                for col in stride(from: right-1, through: left, by: -1) {
                    results.append(matrix[bottom][col])
                }
            }

            if left != right { // to handle the case of only 1 column
                for row in stride(from: bottom-1, through: top+1, by: -1) {
                    results.append(matrix[row][left])
                }
            }

            left += 1
            right -= 1
            top += 1
            bottom -= 1
        }
        return results
    }
}

//5. Return all possible subsets
class Solution65 {
    func subsets(_ nums: [Int]) -> [[Int]] {
        // recursion using I/P method
        guard !nums.isEmpty else { return [[]] }
        var results: [[Int]] = []
        var ip: [Int] = nums
        var op: [Int] = []

        func subsetRecrusive(ip: [Int], op: [Int]) {
            var ip = ip
            var op = op
            if ip.isEmpty {
                results.append(op)
                return
            } else {
                var elem = ip.removeFirst()
                subsetRecrusive(ip: ip, op: op)
                
                op.append(elem)
                subsetRecrusive(ip: ip, op: op)
            }
        }

        subsetRecrusive(ip: ip, op: op)
        return results
    }
}

// 6. Binary Tree right side view
class Solution66 {
    func rightSideView(_ root: TreeNode?) -> [Int] {
        
        var levels: [[Int]] = []
        func levelOrderTraversal(_ node: TreeNode?, _ level: Int) {
            guard let node = node else { return }
            if levels.count == level {
                levels.append([node.val])
            } else {
                levels[level].append(node.val)
            }
            levelOrderTraversal(node.left, level + 1)
            levelOrderTraversal(node.right, level + 1)
        }

        levelOrderTraversal(root, 0)
        var rightView = levels.compactMap { $0.last }
        return rightView
    }
}

//7. Longest Palindrome Substring
class Solution67 {
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

//8. Unique Paths
class Solution68 {

    // DFS Solution: Time out
    
    // func uniquePaths(_ m: Int, _ n: Int) -> Int {
    //     var rows = m
    //     var cols = n
    //     var result = 0
    //     var neighbors = [[1,0], [0,1]]

    //     func dfs(_ row: Int, _ col: Int) {
    //         if row == rows - 1 && col == cols - 1 {
    //             result += 1
    //             return
    //         }
    //         for neighbor in neighbors {
    //             var newRow = row + neighbor[0]
    //             var newCol = col + neighbor[1]
    //             if newRow < rows && newCol < cols {
    //                 dfs(newRow, newCol)
    //             }
    //         }
    //     }

    //     dfs(0, 0)
    //     return result
    // }

    // DP solution
    
    func uniquePaths(_ m: Int, _ n: Int) -> Int {
        var dp: [[Int]] = Array(repeating: Array(repeating: 1, count: n), count: m)
        for i in 1..<m {
            for j in 1..<n {
                dp[i][j] = dp[i-1][j] + dp[i][j-1]
            }
        }
        return dp[m-1][n-1]
    }
}

//9. Construct Binary Tree from Preorder and Inorder Traversal
// recrusive func that takes left and right integer for array, and constructs a tree out of it
class Solution69 {
    func binaryTree(_ preorder: [Int], _ inorder: [Int]) -> TreeNode? {
      
        var rootIndex = 0
        var inorderMap: [Int: Int] = [:]
        for (index, value) in inorder.enumerated() {
            inorderMap[value] = index
        }
        func arrToTree(_ left: Int, _ right: Int) -> TreeNode? {
            if left > right { return nil }
            var root = preorder[rootIndex]
            var rootNode = TreeNode(root)
            rootIndex += 1
            rootNode.left = arrToTree(left, inorderMap[root]! - 1)
            rootNode.right = arrToTree(inorderMap[root]! + 1, right)
            return rootNode
        }
        
        return arrToTree(0, inorder.count - 1)
    }
}

//------------- Week7----------------- //
//1. Container with water
// so always find max area by using min height and diff between left and right
// whichever side height is less, increment that by 1
class Solution71 {
    func containerWithMostWater(_ heights: [Int]) -> Int {
        guard !heights.isEmpty else { return 0 }
        var maxArea = 0
        var left = 0
        var right = heights.count - 1
        while left <= right {
            maxArea = max(maxArea, min(heights[left], heights[right]) * (right - left))
            if heights[left] < heights[right] {
                left += 1
            } else {
                right -= 1
            }
        }
        
        return maxArea
    }
}

// 2. Letter combination of Phone number
class Solution72 {
    func letterCombinations(_ digits: String) -> [String] {
        guard !digits.isEmpty else { return [] }
        var map: [Character: String] = [
            "2": "abc",
            "3": "def",
            "4": "ghi",
            "5": "jkl",
            "6": "mno",
            "7": "pqrs",
            "8": "tuv",
            "9": "wxyz",
        ]
        var result: [String] = []
        
        func backTrack(_ index: Int, _ combo: [String]) {
            var combo = combo
            if combo.count == digits.count {
                result.append(combo.joined())
                return
            }
            var digit = digits[index]
            guard var characters = map[digit] else { return }
            for ch in characters {
                combo.append(String(ch))
                backTrack(index + 1, combo)
                combo.removeLast()
            }
            
        }

        backTrack(0, [])
        return result
    }
}

//3. Word Search:
// Mix of Backtracking and DFS
class Solution73 {
    func exist(_ board: [[Character]], _ word: String) -> Bool {
        guard !board.isEmpty else { return false }
        guard !word.isEmpty else { return true }
        var board = board
        var rows = board.count
        var cols = board[0].count
        var neighbors: [[Int]] = [[0,1], [0,-1], [1,0], [-1,0]]


        func backTrack(_ row: Int, _ col: Int, _ suffix: String) -> Bool {
            if suffix.count == 0 {
                return true
            }

            board[row][col] = "#"
            var ret = false

            for neighbor in neighbors {
                var newRow = row + neighbor[0]
                var newCol = col + neighbor[1]
                if newRow >= 0 && newRow < rows && newCol >= 0 && newCol < cols && board[newRow][newCol] == suffix[0] {
                    var index = suffix.index(suffix.startIndex, offsetBy: 1)
                    var newSuffix = String(suffix[index...])
                    ret = backTrack(newRow, newCol, newSuffix)
                    if ret { return true }
                }
            }
            
            board[row][col] = suffix[0]
            return ret
        }

        for i in 0..<rows {
            for j in 0..<cols {
                if backTrack(i, j, word) { return true }
            }
        }
        return false
    }
}

//4. Find All Anagrams
class Solution74 {
    func findAnagrams(_ s: String, _ p: String) -> [Int] {
        guard p.count <= s.count else { return [] }
        var result: [Int] = []
        var i = 0
        var j = 0
        var n = s.count
        var str = ""
        while j < n {
            str += String(s[j])
            if j - i + 1 < p.count {
                j += 1
            } else if j - i + 1 == p.count {
                if isAnagram(str, p) {
                    result.append(i)
                }
                str.removeFirst()
                i += 1
                j += 1
            }
        }
        return result
    }

    func isAnagram(_ s: String, _ t: String) -> Bool {
        guard s.count == t.count else { return false }
        var mappedItems = s.map { ($0, 1) }
        var map: [Character: Int] = Dictionary(mappedItems, uniquingKeysWith: +)
        var t = Array(t)
                      
        for i in t {
            guard var val = map[i] else { return false }
            if val == 1 {
                map[i] = nil
            } else {
                map[i] = val - 1
            }
        }
        
        return map.isEmpty
    }
}

//5. Minimum Height Tree (Topological Sort)


//6. Task Scheduler
// Use greedy approach, min total time = min time(tasks) + min idle time
// we already know tasks take tasks.count time, and is constant
// so we need min idle time, lets use greedy approach
// sort tasks by most frequency
// maximum idle time = Fmax - 1 * n [(max frequency - 1) * cooling period]
// now at each iteration, lets try to reduce the idle time by filling in the empty box inbetween most freq elements
// idleTime -= min(Fmax, Fi) <- why not Fi ?
// well if by sorting there are two elements with max frequence then this approach fails so to handle that.
// finally return tasks.count + max(idleTime,0)
class Solution76 {
    // Use Greedy Approach
    func leastInterval(_ tasks: [Character], _ n: Int) -> Int {
        guard !tasks.isEmpty else { return 0 }
        var idleTime = 0
        
        //sort the tasks by frequency
        var frequency: [Int] = Array(repeating: 0, count: 26)
        for task in tasks {
            var index = task.asciiValue! - Character("A").asciiValue!
            frequency[Int(index)] += 1
        }
        
        frequency = frequency.sorted(by: >).filter { $0 != 0 }
        
        //max frequency
        var maxFreq = frequency.removeFirst()

        //max idle time
        var maxFreeSlots =  (maxFreq - 1)
        idleTime = maxFreeSlots * n

        //reduce idle time by filling in empty slots
        while !frequency.isEmpty && idleTime > 0 {
            idleTime -= min(maxFreeSlots, frequency.removeFirst())
        }
        
        return tasks.count + max(0, idleTime)
    }
}

//7. LRU Cache
// Idea is to create Ordered dictionary using Doubly linked list
// normal dictionary puts and gets element in O(1)
// and DLinkedList can delete an element in O(1)

class DLinkedListNode {
    var key: Int  = 0
    var value: Int = 0
    var prev: DLinkedListNode? = nil
    var next: DLinkedListNode? = nil
}

class LRUCache {
    var cache: [Int: DLinkedListNode] = [:]
    var size: Int
    var capacity: Int
    var head: DLinkedListNode
    var tail: DLinkedListNode

    init(_ capacity: Int) {
        self.capacity = capacity
        self.size = 0
        self.head = DLinkedListNode()
        self.tail = DLinkedListNode()
        head.next = tail
        tail.prev = head
    }
    
    func description() {
        var curr: DLinkedListNode? = head
        while curr != nil {
            print("->", curr?.value)
            curr = curr?.next
        }
    }

    // Custom Functions
    func addNode(_ node: DLinkedListNode?) {
        // Always add the new node right after the head
        node?.prev = head
        node?.next = head.next

        head.next?.prev = node
        head.next = node
    }

    func removeNode(_ node: DLinkedListNode?) {
        var prev = node?.prev
        var new = node?.next

        prev?.next = new
        new?.prev = prev
    }

    func moveToHead(_ node: DLinkedListNode?) {
        self.removeNode(node)
        self.addNode(node)
    }

    func popTail() -> DLinkedListNode? {
        var lastNode = tail.prev
        self.removeNode(lastNode)
        return lastNode
    }

    func get(_ key: Int) -> Int {
        guard let node = cache[key] else { return -1 }
        self.moveToHead(node)
        return node.value
    }
    
    func put(_ key: Int, _ value: Int) {
        if let node = cache[key] {
            cache[key]?.value = value
            self.moveToHead(node)
        } else {
            let newNode = DLinkedListNode()
            newNode.key = key
            newNode.value = value
            self.addNode(newNode)
            cache[key] = newNode
            size += 1

            if size > capacity {
                //pop the tail
                var tailNode = self.popTail()
                if tailNode != nil {
                    cache[tailNode!.key] = nil
                    size -= 1
                }
            }
        }
    }
}

// ----------Week8-----------//
//1. Kth smallest element in BST
// Find inorder traversal of BST, it will return sorted array
// return kth element from start
class Solution81 {
    func kthElement(_ root: TreeNode?, _ k: Int) -> Int {
        guard let root = root else { return -1 }
        var result: [Int] = []
        func inorder(_ node: TreeNode?) {
            guard let node = node else { return }
            inorder(node.left)
            result.append(node.val)
            inorder(node.right)
        }
        
        inorder(root)
        return result[k-1]
    }
}

//2.
                      
