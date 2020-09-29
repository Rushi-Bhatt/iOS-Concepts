//
//  BinarySearchTests.swift
//  DSATests
//
//  Created by Bhatt,Rushi on 6/17/20.
//  Copyright © 2020 Bhatt,Rushi. All rights reserved.
//

import XCTest

class BinarySearchTests: XCTestCase {

  var array: [Int] = [1,3,5,6,8,9,11,15,18,19,26]
  func testBinarySearch() {
    let i = array.binarySerch(value: 11)
    XCTAssertEqual(i, 6)
  }
}
