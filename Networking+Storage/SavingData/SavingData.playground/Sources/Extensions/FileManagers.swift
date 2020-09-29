import Foundation

public extension FileManager {
  static var documentDirectory: URL {
    FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
  }
}
