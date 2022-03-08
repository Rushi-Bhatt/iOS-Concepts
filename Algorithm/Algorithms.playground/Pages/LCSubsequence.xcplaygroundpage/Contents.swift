import Foundation
/*
Given two strings text1 and text2, return the length of their longest common subsequence. If there is no common subsequence, return 0.

A subsequence of a string is a new string generated from the original string with some characters (can be none) deleted without changing the relative order of the remaining characters.

 Input: text1 = "abcde", text2 = "ace"
 Output: 3
 Explanation: The longest common subsequence is "ace" and its length is 3.

*/


extension String {
  subscript(offset: Int) -> Character {
    self[index(startIndex, offsetBy: offset)]
  }
}

/* LCS using Recursive approach */
func LCSUsingRecursion(s1: String, s2: String, l1: Int, l2: Int) ->  Int {
  if l1 == 0 || l2 == 0 { return 0 }
  
  if s1[l1-1] == s2[l2-1] {
    return 1 + LCSUsingRecursion(s1: s1, s2: s2, l1: l1-1, l2: l2-1)
  } else {
    return max(LCSUsingRecursion(s1: s1, s2: s2, l1: l1, l2: l2-1),
               LCSUsingRecursion(s1: s1, s2: s2, l1: l1-1, l2: l2))
  }
}

let start1 = CFAbsoluteTimeGetCurrent()
LCSUsingRecursion(s1: "abcde", s2: "ace", l1: 5, l2: 3)
let end1 = CFAbsoluteTimeGetCurrent()
print("Recursion time \(end1 - start1)")

/* LCS using Dynamic programming: memoization: To avoid overlapping subproblems: */
let s1 = "abcde"
let s2 = "aced"
var t: [[Int]] = Array(repeating: Array(repeating: 0, count: s2.count+1), count: s1.count+1)

func LCSUsingMemoization(s1: String, s2: String, l1: Int, l2: Int) ->  Int {
  if l1 == 0 || l2 == 0 {
    t[l1][l2] = 0
  }
  else if s1[l1-1] == s2[l2-1] {
    t[l1][l2] = 1 + LCSUsingRecursion(s1: s1, s2: s2, l1: l1-1, l2: l2-1)
  }
  else {
    t[l1][l2] = max(LCSUsingRecursion(s1: s1, s2: s2, l1: l1, l2: l2-1),
               LCSUsingRecursion(s1: s1, s2: s2, l1: l1-1, l2: l2))
  }
  return t[l1][l2]
}
let start2 = CFAbsoluteTimeGetCurrent()
LCSUsingMemoization(s1: s1, s2: s2, l1: s1.count, l2: s2.count)
let end2 = CFAbsoluteTimeGetCurrent()
print("Memoization time \(end2 - start2)")


/* LCS using Dynamic programming: Tabulation: To avoid overlapping subproblems: */
var dp: [[Int]] = Array(repeating: Array(repeating: 0, count: s2.count+1), count: s1.count+1)

func LCSUsingTabulation(s1: String, s2: String, l1: Int, l2: Int) ->  Int {
  for i in 0...l1 {
    for j in 0...l2 {
      if i == 0 || j == 0 {
        dp[i][j] = 0
      } else if s1[i-1] == s2[j-1] {
        dp[i][j] = 1 + dp[i-1][j-1]
      } else {
        dp[i][j] = max(dp[i-1][j], dp[i][j-1])
      }
    }
  }
  return dp[l1][l2]
}
let start3 = CFAbsoluteTimeGetCurrent()
LCSUsingTabulation(s1: s1, s2: s2, l1: s1.count, l2: s2.count)
let end3 = CFAbsoluteTimeGetCurrent()
print("Tabulation time \(end3 - start3)")

/* Print Longest common subsequence */
/*
Explanation: Complete the DP table, and start from the last cell:
if s1[i] == s2[j] => then add 1 to the dp[i-1][j-1] to get dp[i][j]
    | j-1 | j
 i-1|  2  | -    __
 i  |  -  | 3   |\  Diagonally up, 3-1=2
                  \

if s1[i] != s2[j] => then add take the max of dp[i-1][j], dp[i][j-1] to get dp[i][j]
   | j-1 | j
i-1|  -  | 1
i  |  2  | 2
       <----   Sideways because 2>1, 2 = max(1,2)
 
 
so in order to get the string, start from last cell, and see if s1[i] and s2[j] is equal, move diagonally up, and store the s1[i](or s2[j]),
 else move to (i-1, j) or (i, j-1) based on whatever is maximum out of those 2, and dont store anything
 finally, reverse the stored string, to get the LCS
*/

func printLCS(s1: String, s2: String, l1: Int, l2: Int) -> String {
  LCSUsingTabulation(s1: s1, s2: s2, l1: l1, l2: l2)
  var i = l1
  var j = l2
  var lcs: String = ""
  while i > 0 || j > 0 { //As soon as any string is empty, stop
    if s1[i-1] == s2[j-1] {
      //Store s1[i-1] or s2[j-1]
      lcs.append(s1[i-1])
      
      //Move diagonally up,
      i-=1
      j-=1
    } else if dp[i-1][j] > dp[i][j-1] {
      // Move sideways
      i-=1
    } else {
      // Move up
      j-=1
    }
  }
  return String(lcs.reversed())
}

printLCS(s1: s1, s2: s2, l1: s1.count, l2: s2.count)

/* Length of shortest common supersequence
Given two strings str1 and str2, the task is to find the length of the shortest string that has both str1 and str2 as subsequences.
 
Input:   str1 = "geek",  str2 = "eke"
Output: 5
Explanation:
String "geeke" has both string "geek" and "eke" as subsequences.

Worst case scenario, the longest supersequence = string 1 + string 2
if you remove the longest common subsequence from them, you will end up with shortest supersequence
Length of the shortest supersequence = (Sum of lengths of given two strings) - (Length of LCS of two given strings)
 */

func shortestSuperSequence(s1: String, s2: String, l1: Int, l2: Int) -> Int {
  return l1 + l2 - LCSUsingTabulation(s1: s1, s2: s2, l1: l1, l2: l2)
}

shortestSuperSequence(s1: "geek", s2: "eke", l1: 4, l2: 3)

/* Print shortest supersequence:
 Explanation: In print LCS, we used to add the character in the LCS only if s1[i-1] == s2[j-1], else we used to move to the cell sideways or upwards
 
 In shortest supersequence, we want to print out all the characters atleast once, and for LCS characters, we need to print out exactly once
 So if s1[i-1] == s2[j-1] then add it to shortest supersequnce,
 but if its not, then add respective character from S1 or S2 ( whichever is having bigger value in dp), and then move
 
 Same way, for base condition, for LCS, we used to stop when i==0 || j ==0 because lcs of "abc" and "" is ""
 but for shortest supersequence, we need to add the remaining string since sss of "abc" and "" is "abc"
 
 */

func printSSS(s1: String, s2: String, l1: Int, l2: Int) -> String {
  var i = l1 // i relates to s1
  var j = l2 // j relates to s2
  var sss = ""
  LCSUsingTabulation(s1: s1, s2: s2, l1: l1, l2: l2)
  while i > 0 && j > 0 {
    if s1[i-1] == s2[j-1] {
      sss.append(s1[i-1])
      i -= 1
      j -= 1
    } else if dp[i][j-1] > dp[i-1][j] {
      sss.append(s2[j-1])   //Append the character of string from where we are moving on, i.e j
      j -= 1
    } else {
      sss.append(s1[i-1])   //Append the character of string from where we are moving on, i.e i
      i -= 1
    }
  }
  
  // If one of them is empty, we need to append the remaining string in sss
  while i > 0 {
    sss.append(s1[i-1])
    i -= 1
  }
  while j > 0 {
    sss.append(s2[j-1])
    j -= 1
  }
  return String(sss.reversed())
}

printSSS(s1: "geek", s2: "eke", l1: 4, l2: 3)

/* Minimum number of insertion/deletion to convert string a to b */
/* Explanation:
 a: heap
 b: pea
 o/p: (1,2)
 #of insertions: 1
 #of deletions: 2
 if you see the 2 strings, we can see that in order to have minimum number of insertions/deletions, we need to find maximun number of common characters
 The simplest way to do it is using LCS
string a -> LCS + some characters
string b -> LCS + some characters
so in order to convert string a to b, we can first convert a to LCS, and then LCS to be
string a - - - - >  string b
    \              /
  deletion       insertion
      \          /
       -LCS(a,b)-
# of deletion = a.length - LCS(a,b).length
# of insertions = b.length - LCS(a,b).length
*/

func numberOfEditsToConvert(from a: String, to b: String) -> (Int, Int) {
  let lenOfLCS = LCSUsingTabulation(s1: a, s2: b, l1: a.count, l2: b.count)
  let numOfDeletion = a.count - lenOfLCS
  let numOfInsertion = b.count - lenOfLCS
  return (numOfInsertion, numOfDeletion)
}

numberOfEditsToConvert(from: "heap", to: "pea")

/* Sequence Pattern Matching: Given two strings s and t, return true if s is a subsequence of t, or false otherwise.
 Input: s = "axc", t = "ahbgdc"
 Output: false
 
 Input: s = "abc", t = "ahbgdc"
 Output: true
 
 Explanation: if we find the LCS of s, and t, and if that matches s, then we can say that s is a subsequence of t.
 But we dont need to find the complete LCS as well, we can just compare the length of LCS with lenght of s, and of they are same, then we can say that s is subsequence of t. How? , well if length of s and length of LCS(s,t) is different, that means, s has some extra characters that LCS doesnt(and therefore t doesnt), so s cant be a subsequnce of t.
 */

func isSubsequence(s: String, of t: String) -> Bool {
  let lcs = LCSUsingTabulation(s1: s, s2: t, l1: s.count, l2: t.count)
  return s.count == lcs
}

isSubsequence(s: "abc", of: "ahbc")
isSubsequence(s: "abh", of: "ahbc")

/* Longest repeating subsequence: Given a string, find the length of the longest repeating subsequence such that the two subsequences don’t have same string character at the same position, i.e., any i’th character in the two subsequences shouldn’t have the same index in the original string.

 I/P: "a |a| b e |b| c d |d|"
       -     -         -
 o/p: 3, longest repeating subsequence is "abd"
 Explanation: Given string s1: "aabebcdd", lets say s2 = s1 = "aabebcdd",
 now if we want the longest repeating subsequence, we cant have a character appearing odd number of times, because then both of the strings will have same index matched. For example:
 s1: a a b
 s2: a a b
 s1[0] <-> s2[1],
 s1[1] <-> s2[0]
 but s1[2] <-> s2[2] <- this cant happen as the rules dictate: "any i’th character in the two subsequences shouldn’t have the same index in the original string"
 so i == j cant happen.
 If we add this rule in the LCS, we will find the longest repeating subsequence:
 */

func LongestRepeatingSubsequence(s: String) -> Int {
  var dp1: [[Int]] = Array(repeating: Array(repeating: 0, count: s.count+1), count: s.count+1)
  let n = s.count
  for i in 0...n {
    for j in 0...n {
      if i == 0 || j == 0 {
        dp1[i][j] = 0
      } else if s[i-1] == s[j-1] && i != j { // Notice that extra condition: i != j
        dp1[i][j] = 1 + dp1[i-1][j-1]
      } else {
        dp1[i][j] = max(dp1[i-1][j], dp1[i][j-1])
      }
    }
  }
  return dp1[n][n]
}

LongestRepeatingSubsequence(s: "aabebcdd")



//------------------------------------ Palindrome ------------------------------------
/* Longest Palindrome Subsequence: Given string a and b, find the longest common subsequence of a and b that is palindrome.
example: a: abbab
o/p: 4: One possible longest palindromic subsequence is "abba"

Explanation: To find the longest common subsequence, we need 2 strings, here we are just given 1 in I/P. But the property of palindrome is that the reverse should be the same, so lets take another string b = a.reversed()
Now, finding the LCS of a and b would generate a subsequnce that is longest, and common between string and its reverse, hence palindrome
a: abbab
b: babba
LCS(a,b) = abba = LPS

LPS = LCS(a, a.reversed())
*/

func LPS(of s: String) -> Int {
  let s1 = s
  let s2 = String(s.reversed())
  let lcs = LCSUsingTabulation(s1: s1, s2: s2, l1: s1.count, l2: s2.count)
  return lcs
}

LPS(of: "abbg")

/* Minimum #of deletions to make a string palindrome: Given a string of size ‘n’. The task is to remove or delete the minimum number of characters from the string so that the resultant string is a palindrome.
 Input : aebcbda
 Output : 2
 Remove characters 'e' and 'd', Resultant string will be 'abcba' which is a palindromic string

Explanation: given string s of size n,
deletion: 1  resultant: n-1
deletion: 2  resultant: n-2
deletion: 3  resultant: n-3
so, deletion and resultant have opposite relation, hence
if We want to make the number of deletion to be minimium, the resultant string should be maximum/longest possible
Also, the resultant string should be a palindrome, so we want a longest palindrome subsequnce(LPS) as a resultant
 so, minimum number of deletions = s.length - LPS(s)
 */

func numOfDeletionsToCreatePalindrome(from s: String) -> Int {
  return s.count - LPS(of: s)
}

numOfDeletionsToCreatePalindrome(from: "abbg")

/* Minimum #of insertions to make a string palindrome: Given a string of size ‘n’. The task is to insert the minimum number of characters to the string so that the resultant string is a palindrome.
 Input : aebcbda
 Output : 2
 Add characters 'd' and 'e', Resultant string will be 'ae{d}bcbd{e}a' which is a palindromic string
 Explanation: If you notice the string, only thing thats additional in the string are characters thats not present in LPS, if we add another copy of the same characters at appropriate places to pair them up, then the string becomes palindrome
so, e and d can be paired up with d and e respectively (2 new character added, since 2 characters are not present in LPS)
Therefore, minimum #of insertion = s.length - LPS(s) which is same as minimum #of deletion
so, for any string s-> "aebcbda", there are 2 ways to make it a palindrome:
 1) delete s.length - LPS(s) characters to make "abcba" (deleted e and d)
 2) Insert another s.length - LPS(s) characters to make "aedbcbdea" (added one more e and d)
 
so, minimum number of deletions/insertions = s.length - LPS(s)
*/

func numOfInsertionsToCreatePalindrome(from s: String) -> Int {
  return numOfDeletionsToCreatePalindrome(from: s)
}
numOfInsertionsToCreatePalindrome(from: "abbg")

