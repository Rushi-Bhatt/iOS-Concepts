//
//  SortingAlgo.swift
//  DSA
//
//  Created by Bhatt,Rushi on 6/17/20.
//  Copyright © 2020 Bhatt,Rushi. All rights reserved.
//

import Foundation

//Complexity:
//Best case: n-1 passes, O(n)
//Worst case: n*(n-1) passes, O(n^2)
func bubbleSort<Element: Comparable> (_ input: inout [Element]) {
  // No need of sorting if the number of elements are less than 2
  guard input.count >= 2 else { return }
  
  //Outer loop from array lenght to 1
  for end in (1..<input.count).reversed() {
    var swapped = false
    for each in 0..<end {
      if input[each] > input[each + 1] {
        input.swapAt(each, each+1)
        swapped = true
      }
    }
    //If no values are swapped, then exit early without finishing the end loop
    if !swapped {
      return
    }
  }
}

//Complexity:
//Best case:  O(n^2)
//Worst case:  O(n^2)
func selectionSort<Element: Comparable> (_ input: inout [Element]) {
  guard input.count >= 2 else { return }
  for current in 0..<input.count {
    var lowest = current
    
    for next in (current+1)..<input.count {
      if input[next] < input[lowest] {
        lowest = next
      }
    }
    
    if lowest != current {
      //Swap lowest with current
      input.swapAt(lowest, current)
    }
  }
}

//Complexity:
//Best case: O(n)
//Worst case: O(n^2)
func insertionSort<Element: Comparable> (_ input: inout [Element]) {
  guard input.count >= 2 else { return }
  for current in 1..<input.count {
    for shift in (1...current).reversed() {
      if input[shift] < input[shift - 1] {
        input.swapAt(shift, shift-1)
      } else {
        //If no values are swapped, then exit early without finishing the shift loop
        break
      }
    }
  }
}

//Complexity:
//Best case: O(nlogn)
//Worst case: O(nlogn)
func mergeSort<Element: Comparable> (_ input: [Element]) -> [Element] {
  guard input.count > 1 else { return input }
  let middle = input.count/2
  let left = mergeSort(Array(input[0..<middle]))
  let right = mergeSort(Array(input[middle...]))
  return mergeList(left, right)
}

//Function that takes in 2 sorted list and returns the combined sorted list
func mergeList<Element: Comparable> (_ left: [Element], _ right: [Element]) -> [Element] {
  var result: [Element] = []
  var left = left
  var right = right
  while left.count > 0 && right.count > 0 {
    if left.first! < right.first! {
      result.append(left.removeFirst())
    } else {
      result.append(right.removeFirst())
    }
  }
  return result + left + right
}
