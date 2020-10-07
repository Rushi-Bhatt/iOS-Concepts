 import Foundation

 //MARK:-Product
 public struct Hamburger: CustomStringConvertible {
  public let meat: Meat
  public let sauces: Sauces
  public let toppings: Toppings
  
  public var description: String {
    return meat.rawValue + " burger"
  }
 }
 
 public enum Meat: String {
  case beef, chicken, kitten, tofu
 }
 
 public struct Sauces: OptionSet {

  public static let mayonnaise = Sauces(rawValue: 1 << 0)
  public static let mustard = Sauces(rawValue: 1 << 1)
  public static let ketchup = Sauces(rawValue: 1 << 2)
  public static let secret = Sauces(rawValue: 1 << 3)
  
  public let rawValue: Int
  public init(rawValue: Int) {
    self.rawValue = rawValue
  }
 }
 
 public struct Toppings: OptionSet {

  public static let cheese = Toppings(rawValue: 1 << 0)
  public static let lettuce = Toppings(rawValue: 1 << 1)
  public static let pickels = Toppings(rawValue: 1 << 2)
  public static let tomatoes = Toppings(rawValue: 1 << 3)
  
  public let rawValue: Int
  public init(rawValue: Int) {
    self.rawValue = rawValue
  }
 }

//MARK:-Builder
 public class HamburgerBuilder {
  
  //Notice the private(set) which insures that only the builder can set these values
  public private(set) var meat: Meat = .beef
  public private(set) var sauces: Sauces = []
  public private(set) var toppings: Toppings = []
  
  // Since the setters are private, we need public helper methods to set the properties
  // Benefit of having these custom helper methods is to add custom logic
  // For example, showing an error for the sold out meat like .kitten
  
  private var soldOutMeats: [Meat] = [.kitten]
  public enum Error: Swift.Error {
    case soldOut
  }
  
  public func isAvailable(_ meat: Meat) -> Bool {
    return !soldOutMeats.contains(meat)
  }
  
  public func addSauce(_ sauce: Sauces) {
    sauces.insert(sauce)
  }
  public func removeSauce(_ sauce: Sauces) {
    sauces.remove(sauce)
  }
  public func addTopping(_ topping: Toppings) {
    toppings.insert(topping)
  }
  public func removeTopping(_ topping: Toppings) {
    toppings.remove(topping)
  }
  public func setMeat(_ meat: Meat) throws {
    guard isAvailable(meat) else { throw Error.soldOut }
    self.meat = meat
  }
  
  public func build() -> Hamburger {
    return Hamburger(meat: meat, sauces: sauces, toppings: toppings)
  }
 }


//MARK:- Director
 public class Employee {
  public func createCombo1() throws -> Hamburger {
    let builder = HamburgerBuilder()
    try builder.setMeat(.beef)
    builder.addSauce([.mayonnaise, .secret])
    builder.addTopping([.pickels, .tomatoes, .lettuce])
    return builder.build()
  }
  
  public func createKittenSpecial() throws -> Hamburger {
    let builder = HamburgerBuilder()
    try builder.setMeat(.kitten)
    builder.addSauce([.mayonnaise, .secret])
    builder.addTopping([.pickels, .tomatoes, .lettuce])
    return builder.build()
  }
 }

let employee = Employee()
if let combo1 = try? employee.createCombo1() {  print("Nom Nom \(combo1.description)") }
if let kittenSpecial = try? employee.createKittenSpecial() {
  print("Nom Nom \(kittenSpecial.description)")
} else {
  print("Sorry, sold out")
}
