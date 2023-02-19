import Foundation

//MARK:- Protocol Copying
public protocol Copying: AnyObject {
  // Required Copy initiazer
  init(_ prototype: Self)
}

extension Copying {
  // Since its using type of Self and then calling Copy initializer on that, even if you create a subclass of a type that conforms to Copying, the copy function works correctly.
  public func copy() -> Self {
    return type(of: self).init(self)
  }
}

//MARK:- Prototype
public class Monster: Copying {
  public var health: Int
  public var level: Int
  
  public init(health: Int, level: Int) {
    self.health = health
    self.level = level
  }
  
  // "Required" Copy initializer, its purpose is to create a new instance using an existing one
  // However, you are allowed to mark it as convenience init and call another designated init from it
  // You wont directly call the copy initializer, instead you will just call copy function on an instance
  public required convenience init(_ prototype: Monster) {
    self.init(health: prototype.health, level: prototype.level)
  }
}

public class EyeBallMonster: Monster {
  public var redness = 0
  public override convenience init(health: Int, level: Int) {
    self.init(health: health, level: level, redness: 0)
  }
  
  public init(health: Int, level: Int, redness: Int) {
    self.redness = redness
    super.init(health: health, level: level)
  }
  
  // "Required" Copy initializer, for Copying protocol
  // Notice how the prototype is of type Monster, and not EyeBallMonster
  
  @available(*, unavailable, message: "Call copy() instead")
  public required convenience init(_ prototype: Monster) {
    let eyeBallMonster = prototype as! EyeBallMonster
    self.init(health: eyeBallMonster.health, level: eyeBallMonster.level, redness: eyeBallMonster.redness)
  }
}

//MARK:- Example
let monster = Monster(health: 700, level: 37)
let shallowCopyMonster = monster
shallowCopyMonster.health
shallowCopyMonster.level

monster.health = 701
shallowCopyMonster.health // Notice how the property of another instance changes if you change the property of one instance, because of the shallow copy

let monster2 = monster.copy()
monster2.health
monster2.level

monster.health = 702
monster2.health // Notice how the property of another instance DOESNT change if you change the property of one instance, because of the deep copy using Copying protocol

let eyeBallMonster = EyeBallMonster(health: 900, level: 55, redness: 999)
let eyeBallMonster2 = eyeBallMonster.copy()
eyeBallMonster.health
eyeBallMonster.level
eyeBallMonster.redness

// what happens if you try to create eyeBallMonster out of Monster?, using the init(prototype)
// let eyeBallMonster3 = EyeBallMonster(monster) // Run time exception, because we are force casting prototype to EyeBallMonster in line 48, so the app crashes.
// Ideally, you should not call the init(prototype) [Copy initializer] directly, ever. Rather you should only call copy() function and let it call the init(prototype) by itself.
// To restrict users from directly calling Copy initializer, mark it as unavailable, that will throw the compile time error



// ------------------------Shallow Copy-----------------------------------------------------//
// See how the Array of Angel objects, when copied, still uses the same property reference
public class Angel {
  public var health: Int
  public var level: Int
  
  public init(health: Int, level: Int) {
    self.health = health
    self.level = level
  }
}

var angelArray: [Angel] = []
angelArray.append(Angel(health: 10, level: 10))
angelArray.append(Angel(health: 11, level: 11))
angelArray.append(Angel(health: 12, level: 12))
angelArray

var copyOfAngelArray = angelArray
copyOfAngelArray

// Notice how changing the property of angelArray memeber, changes the property of copyOfAngelArray
print(copyOfAngelArray[1].health)
angelArray[1].health = 13
print(copyOfAngelArray[1].health)

// But Notice how deleting the angelArray memeber, DOESNT delete the member of copyOfAngelArray
// So new instances are created for each of the members, just the properies are still referring to the same instance.
angelArray.count
angelArray.remove(at: 0)
angelArray.count
copyOfAngelArray.count

// ------------------Deep Copy-------------------------------------------------- //
// You can create extenstion on Array to make deepCopy method available for Arrays
extension Array where Element: Copying {
  public func deepCopy() -> [Element] {
    return map {  $0.copy() }
  }
}

// ------------------------------------------------------------------------------------------ //
// Now See how Array of Monster object will behave differently as we have made Array extension with deepCopy() function

var monsterArray: [Monster] = []
monsterArray.append(Monster(health: 10, level: 10))
monsterArray.append(Monster(health: 11, level: 11))
monsterArray.append(Monster(health: 12, level: 12))
monsterArray

var deepcopyOfMonsterArray = monsterArray.deepCopy()
deepcopyOfMonsterArray

// Notice how changing the property of monsterArray memeber, DOESNT change the property of deepcopyOfMonsterArray
print(deepcopyOfMonsterArray[1].health)
monsterArray[1].health = 13
print(monsterArray[1].health)
print(deepcopyOfMonsterArray[1].health)

