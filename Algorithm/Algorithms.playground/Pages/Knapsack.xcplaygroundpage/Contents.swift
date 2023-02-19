import Foundation
/*
 Knapsack problems:
 1) 0-1 Knapsack:
    Problems:
    -> 0-1 Knapsack
    -> Subset Sum
    -> Count of subset sum
    -> Equal sum subset
    -> Minimum subset sum diff
    -> Target sum
    -> Count of subset of given diff
 2) Unbounded Knapsack
 3) Fractional Knapsack: Greedy Algorithm, not DP
 */  

/* 0-1 Knapsack using recursion: */
/*
Choice diagram:
0-1 Knapsack:
W = 4
[1, 2, 3,            5             ]
            /              \ is item < W?
           yes              no
           /  \ include?     \ processed?
           yes  no             yes
           /     \ processed?
          yes    yes
*/
/* value: [60, 100, 120], weight: [10, 20, 30], W: 50 */

// returns maximum total value of a knapsack
func knapSack(_ value: [Int], _ weight: [Int], _ n: Int, _ kw: Int) -> Int {
  //print(kw, weight, value, n)
  if n == 0 || kw == 0 {
    return 0
  }
  // starting from last item
  if weight[n-1] > kw {
    // I get 1 choice, to ignore n-1 item
    return knapSack(value, weight, n-1, kw)
  } else {
    // I get 2 choices, either to include n-1 item or to ignore
    return max(value[n-1] + knapSack(value, weight, n-1, kw - weight[n-1]),
      knapSack(value, weight, n-1, kw)
    )
  }
}

let start1 = CFAbsoluteTimeGetCurrent()
print(knapSack([50, 100, 150, 200], [8, 16, 32, 40], 4, 64))
let diff1 = CFAbsoluteTimeGetCurrent() - start1
print("time for recursion: \(diff1)")


/* 0-1 Knapsack using Dynamic programming: memoization: To avoid overlapping subproblems: */

// returns maximum total value of a knapsack
// creating a 2d array to hold the values of all subproblems

var val = [50,100,150,200]
var wt = [8,16,32,40]
var kw = 64
var n = val.count
var t =  Array(repeating: Array(repeating: 0, count: kw+1), count: n+1)
func knapSackMemoized(_ value: [Int], _ weight: [Int], _ n: Int, _ kw: Int) -> Int {
  //print(kw, weight, value, n)
  if (t[n][kw] != 0) {
     return t[n][kw]
  }
  if n == 0 || kw == 0 {
    return 0
  }
  // starting from last item
  if weight[n-1] > kw {
    // I get 1 choice, to ignore n-1 item
    t[n][kw] = knapSackMemoized(value, weight, n-1, kw)
  } else {
    // I get 2 choices, either to include n-1 item or to ignore
    t[n][kw] = max(value[n-1] + knapSackMemoized(value, weight, n-1, kw - weight[n-1]),
               knapSackMemoized(value, weight, n-1, kw)
    )
  }
  return t[n][kw]
}

let start2 = CFAbsoluteTimeGetCurrent()
print(knapSackMemoized(val, wt, n, kw))
let diff2 = CFAbsoluteTimeGetCurrent() - start2
print("time for memoization: \(diff2)")

/* 0-1 Knapsack using Dynamic programming: Tabulation: To avoid overlapping subproblems: */
// returns maximum total value of a knapsack
// creating a 2d array to hold the values of all subproblems

//var val = [50,100,150,200]
//var wt = [8,16,32,40]
//var kw = 64
//var n = val.count
func knapSackTabulation(_ value: [Int], _ weight: [Int], _ n: Int, _ kw: Int) -> Int {
  print(kw, weight, value, n)
  var dp = Array(repeating: Array(repeating: -1, count: kw+1), count: n+1)
  for i in 0...n {
    for j in 0...kw {
      //Base condition
      if i == 0 || j == 0 {
        dp[i][j] = 0
      } else if weight[i-1] > j {
        dp[i][j] = dp[i-1][j]
      } else {
        dp[i][j] = max(value[i-1] + dp[i-1][j-weight[i-1]] , dp[i-1][j])
      }
    }
  }
  return dp[n][kw]
}

let start3 = CFAbsoluteTimeGetCurrent()
print(knapSackTabulation(val, wt, n, kw))
let diff3 = CFAbsoluteTimeGetCurrent() - start3
print("time for tabulation: \(diff3)")
