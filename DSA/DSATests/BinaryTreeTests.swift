//
//  BinaryTreeTests.swift
//  DSATests
//
//  Created by Bhatt,Rushi on 6/17/20.
//  Copyright © 2020 Bhatt,Rushi. All rights reserved.
//

import XCTest
@testable import DSA

class BinaryTreeTests: XCTestCase {
    
  var tree: BinaryNode<Int> = {
    let zero = BinaryNode(value: 0)
    let one = BinaryNode(value: 1)
    let five = BinaryNode(value: 5)
    let three = BinaryNode(value: 3)
    let eight = BinaryNode(value: 8)
    let four = BinaryNode(value: 4)
    zero.leftChild = one
    zero.rightChild = five
    one.leftChild = three
    one.rightChild = eight
    five.leftChild = four
    return zero
  }()
  
  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  func testInOrderTraversal() {
    var testArray: [Int] = []
    tree.inorderTraversal { (each) in
      testArray.append(each)
    }
    XCTAssertEqual(testArray, [3,1,8,0,4,5])
  }
  
  func testPreOrderTraversal() {
    var testArray: [Int] = []
    tree.preorderTraversal { (each) in
      testArray.append(each)
    }
    XCTAssertEqual(testArray, [0,1,3,8,5,4])
  }
  
  func testPostOrderTraversal() {
    var testArray: [Int] = []
    tree.postorderTraversal { (each) in
      testArray.append(each)
    }
    XCTAssertEqual(testArray, [3,8,1,4,5,0])
  }
  

}
