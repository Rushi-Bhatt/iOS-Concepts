//
//  Queue.swift
//  DSA
//
//  Created by Bhatt,Rushi on 6/16/20.
//  Copyright © 2020 Bhatt,Rushi. All rights reserved.
//

protocol Queue {
  associatedtype Element
  mutating func enqueue(_ element: Element)
  mutating func dequeue() -> Element?
  func peek() -> Element?
  var isEmpty: Bool { get }
}

struct QueueArray<T>: Queue {
  typealias Element = T
  var storage:[T] = []
  var isEmpty: Bool {
    storage.isEmpty
  }
  
  func peek() -> T? { return storage.first }
  
  //Time Complexity- O(1)
  mutating func enqueue(_ element: T) {
    storage.append(element)
  }
  
  //Time Complexity- O(n)
  @discardableResult
  mutating func dequeue() -> T? {
    return isEmpty ? nil: storage.removeFirst()
  }
}

struct QueueStack<T>: Queue {
  typealias Element = T
  var enqueueStack: [T] = []
  var dequeueStack: [T] = []
  
  var isEmpty: Bool {
    return enqueueStack.isEmpty && dequeueStack.isEmpty
  }
  
  func peek() -> T? {
    return !dequeueStack.isEmpty ? dequeueStack.last : enqueueStack.first
  }
  
  //Time Complexity- O(1)
  mutating func enqueue(_ element: T) {
    enqueueStack.append(element)
  }
  
  //Time Complexity- O(1)
  @discardableResult
  mutating func dequeue() -> T? {
    if dequeueStack.isEmpty {
      dequeueStack = enqueueStack.reversed()
      enqueueStack.removeAll()
    }
    return dequeueStack.removeLast()
  }
}
