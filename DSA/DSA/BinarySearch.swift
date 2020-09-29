//
//  BinarySearch.swift
//  DSA
//
//  Created by Bhatt,Rushi on 6/17/20.
//  Copyright © 2020 Bhatt,Rushi. All rights reserved.
//

import Foundation

//Requirement: To search in a collection, it has to be RandomAccessCollection
// The colletion has to be pre-sorted
// Each Element must be Comparable
// Complexity: O(logn)

extension RandomAccessCollection where Element: Comparable {
  func binarySerch(value: Element, range: Range<Index>? = nil) -> Index? {
    let range = range ?? startIndex..<endIndex
    guard range.lowerBound < range.upperBound else {
      return nil
    }
    let size = distance(from: range.lowerBound, to: range.upperBound)
    let middle = index(range.lowerBound, offsetBy: size/2)
    if self[middle] == value {
      return middle
    } else if self[middle] > value {
      return binarySerch(value: value, range: range.lowerBound..<middle)
    } else {
      return binarySerch(value: value, range: index(after: middle)..<range.upperBound)
    }
  }
}
