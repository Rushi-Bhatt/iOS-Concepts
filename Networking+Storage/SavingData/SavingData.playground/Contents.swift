import Foundation

//Document Directory URL

FileManager.documentDirectory
FileManager.documentDirectory.path

//URLs and Paths

let remidersURL = URL(fileURLWithPath: "Reminder", relativeTo: FileManager.documentDirectory)

let stringURL = FileManager.documentDirectory.appendingPathComponent("String").appendingPathExtension("txt")

remidersURL.path
stringURL.path

let challengeString: String = "To do list"
let challengeURL: URL = URL(fileURLWithPath: challengeString, relativeTo: FileManager.documentDirectory).appendingPathExtension("txt")

challengeURL.lastPathComponent

//Data and Data types

var ui8: UInt8 = 3
var i8: Int8 = -2

MemoryLayout<Int8>.size
MemoryLayout.size(ofValue: ui8)
UInt8.min
Int8.max

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
savedByteArrayString.write(to: catsURL, atomically: true, encoding: .utf8)

//read
let savedCatStrings = try String(contentsOf: catsURL)

