import Foundation

//Use only to persist small values between different app launches
//These values are stored in your apps bundle -> .plist file: <appname>.plist, and gets downloaded with the app
//The values we store must be an instance of NSData, NSString, NSNumber, NSDate, NSArray, or NSDictionary
// Only good for small values, having too much information stored here will make it take longer to launch your app.

UserDefaults.standard.set(15, forKey: "fontSize")

// print(UserDefaults.standard.value(forKey: "fontSize")) -> Throws warning as we need to cast Any to String or Integer. But if you already know the type that you are using, then you can use other methods: exp:

UserDefaults.standard.integer(forKey: "fontSize")

UserDefaults.standard.set("test", forKey: "testString")
UserDefaults.standard.string(forKey: "testString")

UserDefaults.standard.set(122.002, forKey: "testDouble")
UserDefaults.standard.double(forKey: "testDouble")

//Better design is to use a wrapper class if you want to store multiple values in user default
class UserDefaultWrapper {
    static let shared = UserDefaultWrapper()
    
    enum Keys: String {
        case value1Key
        case value2Key
    }
    
    func store(value1: Double) {
        UserDefaults.standard.set(value1, forKey: Keys.value1Key.rawValue)
    }
    
    func store(value2: Int) {
        UserDefaults.standard.set(value2, forKey: Keys.value2Key.rawValue)
    }
    
    func getValue1() -> Double? {
        UserDefaults.standard.value(forKey: Keys.value1Key.rawValue) as? Double
    }
    
    func getValue2() -> Int? {
        UserDefaults.standard.value(forKey: Keys.value2Key.rawValue) as? Int
    }
}

enum FileError: Error {
    case noPathGiven
    case failedToLoad
}

// Load filesystem data from path thats passed as an argument
// The fact is UserDefaults contains all arguments passed on the command line - and can do basic conversion to types like Bool, Int and Double
// If not UserDefaults, you can also use standard way of accessing command line args: CommandLine.arguments.contains("-new-profile")

guard  let path = UserDefaults.standard.value(forKey: "path") as? String else {
    throw FileError.noPathGiven
}

let url = URL(filePath: path)
do {
    let data = try Data(contentsOf: url)
} catch {
    throw FileError.failedToLoad
}
