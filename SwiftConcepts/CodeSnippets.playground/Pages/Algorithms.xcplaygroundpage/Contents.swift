//Q1)Given a sorted array nums, remove the duplicates in-place such that each element appear only once and returns the new length.
//Given nums = [0,0,1,1,1,2,2,3,3,4],
//
//Your function should return length = 5, with the first five elements of nums being modified to 0, 1, 2, 3, and 4 respectively.
//It doesn't matter what values are set beyond the returned length.

func removeDuplicates(_ nums: inout [Int]) -> Int {
    if nums.count == 0 || nums.count == 1 {
        return nums.count
    }
    var stPoint: Int = 0
    var curPoint: Int = 1
    while curPoint < nums.count {
        if nums[curPoint] != nums[stPoint] {
            stPoint = stPoint + 1
            nums.swapAt(stPoint, curPoint)
        }
        curPoint = curPoint + 1
    }
    return stPoint + 1
}

var nums = [0,0,1,1,1,2,2,3,3,4]
var ans = removeDuplicates(&nums)
print(nums)

//Q2) /**********************************************************************************
//*
//* Given two strings s and t, determine if they are isomorphic.
//*
//* Two strings are isomorphic if the characters in s can be replaced to get t.
//*
//* All occurrences of a character must be replaced with another character while preserving
//* the order of characters. No two characters may map to the same character but a character
//*  may map to itself.
//*
//* For example,
//*
//*     Given "egg", "add", return true.
//*
//*     Given "foo", "bar", return false.
//*
//*     Given "paper", "title", return true.
//*
//*
//**********************************************************************************/

class Solution {
  func isIsomorphic(_ s: String, _ t: String) -> Bool {
    let s = Array(s)
    let t = Array(t)

    var dict: [Character: Character] = [:]

    for i in 0..<s.count {
      if let cache = dict[s[i]] {
         if cache != t[i] {
           return false
         }
       } else if dict.values.contains(t[i]) {
         return false
       } else {
         dict[s[i]] = t[i]
       }
     }

     return true
   }
 }

print(Solution().isIsomorphic("egg", "add"))
print(Solution().isIsomorphic("foo", "bar"))
print(Solution().isIsomorphic("papre", "title"))
print(Solution().isIsomorphic("ab", "aa"))
