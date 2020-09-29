//
//  Stack.swift
//  DSA
//
//  Created by Bhatt,Rushi on 6/16/20.
//  Copyright © 2020 Bhatt,Rushi. All rights reserved.
//

struct Stack<Element: Equatable> : Equatable {
  private var storage: [Element] = []
  
  init() { }
  
  init(withArray elements: [Element]) {
    storage = elements
  }
  
  mutating func push(_ element: Element) {
    storage.append(element)
  }
  
  @discardableResult
  mutating func pop() -> Element? {
    return storage.popLast()
  }
  
  func peek() -> Element? {
    return storage.last
  }
  
  func isEmpty() -> Bool {
    return storage.isEmpty // OR peek() == nil
  }
  
}

extension Stack: CustomStringConvertible {
  var description: String {
    storage.map { (each) -> String in
      return "\(each)"
    }.joined(separator: " ")
  }
}

extension Stack: ExpressibleByArrayLiteral {
  typealias ArrayLiteralElement = Element
  init(arrayLiteral elements: Self.ArrayLiteralElement...) {
    self.storage = elements
  }
}
