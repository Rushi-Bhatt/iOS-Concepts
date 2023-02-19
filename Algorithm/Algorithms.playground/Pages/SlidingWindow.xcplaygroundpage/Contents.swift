import Foundation

extension String {
  subscript(i: Int) -> Character {
    self[index(startIndex, offsetBy: i)]
  }
}

/* Sliding Window:
 Brute force: Adds repeatative work, to avoid that we can use sliding window
 
 Identification: Given Array or string, we will be asked to get subarray or substring (continuos)
 1) Fixed Size Sliding Window: Window size k will be given and we will be asked to find largest/smallest/maximum/minimum
 
 -> Max/Min subarray of size k
 -> 1st negative in every window of size k
 -> Count occurences of anagrams
 -> max of all subarrays of size k
 -> max of minimum of every window size
 
 
 2) Variable Size Sliding Window: Some condition will be given and we need to find the window size (either largest or smallest) that matches that condition
 
 -> Largest/Smallest subarray of sum k
 -> Largest substring with k distint characters
 -> Length of largest substring with no repeating characters
 -> Pick toys
 -> Min window substring (VIMP)
 
 */

/* Fixed length sliding window format
 
 func abc(array: [Int], k: Int) -> returnType {
 var n = array.count
 var i = 0 // start of window
 var j = 0 // end of window
 var ans
 while j < n {
 // calculation based on j
 ...
 if j-i+1 < k {
 // Increase Window Size
 j ++
 }
 else if j-i+1 == k {
 // Find ans from calculation
 ...
 //Remove calculation of i from ans
 ...
 // Slide the window
 i ++
 j ++
 }
 return ans
 }
 
 */
/* Fixed:
 1) Maximum sum of all subarrays of size k: Given an array, find the maximum sum of all the subarrays of size k
 I/P: [2,5,1,8,2,9,1], k = 3
 O/P:
 
 Explanation: given array, we will use i and j to represent the window start and end of the window.
 windown size = j - i + 1
 So start with i = j = 0 and start incrementing j until we reach the window size
 Now, we need to maintain the window size so for each iteration, j++ and i++
 */

func maxSumOfSubarrays(for array: [Int], with k: Int) -> Int {
  let n = array.count
  var i = 0
  var j = 0
  var sum = 0
  var maxSum = Int.min
  while j < n {
    // Always add the j th element to the sum
    sum = sum + array[j]
    
    if (j-i+1) < k {
      
      //Increase the window size
      j += 1
      
    } else if (j-i+1) == k {
      
      //Found the window size
      maxSum = max(maxSum, sum)
      
      // we need to remove i th element from sum to get the correct sum in next iteration on line 43
      sum = sum - array[i]
      
      //Maintain the window size
      i += 1
      j += 1
      
    }
  }
  return maxSum
}

maxSumOfSubarrays(for: [2,5,1,8,2,9,1], with: 3)

/* First negative number in every window of size k:
 If window doesnt contain negative number, then print 0
 
 I/P: 12 -1 -7 8 -15 30 13 28,  k = 3
 i       j
 
 O/P: -1 -1 -7 -15 -15 0
 #of outputs = n - k + 1 since we need 1 for each window
 
 */

func firstNeg(from array: [Int], with k: Int) -> [Int] {
  let n = array.count
  var i = 0
  var j = 0
  var list: [Int] = [] //Temporary list to store all neg numbers in the window, and remove from that list as soon as the number goes out of the window
  var ans: [Int] = []
  while j < n {
    if array[j] < 0 {
      list.append(array[j])
    }
    if (j-i+1) < k {
      j += 1
    } else if (j-i+1) == k {
      if let firstNeg = list.first {
        ans.append(firstNeg)
        if firstNeg == array[i] {
          list.removeFirst()
        }
      } else {
        // List is empty, so window doesnt have any negative number
        ans.append(0)
      }
      i += 1
      j += 1
    }
  }
  return ans
}

firstNeg(from: [12,-1,-7,8,-15,30,13,28], with: 3)

/* Count occurences of Anagram:
 Given two strings s and p, return number of p's anagrams in s. You may return the answer in any order.
 
 An Anagram is a word or phrase formed by rearranging the letters of a different word or phrase, typically using all the original letters exactly once.
 
 Example 1:
 
 Input: s = "cbaebabacd", p = "abc"
 Output: 2
 Explanation:
 The substring with start index = 0 is "cba", which is an anagram of "abc".
 The substring with start index = 6 is "bac", which is an anagram of "abc".
 
 Here, we are going to create a map that stores the freq. of each character in the window, as we traverse the list.
 Also, we can say that the window represents the anagram when both window and pattern has the same characters with same freq.
 So in order to check that, we calculate count which will be 3 for a=1, b=1, c=1.
 So if count == 3 at any given time for any windown, that means that we have found an anagram
 */

func numberOfAnagrams(for str: String, with ptr: String) -> Int {
  let n = str.count
  let k = ptr.count
  var i = 0
  var j = 0
  var map: [Character: Int] = [:]
  var ans: Int = 0
  
  var count: Int  {
    var count = 0
    ptr.forEach { (ch) in
      if map[ch] == 1 {
        count += 1
      }
    }
    return count
  }
  
  var isAnagram: Bool {
    count == ptr.count ? true : false
  }
  
  while j < n {
    //calculation for j
    if map[str[j]] != nil {
      map[str[j]]! += 1
    } else {
      map[str[j]] = 1
    }
    
    if j-i+1 < k {
      
      //Reach window size first
      j += 1
      
    } else if j-i+1 == k {
      
      //ans from calculation
      if isAnagram {
        ans += 1
      }
      
      // remove calculation for i
      if map[str[i]] != nil {
        map[str[i]]! -= 1
      }
      
      //slide the window
      i += 1
      j += 1
    }
  }
  
  return ans
}

numberOfAnagrams(for: "cbaebabacd", with: "abc")
numberOfAnagrams(for: "abab", with: "ab")

/* Maximum of all subarrays of size k:
 Given an array and an integer K, find the maximum for each and every contiguous subarray of size k.
 
 Examples :
 Input: arr[] = {1, 2, 3, 1, 4, 5, 2, 3, 6}, K = 3
 Output: 3 3 4 5 5 5 6
 if we just have 1 variable, storing the max number, when we go out of that window, we dont have a backup to replace that max with next max.
 So Here we are going to create list, and store all the numbers in that with max always being the first element.
 
 [ 1 2 3 4 5 ... j ... 1 2 3 4 5]
 here, all the elements on the left side of j are not useless if they are smaller than j.
 but we need smallers elements on the right side of j, because when j gets removed from the window, the new max will be from those elements
 
 so everytime we enter jth element in the list, we remove all the smaller elements before that from the list.
 And everytime we hit the window size, the first element in that list will be the maximum, because the smaller once will already be removed in the previous step
 
 now while moving the window, we just need to remove the ith element from list as well if its there
 
 */

func maxOfSubarrays(from array: [Int], with k: Int) -> [Int] {
  let n = array.count
  var i = 0
  var j = 0
  var ans: [Int] = []
  var list: [Int] = []
  while j < n {
    //calculation
    while !list.isEmpty && list.last! < array[j] {
      list.removeLast()
    }
    list.append(array[j])
    
    if j-i+1 < k {
      j += 1
    } else if j-i+1 == k {
      //ans from calculation
      guard let first = list.first else {
        return []
      }
      ans.append(first)
      
      //remove i from calculation
      if first == array[i] {
        list.removeFirst()
      }
      
      //slide the window
      i += 1
      j += 1
    }
  }
  return ans
}

maxOfSubarrays(from: [1, 2, 3, 1, 4, 5, 2, 3, 6], with: 3)

/* Variable length sliding window: */
/* Variable length sliding window format
 
 func abc(array: [Int], k: Int) -> returnType {
 var n = array.count
 var i = 0 // start of window
 var j = 0 // end of window
 var ans
 while j < n {
 // calculation based on j
 ...
 if calculation < k {
 // Increase Window Size
 j ++
 }
 else if calculation == k {
 // Find ans from calculation, this window size is one candidate
 ans = max(ans, j-i+1)
 
 // move on to the next j
 // slide the end of window
 j ++
 } else if calculation > k {
 // Oops, we need to re-adjust the window size to meet the calculation
 while (calculation > k) {
 // Remove i from calculation
 ...
 
 // slide the front of window
 i ++
 }
 // Now we have calculation which is less than or equal to k
 // so move on to the next j
 // slide the end of window
 j ++
 }
 return ans
 }
 */

/* Largest subarray with sum k: Given an array arr[] of size n containing integers. The problem is to find the length of the longest sub-array having sum equal to the given value k.
 Examples:
 Input : arr[] = { 10, 5, 2, 7, 1, 9 }, k = 15
 Output : 4
 The sub-array is {5, 2, 7, 1}.
 */

func largestSubarray(of array: [Int], with k: Int) -> Int {
  let n = array.count
  var i = 0
  var j = 0
  var ans = Int.min
  var sum = 0
  while j < n {
    
    //Calculation based on j
    sum += array[j]
    
    if sum < k {
      // Increase the window size
      j += 1
    } else if sum == k {
      // Found one candidate as window size. Checking with current ans to find maximum
      ans = max(ans, j-i+1)
      
      // consider next element
      j += 1
    } else if sum > k {
      // New condition, Fixed length sliding window doesnt have this
      while sum > k {
        // Removing ith element from window till we meet the condition
        sum -= array[i]
        i += 1
          
        // handle for "if sum == k" in case of [1,1,1] and k=2
          
      }
      // Now sum is <=k again, time to consider next element
      j += 1
    }
  }
  
  return ans
}

largestSubarray(of: [10, 5, 2, 7, 1, 9], with: 15)

/* Longest substring with k unique character Using Set. More efficient
 I/P: s: aabacbebebe, k = 3
 O/P: 7 (cbebebe)
 */

func longestSubstring(of s: String, withUniqueCharacter k: Int) -> Int {
  let n = s.count
  var i = 0
  var j = 0
  var ans = 0
  var str: String = ""
  guard n >= k else { return ans }
  while j < n {
    str = str + String(s[j])
    if uniqueCharacters(in: str) < k {
      // Simply increase the window size
      j += 1
    } else if uniqueCharacters(in: str) == k {
      // Found one candidate
      ans = max(ans, str.count)
      j += 1
    } else if uniqueCharacters(in: str) > k {
      while uniqueCharacters(in: str) > k {
        str.removeFirst()
        i += 1
      }
      j += 1
    }
    
  }
  print("Longest substring with \(k) unique characters: \(str)")
  return ans
  
}

func uniqueCharacters(in str: String) -> Int {
  return Set(str).count
}

let start1 = CFAbsoluteTimeGetCurrent()
longestSubstring(of: "aabacbebebe", withUniqueCharacter: 3)
let diff1 = CFAbsoluteTimeGetCurrent() - start1
print("time using Set: \(diff1)")


/* Longest substring with k unique character Using Map. Less Efficient
 I/P: s: aabacbebebe, k = 3
 O/P: 7 (cbebebe)
 */
func longestSubstringUsingMap(of s: String, withUniqueCharacter k: Int) -> Int {
  let n = s.count
  var i = 0
  var j = 0
  var ans = 0
  var map: [Character: Int] = [:]
  guard n >= k else { return ans }
  while j < n {
    //Calculation for j
    if let count = map[s[j]] {
      map[s[j]] = count + 1
    } else {
      map[s[j]] = 1
    }
    
    if map.count < k {
      // Simply increase the window size
      j += 1
    } else if map.count == k {
      // Found one candidate
      ans = max(ans, j - i + 1)
      j += 1
    } else if map.count > k {
      while map.count > k {
        // Remove ith element from map
        if let count = map[s[i]], count > 1 {
          map[s[i]] = count - 1
        } else {
          map.removeValue(forKey: s[i])
        }
        i += 1
      }
      j += 1
    }
    
  }
  
  let str = s[s.index(s.startIndex, offsetBy: i)..<s.index(s.startIndex, offsetBy: j)]
  print("Longest substring with \(k) unique characters: \(str)")
  return ans
  
}
let start2 = CFAbsoluteTimeGetCurrent()
longestSubstringUsingMap(of: "aabacbebebe", withUniqueCharacter: 3)
let diff2 = CFAbsoluteTimeGetCurrent() - start2
print("time using Map: \(diff2)")

/* Longest Substring with no repeating characters:
 Explanation: If a sunstring has no repeating characters, it means it has all unique characters.
 So the problem can be categorized as longest sunstring with k (substring.count or in other words j - i + 1) unique characters.
 This can also be solved using set instead of map, just like previous question
 
 One difference is in terms of conditions:
 
 */

func LongestSubstringWithNoRepeat(of s: String) -> Int {
  let n = s.count
  var i = 0
  var j = 0
  var ans = 0
  var map: [Character: Int] = [:]
  guard n >= 2 else { return n }
  while j < n {
    //Calculation for j
    if let count = map[s[j]] {
      map[s[j]] = count + 1
    } else {
      map[s[j]] = 1
    }
    
    // each time, we need all unique characters so k = window size = j - i + 1
    if map.count > j - i + 1 {
      // This condition will never occur, but in the interest of format, we are keeping it as is
      j += 1
    } else if map.count == j - i + 1 {
      // Found one candidate
      ans = max(ans, j - i + 1)
      j += 1
    } else if map.count < j - i + 1 {
      // Notice how its "<" and not ">" like prev. question. In this question, there wont be a condition where map.count > k, so we removed the first if.
      while map.count < j - i + 1 {
        // Remove ith element from map
        if let count = map[s[i]], count > 1 {
          map[s[i]] = count - 1
        } else {
          map.removeValue(forKey: s[i])
        }
        i += 1
      }
      j += 1
    }
    
  }
  
  return ans
  
}

LongestSubstringWithNoRepeat(of: "aabacbebebe")

/*
Same as above but with Set
*/

func uniqueCharactersCount(_ s: String) -> Int {
    return Set(s).count
}
func lengthOfLongestSubstringWithNoRepeat(_ s: String) -> Int {
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

/* Pick Toys:
 Given an array arr[ ] of length N consisting N toys and an integer K depicting
 the unique toys you can pick. Your task is to find maximum number of toys you can pick. Toys need to be picked up in sequence
 Example:
 Input:
 K = 2
 arr[] = [a b a c c a b]
 Output: 4 (a c c a)
 
 Explanation: Its the same problem as finding longest substring with k unique characters.
*/

func pickToys(from arr: [Character], withUniqueToys k: Int) -> Int {
  return longestSubstring(of: String(arr), withUniqueCharacter: k)
}

pickToys(from: ["a", "b", "a", "c", "c", "a", "b"], withUniqueToys: 2)

/* Minimum Window Substring:
 Given two strings s and t of lengths m and n respectively, return the minimum window substring of s such that every character in t (including duplicates) is included in the window. If there is no such substring, return the empty string ""
 
 Input: s = "ADOBECODEBANC", t = "ABC"
 Output: "BANC"
 Explanation: The minimum window substring "BANC" includes 'A', 'B', and 'C' from string t.
 */

func minimumWindowSubstring(of s: String, with t: String) -> String {
  guard t.count <= s.count else { return "" }
  let n = s.count
  var i = 0
  var j = 0
  var final = 0
  var ans = Int.max
  var mappedItems = t.map { ($0, 1) }
  var map: [Character: Int] = Dictionary(mappedItems, uniquingKeysWith: +)
  
  while j < n {
    //Calculation for j
    // if character from s is not subset of t, then dont bother adding that in map
    // if the character is from t, then reduce the freq from the map
    // if the freq reaches 0, then increment final by 1.
    // if final == t.count => that means all the values are covered and we found a candidate
    if let freq = map[s[j]] {
      map[s[j]] = freq - 1
      if map[s[j]] == 0 { final += 1 }
    }
    
    if final < t.count {
      // Some characters from t are not yet covered
      // Keep going
      j += 1
    } else if final == t.count {
      // All characters of t are covered in current candidate
      ans = min(ans, j - i + 1)
      
      // Now try and optimize by incrementing the i, may be i to j might not be the shortest, and we can get the shortest from i+1 to j or i+2 to j
      while final == t.count {
        if let freq = map[s[i]] {
          if freq < 0 {
            // we have extra character s[i], so we can do i ++
            map[s[i]] = freq + 1
            i += 1
          } else {
            // Here the freq is 0, so we absolutely need character s[i]
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

minimumWindowSubstring(of: "ABABDOBECODEBANC", with: "ABC")
