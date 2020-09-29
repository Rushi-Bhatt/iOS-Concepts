//
//  SortingTests.swift
//  DSATests
//
//  Created by Bhatt,Rushi on 6/17/20.
//  Copyright © 2020 Bhatt,Rushi. All rights reserved.
//

import XCTest
@testable import DSA

class SortingTests: XCTestCase {
  var input: [Int] = []
  var output: [Int] = []
  var sortedArray = [1,3,4,9,10]
  
  override func setUp() {
    input = [3,10,9,4,1]
  }

  func testBubbleSort() {
    bubbleSort(&input)
    XCTAssertEqual(input, sortedArray)
  }
  
  func testSelectionSort() {
    selectionSort(&input)
    XCTAssertEqual(input, sortedArray)
  }
  
  func testInsertionSort() {
    insertionSort(&input)
    XCTAssertEqual(input, sortedArray)
  }
  
  func testMergeSort() {
    output = mergeSort(input)
    XCTAssertEqual(output, sortedArray)
  }

}
