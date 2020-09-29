import Foundation

//Stored property of superclass can be overridden to make it computed property of subclass, but computer property of superclass can not be overridden to make it stored property of subclass.
// Initializers:

class Student {
  var firstName: String
  var lastName: String
  init(firstName: String, lastName:String) {
    self.firstName = firstName
    self.lastName = lastName
  }
}

class StudentAthlete: Student {
  var sports: [String] // This cant work without init, Swift has the requirement that all stored property must have initial valuex
  
  override init(firstName: String, lastName: String) {
    self.sports = []
    super.init(firstName: firstName, lastName: lastName)
  }
  
  init(firstName:String, lastName:String, sports: [String]) {
    self.sports = sports // First assign the value of sports and then only call the super init, the order is important
    super.init(firstName: firstName, lastName: lastName)
  }
}

//Superclass needs to make sure that not only its own stored property is intialized, but also its super class's stored property is also initialized, by using super init.
// each class first initializes its own stored property and then initalizes the super class's stored property by calling super.init

// required init: needs to be implemented by all the subclass of that super class, when you use required init, you dont need to use override keyword in the subclass init when overriding it

// convenience init: delegates the responsibility of instantiating stored property to designated inits., they are good for supporting multiple signature inits

// designated init must call a designated init from an "immediated" superclass, exp.  Person ->  Student -> StudentAthlete : init() of StudentAthelete must call init() of Student, and cant directly call init() of Person

// convenience init must call another init ( be it a designated init or another convenience init) from the same class ( self.init..)
// and convenience init must ultimately call a designated init so the chain should end with designated init call
// any init which is calling self.init needs to be convenience init
 

class Animal {
  var name: String
  required init(name: String) {
    self.name = name
  }
  
  func speak() {
    
  }
}

class Dog: Animal {
  var tricks: UInt
  
  init(name: String, numberOfTricks: UInt) {
    self.tricks = numberOfTricks
    super.init(name: name)
    speak()
  }

  required convenience init(name: String) {
    self.init(name: name, numberOfTricks: 0)
  } // this required init has to be convenience, otherwise it can not delegate the responsibility to another init
  
  convenience init(numberOfTricks: UInt = .max) {
    self.init(name: "Tramp", numberOfTricks: numberOfTricks)
  }
  
  override func speak() {
    print("Hello, I am \(self.name)")
  }
  
}

Dog(name: "Shadow")
Dog(name: "Hsuky", numberOfTricks: 4)
Dog().tricks

// Protocols:
protocol WildAnimal {
  //let name: String { get } // Error, let declarations cant be comouted properties, need to use var in the protocol
  var name: String { get }
  init(name: String)
  func speak()
}

class Lion: WildAnimal {
  func speak() {
    print("Roarrr!!")
  }
  
  let name: String
  required init(name: String) {
    self.name = name
  }
}

class Tiger: WildAnimal {
  func speak() {
    print("Ghrrr..!!")
  }
  
  let name: String
  required init(name: String) {
    self.name = name
  }
}
// Notice how we are using let name in the classes but var name with getter in the protocol,
// No override keywords :)
// Protocol cant be instantiated directly
// Protocol can inherit from multiple protocols, called composition

// Extensions let you define property, methods and inits outside of named type. With Protocol, you can provide default implementations in extension
// Extensions: What is allowed: Methods, computed properties and stored type/static property, convenience init
// Extensions: What is NOT allowed: Stored properties, required init, designated init

extension Numeric {
  var squared: Self { self  * self } // By "Self", we are saying that the squared is the same type as whatever type the instance will be
  
}

5.squared
6.8.squared

// One more struct specific use of Extension: if you define custom init for struct, you lose the access to member wise default init of the struct
struct Time {
  var day: String = "monday"
  var hour: UInt = 0
  
//  init(day: String) {
//    self.day = day
//  }
}

//Time(day: "tuesday", hour: 8) // Error, because this init got overridden by the custom init that you provided.
// To have both the init, always define the custom init in the extension, that way you will have access to default init as well

extension Time {
  init(day: String) {
    self.day = day
  }
}

Time(day: "tuesday", hour: 8)
Time()
Time(day: "wednesday")
