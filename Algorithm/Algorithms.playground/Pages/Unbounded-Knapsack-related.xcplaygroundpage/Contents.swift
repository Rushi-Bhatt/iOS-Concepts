/* Unbounded Knapsack: item repetition allowed: Given a knapsack weight W and a set of n items with certain value val and weight wt, we need to calculate the maximum amount that could make up this quantity exactly. */
/* Input : W = 8
 val[] = {10, 40, 50, 70}
 wt[]  = {1, 3, 4, 5}
 Output : 110 */
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
                    
 
 Choice diagram:
 Unbounded Knapsack:
 W = 4
 [1, 2, 3,         5              ]
           /              \ is item < W?
          yes              no
          /  \ include?     \ processed?
         yes  no             yes
         /     \ processed?
       _____
       | no |    yes
       ------
 */

/* Only difference between 0-1 and unbounded knapsack is when the item meets the criteria, and we decided to include it, its still not marked as processed, that means we can add it again if need be.
 
 But if the item doesnt meet the criteria, or we decide to not include it, then its processed. */

func unboundedKnapsack(_ value: [Int], _ weight: [Int], _ n: Int, _ kw: Int) -> Int {
  var dp: [[Int]] = Array(repeating: Array(repeating: 0, count: kw+1), count: n+1)
  for i in 0...n {
    for j in 0...kw {
      if i == 0 || j == 0 {
        dp[i][j] = 0
      } else if weight[i-1] > j {
        dp[i][j] = dp[i-1][j]
      } else {
        dp[i][j] = max(value[i-1] + dp[i][j-weight[i-1]]
                       ,dp[i-1][j])
        // Notice how its dp[i][j-weight[i-1]] instead of dp[i-1][j-weight[i-1]] like in 0-1 knapsack
      }
    }
  }
  return dp[n][kw]
}
print(unboundedKnapsack([10, 40, 50, 70], [1, 3, 4, 5], 4, 8))

/* Rod cutting problem: Given a rod of length n and a list of rod prices of length i, where 1 <= i <= n, find the optimal way to cut the rod into smaller rods to maximize profit.
 
 length[] = [1, 2, 3, 4, 5, 6, 7, 8]
 price[] = [1, 5, 8, 9, 10, 17, 17, 20]
  
 Rod length L: 4
 Output: 10, 2 parts of 2 each, so 5+5
 
 sometimes they wont give you the length array, but you can create one from rod length, [0, 1, 2..., rod length]
 Its same as unbounded knapsack above, just variables differ
 */

func rodCutting(with length: [Int], and price: [Int], L: Int) -> Int {
  let n = length.count
  var dp: [[Int]] = Array(repeating: Array(repeating: 0, count: L+1), count: n + 1)
  for i in 0...n {
    for j in 0...L {
      if i == 0 || j == 0 {
        dp[i][j] = 0
      } else if length[i-1] > j {
        dp[i][j] = dp[i-1][j]
      } else {
        dp[i][j] = max(price[i-1] + dp[i][j-length[i-1]]
                       ,dp[i-1][j])
        // Notice how its dp[i][j-length[i-1]] instead of dp[i-1][j-length[i-1]] like in 0-1 knapsack
      }
    }
  }
  return dp[n][L]
}

print(rodCutting(with: [1, 2, 3, 4, 5, 6, 7, 8], and: [1, 5, 8, 9, 10, 17, 17, 20], L: 4))


/* Coin change problem: Maximum # of ways: Given an amount and an array of coins showing available coins. Determine in how many ways coins can be added for the amount. There is limitless supply of coins of each type.
 coin[] = [1,2,3]
 amount = 5
     
 Ways coins can be added to get amount = 5:
 1) 1+1+1+1+1 = 5
 2) 1+1+1+2 = 5
 3) 1+1+3 = 5
 4) 1+2+2 = 5
 5) 3+2 = 5
There are 5 ways, therefore output should be 5 for this example.

Explanation: Same as subset sum problem, but unbounded version. Finding the number of subsets with given sum, but here the element can be considered multiple times
*/

func maximumWays(to amount: Int, from coins: [Int]) -> Int {
  let n = coins.count
  var dp: [[Int]] = Array(repeating: Array(repeating: 0, count: amount+1), count: n+1)
  for i in 0...n {
    for j in 0...amount {
      if i == 0 && j == 0 {
        dp[i][j] = 1
      } else if i == 0 {
        dp[i][j] = 0
      } else if j == 0 {
        dp[i][j] = 1
      } else if coins[i-1] > j {
        dp[i][j] = dp[i-1][j]
      } else {
        dp[i][j] = dp[i][j-coins[i-1]] + dp[i-1][j]
        // Notice how its dp[i][j-coins[i-1]] instead of dp[i-1][j-coins[i-1]] like in 0-1 knapsack
      }
    }
  }
  return dp[n][amount]
}

print(maximumWays(to: 5, from: [1,2,3]))


/* Coin change problem: Minimum # of coins: Tricky one: Given a value V, if we want to make a change for V cents, and we have an infinite supply of each of C = { C1, C2, .., Cm} valued coins, what is the minimum number of coins to make the change? If it’s not possible to make a change, print -1.
 Input: coins[] = {9, 6, 5, 1}, V = 11
 Output: Minimum 2 coins required
     
*/
func minimumCoins(to amount: Int, from coins: [Int]) -> Int {
  let n = coins.count
  var dp: [[Int]] = Array(repeating: Array(repeating: 0, count: amount+1), count: n+1)
  let infinite: Int = Int.max - 1 // default value
  
  for i in 0...n {
    for j in 0...amount {
      if i == 0 && j == 0 {
        dp[i][j] = infinite
      } else if i == 0 {
        dp[i][j] = infinite
      } else if j == 0 {
        dp[i][j] = 0
      }
      else if coins[i-1] > j {
        dp[i][j] = dp[i-1][j]
      } else {
        dp[i][j] = min( 1 + dp[i][j-coins[i-1]],
                        dp[i-1][j])
        // +1 because we want to find the # of ways, so not using coins[i-1] or val[i-1]
        // Added min because we want to find the minimum # of coins required.
        // See how we are adding +1, thats why our infinite value is Int.max - 1, so even with +1, it can be stored in Int.
        // Notice how its dp[i][j-coins[i-1]] instead of dp[i-1][j-coins[i-1]] like in 0-1 knapsack
      }
    }
  }
  return dp[n][amount] != infinite ? dp[n][amount] : -1
}

print(minimumCoins(to: 13, from: [9,6,5,1]))
print(minimumCoins(to: 13, from: [9,6,5]))
