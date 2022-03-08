import Foundation
import CoreGraphics

public struct Stack<T> {
  private var arr: [T] = []
  
  init(arr: [T] = []) {
    self.arr = arr
  }
  
  public var isEmpty: Bool {
    arr.isEmpty
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

/* Stack problems:
 1) Nearest greater/smaller to left/right (Next/Previous Largest/Smallest Element)
 2) Stock span problem
 3) Maximum area of historgram
 4) Maximum area rectangle in binary matrix
 5) Rain water trapping
 6) Implement a min stack (with and without extra space)
 7) Implement stack using heap
 8) The celebrity problem
 9) Longest valid parenthesis
 10) Iterative Tower of Hanoi
 
 Concept: Identification:
 -> Most of the questions are based on Array or string
 -> Brute force of O(n^2) solution using "dependent" for loops:
 for i in 0..<n {
    for j in i..<n {
      // here j is dependent on i
      // j can be any func of i, and run from 0...i, or i...0, or i...n, or n...i
    }
 }
 For such questions, we can always find a better solution using stack, with liner complexity
 
 And ALWAYS, while using the stack, start traversal from the opposite direction of the 2 for loops of brute force, i.e
 if for Brute Force solution,  i from 0..n and j from i...n,
 for ....>
   for .....>
 
 then while using stack, i from n...0
 for <....
 
 */

/* Problem 1: Nearest greater/smaller to left/right:
Given an array, return an array indicating nearest greater/smaller element to the left/right
example: arr: [1,3,0,0,1,2,4]
O/P: NGR [3,4,1,1,2,4,-1]

Explanation: for NGR, at any time, we are going to store the right side of the elements in stack,
With stack top always going to be the nearest greater
if not then we keep popping, till
 1) We find the element greater than current, push that to ans array
 2) or stack is empty, push -1 to ans array
Finally add this current element to the stack and move to the prev element in array
 
*/

enum Side { case right, left }
enum Property { case greater, smaller }
enum AnswerFormat { case element, index }

func nearestElement(in arr: [Int], to side: Side, with property: Property, ansFormat: AnswerFormat = .element) -> [Int] {
  guard arr.count > 0 else { return [] }
  var resultElements: [Int] = []
  var resultIndices: [Int] = []
  var stack: Stack<(Int, Int)> = Stack()  // Pair to track element and its index both, element at 0, and index at 1
  let comparisonClosure: (Int, Int) -> Bool = { p1,p2 in
    switch property {
    case .greater:
      return p1 <= p2
    case .smaller:
      return p1 >= p2
    }
  }
  
  var strideRange: StrideThrough<Int> {
    switch side {
    case .left:
      return stride(from: 0, through: arr.count - 1, by: 1) // run the loop from 0 to n
    case .right:
      return stride(from: arr.count-1, through: 0, by: -1) // run the loop from n to 0
    }
  }
  
  for i in strideRange {
    if stack.isEmpty { //If stack is empty, append -1 in result
      resultElements.append(-1)
      resultIndices.append(-1)
    } else {
      while let top = stack.top(), comparisonClosure(top.0, arr[i]) { //While the condition is not met, keep popping
        stack.pop()
      }
      resultElements.append(stack.top()?.0 ?? -1) //Finally append the stack top element in result
      resultIndices.append(stack.top()?.1 ?? -1) //Finally append the stack top index in result
    }
    stack.push(element: (arr[i], i)) //Always add new element and its index to the stack
  }

  // Reverse the result for right side elements, keep it as is for left side elements
  return side == .right
  ? (ansFormat == .element ? resultElements.reversed() : resultIndices.reversed())
  : ((ansFormat == .element) ? resultElements : resultIndices)
}

nearestElement(in: [1,3,0,0,1,2,4], to: .right, with: .greater)
nearestElement(in: [1,3,0,0,1,2,4], to: .right, with: .greater, ansFormat: .index)
nearestElement(in: [1,3,2,5,4,2,3], to: .right, with: .smaller)
nearestElement(in: [1,3,0,0,1,2,4], to: .left, with: .greater)
nearestElement(in: [1,3,2,5,4,2,3], to: .left, with: .smaller)
nearestElement(in: [1], to: .left, with: .smaller, ansFormat: .index)
nearestElement(in: [1], to: .right, with: .smaller, ansFormat: .index)

/* Stock span problem: Design an algorithm that collects daily price quotes for some stock and returns the span of that stock's price for the current day.
 
 The span of the stock's price today is defined as the maximum number of consecutive days (starting from today and going backward) for which the stock price was less than or equal to today's price.

 For example, if the price of a stock over the next 7 days were [100,80,60,70,60,75,85], then the stock spans would be [1,1,1,2,1,4,6].
 
 Explanation: If you observe, at each index, we are trying to count the number of consecutive elements to its left that smaller than or equal to the current element.
 So for 75, we keep going left, till we reach any element greater than 75 i.e 80 in this case.
 Now, 80 here is the nearest greater element to its left, so we just need to return the index difference of element and its NGL element. i.e index of 75 - index of 80 = 5-1 = 4
 if we cant find the NGL, then return just 1
 
 In order to do that, we need to find the index of NGL, so we need to modify the code a little, and in stack, we can push element and index both each time.
*/

func stockSpan(for arr: [Int]) -> [Int] {
  guard !arr.isEmpty else { return arr }
  let ngl = nearestElement(in: arr, to: .left, with: .greater, ansFormat: .index) // Notice that its index of ngl, not element itself
  var ans: [Int] = []
  for i in 0..<ngl.count {
    if ngl[i] == -1 {
      // No element smaller on left side, so span = 1 (index itself)
      ans.append(1)
    } else {
      // found the ngl element idex, subtract that from current index
      ans.append(i - ngl[i])
    }
  }
  return ans
}
stockSpan(for: [100,80,60,70,60,75,85])

/* Maximum area of a histogram: Largest Rectangle of histogram:
 Given an array of integers heights representing the histogram's bar height where the width of each bar is 1, return the area of the largest rectangle in the histogram.
 
 Input: heights = [2,1,5,6,2,3]
 Output: 10
 Explanation: The above is a histogram where width of each bar is 1.
 The largest rectangle is on bar 5 and 6 height, which has an area = 10 units.(5*1 + 5*1)
 
 Input: heights = [2,4]
 Output: 4
 Explanation: with 2 bars, its going to be 4 (2*1 + 2*1)
 with 1 bar, its 4 (4*1)
 so max is 4.
 
 Explanation: Any building can only be expanded if the surroding buildings are of the same or greater height. so for any height in array, we can merge the consecutive building on left or right till they are >= height of the current building.
 Or in other words, we need to stop as soon as we encounter nearest smaller element to the left and right.
 [2,1,5,6,2,3] -> for 5, the NSL = 1(index of 1) , NSR = 4(index of 2), so we need to consider the width between NSR and NSL index.(so NSR - NSL - 1 i.e 4-1-1 = 2 bars)
 One trick here is: considering the -1 th position and 7th position as ground and assume that their widht is 0.
 so for NSR, if we cant find the index, then instead of considering -1, we will consider it as index being 7 (arr.count-1 + 1)
 same way, for NSL, if we cant find the index, then instead of considering -1, we will consider it as -1 (index being -1)
 
 Now widhth[i] = NSR[i] - NSL[i] - 1
 and we already have height[i] in the input
 so we can find area[i] = width[i] * height[i]
 
 and then we can find max of that area array.
 */

func maxAreaOfHistogram(from heights: [Int]) -> Int {
  guard !heights.isEmpty else { return 0 }
  let nsl = nearestElement(in: heights, to: .left, with: .smaller, ansFormat: .index)
  let nsr = nearestElement(in: heights, to: .right, with: .smaller, ansFormat: .index)
  
  // replace -1 in NSR with last index + 1 (index of right element for last building)
  let right = nsr.map { $0 == -1 ? heights.count : $0 }
  print("right", right)
  
  // replace -1 in NSL with -1 (index of left element for 1st building), so no need
  let left = nsl
  print("left", left)
  
  // Find width array
  let width = zip(right, left).map { $0 - $1 - 1 }
  print("width", width)
  
  // Find area array with height and width
  let area = zip(heights, width).map { $0 * $1 }
  print("area", area)
  
  return area.max() ?? 0
}

maxAreaOfHistogram(from: [2,1,5,6,2,3])
maxAreaOfHistogram(from: [2,4])
maxAreaOfHistogram(from: [2])

/* Maximum area rectangle in Binary matrix:
 Given a binary matrix, find the maximum size rectangle binary-sub-matrix with all 1’s.

 Example:
 Input:
 0 1 1 0
 1 1 1 1
 1 1 1 1
 1 1 0 0
 Output :
 8
 Explanation :
 The largest rectangle with only 1's is from
 (1, 0) to (2, 3) which is
 1 1 1 1
 1 1 1 1
 
 Explanation:
 Here, the problem can be solved using MAH function that we defined previously.
 this 2D matrix can further be split into following combinations if we consider each column a building, and add up the height of each cell
 
 Till row 1: [0,1,1,0]
 Till row 2: [1,2,2,1]
 Till row 3: [2,3,3,2]
 But here comes the twist, for row 4, last 2 cells are 0, and building cant stand without the ground or in the air, so while considering row 4, we are not going to consider last 2 columns
 
 Till row 4: [3,4,0,0]
 Now we will apply MAH on each of these 4 arrays, and then find the maximum of that.
 These 4 combinations will take care of any possible rectangle in the matrix
 */

func maxAreaInBinaryMatrix(matrix: [[Int]]) -> Int {
  guard !matrix.isEmpty else { return 0 }
  let rows = matrix.count
  let cols = matrix[0].count
  
  var height: [Int] = Array(repeating: 0, count: cols)
  var ans: Int = 0
  // For each row, count the height till that row and apply MAH
  for i in 0..<rows {
    height = zip(height, matrix[i]).map {
      // if the new cell is 0, then consider the building height as 0, else add new height to the current height
      $1 == 0 ? 0 : ($0 + $1)
    }
    
    let mahTillRowI = maxAreaOfHistogram(from: height)
    ans = max(mahTillRowI, ans)
  }
  
  return ans
}

maxAreaInBinaryMatrix(matrix: [[0,1,1,0],
                               [1,1,1,1],
                               [1,1,1,1],
                               [1,1,0,0]])

maxAreaInBinaryMatrix(matrix: [[0,1,1],
                               [1,1,1],
                               [0,1,1]])
/* Trapping rain water:  Given n non-negative integers representing an elevation map where the width of each bar is 1, compute how much water it can trap after raining.
 
 Input: height = [0,1,0,2,1,0,1,3,2,1,2,1]
 Output: 6
 https://assets.leetcode.com/uploads/2018/10/22/rainwatertrap.png
 Explanation: The above elevation map (black section) is represented by array [0,1,0,2,1,0,1,3,2,1,2,1]. In this case, 6 units of rain water (blue section) are being trapped.
 
 Input: height = [4,2,0,3,2,5]
 Output: 9
 
 Explanation: If you observe closely, at any bar, the water can only be trapped if the surrounding bars are higher than the current bar. And the height of the water+bar at any bar will be determined based on heightest bar on left and heighest bar on right side of the current bar
 if we find the min of heightest bars on each side, we get the filled level
 if we remove the bar height from that, we get the water level
 
 water[i] = min(maxLeft[i], maxRight[i]) - height[i]
 Total water = Sum(water[i])
 
 now to get the maxLeft for any i,
 arr:     [4,2,0,3,2,5]
           |/ / / / /
 maxLeft:  4 4 4 4 4 5   ----> From left to right
 maxLeft[i] = max(maxLeft[i-1], arr[i])
 
 arr:     [4,6,0,3,2,5]
            \ \ \ \ \|
 maxRight: 6 6 5 5 5 5  <---- From right to left
 maxRight[i] = max(maxRight[i+1], arr[i])
 
 so once we get these values, we can use the formula:
 water[i] = min(maxLeft[i], maxRight[i]) - height[i]
 Total water = Sum(water[i])
 */

func trappedWaterVolume(in heights: [Int]) -> Int {
  guard heights.count > 2 else { return 0 }
  let n = heights.count
  
  //calculate maxL, initate with first element
  var maxL: [Int] = Array(repeating: -1, count: n)
  maxL[0] = heights[0]
  for i in 1..<n {
    maxL[i] = max(maxL[i-1], heights[i])
  }
  
  //calculate maxR, initiate with last element
  var maxR: [Int] = Array(repeating: -1, count: n)
  maxR[n-1] = heights[n-1]
  for i in stride(from: n-2, through: 0, by: -1) {
    maxR[i] = max(maxR[i+1], heights[i])
  }
  
  //calculate water for each bar, find sum of all
  var water: [Int] = Array(repeating: -1, count: n)
  var sum: Int = 0
  for i in 0..<n {
    water[i] = min(maxR[i], maxL[i]) - heights[i]
    sum = sum + water[i]
  }
  
  return sum
}

trappedWaterVolume(in: [0,1,0,2,1,0,1,3,2,1,2,1])
trappedWaterVolume(in: [4,2,0,3,2,5])

/* Min stack (using extra space): Design a stack that supports push, pop, top, and retrieving the minimum element in constant time.
 You can use extra space if needed
 */

public struct MinStack1<T: Comparable> {
  private var s: Stack<T>  //actual stack performing operations
  private var ss: Stack<T> //supporting stack, only stores min elements
  
  public init(s: Stack<T>, ss: Stack<T>) {
    self.s = s
    self.ss = ss
  }
  
  public mutating func push(element: T) {
    s.push(element: element)
    guard let top = ss.top() else {
      ss.push(element: element)
      return
    }
    if top > element {
      ss.push(element: element)
    }
  }
  
  public mutating func pop() -> T? {
    let elem = s.pop()
    if elem == ss.top() {
      ss.pop()
    }
    return elem
  }
  
  public mutating func top() -> T? {
    s.top()
  }
  
  public mutating func minElement() -> T? {
    ss.top()
  }
}

let s = Stack<Int>()
let ss = Stack<Int>()
var minStack = MinStack1<Int>(s: s, ss: ss)

minStack.push(element: 18)
minStack.push(element: 19)
minStack.push(element: 29)
minStack.push(element: 15)
minStack.minElement()
minStack.push(element: 16)
minStack.push(element: 7)
minStack.minElement()
minStack.pop()
minStack.pop()
minStack.pop()
minStack.minElement()

/* Min stack (in O(1) space): Design a stack that supports push, pop, top, and retrieving the minimum element in constant time.
 You can use O(1) extra space only
 
 Explanation: Here we can keep one variable as min, and keep storing the smallest value there, but since we dont have a way to store the 2nd smallest value, when the min element gets popped, we cant find the next min.
 Solution:
 create a variable called min:
 Push:
 if stack is empty, push element and change min to element
 if element is > stack.top, so just push
 if element < stack.top, so we update the min with element, but we dont push the element directly, rather we push
 
 -----------------------------------------
 so push this in stack: 2*element - min
 -----------------------------------------
 stack: [5,6]  min: 5, element: 3 => push(2*3 - 5)
 stack: [1,5,6], min: 3
 
 since this pushed value will always be < min, it represnts a corrupt value (after all min represnts the smallest of the stack, and yet this value is <min)
 We will use this current value to find the 2nd smallest min at the time of pop
 
 Pop:
 if stack is empty, return nil
 if stack.top > min, so just pop, as it wouldnt change the min value
 if stack.top < min, so we have found the corrupt value, and its about to be popped, so before that, update the min
 -----------------------------------
 new_min: 2*old_min - element
 -----------------------------------
 and now pop the stack top
 
 
 Top:
 if stack is empty, return nil
 if stack.top > min, so just return top of stack, as its correct value
 if stack.top < min, so we have found the corrupt value, so the actual value for that can be found in min
 so return min
 */

public struct MinStack2<T: Comparable & Numeric> {
  private var s: Stack<T>
  public var minElement: T? = nil
  
  public init(s: Stack<T>) {
    self.s = s
  }
  
  public mutating func push(element: T) {
    guard let min = minElement else {
      //stack is empty here since minElement is nil
      s.push(element: element)
      minElement = element
      return
    }
    if element > min {
      s.push(element: element) //min value doesnt change
    } else {
      s.push(element: (2 * element - min)) //Pushing the corrupt flag
      minElement = element //Storing the min value
    }
  }
  
  public mutating func pop() -> T? {
    guard let element = s.pop(), let min = minElement else {
      //stack is empty here
      return nil
    }
    if element > min { //min value doesnt change
      return element
    } else {
      // we are popping the corrupt value here, so update min with 2nd smallest value
      minElement = 2 * min - element
      return min //return old min as the pop value
    }
  }
  
  public mutating func top() -> T? {
    guard let top = s.top(), let min = minElement else {
      //stack is empty here
      return nil
    }
    if top > min { //min value doesnt change
      return top
    } else {
      // we are seeing the corrupt value here, so actual value of top will be on min
      return min
    }
  }
}

let stack = Stack<Int>()
var minStack2 = MinStack2<Int>(s: stack)

minStack2.push(element: 18)
minStack2.push(element: 19)
minStack2.push(element: 29)
minStack2.push(element: 15)
minStack2.minElement
minStack2.push(element: 16)
minStack2.push(element: 7)
minStack2.minElement
minStack2.pop()
minStack2.pop()
minStack2.pop()
minStack2.minElement

/* Celebrity Problem: In a party of N people, only one person is known to everyone. Such a person may be present in the party, if yes, (s)he doesn’t know anyone in the party. We can only ask questions like “does A know B? “. Find the stranger (celebrity) in the minimum number of questions.
 We can describe the problem input as an array of numbers/characters representing persons in the party. We also have a hypothetical function HaveAcquaintance(A, B) which returns true if A knows B, false otherwise. How can we solve the problem.

 Examples:

 Input:
 MATRIX = { {0, 0, 1, 0},
            {0, 0, 1, 0},
            {0, 0, 0, 0},
            {0, 0, 1, 0} }
 Output:id = 2
 Explanation: The person with ID 2 does not
 know anyone but everyone knows him

 Input:
 MATRIX = { {0, 0, 1, 0},
            {0, 0, 1, 0},
            {0, 1, 0, 0},
            {0, 0, 1, 0} }
 Output: No celebrity
 Explanation: There is no celebrity.
 
 Solution: There is always a brute force way where we can create 2 arrays in and out, representing in degree and out degree for each person, and then we can find a person whose in degree is n and out degree is 0. That is the celebrity. But, that will require O(n^2) time
 To find O(n) time solution:
 
 we will start from person 0 and go till person n, with celebrity c as P0,
 at any point, if P0 -> P1 is 1 i.e P0 knows P1, then P0 cant be celebrity, so we update c with P1
 if P1 -> P2 is 1, then P1 cant be celebrity either, so update c by P2. Complete the iteration till n
 Finally we will get one potential celebrity in c.
 Verify that by checking the indegree and outdegree of that c.
 */

func findCelebrity(in matrix: [[Int]]) -> Int {
  let n = matrix.count
  guard n > 0 else { return -1 }
  guard n == matrix[0].count else { return -1 }
  var c: Int = 0
  for i in 0..<n {
    if matrix[c][i] == 1 {
      // c cant be celebrity
      c = i
    }
  }
  
  // now validate if c is a celebrity
  for i in 0..<n {
    // if at any point, in-degree of c is 0 or out-degree is 1, then false
    if i != c && (matrix[c][i] == 1 || matrix[i][c] == 0) {
      // c cant be celebrity
      return -1
    }
  }
  return c
}

findCelebrity(in: [ [0, 0, 1, 0],
                    [0, 0, 1, 0],
                    [0, 0, 0, 0],
                    [0, 0, 1, 0] ])
findCelebrity(in: [ [0, 0, 1, 0],
                    [0, 0, 1, 0],
                    [0, 1, 0, 0],
                    [0, 0, 1, 0] ])
/* */
