//
//  QueueTests.swift
//  DSATests
//
//  Created by Bhatt,Rushi on 6/16/20.
//  Copyright © 2020 Bhatt,Rushi. All rights reserved.
//

import XCTest

class QueueTests: XCTestCase {

  var queueArray = QueueArray<String>()
  var queueStack = QueueStack<String>()
  override func setUp() {
    queueArray.enqueue("a")
    queueArray.enqueue("b")
    queueArray.enqueue("c")
    queueArray.enqueue("d")
    
    queueStack.enqueue("a1")
    queueStack.enqueue("b1")
    queueStack.enqueue("c1")
    queueStack.enqueue("d1")
  }
  
  func nextInCircularQueue() -> String? {
    guard let next = queueStack.dequeue() else { return nil }
    queueStack.enqueue(next)
    return next
  }
  
  func test_enqueue() {
    XCTAssertEqual(queueArray.peek(), "a")
    XCTAssertEqual(queueStack.peek(), "a1")
  }
  
  func test_dequeue() {
    XCTAssertEqual(queueArray.dequeue(), "a")
    XCTAssertEqual(queueStack.dequeue(), "a1")
  }
  
  func test_peek() {
    XCTAssertEqual(queueArray.peek(), "a")
    queueArray.dequeue()
    queueArray.dequeue()
    XCTAssertEqual(queueArray.peek(), "c")
    queueArray.dequeue()
    queueArray.dequeue()
    XCTAssertNil(queueArray.peek())
    
    XCTAssertEqual(queueStack.peek(), "a1")
    queueStack.dequeue()
    queueStack.dequeue()
    XCTAssertEqual(queueStack.peek(), "c1")
    queueStack.dequeue()
    queueStack.dequeue()
    XCTAssertNil(queueStack.peek())
  }
  
  func testNextInCircularQueue() {
    XCTAssertEqual(nextInCircularQueue(), "a1")
    XCTAssertEqual(nextInCircularQueue(), "b1")
    XCTAssertEqual(nextInCircularQueue(), "c1")
    XCTAssertEqual(nextInCircularQueue(), "d1")
    XCTAssertEqual(nextInCircularQueue(), "a1")
  }
}
