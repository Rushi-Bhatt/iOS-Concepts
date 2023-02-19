/* Using DP: Tabulation:
Subset sum: Given a set of non-negative integers, and a value sum, determine if there is a subset of the given set with sum equal to given sum.
Input: set[] = {3, 34, 4, 12, 5, 2}, sum = 9
Output: True
There is a subset (4, 5) with sum 9.

Input: set[] = {3, 34, 4, 12, 5, 2}, sum = 30
Output: False
There is no subset that add up to 30.
*/

func subsetSum(set: [Int], sum: Int) -> Bool {
  let n = set.count
  var dp: [[Bool]] = Array(repeating: Array(repeating: false, count: sum+1), count: n+1)
  
  for i in 0...n {
    for j in 0...sum {
      if i == 0 && j == 0 {
        dp[i][j] = true
      } else if i == 0 {
        dp[i][j] = false
      } else if j == 0 {
        dp[i][j] = true
      } else if set[i-1] > j {
        dp[i][j] = dp[i-1][j]
      } else {
        dp[i][j] =  dp[i-1][j-set[i-1]] || dp[i-1][j]
      }
    }
  }
  
  return dp[n][sum]
}

let set = [3, 34, 4, 12, 5, 2]
let sum = 9
print(subsetSum(set: set, sum: sum))

/* Using DP: Tabulation:
Count # of Subset with sum: Given a set of non-negative integers, and a value sum, determine number of subsets of the given set with sum equal to given sum.
Input: set[] = {3, 34, 4, 12, 5, 2}, sum = 9
Output: 1
There is a subset (4, 5) with sum 9.
*/

func numberOfSubSet(of set: [Int], with sum: Int) -> Int {
  let n = set.count
  var dp: [[Int]] = Array(repeating: Array(repeating: 0, count: sum+1), count: n+1)
  for i in 0...n {
    for j in 0...sum {
      if i == 0 && j == 0 {
        dp[i][j] = 1
      } else if j == 0 {
        dp[i][j] = 1
      } else if i == 0 {
        dp[i][j] = 0
      } else if set[i-1] > j {
        dp[i][j] = dp[i-1][j]
      } else {
        dp[i][j] = dp[i-1][j-set[i-1]] + dp[i-1][j]
      }
    }
  }
  return dp[n][sum]
}

let set1 = [2, 3, 5, 6, 8, 10]
let sum1 = 10
print(numberOfSubSet(of: set1, with: sum1))

/* Using DP: Tabulation:
Equal sum Subset: Given a set of positive numbers, find if we can partition it into two subsets such that the sum of elements in both the subsets is equal..
Input: set[] = {1, 2, 3, 4}
Output: true
Input: set[] = {2, 3, 4, 6}
Output: false
 
 
Explanation: let say that 2 partitions are p1 and p2 with sum s1 and s2, so s1+s2 = total sum of entire set, and s1 = s2
therefore, s1 = total sum of set/2, now in order for s1 to be integer, total sum needs to be even
So, since numbers are integers -> if total sum of set is odd then return false, because 2 partitions not possible with equal sum
otherwise, find if one subset is possible with given sum s1 (=total sum/2)
*/

func isEqualSumSubset(of set: [Int]) -> Bool {
  let totalSum = set.reduce(0, +)
  if !totalSum.isMultiple(of: 2) {
    return false
  }
  let subSetSum = totalSum/2
  return subsetSum(set: set, sum: subSetSum)
}

let set3 = [2, 3, 4, 6]
print(isEqualSumSubset(of: set3))


/* Using DP: Tabulation:
 Minimum subset sum diff: Given a set of positive numbers, divide it into two sets S1 and S2 such that the absolute difference between their sums is minimum.
Input: set[] = {1, 6, 11, 5}
Output: 1
 
Explanation: let say that 2 partitions are p1 and p2 with sum s1 and s2, so s1+s2 = total sum of entire set, and |s1 - s2| is minimum
Now each s1 and s2 are in range 0..S where S = s1+s2
so, s1 and s2 need to be on the opposite side of the center point(being S/2), and that too as close as possible. Example, if S = 10, then, s1 and s2 will be on opposite sides of 5 ( or 5 each), and as close to 5 as possible (i.e 5,5 or 4,6 or 3,7)
Now, all s1/s2 values can't be possible, because we can only produce finite sum values from given set. i.e {1, 6, 5, 11} set can produce sum 2, 3, 4, 8 and so on.
So we need to find the closest possible value from the half point, and that will be our s1. And S-s1 will be our s2.
so diff = s2 - s1 = (S - s1) - s1 = S - 2s1
*/

func minimumSubsetSumDiff(of set: [Int]) -> Int {
  let n = set.count
  let sum = set.reduce(0, +)
  var dp: [[Bool]] = Array(repeating: Array(repeating: false, count: sum+1), count: n+1)
  
  for i in 0...n {
    for j in 0...sum {
      if i == 0 || j == 0 {
        dp[i][j] = true
      } else if i == 0 {
        dp[i][j] = false
      } else if j == 0 {
        dp[i][j] = true
      } else if set[i-1] > j {
        dp[i][j] = dp[i-1][j]
      } else {
        dp[i][j] = dp[i-1][j-set[i-1]] || dp[i-1][j]
      }
    }
  }
  
  for j in (0...sum/2).reversed() {
    if dp[n][j] {
      return sum - 2*j
    }
  }
  return -1
}

print(minimumSubsetSumDiff(of:[1, 6, 5, 11]))
print(minimumSubsetSumDiff(of:[2, 3, 4, 6]))
print(minimumSubsetSumDiff(of:[1, 2, 3, 4]))

/* Using DP: Tabulation:
Target Sum: You want to build an expression out of nums by adding one of the symbols '+' and '-' before each integer in nums and then concatenate all the integers. Find out how many ways it can be done.
Input: set[] = [1,1,1,1,1], target = 3
Output: 5
 
Explanation: let say that 2 partitions are p1 and p2 with sum s1 and s2, so s1+s2 = total sum of entire set, and |s1 - s2| is the given target sum, that way when you put + and - signs for s1 and s2 respectively, their sum becomes the target sum we want.
Now each s1 and s2 are in range 0..S where S = s1+s2
s1+s2 = S
s1-s2 = target sum
So, by these 2 equations, you can find s = (S + target sum)/2
So, the question then becomes -> number of subsets with sum: (S + target sum)/2
*/

func targetSum(of set: [Int], with sum: Int) -> Int {
  let n = set.count
  let totalSum = set.reduce(0, +)
  let targetSum = sum
  let s1 = (targetSum + totalSum)/2
  return numberOfSubSet(of: set, with: s1)
}

print(targetSum(of: [1,1,1,1,1], with: 3))

/* Using DP: Tabulation:
 Count of subset of given diff: Given set of positive numbers, count number of subset with given difference in their sum
Input: set[] = [1,1,1,1,1], target = 3
Output: 5

 
Same question as above, just different language
target sum = Count of subset of given diff
 
Explanation: let say that 2 partitions are p1 and p2 with sum s1 and s2, so s1+s2 = total sum of entire set, and |s1 - s2| is the given target sum
Now each s1 and s2 are in range 0..S where S = s1+s2
s1+s2 = S
s1-s2 = target diff
So, by these 2 equations, you can find s = (S + target diff)/2
So, the question then becomes -> number of subsets with sum: (S + target diff)/2
*/

func countSubset(of set: [Int], with diff: Int) -> Int {
  return targetSum(of: set, with: diff)
}
print(countSubset(of: [1,1,1,1,1], with: 3))
