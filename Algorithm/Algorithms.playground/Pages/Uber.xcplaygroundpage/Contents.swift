// 1. Longest Common Prefix
class Solution {
    func longestCommonPrefix(_ strs: [String]) -> String {
        guard !strs.isEmpty else { return "" }

        // Find the shortest string first
        var shortest: String?  = nil
        var len = Int.max
        for str in strs {
            if str.count < len {
                shortest = str
                len = str.count
            }
        }
        guard var s = shortest else { return "" }
        for str in strs {
            while !s.isEmpty && !str.hasPrefix(s) {
                s.removeLast()
            }
        }
        return s
    }
}

// 2. Remove Element
class Solution {
    func removeElement(_ nums: inout [Int], _ val: Int) -> Int {
        guard !nums.isEmpty else { return 0 }
        var count = 0
        var i = 0
        for j in 0..<nums.count {
            if nums[j] != val {
                nums[i] = nums[j]
                i += 1
            }
        }
        return i
    }
}

// 3. Leftmost Column with a at Least a One
/**
 * // This is the BinaryMatrix's API interface.
 * // You should not implement it, or speculate about its implementation
 * public class BinaryMatrix {
 *     public func get(_ row: Int, _ col: Int) -> Int {}
 *     public func dimensions() -> [Int] {}
 * };
 */

class Solution {
    func leftMostColumnWithOne(_ binaryMatrix: BinaryMatrix) -> Int {
        var size = binaryMatrix.dimensions()
        var rows = size[0]
        var cols = size[1]
        if rows == 0 || cols == 0  { return -1 }
        var currRow = 0
        var currCol = cols - 1
        // start with top right corner and go down left
        while currRow < rows && currCol >= 0 {
            if binaryMatrix.get(currRow, currCol) == 0 {
                currRow += 1
            } else {
                currCol -= 1
            }
        }

        if currCol == cols - 1 { return -1 } //never found 1, just kept going down

        return currCol + 1
    }
}
