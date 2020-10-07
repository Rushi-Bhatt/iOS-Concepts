import Foundation
import Combine

public class User {
  @Published public var name: String  // @Published only works with Class, and on "var" properties
  public init(name: String) {
    self.name = name
  }
}

let user = User(name: "Ray")
let publisher = user.$name

var subscriber: AnyCancellable? = publisher.sink() {
  print("User's name is \($0)")
}
user.name = "Vikki" // See how the message is being printed in the console

subscriber = nil // Now lets set the subsriber as nil

user.name = "No message this time"

