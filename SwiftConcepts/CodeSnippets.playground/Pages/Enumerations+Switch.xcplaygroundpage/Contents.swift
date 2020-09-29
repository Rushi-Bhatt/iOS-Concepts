import Foundation

//Named Type:
// Structure, Class, Enum and Protocol
// Named types have properties and methods

enum Month: Int, CaseIterable {
  case january = 1, february, march, april, may, june, july, august, september, october, novermber
  /// You can add documentation regarding "december" case here
  case december
  
  mutating func advance(by monthCount: UInt) {
    let indexOfCurrent = Month.allCases.firstIndex(of: self)!
    let indexOfAdvancedMonth = indexOfCurrent + Int(monthCount)
    self = Month.allCases[indexOfAdvancedMonth % Month.allCases.count]
  }
}

var feb: Month = .february
feb.rawValue
let mar = Month(rawValue: 3) ?? nil // Returns optional
let allMonths = Month.allCases // Conform to CaseIterable and this will return array of all cases

let afterMarchMonts = allMonths.filter( { $0.rawValue > 3})
afterMarchMonts

feb.advance(by: 4)
print(feb)


enum Season: String, CaseIterable {
  case winter, spring, summer, autumn
}

func getSeason(for month: Month) -> Season {
  switch month {
  case .december, .january, .february:
    return .winter
  case .march, .april, .may:
    return .spring
  case .june, .july, .august:
    return .summer
  case .september, .october, .novermber:
    return .autumn
  }
}

let seasonForMarch = getSeason(for: .march)

func getDescription(for num: Int) -> String {
  switch num {
  case 0:
    return "Zero"
  case 1...9:
    return "Between 1 and 9"
  case let negativeNum where negativeNum < 0:
    return "Negative"
  case _ where num > .max/2:
    return "Very large!!"
  default:
    return "No Description"
  }
}

// See how value binding is being done in the "case let negativeNum where negativeNum < 0:" and "case _ where num > .max/2:"

func pointCategory(for coordiates: (Double, Double)) -> String {
  switch coordiates {
  case (0,0):
    return "Origin"
  case (let x, 0):
    return "On X Axis at \(x)"
  case (0, let y):
    return "On Y Axis at \(y)"
  case _ where coordiates.0 == coordiates.1:
    return "X is equal to Y"
  case (let x, let y) where y == x * x:
  return "Along y = x^2, x = \(x), y = \(y)"
  case (let x, let y):
    return "No Zero Category, x = \(x), y = \(y)"
  }
}

pointCategory(for: (0,0))
pointCategory(for: (4,4))
pointCategory(for: (12,0))
pointCategory(for: (2,4))
pointCategory(for: (12,14))

//Associated values
// Different than rawValues
// Not limited to one type!
// 0..> custom values per case
// Label names for each value
// No default associated values
// enum can have either raw values or associated values but not both

enum TwoDimPoint {
  case origin
  case onXAxis(Double)
  case onYAxis(Double)
  case noZeroCoordinate(x:Double, y:Double)
}



