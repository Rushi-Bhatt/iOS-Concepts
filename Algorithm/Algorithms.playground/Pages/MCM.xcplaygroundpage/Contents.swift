import Foundation

extension String {
  subscript(i: Int) -> Character {
    return self[index(self.startIndex, offsetBy: i)]
  }
}


/* Matrics Chain Multiplication:

Problems:
1) MCM, Printing MCM
2) Boolean Parenthesis/Evaluate expression to be true
3) Palindrome Partitioning
4) Min/Max value of any expression
5) Egg Dropping
6) Scramble String

Format for MCM:
Given String/Array from i to j, select different values of k such that the problem splits into (i,k) and (k+1, j)
for k in range i...j,
  find temp_ans(k) using f(i,k) & f(k+1, j)
f(i,j) using all temp_ans(k)

func solve(arr: [Int], i: Int, j: Int) -> SomeReturnType {
 // Base condition: think of smallest valid i/p, or invalid i/p
 if i >= j { return 0 }
 ans = 0
 // Loop over the range, and pick different k
 for k in i..<j {
   // calculate temporary answer
   temp_ans = SomeFunc(solve(arr, i, k), solve(arr, k+1, j))
   ans = SomeOtherFunc(temp_ans)
 }
 return ans
}
 
*/

/* MCM Using Recursion:
Given arr: [40, 20, 30, 10, 30], find the minimum cost of multiplying these metrices
Explanation:
Here, Ai = arr[i-1]*arr[i]
so the metrics are A1=40*20, A2=20*30, A3=30*10, A4=10*30, and we need to find the
split that produces the minimum cost from all combinations: ((A1*A2)(A3*A4)) or
((A1*A2*A3)*A4) and so on.

cost of multiplication = number of multiplication that we need to do
Some basics on MCM:
A1= a*b, A2= c*d can only be multiplied if, b == c
and resulting matrics will be of size a*d
and cost of this multiplication will be a*b*d (or a*c*d since b==c)

Format:
1) Figure out i and j values
2) Figure out the base condition based on i & j
3) Figure out the k loop
4) Caculate temporary answer
5) Use all temporary answers to find the final answer

for our case, i will be 1 (not 0) so that Ai = arr[i-1]*arr[i] = arr[0]*arr[1]
same way, j will be the last index

base condition: here, i and j cant be the same, else that will mean just 1 element in the metric
to determine the range of k:
k can range from i to (j-1), and we can solve for (i,k) (k+1,j)
so when k=i, first partition will be just A1, and remaining all metrices will be together
and when k=j-1, last partition will be just A4, and remaining all metrices will be together

now lets say we have done (A1*A2) and (A3*A4), so finally we got
(40*30) (30*30) as temp results, so the final multiplication cost will be
40 * 30 * 30 -> i.e arr[i-1]*arr[k]*arr[j]
*/

func MCMUsingRecursion(arr: [Int], i: Int, j: Int) -> Int {
  if i >= j {
    return 0
  }
  var ans = Int.max
  for k in i..<j {
    let temp_ans =
      MCMUsingRecursion(arr: arr, i: i, j: k)
    + MCMUsingRecursion(arr: arr, i: k+1, j: j)
    + arr[i-1]*arr[k]*arr[j] // cost of multiplying 2 partitions
    ans = min(ans, temp_ans)
  }
  
  return ans
}
               
let arr = [40,20,30,10,30]
let start1 = CFAbsoluteTimeGetCurrent()
MCMUsingRecursion(arr: arr, i: 1, j: arr.count-1)
let diff1 = CFAbsoluteTimeGetCurrent() - start1
print("time for recursion: \(diff1)")

/* MCM using Memoization:
Since i and j are the only changing input of the solve function, we can create a 2d
 cache based using i, and j.
Max values for i and j can be count of array, so, we can create t[i][j] of size
 t[n+1][n+1]
*/
var t: [[Int]] = Array(repeating: Array(repeating: -1, count: arr.count+1), count: arr.count + 1)
func MCMUsingMemoization(arr: [Int], i: Int, j: Int) -> Int {
  if i >= j {
    return 0
  }
  if t[i][j] != -1 {
    return t[i][j]
  }
  var ans = Int.max
  for k in i..<j {
    let temp_ans =
      MCMUsingRecursion(arr: arr, i: i, j: k)
    + MCMUsingRecursion(arr: arr, i: k+1, j: j)
    + arr[i-1]*arr[k]*arr[j] // cost of multiplying 2 partitions
    ans = min(ans, temp_ans)
  }
  t[i][j] = ans
  return ans
}

let start2 = CFAbsoluteTimeGetCurrent()
MCMUsingMemoization(arr: arr, i: 1, j: arr.count-1)
let diff2 = CFAbsoluteTimeGetCurrent() - start2
print("time for memoization: \(diff2)")

/* Palindrome Partitioning: Given a string s, find the minimum partitions that you need to make so that each substring is a palindrome
 exp. I/P: s = nitik
 O/P: 2 , n|iti|k
 
 I/P: s = nitin
 O/P: 0 since string is already a palindrome
 
 I/P: s = rushi
 O/P: 4, r|u|s|h|i
 
 Explanation: Worst case scenario, we need to make len(s)-1 partitions since only palindrome substring is each character itself
 now, here following the MCM format, we are given array/string,
 lets find i, and j. That can be the start and end of the string
 and for k, we can start with i, and go all the way till j-1, and then we can partion the string as (i, k) & (k+1, j)
 
 n i t i k    In this case, the partion will be (i,k) = n, (k+1, j) = itik
 i       j
 k
 
 n i t i k    In this case, the partion will be (i,k) = niti, (k+1, j) = k
 i       j
       k
 
Base condition: if i == j, so return 0 since its just 1 character, if i>j then return 0 since its "" string
Also, if the string is palidrome, we need to return 0.
  
so palindromePartition function will basically mean, finding minimum number of ways to palindrom partition string s from i to j
 
n i | t i k
 
s1  1  s2 => temp = s1(ni)+1+s2(tik)
 */
func palindromePartition(s: String, i: Int, j: Int) -> Int {
  var ans = Int.max
  
  //Base condition:
  if i >= j {
    return 0
  }
  if(isPalindrome(s: s, i: i, j: j)) {
    return 0
  }
  
  for k in i..<j {
    let temp =
      1 // This is because of the existing parition that we are making at k
      + palindromePartition(s: s, i: i, j: k)
      + palindromePartition(s: s, i: k+1, j: j)
    ans = min(ans, temp)
  }
  return ans
}

// To check if the string s is palindrome from i to j
func isPalindrome(s: String, i: Int, j: Int) -> Bool {
  if i == j {
    return true //One character string
  }
  if i > j {
    return true //empty string
  }
  var i = i
  var j = j
  while i < j {
    if s[i] != s[j] {
      return false
    }
    i += 1
    j -= 1
  }
  return true
}

let str = "nitik"
let start3 = CFAbsoluteTimeGetCurrent()
print(palindromePartition(s: str, i: 0, j: str.count-1))
let diff3 = CFAbsoluteTimeGetCurrent() - start3
print("time for recursion: \(diff3)")

/* Palindrome Partitioning with memoization:
 Since i and j are the only changing input in the function, we can make a metrics using that
 the limit of i and j will be length of string s
 t[i][j] of size t[n+1][n+1]
 */

let n = str.count
var t1: [[Int]] = Array(repeating: Array(repeating: -1, count: n+1), count: n+1)
func palindromePartitionWithMemoization(s: String, i: Int, j: Int) -> Int {
  
  var ans = Int.max
  if(i >= j ) || isPalindrome(s: s, i: i, j: j) {
    return 0
  }
  
  if(t1[i][j] != -1) {
     return t1[i][j]  //returning the already stored value from cache
  }
  
  for k in i..<j {
    let temp = 1
      + palindromePartitionWithMemoization(s: s, i: i, j: k)
      + palindromePartitionWithMemoization(s: s, i: k+1, j: j)
    // One more optimization is to check if these 2 function calls are in the the t metrics, if yes, then directly use the value here
    ans = min(ans, temp)
  }
  
  t1[i][j] = ans
  return ans
}

let start4 = CFAbsoluteTimeGetCurrent()
print(palindromePartitionWithMemoization(s: str, i: 0, j: str.count-1))
let diff4 = CFAbsoluteTimeGetCurrent() - start4
print("time for memoization: \(diff4)")

/* Boolean Parenthesis: Evaluate expression to be true
 Count the number of ways we can parenthesize the expression so that the value of expression evaluates to true.
 Let the input be in form of two arrays one contains the symbols (T and F) in order and the other contains operators (&, | and ^}
 
 Input: symbol[]    = {T, F, T}
        operator[]  = {^, &}
 Output: 2
 two ways "((T ^ F) & T)" and "(T ^ (F & T))"

 Explanation: How its MCM: Given Array or string, we are partitioning it into different slots, using parenthesis so that the expression becomes
 T OP F OP T
 i  k      j
 Some constraints: this above string will start and end with symbols, and will have operator in between in alternate positions. Otherwise the expressions become invalid
so here partition can only happen if both expressions are valid.
i and j can be start and end of the expression: No issues
for k, it cant be at i=k, because then (i,k) = T and (k+1, j) = (OP F OP T) -> Invalid
 T OP F OP T
 i         j
 k
so k will start with i+1 and end at j-1, and increment by 2, not 1, i.e we can only partition expression with operators, not symbols
also, the partition will be then, (i, k-1) (k+1, j)

Base condition:
if i == j, i.e just one symbol, then the ans depends on if the symbol is T or F
if i > j -> return 0, i.e if just "" string, then it cant be true

so if you notice, we cant just work with i and j, we need one more bool(T/F) at each stage to get the answer? -> Why?
well,
1) a^b = true if, (a=t, b=f) or if (a=f, b=t)
2) a||b = true if, (a=t, b=f) or (a=f, b=t) or (a=t, b=t)
3) a&b = true if, (a=t, b=t)
so we also need some expressions/partitions to be evaluated to False, and thats why we need i, j, and bool evaluateTo.

 number of ways (a=t, b=f) can happen is the multiplication of those 2, so if a=t for 2 cases, and b=f for 3 cases, then total 6 combinations will give (a=t, b=f)
a   b
t   f
t   f
    f
 */

func booleanParenthesis(symbol: [Character], op: [Character], i: Int, j: Int, memoization: Bool = false) -> Int {
  guard op.count == symbol.count - 1 else {
    return -1
  }
  var s: String = ""
  for i in 0..<symbol.count {
    s.append(symbol[i])
    if i < op.count { s.append(op[i]) }
  }
  print("Final expression", s)
  return memoization
    ? booleanParenthesisWithMemizationFor(str: s, i: i, j: j, evaluateTo: "T")
    : booleanParenthesisFor(str: s, i: i, j: j, evaluateTo: "T")
}

func booleanParenthesisFor(str: String, i: Int, j: Int, evaluateTo: Character) -> Int {

  // Base condition:
  if i > j  { //empty string ("")
    return 0
  }
  if i == j { // just one symbol (T/F)
    return str[i] == evaluateTo ? 1: 0
  }
  
  var ans = 0
  for k in stride(from: i+1, through: j-1, by: 2) {
    let leftTrue = booleanParenthesisFor(str: str, i: i, j: k-1, evaluateTo: "T")
    let rightTrue = booleanParenthesisFor(str: str, i: k+1, j: j, evaluateTo: "T")
    let leftFalse = booleanParenthesisFor(str: str, i: i, j: k-1, evaluateTo: "F")
    let rightFalse = booleanParenthesisFor(str: str, i: k+1, j: j, evaluateTo: "F")
  
    switch str[k] {
    case "^":
      if evaluateTo == "T" {
        //left XOR right = true if (left true, right false) or (left false, right true)
        ans += (leftTrue * rightFalse) + (leftFalse * rightTrue)
      } else {
        //left XOR right = false if (left true, right true) or (left false, right false)
        ans += (leftTrue * rightTrue) + (leftFalse * rightFalse)
      }
    
    case "&":
      if evaluateTo == "T" {
        //left & right = true if (left true, right true)
        ans += (leftTrue * rightTrue)
      } else {
        //left & right = false if (left true, right false) or (left false, right true) or (left false, right false)
        ans += (leftFalse * rightFalse) + (leftFalse * rightTrue) + (leftTrue * rightFalse)
      }
      
    case "|":
      if evaluateTo == "T" {
        //left || right = true if (left true, right true), (left true, right false) or (left false, right true)
        ans += (leftTrue * rightTrue) + (leftFalse * rightTrue) + (leftTrue * rightFalse)
      } else {
        //left || right = false if (left false, right false)
        ans += (leftFalse * rightFalse)
      }
      
    default:
      return -1
    }
  }

  return ans
}

let symbols: [Character] = ["T", "T", "F", "T"]
let operators: [Character] = ["|", "&", "^"]
print("# of ways:", booleanParenthesis(symbol: symbols, op: operators, i: 0, j: symbols.count + operators.count - 1))


/* Boolean Parenthesis with memoization:
 Since here 3 variables are changing, i, j and evaluateTo, we can have a 3D metrix, like below:
 t[i][j][evaluateTo] = t[str.count+1][str.count+1][2] (2 for T & F)
 
 if it gets difficult to imagine the 3D metix, we can also have a map to store the temp results:
 key of the map will be comprised of 3 changing variables.
 map[i+"_"+j+"_"+evaluteTo] = value
 
 */
var str_count = symbols.count + operators.count - 1
var t3: [[[Int]]] = Array(repeating: Array(repeating: Array(repeating: -1, count: 2), count: str_count+1), count: str_count+1)

func booleanParenthesisWithMemizationFor(str: String, i: Int, j: Int, evaluateTo: Character) -> Int {
  print("i j", i, j)
  if i > j {
    return 0
  }
  if i == j {
    return str[i] == evaluateTo ? 1 : 0
  }
  
  if t3[i][j][evaluateTo == "T" ? 1 : 0] != -1 {
    return t3[i][j][evaluateTo == "T" ? 1 : 0]
  }
  
  var ans = 0
  for k in stride(from: i+1, through: j-1, by: 2) {
    let leftTrue = booleanParenthesisFor(str: str, i: i, j: k-1, evaluateTo: "T")
    let rightTrue = booleanParenthesisFor(str: str, i: k+1, j: j, evaluateTo: "T")
    let leftFalse = booleanParenthesisFor(str: str, i: i, j: k-1, evaluateTo: "F")
    let rightFalse = booleanParenthesisFor(str: str, i: k+1, j: j, evaluateTo: "F")
  
    switch str[k] {
    case "^":
      if evaluateTo == "T" {
        //left XOR right = true if (left true, right false) or (left false, right true)
        ans += (leftTrue * rightFalse) + (leftFalse * rightTrue)
      } else {
        //left XOR right = false if (left true, right true) or (left false, right false)
        ans += (leftTrue * rightTrue) + (leftFalse * rightFalse)
      }
    
    case "&":
      if evaluateTo == "T" {
        //left & right = true if (left true, right true)
        ans += (leftTrue * rightTrue)
      } else {
        //left & right = false if (left true, right false) or (left false, right true) or (left false, right false)
        ans += (leftFalse * rightFalse) + (leftFalse * rightTrue) + (leftTrue * rightFalse)
      }
      
    case "|":
      if evaluateTo == "T" {
        //left || right = true if (left true, right true), (left true, right false) or (left false, right true)
        ans += (leftTrue * rightTrue) + (leftFalse * rightTrue) + (leftTrue * rightFalse)
      } else {
        //left || right = false if (left false, right false)
        ans += (leftFalse * rightFalse)
      }
      
    default:
      return -1
    }
  }
  
  t3[i][j][evaluateTo == "T" ? 1 : 0] = ans
  return ans
}

print("# of ways with memoization:", booleanParenthesis(symbol: symbols, op: operators, i: 0, j: str_count, memoization: true))


/* Egg Dropping Problem: What is the minimum no of eggs required to identify the maximum no of floors (Worst Case Scenario) from where the eggs do not break if dropped from there?

 we are finding The least amount of egg drops needed to find threshold and not the threshold floor itself.
 I/P: f: 5, e: 3
 O/P: 3
 
 Explanation: Simplest solution if you are only given 1 egg, then you will start from floor 1, and keep going up till you reach the threshold floor, so worst case, it will take f tries at minimum with 1 egg.
 Since we are given e eggs, we can start with selecting a k somewhere in the middle, and then checking the 2 cases:
 1 .  . k . . f
 
 Dropping the egg from here, there are 2 cases:
 1) Egg breaks: Means threshold floor is between 1<->k-1, and only e-1 eggs left to find it
 2) Egg doesnt break: Means threshold floor is between k+1<->f and still e aggs left to find it
 
 Why MCM? Well, given f, we can see that we need to make array from floor 1 to f, and find a floor k in between, such that the tries are minimum for the worst case scenario
Base condition:
f: 0 // return 0
f: 1 // return 1
e: 0 // Not possible to find ans here, if no eggs
e: 1 // return f, since you will go up one-by-one from floor 1.
*/

func eggDropping(f: Int, e: Int, memoization: Bool = false) -> Int {
  var arr: [Int] = []
  for i in 1...f {
    arr.append(i)
  }
  return memoization
  ? eggDroppingWithMemoization(arr: arr, e: e, f: f)
  :eggDroppingSolve(for: arr, e: e, f: f)
}

func eggDroppingSolve(for arr: [Int], e: Int, f: Int) -> Int {
  var ans = Int.max
  
  //Base conditions
  if f <= 1 || e == 1 {
    return f
  }

  for k in 1...f {
    let temp = 1  // current try
      + max(
        eggDroppingSolve(for: arr, e: e-1, f: k-1), //Need to check for k-1 floors below k
        eggDroppingSolve(for: arr, e: e, f: f-k) //Need to check for f-k floors above k
      )
    ans = min(ans, temp)
  }
  return ans
}
  
eggDropping(f: 5, e: 3, memoization: false)

/* Egg dropping problem with memoization
Since e and f are the only changing variables in the function, we can create t[e][f]
the maximum value of e and f can be obtained from the constraints in the question:
 0 < e < 10
 f < 50
 for something like that:
 t[e][f] = t[11][51]
 */


var t4: [[Int]] = Array(repeating: Array(repeating: -1, count: 51), count: 11)
func eggDroppingWithMemoization(arr: [Int], e: Int, f: Int) -> Int {
  var ans = Int.max
  
  //Base conditions
  if f <= 1 || e == 1 {
    return f
  }

  if t4[e][f] != -1 {  //check in the cache first
    return t4[e][f]
  }
  
  for k in 1...f {
    let temp = 1  // current try
      + max(
        eggDroppingSolve(for: arr, e: e-1, f: k-1), //Need to check for k-1 floors below k
        eggDroppingSolve(for: arr, e: e, f: f-k) //Need to check for f-k floors above k
      )
    ans = min(ans, temp)
  }
  t4[e][f] = ans
  return ans
}

eggDropping(f: 5, e: 3, memoization: true)

/* Scrambled Sctring:
 Input: s1 = "great", s2 = "rgeat"
 Output: true
 
 We can scramble a string s to get a string t using the following algorithm:

 If the length of the string is 1, stop.
 If the length of the string is > 1, do the following:
 Split the string into two non-empty substrings at a random index, i.e., if the string is s, divide it to x and y where s = x + y.
 Randomly decide to swap the two substrings or to keep them in the same order. i.e., after this step, s may become s = x + y or s = y + x.
 Apply step 1 recursively on each of the two substrings x and y.
 Given two strings s1 and s2 of the same length, return true if s2 is a scrambled string of s1, otherwise, return false.
 
 s: A + B
 t: C + D
 for s<==>t to happen,
 condition1: Swap happened: A<==>D && B<==>C
 condition2: Swap didnt happen: A<==>C && B<==>D
 
 Base condition:
 if lenght of s & t are different, then return false, as not scrambled strings
 if length of the string is <= 1, then its scrambled string, return true
 
 Why MCM? Given a string, we are going through it and at each step, partitioning it using k, and checking for smaller problems
 */

func scrambledString(s: String, t: String) -> Bool {
  var ans = false
  
  // Base condition:
  if s == t {
    return true
  }
  if s.count <= 1  { //or t.count <= 1, since both count are same but strings are different. i.e. a, b
    return false
  }
  
  for k in 1..<s.count {
    let s1: String = String(s.prefix(k))
    let s2: String = String(s.suffix(from: s.index(s.startIndex, offsetBy: k)))
    print(s1, s2)
    
    let t1: String = String(t.prefix(k))
    let t2: String = String(t.suffix(from: t.index(t.startIndex, offsetBy: k)))
    print(t1, t2)
    
    if (scrambledString(s: s1 , t: t2) && scrambledString(s: s2 , t: t1))
        || (scrambledString(s: s1 , t: t1) && scrambledString(s: s2 , t: t2)) {
      ans = true
      break
    }
  }
  return ans
}

var a = "great"
var b = "rgeat"
scrambledString(s: a, t: b)

/* Scrambled String with Memoization:
 since here s and t are strings, we cant use them as an array index, so 2d array wont work
 Therefore we are creating a map using s and t values are keys
 */
var map: [String: Bool] = [:]

func scrambledStringWithMemoization(s: String, t: String) -> Bool {
  var ans = false
  
  // Base condition:
  if s.count != t.count {
    return false
  }
  if s == t {
    return true
  }
  if s.count <= 1  { //or t.count <= 1, since both count are same but strings are different. i.e. a, b
    return false
  }
  
  let key = s + "_" + t
  if map[key] != nil {
    return map[key] ?? false
  }
  
  for k in 1..<s.count {
    let s1: String = String(s.prefix(k))
    let s2: String = String(s.suffix(from: s.index(s.startIndex, offsetBy: k)))
    print(s1, s2)
    
    let t1: String = String(t.prefix(k))
    let t2: String = String(t.suffix(from: t.index(t.startIndex, offsetBy: k)))
    print(t1, t2)
    
    if (scrambledString(s: s1 , t: t2) && scrambledString(s: s2 , t: t1))
        || (scrambledString(s: s1 , t: t1) && scrambledString(s: s2 , t: t2)) {
      ans = true
      break
      // One more optimization is to check if these 4 function calls are in the the t metrics, if yes, then directly use the value here
    }
  }
  map[key] = ans
  return ans
}

scrambledStringWithMemoization(s: a, t: b)
