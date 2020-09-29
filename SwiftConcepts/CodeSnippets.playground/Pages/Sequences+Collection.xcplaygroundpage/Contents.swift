import Foundation

//Sequence protocol just requires an Iterator, which helps traverse the sequence, be it array or any other collection
//protocol Sequence {
//  associatedtype Iterator
//  func makeIterator() -> Iterator
//}
//protocol IteratorProtocol {
//  associatedtype Element
//  mutating func next() -> Element?
//}

// For. exp,
struct InfiniteIterator: IteratorProtocol {
  let value: Int
  mutating func next() -> Int? {
    return value
  }
}

var iterator = InfiniteIterator(value: 42)
iterator.next()
iterator.next()
iterator.next()

struct InfiniteSequence: Sequence {
  let value: Int
  func makeIterator() -> InfiniteIterator {
    return InfiniteIterator(value: value)
  }
}

let infinite = InfiniteSequence(value: 24)
for value in infinite.prefix(5) { print(value) }


// To write the same thing in code:
for value in repeatElement(24, count: 5) {
  print(value)
}


//Collections: Just like Sequences but lets you revisit elements by subscript and indices
// To Implment a collection:
// Define a "Comparable" index type
// Define startIndex and endIndex( which is one past the last element, not the last element, that way you can represent the emptyCollection if startIndex == endIndex )
// Define a method "index(after:)" to advance an index
// Define O(1) subscript operator that returns an element given an index

// for exp, define FizzBuzz collection from 1-100, where if num is div by 3, print Fizz, if dev by 5, print Buzz, if div by both 3 and 5, print FizzBuzz

struct FizzBuzz: Collection {
  typealias Index = Int // Comparable Index
  var startIndex: Index { return 1 }
  var endIndex: Index { return 101 }
  
  func index(after i: Index) -> Index {
    return i + 1
  }
  
  subscript(index: Index) -> String {
    print("debug description: \(index)")
    switch(index.isMultiple(of:3), index.isMultiple(of:5)) {
    case (false, false):
      return String(describing: index)
    case (false, true):
      return "Buzz"
    case (true, false):
      return "Fizz"
    case (true, true):
      return "FizzBuz"
    }
  }
}

for value in FizzBuzz() {
  print(value)
}

FizzBuzz().dropFirst(11).first! // dropFirst() -> drops first n elements, and returns the subsequence of the remaining, notice how we are getting sequece functions in collection

print("Now lets print the last 5 values, notice how it traverse through the whole collection to print the last 5, that's inefficient, so lets use Bidirectional collection for that")
for value in FizzBuzz().reversed().prefix(5) {
  print(value)
}

// Bidirectional collection:
struct FizzBuzzBiDirectional: BidirectionalCollection {
  typealias Index = Int // Comparable Index
  var startIndex: Index { return 1 }
  var endIndex: Index { return 101 }
  
  func index(after i: Index) -> Index {
    print("called index(after:) method \(i+1) time")
    return i + 1
  }
  
  func index(before i: Index) -> Index {
    return i - 1
  }
  
  subscript(index: Index) -> String {
    print("debug description: \(index)")
    switch(index.isMultiple(of:3), index.isMultiple(of:5)) {
    case (false, false):
      return String(describing: index)
    case (false, true):
      return "Buzz"
    case (true, false):
      return "Fizz"
    case (true, true):
      return "FizzBuz"
    }
  }
}

print("Now lets print the last 5 values, notice how it doesn't traverse through the whole collection to print the last 5, rather it starts from the last index and goes backwards")
for value in FizzBuzzBiDirectional().reversed().prefix(5) {
  print(value)
}


// Now notice when we call count() method on the same, you will see index(after:) getting called 101 times
print("Now notice when we call count() method on the same, you will see index(after:) getting called 101 times")
FizzBuzzBiDirectional().count




//To resolve that, we need to make it RandomAccessCollection that can return the count in O(1)
// RandomAccess collection:
// generally require 2 more methods: index(offsetBy) and distance(from:to:), but if your index type conforms to 'Strideable' protocol ( which in our case, Int does), then you dont need any index(_) or distance(_) method

struct FizzBuzzRandom: RandomAccessCollection {
  typealias Index = Int // Comparable Index
  var startIndex: Index { return 1 }
  var endIndex: Index { return 101 }
  
//  func index(after i: Index) -> Index {
//    print("called index(after:) method \(i+1) time")
//    return i + 1
//  }
//
//  func index(before i: Index) -> Index {
//    return i - 1
//  } // No need for Strideable index
  
  subscript(index: Index) -> String {
    print("debug description: \(index)")
    switch(index.isMultiple(of:3), index.isMultiple(of:5)) {
    case (false, false):
      return String(describing: index)
    case (false, true):
      return "Buzz"
    case (true, false):
      return "Fizz"
    case (true, true):
      return "FizzBuz"
    }
  }
}

print("Now see the index(after:) method isnt getting called 101 times for count for random collection")
FizzBuzzRandom().count
FizzBuzzRandom().sorted()


// Slices: Super light weight, because they dont copy objects, they have just 3 things:
// Underlying collection that they are slicing, start index and end index
//

let array  = Array(0...99)

//Slices
let all = array[...]
let lower = array[..<50]
let upper = array[50...]

// You can use it to make array out of it whenever you want
func computeSum(values: [Int]) -> Int {
  return values.reduce(0) { $0 + $1 }
}

//computeSum(values: lower) // error, you cant pass slice directly to [Int]
// But you can make Array out of it anytime you want and use that
computeSum(values: Array(lower))

// String are inherently not RandomAccessCollection and not MutableCollection, they are BidirectionalCollection
// Slices of a string are called Substring

//Swift collections are Eager by default, but you can make them lazy
let numbers: [Int] = Array(1...1000)
let bigNumers = numbers.filter { $0 > 7 } // This gets executed 1001 times
let first = bigNumers.first

// Making it lazy
let bigNums = numbers.lazy.filter({$0 > 7}) // This gets executed 9 times
let frst = bigNums.first

// Swift uses Type system to achieve that, number.Lazy gets wrapped into LazyCollection<[Int]>, number.lazy.filter gets wrapped into LazyFilterCollection<[Int]> and all these happens in compile time due to Type inference.
// Lazy gets available to every collection instantly, even the custom collection

