import Foundation
public struct Stack<T> {
  private var arr: [T] = []
  
  init(arr: [T] = []) {
    self.arr = arr
  }
  
  public var isEmpty: Bool {
    arr.isEmpty
  }
  
  public var count: Int {
    arr.count
  }
  
  public mutating func push(element: T) {
    arr.append(element)
  }
  
  public mutating func pop() -> T? {
    arr.removeLast()
  }
  
  public mutating func top() -> T? {
    arr.last
  }
}


/* Recursion:
How to solve it:
Given Choices, Take decisions and as a result, Input gets smaller
Methods:
1) Input/Output method: Make Recursive tree of these decisions, once this decision tree is made, its easy to write the code
example: find all subset of "ab"
 op: ""
 ip: "ab"
 
          op      |    ip
          ""      |    "ab"
(take a) /                \ (dont take a)
        /                  \
    "a"|"b"               ""|"b"
       /\                   /\
      /  \         (take b)/  \(dont take b)
"a"|""   "ab"|""       "b"|""   ""|""    // I/P empty, lead nodes = final Output
      
There's also an extended I/P O/P method where we use other variables along with I/P to make decisions about O/P
 
2) IBH method: Base condition, Hypohtesis, Induction: Use this method to smaller the I/P when decisions/choices are not so clear
 
 Base condition: Smallest valid I/P
 Hypothesis: f(n) will give the required o/p for n, and thats what we want to find.
 so assume that, f(n-1) will give the required o/p for n-1 (smaller i/p).
 Induction: find out f(n) from f(n-1) and n.

 example: print 1 to n using recursion: 1 2 3 4 .. n
 func solve(n) -> void {
    if n == 1 {
      print("1")
      return
    }           // Base condition
    solve(n-1)  // hypothesis, smaller I/P
    print(" ") |// Induction
    print(n)   |//
 }
 
 example: height of a binary tree
 func height(node: Node?) -> Int {
    if node == nil {
      return 0
    }           // Base condition, empty node
    let lh = height(node.left)  // hypothesis, smaller I/P
    let rh = height(node.right) // hypothesis, smaller I/P
    
    return 1 + max(lh, rh) // Induction
 }
 
3) Choice Diagram  - DP //TBD

Generally easy problems will be handled by IBH method
medium problems will require I/P-O/P method
hard probles will require choice diagram
*/

/* ----------------------IBH Method---------------*/


/* Problem 1: Sort an array using recursion */
func sortArrayUsingRecursion(arr: [Int]) -> [Int] {
  guard !arr.isEmpty else { return arr }
  var arr = arr
  sortArr(arr: &arr)
  return arr
}

// sorts the given array
func sortArr(arr: inout [Int]) {
  if arr.count == 1 {
    return  //Base condition, already sorted since just 1 element
  }
  let last = arr.removeLast() //Smaller i/p
  sortArr(arr: &arr)          // Hypothesis
  insert(arr: &arr, element: last) //Induction
}

// inserts the element at correct place in a sorted array
// ip: [0,1,5] , element: 2
func insert(arr: inout [Int], element: Int) {
  guard let lastElement = arr.last,
        lastElement > element else {
    arr.append(element)
    return
  } //Base condition
  
  // take the last element out (5), apply same for [0,1] & 2,
  // append 5 to the output [0,1,2]
  let last = arr.removeLast() //Smaller i/p
  insert(arr: &arr, element: element)  // Hypothesis
  arr.append(last) //Induction
}

var arr = [1,4,2,6,9,0,5]
sortArrayUsingRecursion(arr: arr)

/* Problem2: Sort a stack using recursion: */

func sortStackUsingRecursion(stack: Stack<Int>) -> Stack<Int> {
  guard !stack.isEmpty else { return stack }
  var stack = stack
  sortStack(stack: &stack)
  return stack
}

func sortStack(stack: inout Stack<Int>) {
  if stack.count == 1 { return } //Base condition, already sorted
  let last = stack.pop()
  sortStack(stack: &stack) //smaller I/P
  insert(stack: &stack, element: last!) //Induction
}

// inserts the element at correct place in a sorted stack
// ip: [0,1,5] , element: 2
func insert(stack: inout Stack<Int>, element: Int) {
  guard let top = stack.top(),
        top > element else {
    stack.push(element: element)
    return
  } //Base condition
  
  // take the last element out (5), apply same for [0,1] & 2,
  // push 5 to the output [0,1,2]
  let last = stack.pop() //Smaller i/p
  insert(stack: &stack, element: element)  // Hypothesis
  stack.push(element: last!) //Induction
}

var stack: Stack<Int> = Stack(arr: [1,4,2,6,9,0,5])
sortStackUsingRecursion(stack: stack)

/* Problem 3: Delete middle element of the stack:
 Given stack of size k, delete (k/2 + 1)th element from top
 i.e [1,2,3,4,5] -> 3rd element from top
 [1,2,3,4,5,6] -> 4th element from top
 */
func deleteMiddleElement(of stack: Stack<Int>) -> Stack<Int> {
  guard stack.count > 1 else { return stack }
  let k: Int = stack.count/2 + 1
  var stack = stack
  delete(stack: &stack, index: k)
  return stack
}

// delete index th element from the top
func delete(stack: inout Stack<Int>, index: Int) {
  if index == 1 {
    stack.pop()
    return
  } //Base condition
  
  guard let last = stack.pop() else { return } //smaller I/P
  delete(stack: &stack, index: index - 1) //Hypothesis
  stack.push(element: last) //Induction
}

deleteMiddleElement(of: stack)

/* Problem 4: Reverse a Stack using recursion:*/

func reverseStack(stack: Stack<Int>) -> Stack<Int> {
  var stack = stack
  guard stack.count > 1 else {
    // stack already sorted
    return stack
  }
  reverse(stack: &stack)
  return stack
}

func reverse(stack: inout Stack<Int>) {
  if stack.count == 1 {
    return
  } //Base condition
 
  let last = stack.pop() //smaller I/P
  reverse(stack: &stack) // Hypothesis
  insertAtFirst(stack: &stack, element: last!) //Induction
}

// Insert element at the first index of the stack
func insertAtFirst(stack: inout Stack<Int>, element: Int) {
  if stack.isEmpty {
    stack.push(element: element)
    return
  } // Base condition
  
  let temp = stack.pop() //small i/p
  insertAtFirst(stack: &stack, element: element) //hypothesis
  stack.push(element: temp!) //induction
}

reverseStack(stack: stack)

/* Problem 5: Kth symbol in grammar:
 We build a table of n rows (1-indexed). We start by writing 0 in the 1st row. Now in every subsequent row, we look at the previous row and replace each occurrence of 0 with 01, and each occurrence of 1 with 10.

 For example, for n = 3, the 1st row is 0, the 2nd row is 01, and the 3rd row is 0110.
 Given two integer n and k, return the kth (1-indexed) symbol in the nth row of a table of n rows.
 Example:
 Input: n = 2, k = 1
 Output: 0
 Explanation:
 row 1: 0
 row 2: 01
 
 Explanation:
 As you can see, here is what the table looks like:
     count
 n=1   1   0
 n=2   2   0 1
 n=3   4   0 1 1 0
 n=4   8   0 1 1 0 1 0 0 1
 n=5   16  0 1 1 0 1 0 0 1 1 0 0 1 0 1 1 0
 if you notice, the count at each step is 2^n, and first half remains the same for n and n-1, and remaining part is just the opposite digits of the same
 k shouldnt be more than 2^n - 1 for any row n
 
 Note that here n and k are 1 index based
 so first row first col is 1,1
*/

func kthSymbol(_ n: Int, _ k: Int) -> Int {
  let cols: Int = (pow(2, n-1) as NSDecimalNumber).intValue
  guard k <= cols else { return -1 }
  if n == 1 && k == 1 {
    return 0
  } //Base condition

  let mid: Int = cols/2
  print(n, k, mid)
  
  if k <= mid {
    //First half, same as n-1 row
    return kthSymbol(n-1, k) //Smaller I/P
  } else {
    //Second half, opposite of first half
    return toggle(k: kthSymbol(n-1, k - mid)) //Smaller I/P
  }
}

func toggle(k: Int) -> Int {
  switch k {
  case 0:
    return 1
  case 1:
    return 0
  default:
    return k
  }
}

kthSymbol(4,6)
kthSymbol(5,12)
kthSymbol(4,12)

/* Problem 6: Tower of Hanoi
 Input : 2
 Output : Disk 1 moved from A to B
          Disk 2 moved from A to C
          Disk 1 moved from B to C

 Input : 3
 Output : Disk 1 moved from A to C
          Disk 2 moved from A to B
          Disk 1 moved from C to B
          Disk 3 moved from A to C
          Disk 1 moved from B to A
          Disk 2 moved from B to C
          Disk 1 moved from A to C
 */

func towerOfHanoi(n: Int) {
  guard n > 0 else {
    print(" ")
    return
  }
  solve(source: "A", destination: "C", helper: "B", n: n)
}

func solve(source: String, destination: String, helper: String, n: Int) {
  if n == 1 {
    print("Move disc \(n) from \(source) to \(destination)")
    return
  } // Base condition
  
  solve(source: source, destination: helper, helper: destination, n: n - 1) // Smaller I/P, Hypothesis
  print("Move disc \(n) from \(source) to \(destination)")
  solve(source: helper, destination: destination, helper: source, n: n - 1) // Induction
}

towerOfHanoi(n: 3)

/* Problem 7: Josephus problem: Circle of death:
I/P: n = 40, k = 7
O/P: 24
Explanation: each time, the counting begins from current person including himself, and the kth person will be shot
if we use the IBH method, we can try with smaller I/P
here, if we will be using array and % operator to represent the circle
and since kth person will be at k-1 index, we need to always use
 k = k-1
Also, here during the hypothesis step, we cant just randomly take n-1 as smaller input,
 what if the last person that we removed was the answer,
 so, here we will remove the follwing index:
 index = index + k % n
 
 And therefore, since that person is not going to be used anymore, we dont need to do anything in induction step
*/

func josephusProblem(n: Int, k: Int) -> Int {
  //lets first create an array with n numbers
  var arr: [Int] = []
  for i in 1...n {
    arr.append(i)
  }
  
  let k = k-1 //explained above
  var ans: Int = -1 //index of final person alive
  let index: Int = 0 //Person with a sword
  solve(arr: &arr, k: k, index: index, ans: &ans)
  return ans
}

func solve(arr: inout [Int], k: Int, index: Int, ans: inout Int) {
  if arr.count == 1 {
    ans = arr.first!
    return
  } //Base condition, only one element in array
  
  let index = (index + k) % arr.count
  arr.remove(at: index) // Smaller I/P
  
  //since the person at index position died, the new person on the same index will now carry the sword
  solve(arr: &arr, k: k, index: index, ans: &ans) //Hypothesis
  
  //No Induction.
}

josephusProblem(n: 40, k: 7)



/* ----------------------I/P O/P  Method---------------*/


/* Problem 8: Print all subsets/subsequences/powersets
Explanation:  here all subsets = powerset
but subsequence is a bit different
subset: irrepsetive of order/continuity i.e ac or ca both are subset of abcde {a,c} or {c,a}
subsequence: in order, i.e ace is subsequence for abcde
substring: continuous, i.e abc is substring for abcde
powerset: Set of all subsets
 
so all subsequences, for ab
 "", "a", "b", "ab"

 all subsets, for ab
 {}, {a}, {b}, {a,b} (or {b,a})
 
 so they both match, subset will have some more entries, but if we assume that order doesnt matter, then it becomes the same as subsequnce
 
*/
func printSunsets(str: String) {
  guard !str.isEmpty else {
    print(" ")
    return
  }
  let ip = str
  let op = ""
  solveSubsets(ip: ip, op: op)
}

func solveSubsets(ip: String, op: String) {
  var ip = ip
  if ip.isEmpty {
    print("subset: ", op)
    return
  } //Base condition, leaf node
  
  let first = ip.removeFirst()
  let op1 = op + String(first) //choice 1, include letter
  let op2 = op //choice 2, dont include letter
  
  solveSubsets(ip: ip, op: op1)
  solveSubsets(ip: ip, op: op2)
}

printSunsets(str: "ab")

/* Problem 9: print unique subset:
Same as above, but we will use set to store the ans, so we only get unique subsets
 example: aab
 o/p: "", a, b, ab, aa, aab
*/

func printUniqueSubset(str: String) -> [String] {
  var ans = Set<String>()
  guard !str.isEmpty else {
    return []
  }
  let ip = str
  let op = ""
  solveUniqueSubset(ip: ip, op: op, ans: &ans)
  return Array(ans)
}

func solveUniqueSubset(ip: String, op: String, ans: inout Set<String>) {
  var ip = ip
  if ip.isEmpty {
    ans.insert(op)
    return
  } //Base condition
  
  let first = ip.removeFirst()
  let op1 = op + String(first)
  let op2 = op
  solveUniqueSubset(ip: ip, op: op1, ans: &ans)
  solveUniqueSubset(ip: ip, op: op2, ans: &ans)
}

print("Unique subsets: ", printUniqueSubset(str: "aab"))

/* Problem 10: Permutation with spaces:
Given a string, print all permutations of space in between characters of the string
i/p: "abc"
o/p: "a bc", "ab c", "a b c", "abc"
Explanation:
first character will go as is (a)
Next character onwards, At each time, we have 2 choices,
"" + next character (b) [No space]
" " + next character ( b) [With space]
*/

func permutationWithSpaces(str: String) {
  guard !str.isEmpty else { return }
  var str = str
  let op = String(str.removeFirst()) //first character always goes as is in output
  let ip = str
  solvePermutationsWithSpaces(ip: ip, op: op)
}

func solvePermutationsWithSpaces(ip: String, op: String) {
  var ip = ip
  if ip.isEmpty {
    print("permutation with spaces:", op)
    return
  } //Base condition, leaf node
  
  let first = String(ip.removeFirst())
  let op1 = op + " " + first
  let op2 = op + first
  solvePermutationsWithSpaces(ip: ip, op: op1)
  solvePermutationsWithSpaces(ip: ip, op: op2)
}

permutationWithSpaces(str: "abc")

/* Problem 11: Permutation with case change:
I/P: "ab"
O/P: "aB", "ab", "Ab", "AB"
Each time we have 2 choices, a smaller case, or an upper case
*/

func permutationWithCaseChange(str: String) {
  guard !str.isEmpty else { return }
  let ip = str
  let op = ""
  solvePermutationsWithCaseChange(ip: ip, op: op)
}

func solvePermutationsWithCaseChange(ip: String, op: String) {
  var ip = ip
  if ip.isEmpty {
    print("permutation with case change:", op)
    return
  } //Base condition
  
  let first = String(ip.removeFirst())
  let op1 = op + first.lowercased()
  let op2 = op + first.uppercased()
  solvePermutationsWithCaseChange(ip: ip, op: op1)
  solvePermutationsWithCaseChange(ip: ip, op: op2)
}

permutationWithCaseChange(str: "ab")

/* Problem 12: Letter case change permutation
I/P: "a1b2"
O/P: "a1B2", "a1b2", "A1b2", "A1B2"
Each time we have 2 choices, a smaller case, or an upper case letter
but if the incoming character is digit, then include in the output as is
*/

func permutationWithCaseDigit(str: String) {
  guard !str.isEmpty else { return }
  let ip = str
  let op = ""
  solvePermutationWithCaseDigit(ip: ip, op: op)
}

func solvePermutationWithCaseDigit(ip: String, op: String) {
  var ip = ip
  if ip.isEmpty {
    print("permutation with case digit:", op)
    return
  } //Base condition
  
  let first = String(ip.removeFirst())
  if Int(first) != nil {
    //first is a digit
    let op1 = op + first
    solvePermutationWithCaseDigit(ip: ip, op: op1)
  } else {
    //first is a letter
    let op1 = op + first.uppercased()
    let op2 = op + first.lowercased()
    solvePermutationWithCaseDigit(ip: ip, op: op1)
    solvePermutationWithCaseDigit(ip: ip, op: op2)
  }
}

permutationWithCaseDigit(str: "a1b2")


/* ------------------ Extended I/P O/P Method ---------- */

/* Problem 13: Generate all balanced parentesis:
I/P: n=2
O/P: {{}}, {}{}
*/

func generateBalancedParenthesis(n: Int) -> [String] {
  var ans: [String] = []
  guard n > 0 else { return ans}
  let op = "{" //First can only be open
  let open = n - 1 //#of open brackets left in I/P
  let close = n //#of close brackets left in I/P
  solve(open: open, close: close, op: op, ans: &ans)
  return ans
}

func solve(open: Int, close: Int, op: String, ans: inout [String]) {
  if open == 0 && close == 0 {
    ans.append(op)
    return
  } //Base condition, when I/P gets 0
  
  if open != 0 {  //Open can always be picked
    let op1 = op + "{"
    solve(open: open - 1, close: close, op: op1, ans: &ans)
  }
  
  if open < close { //Close can only be picked when count of open < count of close
    let op2 = op + "}"
    solve(open: open, close: close - 1, op: op2, ans: &ans)
  }
}

generateBalancedParenthesis(n: 3)

/* Problem 14: Print N-bit binary numbers having equal or more 1s than 0s for any prefix:
 Given a positive integer n, print all n-bit binary numbers having >= 1’s than 0’s for any prefix of the number.

 Examples:

 Input : n = 2
 Output : 11 10

 Input : n = 4
 Output : 1111 1110 1101 1100 1011 1010
 
Explanation: more 1s than 0s for any prefix means at each digit,
 we can always pick 1
 but we can only pick 0 if there are more 1s before
 */

func printBinaryNumberWithMore1s(for n: Int) {
  guard n > 0 else { return }
  let op = "1"
  let ones = 1 //#of 1s in output
  let zeros = 0 //#of 0s in output
  solveBinaryNumbers(ones: ones, zeros: zeros, n: n-1, op: op)
}

func solveBinaryNumbers(ones: Int, zeros: Int, n: Int, op: String) {
  if n == 0 {
    print("output:", op)
    return
  } //Base condition, when no more digits left
  
  if n > 0 {
    let op1 = op + "1"
    solveBinaryNumbers(ones: ones+1, zeros: zeros, n: n-1, op: op1)
  }
  
  if ones > zeros {
    let op2 = op + "0"
    solveBinaryNumbers(ones: ones, zeros: zeros+1, n: n-1, op: op2)
  }
}

printBinaryNumberWithMore1s(for: 4)
