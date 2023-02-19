import Foundation

//-------------------- Function Overloading --------------------//
// Avoid overloading by using default values instead as much as possible

var passingGrade = 50
func getPassStatus(for grades: Int) -> Bool {
  return grades >= passingGrade
}

// 1) Overloading by changing the argument name
func getPassStatus(of grades: Int) -> Bool {
  return grades >= passingGrade
}

for i in stride(from: 10, to: 0, by: -2) {
  print(i)
}

for i in stride(from: 10, through: 0, by: -2) {
  print(i)
}
// Notice how for stried, the overloading happens by different argument name


// 2) Overloading by changing the parameter type
func getPassStatus(for grades: [Int]) -> Bool {
  return grades[0] >= passingGrade
}

// 3) Not Overloading just by changing the parameter name
/*
func getPassStatus(for marks: Int) -> Bool {
  return grades >= passingGrade
}
*/

// 4) Overloading by changing return type
func getPassStatus(for grades: Int) -> Int {
  return grades >= passingGrade ? 1 : 0
}

var result = getPassStatus(for: [51,23])
var result1 = getPassStatus(of: 33)
// var result2 = getPassStatus(for: 66) // Error, as compiler doesnt know which return type to return, explicitly mention Int or Bool
var result2: Bool = getPassStatus(for: 66)


//-------------------- Variadic Parameter --------------------//

//Specified by ..., takes any number of parameters of the mentioned type
//One common example is print(Any...) function of Xcode

func getHighestGrade(for grades: Int...) -> Int {
  grades.max() ?? 0
}
getHighestGrade(for: 45,66,23,99)
getHighestGrade()

//-------------------- inout Parameter --------------------//

var counter = 1
func IncrCounter(for i: inout Int, by n: Int ) -> Int {
  return i + n
}

IncrCounter(for: &counter, by: 3)

//-------------------- function as parameter --------------------//

func add(this num1: Int, to num2: Int) -> Int {
  num1 + num2
}

func subtract(this num1: Int, from num2: Int) -> Int {
  num2 - num1
}
var function = add //Type of function = (Int, Int) -> Int
print("\(function(12,15))") // No arguments label, we lose access to those when we assing it as variable

// Higher order function: functions that use functions as parameter or return types
typealias Operate = (Int, Int) -> Int
func operate(function: Operate, a: Int, b: Int) -> Int {
  return function(a,b)
}
var resultAdd = operate(function: add, a: 4, b: 3)
var resultSubtract = operate(function: subtract, a: 4, b: 3)

