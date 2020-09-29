import Foundation

// Q1) // Crate a generic stack with basic operations
// Push, Pop and Peek ----------------------------------------------------------- //
// A1)

//struct Stack<T> {
//  fileprivate var stackData:[T] = []
//  var isEmpty:Bool{
//    return stackData.isEmpty
//  }
//  var count:Int{
//    return stackData.count
//  }
//  mutating func push(_ text:T){
//    stackData.append(text)
//  }
//  mutating func pop()-> T? {
//    return stackData.popLast()
//  }
//  func peek()->T?{
//    return (stackData.last)
//  }
//}
// ----------------------------------------------------------- //
//Q2)
struct Pair<Element> {
  var first: Element
  var second: Element
}

// 1) Make struct conform to Hashable and Codeable if the Elements conform to the same
// 2) Define a generic protocol "Orderable" with min(), max() and sorted() function and make the above struct conform to that.
// min function will return min of first or second
// max will return max of first or second
// sorted will return Pair(first, second) or  Pair(second, first) based on sorted order

// ----------------------------------------------------------- //
//A2)
/*
protocol Orderable {
  associatedtype Element
  func min() -> Element
  func max() -> Element
  func sorted() -> Self
}

extension Pair {
  func flipped() -> Pair {
    return Pair(first: self.second, second: self.first)
  }
}

extension Pair : Orderable where Element: Comparable {
  func min() -> Element {
    return first < second ? first: second
  }
  
  func max() -> Element {
    return first > second ? first: second
  }
  
  func sorted() -> Pair {
    return first < second ? self : self.flipped()
  }
}

let ints = Pair(first: 2, second: 1)
ints.max()
ints.sorted()
*/
// ----------------------------------------------------------- //
