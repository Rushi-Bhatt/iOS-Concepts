import Foundation

extension String {
  subscript(offset: Int) -> Character {
    self[index(startIndex, offsetBy: offset)]
  }
}


/*
Given two strings text1 and text2, return the length of their longest common substring. If there is no common substring, return 0.

A substring of a string is a new string generated from the original string with some characters (can be none) deleted from begenning or end without changing the relative order of the remaining characters. Characters need to be continuous

 Input: text1 = "abcde", text2 = "cde"
 Output: 1
 Explanation: The longest common substring is "a" and its length is 1.

 Same as LCS for the first case where last character matches
 but if the last character doesnt match, then we want to set the value to 0
 as the substring cant have discontignuous characters
*/

/* LCSubstring using Dynamic programming: Tabulation: To avoid overlapping subproblems: */
let s1 = "abcde"
let s2 = "cde"
var dp: [[Int]] = Array(repeating: Array(repeating: 0, count: s2.count+1), count: s1.count+1)

func LCSubstringUsingTabulation(s1: String, s2: String, l1: Int, l2: Int) ->  Int {
  for i in 0...l1 {
    for j in 0...l2 {
      if i == 0 || j == 0 {
        dp[i][j] = 0
      } else if s1[i-1] == s2[j-1] {
        dp[i][j] = 1 + dp[i-1][j-1]
      } else {
        dp[i][j] = 0 // because as soon as we find discoutinuity, we need to make the size 0
      }
    }
  }
  return dp[l1][l2]
}
let start1 = CFAbsoluteTimeGetCurrent()
LCSubstringUsingTabulation(s1: s1, s2: s2, l1: s1.count, l2: s2.count)
let end1 = CFAbsoluteTimeGetCurrent()
print("Tabulation time \(end1 - start1)")
