// Combination Sum, Combination Sum II, and Combination Sum III.//


// Combine Sum
class Solution {
    func combinationSum(_ candidates: [Int], _ target: Int) -> [[Int]] {
        // Backtracking

        guard !candidates.isEmpty else { return [] }
        let n = candidates.count
        var results: [[Int]] = []

        func backTrack(_ remain: Int, _ combo: [Int], _ start: Int) {
            var combo = combo
            if remain == 0 {
                // we found a combination
                results.append(combo)
                return
            } else if remain < 0 {
                return
            } else {
                for i in start..<n {
                    combo.append(candidates[i])
                    backTrack(remain - candidates[i], combo, i)
                    combo.removeLast()
                }
            }
        }
        backTrack(target, [], 0)
        return results
    }

}

// Combine Sum II
class Solution {
    func combinationSum2(_ candidates: [Int], _ target: Int) -> [[Int]] {
        var candidates = candidates.sorted() // First sort it, so we can check and skip on repetative values
        
        var results: [[Int]] = []
        let n = candidates.count
        
        func backTrack(_ remain: Int, _ combo: [Int], _ start: Int) {
            var combo = combo
            if remain == 0 {
                results.append(combo)
                return
            } else if remain < 0 {
                return
            } else {
                for i in start..<n {
                    
                    if i > start && candidates[i] == candidates[start] {
                        continue
                    } // extra step, to remove duplicates
                    
                    combo.append(candidates[i])
                    backTrack(remain - candidates[i], combo, i+1)
                    combo.removeLast()
                }
            }
        }
        
        backTrack(target, [], 0)
        return Array(Set(results)) // extra step to remove [[3,5], [3,5]] type duplicate combinations
    }
}

// Combination Sum III
class Solution {
    func combinationSum3(_ k: Int, _ n: Int) -> [[Int]] {

        var results = [[Int]]()
        var nums: [Int] = (1...9).map { $0 }
        print(nums)
        func backTrack(_ remain: Int, _ combo: [Int], _ start: Int) {
            var combo = combo
            if remain == 0 && combo.count == k {
                results.append(combo)
                return
            } else if remain < 0 || combo.count == k {
                return
            } else {
                for i in start..<nums.count {
                    combo.append(nums[i])
                    backTrack(remain - nums[i], combo, i+1)
                    combo.removeLast()
                }
            }
        }
        backTrack(n, [], 0)
        return results
    }
}

// Letter combination of Phone number
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

extension String {
    subscript(offset: Int) -> Character {
        return self[index(startIndex, offsetBy: offset)]
    }
}

//4.Combination Sum IV: cant be solved using backtracking, use DP instead.


