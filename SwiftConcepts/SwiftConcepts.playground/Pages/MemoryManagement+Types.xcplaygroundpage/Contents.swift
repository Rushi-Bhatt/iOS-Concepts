import Foundation

// Q1: Weak vs unowned, Is there any advantage/disadvantage  in using unown?
// A1: https://krakendev.io/blog/weak-and-unowned-references-in-swift

//-------------------------------------------------------------------------//
// Q2: Explain memory leak in closure? and how to resolve it?
// A2:

//-------------------------------------------------------------------------//
// Q3: Whats the output of show(), show2() and show3() ?
/*
var value = 10
let show = {
  print(value)
}
let show2 = { [value] in
  print(value)
}

value = 11
show() //Whats the output?

value = 12
show2() // Whats the output?

let show3 = {  [v = value, b = value + 1] in
  print(v, b)
}

value = 13
show3()
*/
//-------------------------------------------------------------------------//
// A3: show(): 11, show2(): 10, show3(): 12, 13
//-------------------------------------------------------------------------//

//-------------------------------------------------------------------------//
// Q4: Whats the output ?

/*
class CelestialBody {
  var name: String
  init(name: String) {
    print("Init for \(name) called")
    self.name = name
  }
  
  deinit {
    print("Deinit for \(name) called")
  }
}

class Supernova: CelestialBody {
  lazy var explode: () -> Void = {
    [unowned self] in
    self.name = "Boomed \(self.name)"
  }
}

//Whats the output at the end of the below do block?
do {
  let secondSuperNova = Supernova(name: "secondSuperNova")
  DispatchQueue.global().asyncAfter(deadline:  .now() + 0.1 ) {
    secondSuperNova.explode()
    print(secondSuperNova.name)
  }
}

//Whats the output at the end of the below do block?
do {
  let thirdSuperNova = Supernova(name: "thirdSuperNova")
  DispatchQueue.global().asyncAfter(deadline:  .now() + 0.1 ) {
    [unowned thirdSuperNova] in
    thirdSuperNova.explode()
    print(thirdSuperNova.name)
  }
}

*/
 
//-------------------------------------------------------------------------//
// A4:
//only first do block:
//Init for secondSuperNova called
//Boomed secondSuperNova
//Deinit for Boomed secondSuperNova called
  
//Only second do block:
//Init for thirdSuperNova called
//Deinit for thirdSuperNova called
//-------------------------------------------------------------------------//
// Q5: Where all and How many times will the didSet method be called for pointValues and pointReferences?

/*
struct PointValue: CustomStringConvertible {
  var x, y: Int
  var description: String {
    return "(\(x), \(y))"
  }
  
  mutating func transpose() {
    (y,x) = (x,y)
  }
}

final class PointReference: CustomStringConvertible {
  var x, y: Int
  
  init(x: Int, y: Int) {
    self.x = x
    self.y = y
  }
  var description: String {
    return "(\(x), \(y))"
  }
  
  func transpose() {
    (y,x) = (x,y)
  }
}

var pointValues: [PointValue] = [] {
  didSet {
    print("didSet point value", pointValues)
  }
}

var pointReferences: [PointReference] = [] {
  didSet {
    print("didSet point reference", pointReferences)
  }
}

print("value array")
var pv1 = PointValue(x: 1, y: 2)
var pv2 = PointValue(x: 11, y: 12)
pointValues.append(pv1)
pointValues.append(pv2)
pv1.x = 3
pointValues[0].x = 4
pointValues[1].transpose()


print("reference array")
var pr1 = PointReference(x: 1, y: 2)
var pr2 = PointReference(x: 11, y: 12)
pointReferences.append(pr1)
pointReferences.append(pr2)
pr1.x = 3
pointReferences[0].x = 4
pointReferences[1].transpose()

*/

//-------------------------------------------------------------------------//
// A5) for pointValues: 4 times, for pointReferences: 2 times
// For mutating methods, the self reference is passed as inout parameter, so in struct case, the didSet and willSet on the array gets called, but for class, the self is not passed as inout parameter, so the property observer doesn’t get called.

//-------------------------------------------------------------------------//
// Q6: Which of the last 4 statement(s) will compile and which one(s) will not?

/*
class StudentClass {
  var name: String
  init(name: String) { self.name = name }
}

struct StudentStruct {
  var name: String
}

let a = StudentClass(name: "a")
let b = StudentClass(name: "b")

let c = StudentStruct(name: "c")
let d = StudentStruct(name: "d")

b.name = "b1"
b = a

c.name = "c1"
c = d

//Which of the above statement(s) will compile and which one(s) will not?
*/

//-------------------------------------------------------------------------//
// A6:
// classes are reference type, so with let, you can still customize the properties but can't customize the entire instance so b.name = b1 will compile but b = a will throw error

// structs are value type, so with let, you can not customize anything so both will throw error
//-------------------------------------------------------------------------//

