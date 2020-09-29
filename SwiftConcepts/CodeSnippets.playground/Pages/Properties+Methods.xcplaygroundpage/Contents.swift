import Foundation

// Property observers: didSet and willSet, Only gets called after initlizer, not in initializers
// So they are only useful for var, not let because let properties are initilized during the init method.

struct Wizard {
  static var commonThings = ["wand", "Hat", "Cape"] // Type/Static property, they can also have property observer
  var firstName: String
  var lastName: String
  
  var fullName: String {
    return firstName + " " +  lastName
  } // Computed property, get/read only
  
  var settableFullName: String {
    get {
      return firstName + " " + lastName
    }
    set {
      let nameSubstrings = newValue.split(separator: " ")
      guard nameSubstrings.count >= 2 else { return }
      let nameStrings = nameSubstrings.map(String.init)
      firstName = nameStrings.first!
      lastName = nameStrings.last!
    }
  }
  
  lazy var magicalCreature = timeConsumingFunction(firstName: firstName) // Lazy properties are always var, not initalized unless first used. Creates an optional parameter in the struct's init.
  
  //custom init to get rid of optional lazy property in the init
  init(firstName: String, lastName: String) {
    self.firstName = firstName
    self.lastName = lastName
  }
}

public func timeConsumingFunction(firstName: String) -> String {
 //Length complicaed logic for returning magicalCreatures
  return firstName + "'s Magical creature"
}


let wiz = Wizard(firstName: "Rushi", lastName:"Bhatt")
wiz.firstName
wiz.lastName
// wiz.firstName = "NewName" // Error
Wizard.commonThings

//Enums can't have stored instance property, but can have stored type property
//Enum can however have computed instance property
//Computed property always begins with var, let doesnt work

var wiz1 = Wizard(firstName: "Rushi", lastName:"Bhatt")
//wiz1.fullName = "skdf skdf" // Error, no setter

wiz1.settableFullName = "Radhika Pai"
wiz1.firstName
wiz1.lastName

// You can not have a set-only property, if you provide setter, you must explicitly have to provide getter

wiz1.magicalCreature // Value: Radhika
wiz1.settableFullName = "Rushi Bhatt"
wiz1.magicalCreature // Value still Radhika

//lazy property always begins with var, let doesnt work
//Important: Lazy property doesnt behave same as computer property, think of it like closure, at the time of evaluation, whatever value of firstName is being used, that gets stored with the property, so it doesnt computer the value every time the firstName chagnes.
// Used when the requirement is: could be a constant, expensive to calculate, and might not be used by every instance

//Methods:
// Just like functions but inside named type like enum, struct and class
//struct and enum require mutating keyword for methods that are changing 'self', there are often mutating and non-mutating version of the same method, naming differs, for exp, advance(by:_) is mutating method, but advanced(by: _) is nomn mutating, another exp. sort and sorted
// Type method is also possible for named type
enum Maths {
  static func getLength(x: Double, y: Double) -> Double {
    return (x*x + y*y).squareRoot()
  }
} //Caseless enumeration, great for organization


//computed properties vs methods:
//Extensive computation or DB Access -> Yes, Method ;  No -> ComputedProperty
//Comoputatiuon requiring multiple parameters: Method, if not, then ComputerProperty
