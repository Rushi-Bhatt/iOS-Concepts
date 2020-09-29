import Foundation
// When you store a function to a variable, it becomes a closure
// you can directly store the closure to the variable here like this:

var addClosure = { (a: Int, b: Int) -> Int in
 return a + b
}

var addClosureNoParamType: (Int, Int)  -> Int = { (a, b) -> Int in
 return a + b
}

var addClosureNoReturnType: (Int, Int)  -> Int = { (a, b) in
 return a + b
}

var addClosureShortClosure: (Int, Int)  -> Int = { $0 + $1 }

let voidClosure: () -> Void = { print("yay") }
let voidClosure2: () -> () = { print("same yay") } // Void = (), so in return type you can use either, but params need to be ()

addClosure(4,5)

func operate(function: (Int, Int) -> Int, a: Int, b: Int) -> Int {
  return function(a,b)
}


operate(function: addClosure, a: 5, b: 4)
operate(function: +, a: 5, b: 4) // Already existing closure +
operate(function: { (a: Int, b: Int) -> Int in
  a + b
}, a: 5, b: 4) // Inline closure
operate(function: { $0 + $1 }, a: 5, b: 4)

// Closures dont have names, functions do
// Closures dont support Argument labels
// Closures dont support defauly values for parameter
// Closures can be written Inline, functions can't

//forEach and Map: Works the same way, Iterate over collection, but forEach returns nothing, Map returns collection
//forEach is pretty much like for loop, except you cant use break, continue or where clause with forEach, but you can chain it with other functions and pass in the function


var prices = [1.5, 2, 2.6, 3]
prices.forEach { (price) in
  print(price)
}

var newPrices = prices.map { (price) -> Double in
  return price/2
}

//CompactMap: Useful to work with collections that require optionals or nil, return collection might not have the same no. of elements as the original collection, it filters out the nil values for us

let input = ["Meow", "1", "7", "Five"]
let inputInInt = input.compactMap { (each) -> Int? in
  return Int(each)
}
print(inputInInt)

//flatMap: Useful for working with multi dimention collection or combining multiple collections into one
let twoDArray = [
  ["sleepy", "Grumoty",  "Bashful", "Sneezy"],
  ["Thorin", "Nori",  "Bombur"],
]
let oneDArray = twoDArray.flatMap { $0 }
print(oneDArray)
let namesAfterM = twoDArray.flatMap { (names) -> [String] in
  var afterMName: [String] = []
  for eachName in names where eachName > "M" {
    afterMName.append(eachName)
  }
  return afterMName
}
print(namesAfterM)

//Filter: Iterates over collection and returns only the values that meet the criteria, if the closure returns true, the element gets added to the collection else filtered out

let namesAfterMWithFilter = twoDArray.flatMap { (names) -> [String] in
  return names.filter { (name) -> Bool in
    name > "M"
  }
}.sorted(by: >)
print(namesAfterMWithFilter)

//Reduce: Takes 2 argument, first one starting value, and second closure. The closure takes the starting value and each element on the collection, and performs functionalities mentioned in closure

var grades = [45, 55, 23, 88, 67, 99, 76]
var totalGrades = grades.reduce(0) { (sum, eachGrade) -> Int in
  sum + eachGrade
}
print(totalGrades)
var totalGrades1 = grades.reduce(0) { $0 + $1 }
print(totalGrades1)
var totalGrades2 = grades.reduce(0, +)
print(totalGrades2)

//Reduce(into:): Takes 2 argument, first one starting collection, and second closure. The closure takes the starting collection and each element on the collection, and performs functionalities mentioned in closure
var stocks = [1.50 : 5, 10.00 : 2, 4.99 : 20, 2.30 : 5]
let stockSums = stocks.reduce(into: []) { (result, item) in
  return result.append(item.key * Double(item.value))
}
print(stockSums)

//Sort() and Sort(by:): Sorts in place, mutates the original
var names = ["Z", "P", "A", "D"]
names.sort()
names.sort { (a, b) -> Bool in
  a > b
}
names.sort(by: >)

//Sorted() and Sorted(by:) - Returns a new collection that is sorted
let sortedNames = names.sorted(by: <)
let sortedNames2 = names.sorted(by: { $0 < $1 } )
print(sortedNames, sortedNames2)
