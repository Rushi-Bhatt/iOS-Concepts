//
//  StackTests.swift
//  DSATests
//
//  Created by Bhatt,Rushi on 6/16/20.
//  Copyright © 2020 Bhatt,Rushi. All rights reserved.
//

import XCTest
@testable import DSA

class StackTests: XCTestCase {
  var stack =  Stack<Int>()
  override func setUp() {
    stack.push(1)
    stack.push(2)
    stack.push(3)
    stack.push(4)
  }

  func test_description() {
    XCTAssertEqual(stack.description, "1 2 3 4")
  }
  
  func test_push() {
    stack.push(5)
    XCTAssertEqual(stack.description, "1 2 3 4 5")
  }
  
  func test_pop() {
    XCTAssertEqual(stack.pop(), 4)
  }
  
  func test_peek() {
    XCTAssertEqual(stack.peek(), 4)
  }
  
  func test_init() {
    let s = Stack(withArray: [1,2,3,4])
    XCTAssertEqual(s, stack)
  }
  
  func test_arrayLiteral() {
    let s: Stack<Int> = [1, 2, 3, 4]
    XCTAssertEqual(s, stack)
  }
  
  //Challenge: Parenthesis match
  func checkParentheses(_ input: String) -> Bool {
    var result  = true
    var stack: Stack<Character> = []
    input.forEach { (char) in
      if char == "(" {
        stack.push(char)
      } else if char == ")" {
        let topC = stack.pop()
        if topC == nil {
          result = false
        }
      }
    }
    return result && stack.isEmpty()
  }
  
  func test_checkParens() {
    XCTAssertTrue( checkParentheses("()") )
  }
  
  func test_checkParens1() {
    XCTAssertTrue( checkParentheses("hello(world)()") )
  }
  
  func test_checkParens2() {
    XCTAssertFalse( checkParentheses("(hello world") )
  }
  
  func test_checkParens3() {
    XCTAssertFalse( checkParentheses("((())(meow)))()))") )
  }
}
