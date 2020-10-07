import Foundation
import UIKit

//MARK: - Singleton
let app = UIApplication.shared
// let app2 = UIApplication() // Error, UIApplication class is singleton

public class MySingleton {
  public static let shared = MySingleton()
  private init() { }  // Private init
}

let mySingleton = MySingleton.shared
// let mySingleton = MySingleton() // Error, MySingleton class is singleton

//MARK: - Singleton Plus

let fm = FileManager.default
let fm2 = FileManager() // Allowed, FileManager is Singleton Plus, so you can create your own instance

public class MySingletonPlus {
  public static let shared = MySingleton()
  public init() { } // Public init
}

let mySingletonPlus = MySingletonPlus.shared
let mySingletonPlus2 = MySingletonPlus() // Allowed, MySingletonPlus class is Singleton Plus, so you can create your own instance


