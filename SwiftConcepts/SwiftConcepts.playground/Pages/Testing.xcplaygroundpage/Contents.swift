// Testing:
// Q1) Given the async code below, write a simple unit test with expectation timeout of 2 seconds

import XCTest
final class AsyncTestCase: XCTestCase {
  func test_noServerResponse() {
    let url = URL(string: "dummy URL for failure")!
    URLSession.shared.dataTask(with: url) { data, response, error in
      XCTAssertNil(data)
      XCTAssertNil(response)
      XCTAssertNotNil(error)
    }.resume()
  }
}

// Answer:
//final class AsyncTestCase: XCTestCase {
//
//  func test_noServerResponse() {
//    let expectation = self.expectation(description: "waiting for server response")
//    let url = URL(string: "dummy URL for failure")!
//    URLSession.shared.dataTask(with: url) { data, response, error in
//      defer {
//        self.expectation.fulfill()
//      }
//      XCTAssertNil(data)
//      XCTAssertNil(response)
//      XCTAssertNotNil(error)
//    }.resume()
//
//    waitForExpectation(timeout: 2)
//  }
//}
