//1) Difference between delegates vs KVOs
//2) Solid principle and how familiar are you with each aspect of it?
//3) How familiar are you with storage and persistence on iOS? CoreData, Filemanager, NSUserDefaults/Keychain
//4) Networking: Are you familiar with Codable interface? or Mantle or SwiftyJSON for mapping? binary data -> json -> NSDictionary/NSArray -> your domain model objects.
//5) What are some ways to support newer API methods or classes while maintaining backward compatibility? For instance, if you want your view to have a red tintColor (a method introduced in iOS 7), but your app still supports iOS 6, how could you make sure it won’t crash when running on iOS 6? Another example would be using NSURLSession vs. NSURLConnection – how could you make it so that your code uses the most appropriate of those two classes?
//6) Swift static library vs dynamic library vs framework? https://medium.com/@zippicoder/libraries-frameworks-swift-packages-whats-the-difference-764f371444cd

// https://www.vadimbulavin.com/xcode-build-system/


//Answer:
//Treat deprecated APIs warnings as errors to resolve.
//At runtime, check for OS versions.
//objC : Mark legacy code paths with macros.
//if #available(iOS 8, *, *) {
//self.view.convertPoint(.Zero, toCoordinateSpace:anotherView)
//} else {
//self.view.convertPoint(CGPointZero, toView:anotherView)
//}
//
//Control the number of 3d party libraries.

