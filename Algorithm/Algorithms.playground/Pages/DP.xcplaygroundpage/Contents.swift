/*
 
 Dynamic Programming:
 Recursive problems
 + 1)  Overlapping subproblems
 + 2)  Optimal substructure
= DP
 
 DP: 2 approaches:

 Top down:
 -> Memoization
 -> Recursive in nature
 -> All subproblems might not be calculated, it’s on demand
 -> Might create recursion stack overflow
 -> Recursive func: Base condition
 -> Recursive func: parameters that change and passed into the func call

 Bottom up:
 -> Tabulation
 ->  Iterative in nature
 ->  All subproblems are calculated from smallest to largest
 ->  Safest in terms of memory since no recursion
 -> Iterative table: 0th row and column initialization
 -> Iterative table: X and Y Axis
 */

/*
 Recursive function: 3 parts: 1) Base condition 2) Choice diagram 3) Smaller input at every step
 Memoization/Tabulation array/table stores only the values that change in the recursive function call, so n and kw in case of knapsack. So size will be n+1, kw+1 (+1 for base condition consideration)
 
 DP will only come into picture if there are subproblems and they overlap
 example. if f(n) -> f(n-1) -> f(n-2) in these kind of recursive call, DP wont apply
 but if f(n) = f(n-1) + f(n-2) ->  here DP will be effective as there are overlapping subproblems, so DP makes it more efficient
 */
