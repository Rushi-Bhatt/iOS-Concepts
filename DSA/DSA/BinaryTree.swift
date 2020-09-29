//
//  BinaryTree.swift
//  DSA
//
//  Created by Bhatt,Rushi on 6/17/20.
//  Copyright © 2020 Bhatt,Rushi. All rights reserved.
//

import Foundation

class BinaryNode<Element: Comparable> {
  var value: Element
  var leftChild: BinaryNode?
  var rightChild: BinaryNode?
  init(value: Element) {
    self.value = value
  }
}

extension BinaryNode {
  func inorderTraversal(visit: (Element) -> Void) {
    leftChild?.inorderTraversal(visit: visit)
    visit(value)
    rightChild?.inorderTraversal(visit: visit)
  }
  
  func preorderTraversal(visit: (Element) -> Void) {
    visit(value)
    leftChild?.preorderTraversal(visit: visit)
    rightChild?.preorderTraversal(visit: visit)
  }
  
  func postorderTraversal(visit: (Element) -> Void) {
    leftChild?.postorderTraversal(visit: visit)
    rightChild?.postorderTraversal(visit: visit)
    visit(value)
  }
}

