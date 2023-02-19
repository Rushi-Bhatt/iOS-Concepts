import Foundation
// Assign cookies:
class Solution1 {
    func findContentChildren(_ g: [Int], _ s: [Int]) -> Int {
        var children = g.sorted()
        var cookies = s.sorted()
        
        var childIndex = 0
        var cookieIndex = 0
        var count = 0
        while childIndex < children.count && cookieIndex < cookies.count {
            if children[childIndex] <= cookies[cookieIndex] {
                count += 1
                childIndex += 1
            }
            cookieIndex += 1
        }
        return count
    }
}

//Max area of an island
class Solution2 {
    func maxAreaOfIsland(_ grid: [[Int]]) -> Int {
        guard !grid.isEmpty else { return 0 }
        var rows = grid.count
        var cols = grid[0].count
        var visited: [[Bool]] =  Array(repeating: Array(repeating: false, count: cols), count: rows)
        var result = 0
        var neighbors: [[Int]] = [[0,1], [0,-1], [1,0], [-1,0]]
        
        func dfs(_ row: Int, _ col: Int) -> Int {
            var ans = 1
            if visited[row][col] == true {
                return 0
            }
            
            visited[row][col] = true
            
            for neighbor in neighbors {
                var newRow = row + neighbor[0]
                var newCol = col + neighbor[1]
                if newRow >= 0 && newRow < rows && newCol >= 0 && newCol < cols && grid[newRow][newCol] == 1 {
                    ans += dfs(newRow, newCol)
                }
            }
            
            return ans
        }
        
        for i in 0..<rows {
            for j in 0..<cols {
                if grid[i][j] == 1 {
                    result = max(dfs(i, j), result)
                }
            }
        }
        
        return result
    }
}

// Car Pooling
class Solution3 {
    func carPooling(_ trips: [[Int]], _ capacity: Int) -> Bool {
        var timestamp: [[Int]] = []
        for trip in trips {
            timestamp.append([trip[1], trip[0]])
            timestamp.append([trip[2], -trip[0]])
        }
        
        // Sort by Time First, if time is same, then sort by capacity change, i.e first let the passanger get down and then enters the new passanger
        timestamp.sort { t1, t2 in
            if t1[0] == t2[0] {
                return t1[1] < t2[1]
            }
            return t1[0] < t2[0]
        }
        
        var usedCapacity = 0
        for eachTimeStamp in timestamp {
            let time = eachTimeStamp[0]
            let capacityChange = eachTimeStamp[1]
            usedCapacity += capacityChange
            if usedCapacity > capacity {
                return false
            }
        }
        return true
    }
}

// Palindrome Pairs
class Solution4 {
    func palindromePairs(_ words: [String]) -> [[Int]] {
        
        var result: [[Int]] = []

        // all prefix where suffix is palindrome
        func allValidPrefix(word: String) -> [String] {
            var result: [String] = []
            var word = Array(word)
            for i in 0..<word.count {
                let prefix = Array(word.prefix(upTo: i))
                let suffix = Array(word.suffix(from: i))
                if suffix == suffix.reversed() {
                    result.append(String(prefix))
                }
            }
            return result
        }

        // all suffix where prefix is palindrome
        func allValidSuffix(word: String) -> [String] {
            var result: [String] = []
            var word = Array(word)
            for i in (0..<word.count).reversed() {
                let suffix = Array(word.suffix(from: i))
                let prefix = Array(word.prefix(upTo: i))
                if prefix == prefix.reversed() {
                    result.append(String(suffix))
                }
            }
            return result
        }

        var wordMap: [String: Int] = [:]

        for (i, word) in words.enumerated() {
            wordMap[word] = i
        }
        
        for (index, word) in words.enumerated() {
 
            let reversedWord = String(word.reversed())

            //case 1: where word and reversed word are of palidrome and not the same. This is word 1
            if let reverseWordIndex = wordMap[reversedWord] {
                if reverseWordIndex != index {
                    result.append([index, reverseWordIndex])
                }
            }

            //case 2: this is word 1
            for prefix in allValidPrefix(word: word) {
                let reversePrefix = String(prefix.reversed())
                if let reversePrefixIndex = wordMap[reversePrefix] {
                    if reversePrefixIndex != index {
                        result.append([index, reversePrefixIndex])
                    }
                }
            }

            //case 3: this is word 2
            for suffix in allValidSuffix(word: word) {
                let reverseSuffix = String(suffix.reversed())
                if let reverseSuffixIndex = wordMap[reverseSuffix] {
                    if reverseSuffixIndex != index {
                        result.append([reverseSuffixIndex, index])
                    }
                }
            }
        }

        return Array(Set(result))
    }
}

//Reformat Date
class Solution5 {
    func reformatDate(_ date: String) -> String {
        var dateComponents: [String] = date.components(separatedBy: " ")
        var resultComponents: [String] = []
        var monthMap: [String: String] = [:]
        for (i, month) in ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"].enumerated() {
            monthMap[month] = String(format: "%02d", i+1)
        }
        guard dateComponents.count == 3 else { return "" }
        resultComponents.append(dateComponents[2])
        guard let monthDigit = monthMap[dateComponents[1]] else { return "" }
        resultComponents.append(String(monthDigit))
        dateComponents[0].removeLast(2)
        let date = Int(dateComponents[0])!
        let dateString = String(format: "%02d", date)
        resultComponents.append(dateString)
        return resultComponents.joined(separator: "-")
    }
}

// Number of different integers
class Solution6 {
    func numDifferentIntegers(_ word: String) -> Int {
        guard !word.isEmpty else { return 0 }
        var word = Array(word)
        var tempWord: String = ""
        var result = Set<String>()
        for each in word {
            if let _ = Int(String(each)) {
                tempWord.append(each)
            } else {
                if !tempWord.isEmpty {
                    let val = tempWord.replacingOccurrences(of: "^0+", with: "", options: .regularExpression)
                    result.insert(val)
                    tempWord = ""
                }
            }
        }

        if !tempWord.isEmpty {
            let val = tempWord.replacingOccurrences(of: "^0+", with: "", options: .regularExpression)
            result.insert(val)
        }
        print(result)
        return result.count
    }
}

// Maximum difference between increasing element
class Solution7 {
    func maximumDifference(_ nums: [Int]) -> Int {
        guard nums.count >= 2 else { return -1 }
        var result = -1
        var minimun = nums[0]
        var i = 1
        while i < nums.count {
            result = max(result, nums[i] - minimun)
            minimun = min(minimun, nums[i])
            i += 1
        }
        return result == 0 ? -1 : result
    }
}

// Minimum Absolute Diff:
class Solution8 {
    func minimumAbsDifference(_ arr: [Int]) -> [[Int]] {
        guard !arr.isEmpty else { return [] }
        var arr = arr.sorted()
        var minDiff = Int.max
        var i = 1
        var result: [[Int]] = []
        while i < arr.count {
            if abs(arr[i] - arr[i-1]) < minDiff {
                result.removeAll()
                minDiff = abs(arr[i] - arr[i-1])
                result.append([arr[i-1], arr[i]])
            } else if abs(arr[i] - arr[i-1]) == minDiff {
                result.append([arr[i-1], arr[i]])
            }
            
            i += 1
        }

        return result
    }
}

// Making file names unique
class Solution9 {
    func getFolderNames(_ names: [String]) -> [String] {
        guard !names.isEmpty else { return names }
        var map: [String: Int] = [:]
        var result: [String] = []
        for name in names {
            if var k = map[name] {
                while map[name + "(\(k+1))"] != nil {
                    k += 1
                }
                map[name] = k + 1
                map[name + "(\(k+1))"] = 0
                result.append(name + "(\(k+1))")
            } else {
                map[name] = 0
                result.append(name)
            }
        }

        return result
    }
}

//Maximum area of piece of cake
class Solution10 {
    func maxArea(_ h: Int, _ w: Int, _ horizontalCuts: [Int], _ verticalCuts: [Int]) -> Int {
        guard !horizontalCuts.isEmpty && !verticalCuts.isEmpty else { return h*w }
        var horizontalCuts = horizontalCuts.sorted()
        var verticalCuts = verticalCuts.sorted()
        horizontalCuts.insert(0, at: 0)
        horizontalCuts.append(h)

        verticalCuts.insert(0, at: 0)
        verticalCuts.append(w)

        var maxHeight = 0
        var maxWidth = 0
        for i in 1..<horizontalCuts.count {
            maxHeight = max(horizontalCuts[i] - horizontalCuts[i-1], maxHeight)
        }

        for j in 1..<verticalCuts.count {
            maxWidth = max(verticalCuts[j] - verticalCuts[j-1], maxWidth)
        }

        print(maxHeight, maxWidth)
        return (maxHeight * maxWidth) % Int(pow(10.0, 9.0) + 7)
    }
}

// kth factor of n
class Solution11 {
    func kthFactor(_ n: Int, _ k: Int) -> Int {
        var root = sqrt(Double(n))
        var factors = Set<Int>()
        for i in 1...Int(root) {
            if n % i == 0 {
                factors.insert(i)
                factors.insert(n/i)
            }
        }

        print(factors)
        let result = Array(factors).sorted()
        return k-1 < result.count ? result[k-1] : -1
    }
}

// find least number of unique integers
class Solution12 {
    func findLeastNumOfUniqueInts(_ arr: [Int], _ k: Int) -> Int {
        var mappedItems = arr.map { ($0, 1) }
        var map: [Int: Int] = Dictionary(mappedItems, uniquingKeysWith: +)
        var values = map.values.sorted()
        var removedElements = 0
        var index = 0
        guard k != 0 else { return values.count }
        for _ in (1...k) {
            values[index] -= 1
            if values[index] == 0 {
                index += 1
                removedElements += 1
            }
        }
        return values.count - removedElements

    }
}

// Number of pairs divisable by 60
// https://www.youtube.com/watch?v=toYgBIaUdfM
class Solution13 {
    func numPairsDivisibleBy60(_ time: [Int]) -> Int {
        guard !time.isEmpty else { return 0 }
        var remainder: [Int] = Array(repeating: 0, count: 60)
        for each in time {
            let eachR = each % 60
            remainder[eachR] += 1
        }

        var count = 0
        //for 0 and 30, special handling
        if remainder[0] >= 2 {
            count += remainder[0] * (remainder[0] - 1) / 2
        }

        if remainder[30] >= 2 {
            count += remainder[30] * (remainder[30] - 1) / 2
        }

        // for rest
        for i in 1...29 {
            count += remainder[i] * remainder[60 - i]
        }

        return count
    }
}

//check if valid IP address:
class Solution14 {
    func validIPAddress(_ queryIP: String) -> String {
        var v4Split = queryIP.split(separator: ".", maxSplits: 4, omittingEmptySubsequences: false)
        if v4Split.count == 4 {
            var result = true
            v4Split.forEach {
                result = result && isValidIPv4Component(String($0))
            }
            return result ? "IPv4" : "Neither"
        }

        var v6Split = queryIP.split(separator: ":", maxSplits: 8, omittingEmptySubsequences: false)
       
        if v6Split.count == 8 {
            var result = true
            v6Split.forEach {
                result = result && isValidIPv6Component(String($0))
            }
            return result ? "IPv6" : "Neither"
        }

        return "Neither"
    }

    func isValidIPv6Component(_ str: String) -> Bool {
        return (1...4).contains(str.count) && UInt(str, radix: 16) != nil
    }

    func isValidIPv4Component(_ str: String) -> Bool {
        guard let int = Int(str) else { return false }
        return (0...255).contains(int) && String(int).count == str.count
    }
}

// Minimum # of moves to make all element equal
class Solution15 {
    func minMoves(_ nums: [Int]) -> Int {
        guard !nums.isEmpty else { return 0 }
        var nums = nums.sorted()
        var count = 0
        for i in (1..<nums.count).reversed() {
            count += nums[i] - nums[0]
        }
        return count
    }
}

//String compression
class Solution16 {
    func compress(_ chars: inout [Character]) -> Int {
        var index = 0 // final arrays pointer i.e where to write
        var i = 0 // pointer for each new character
        while i < chars.count {
            var j = i // pointer to keep track of count
            while j < chars.count && chars[j] == chars[i] {
                j += 1
            }
            chars[index] = chars[i]
            index += 1
            if j - i > 1 {
                // need to append the count
                var count = String(j - i)
                for ch in count {
                    chars[index] = ch
                    index += 1
                }
            }
            i = j
        }

        return index
    }
}

