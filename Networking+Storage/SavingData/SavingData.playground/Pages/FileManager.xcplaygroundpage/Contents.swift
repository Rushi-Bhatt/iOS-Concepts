import Foundation
import PlaygroundSupport

// App Sandbox
// When a user downloads your app onto their phone, it allocates extra storage space for you to save information. Users can choose to set the amount of space that your phone can save data to. This sandbox means that you have unrestricted access to a set-aside block of memory on the phone, and cannot access other areas without special permissions.
// Foundation’s FileManager API, which lets us resolve URLs for system folders in a cross-platform manner (iOS, macOS, iPadOS etc) so on macOS, the documentURL will point to ~/Documents, just as we’d expect, but on iOS it’ll instead point to our app’s own version of that folder that’s located within the app’s sandbox.

//Document Directory URL

FileManager.documentDirectory
FileManager.documentDirectory.path

// FileManager.documentDirectory helper is defined as following in the FileManager class:
// FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]


//URLs and Paths
let remindersURL = URL(fileURLWithPath: "Reminder", relativeTo: FileManager.documentDirectory)

let stringURL = FileManager.documentDirectory.appendingPathComponent("String").appendingPathExtension("txt")

print(remindersURL.path)
print(stringURL.path)

let challengeString: String = "To do list"
let challengeURL: URL = URL(fileURLWithPath: challengeString, relativeTo: FileManager.documentDirectory).appendingPathExtension("txt")

print(challengeURL.lastPathComponent)

//Data and Data types

var ui8: UInt8 = 3
var i8: Int8 = -2

MemoryLayout<Int8>.size
MemoryLayout.size(ofValue: ui8)
UInt8.min
Int8.max

let iu: UInt = 4
let i: Int = 4
MemoryLayout.size(ofValue: iu)
MemoryLayout.size(ofValue: i)
MemoryLayout<Int>.size
MemoryLayout<UInt>.size
log2(Double(Int.max))

let f: Float = 12.44
MemoryLayout<Float>.size
MemoryLayout.size(ofValue: f)
Float.leastNormalMagnitude
Float.greatestFiniteMagnitude

let d: Double = 2343.22
MemoryLayout<Double>.size
MemoryLayout.size(ofValue: d)
Double.leastNormalMagnitude
Double.greatestFiniteMagnitude

let ui8binary: UInt8 = 0b0010_0000
let i8binary: Int8 = -0b0100_0010
let u16hex: UInt16 = 0x9B
let i16hex: Int16 = -0x9B

let byteArray: [UInt8] = [240, 159, 152, 184,
                          240, 159, 152, 185,
                          0b1111_0000, 0b1001_1111, 0b1001_1000, 186,
                          0xF0, 0x9F, 0x98, 187 ]
MemoryLayout<UInt8>.size * byteArray.count

//Saving and Loading Data

let byteArrayData = Data(byteArray)
let byteArrayURL = URL(fileURLWithPath: "byteArrayData", relativeTo: FileManager.documentDirectory)
try byteArrayData.write(to: byteArrayURL)

let savedByteArrayData = try Data(contentsOf: byteArrayURL)
let savedByteArray = Array(savedByteArrayData)

byteArrayData == savedByteArrayData
byteArray == savedByteArray

//String

try byteArrayData.write(to: byteArrayURL.appendingPathExtension("txt"))
let savedByteArrayString = String(data: savedByteArrayData, encoding: .utf8)!

//write
let catsURL = URL(fileURLWithPath: "cat", relativeTo: FileManager.documentDirectory).appendingPathExtension("txt")
try savedByteArrayString.write(to: catsURL, atomically: true, encoding: .utf8)

//read
let savedCatStrings = try String(contentsOf: catsURL)

// Bundles and Modules
// On Apple’s platforms, apps are distributed as bundles, which means that in order to access internal files that we’ve included (or bundled) within our own app, we’ll first need to resolve their actual URLs by searching for them within our app’s main bundle.

struct Content: Codable {
    var id: Int
    var content: String
}

// Loads content from any bundle
struct ContentLoader {
    enum ContentLoaderError: Error {
        case fileNotFoundError
        case decodingError
    }
    
    func loadContent(fromFile name: String, with fileExtension: String, in bundle: Bundle = .main) throws -> Content? {
        //first read the file from main bundle
        guard let url = bundle.url(forResource: name, withExtension: fileExtension) else {
            throw ContentLoaderError.fileNotFoundError
        }
        
        //decode the Content data from data
        do {
            let data = try Data(contentsOf: url)
            let jsonData = try JSONDecoder().decode(Content.self, from: data)
            return jsonData
        } catch {
            throw ContentLoaderError.decodingError
        }
    }
}

let content = try? ContentLoader().loadContent(fromFile: "content", with: ".json")
print(content as Any)

//So for our main target, the bundle will be .main, but if we want to load some mock file in our test target, the bundle will not be .main, and in that case you need to pass the bundle like this:
// let bundle = Bundle(for: Self.self) inside the class ContentLoaderTests

// Storing files within system defined folders
struct FileIOController {
    func writeJSON<T: Encodable>(_ value: T, to documentName: String, encoder: JSONEncoder = .init()) throws {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        //let documentDirectory = playgroundSharedDataDirectory // Only for Playground suppport
        let fileURL = documentDirectory.appending(path: documentName)
        let data = try encoder.encode(value)
        try data.write(to: fileURL)
    }
}

// If all that we’re looking for is a URL for a temporary folder, however, we can use the much simpler NSTemporaryDirectory function — which returns a URL for a system folder can be used to store data that we only wish to persist for a short period of time:
let temporaryURL = URL(fileURLWithPath: NSTemporaryDirectory())
FileManager.default.temporaryDirectory

// Managing custom folders
extension FileIOController {
    func writeJSON<T: Encodable>(_ value: T, to documentName: String, within folderName: String, encoder: JSONEncoder = .init()) throws {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        // create directory url first, and then actually create diretory on that url
        let folderDirectory = documentDirectory.appending(path: folderName, directoryHint: .isDirectory)

        //check if the directory already exists at that location, if not, then only create
        // notice how we are using relativePath (or path), and not absoluteString
        // absoluteString works well with URL from internet, if we use it in this content, it will give the value as "file://rushi/document/..." which is not what we want
        if !FileManager.default.fileExists(atPath: folderDirectory.relativePath) {
            try FileManager.default.createDirectory(at: folderDirectory, withIntermediateDirectories: false)
        }
        
        let fileURL = folderDirectory.appending(path: documentName)
        let data = try encoder.encode(value)
        try data.write(to: fileURL)
    }
}

do {
    try FileIOController().writeJSON(content!, to: "content.json")
    try FileIOController().writeJSON(content!, to: "content.json", within: "MyContent")
} catch {
    print(error)
}


// Directory in the default FileSystems
/*
 SandBox:
 -> Bundle Container: MyApp.app
 -> Data Container: Documents, Library/Cache, Library/ApplicationSupport, Temp
 -> iCloud Contaier
 
 1) Bundle Container: read only, no changes allowed, signed at installation time and Writing to this directory changes the signature and prevents your app from launching
 2) Data Container:
    -> Documents: User visible files. files become visible in “Files” application and user can find their files in spotlight.
    -> Library/Application support: Store files in here that are required for your app but should never be visible to the user like your app’s database file
    -> Lbrary/Cache: Stores files in here that can be discarded when the space is low.This is a good location for any content that can be re-downloaded when needed. Files will never be removed from your cache if your application is running
    -> Temp: Put files in here that your won’t be needing for extended period of time.Even though operating system will periodically remove these files when your app is not running, it’s best to remove them when you are done with them
3) iCloud Cotainer: iCloud drive is the best place to put document because they become available on all of the user devices. Contents of your application folder is visible on the iCloud Drive. Your application reads and writes data locally and when the network is available data is uploaded automatically to iCloud drive.
 */

/**
 DispatchSource - used for detecting changes in files and folders.
 */
func dispatchSourceSample() {
  let urlPath = URL(fileURLWithPath: "/PathToYourFile/log.txt")
  do {
      let fileHandle: FileHandle = try FileHandle(forReadingFrom: urlPath)
      let source = DispatchSource.makeFileSystemObjectSource(fileDescriptor: fileHandle.fileDescriptor,
                                                             eventMask: .write, // .all, .rename, .delete ....
                                                             queue: .main) // .global, ...
      source.setEventHandler(handler: {
          print("Event")
      })
      source.resume()
  } catch {
      // Error
  }
}


// Monitor/detect if the file has changed
class FolderMonitor {
   
    /// A file descriptor for the monitored directory.
    private var fileDescriptor: CInt = -1
    
    /// A dispatch queue used for sending file changes in the directory.
    private let folderMonitorQueue = DispatchQueue(label: "FolderMonitorQueue", attributes: .concurrent)

    /// A dispatch source to monitor a file descriptor created from the directory.
    private var folderMonitorSource: DispatchSourceFileSystemObject?

    /// URL for the directory being monitored.
    let url: URL
    
    var folderDidChange: (() -> Void)?


    init(url: Foundation.URL) {
        self.url = url
    }

    /// Listen for changes to the directory (if we are not already).
    func startMonitoring() {
        guard folderMonitorSource == nil && fileDescriptor == -1 else {
            return
            
        }
        // Open the directory referenced by URL for monitoring only.
        fileDescriptor = open(url.path, O_EVTONLY)
        
        // Define a dispatch source monitoring the directory for additions, deletions, and renamings.
        folderMonitorSource = DispatchSource.makeFileSystemObjectSource(fileDescriptor: fileDescriptor, eventMask: .write, queue: folderMonitorQueue)
        
        // Define the block to call when a file change is detected.
        folderMonitorSource?.setEventHandler { [weak self] in
            self?.folderDidChange?()
        }
        // Define a cancel handler to ensure the directory is closed when the source is cancelled.
        folderMonitorSource?.setCancelHandler { [weak self] in
            guard let self = self else { return }
            close(self.fileDescriptor)
            self.fileDescriptor = -1
            self.folderMonitorSource = nil
        }
        
        // Start monitoring the directory via the source.
        folderMonitorSource?.resume()
    }
    
    /// Stop listening for changes to the directory, if the source has been created.
    func stopMonitoring() {
        folderMonitorSource?.cancel()
    }
}

// Split file into multiple chunks:
let data = try Data(contentsOf: URL(fileURLWithPath: "content.json", relativeTo: .documentsDirectory))
let dataLen = data.count
print("total lenght:", dataLen)
//let chunkSize = ((1024 * 1000) * 4) // MB
let chunkSize = 4 // 4 bytes
let fullChunks = Int(dataLen / chunkSize)
let totalChunks = fullChunks + (dataLen % 1024 != 0 ? 1 : 0)

var chunks: [Data] = [Data]()
for chunkCounter in 0..<totalChunks {
  var chunk: Data
  let chunkBase = chunkCounter * chunkSize
  var diff = chunkSize
  if(chunkCounter == totalChunks - 1) {
    diff = dataLen - chunkBase
  }

  let range = (chunkBase..<(chunkBase + diff))
  chunk = data.subdata(in: range)
  print("The size is \(chunk.count)")
}


