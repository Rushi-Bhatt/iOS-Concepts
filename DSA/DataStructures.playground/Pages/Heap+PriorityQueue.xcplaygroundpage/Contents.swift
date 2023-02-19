// Complete binary tree: All levels except last level should be filled, and on last level, node should be far left
// Full binary tree: All nodes except leaf nodes should have exactly 2 children
// so Full binary tree is complete, but the converse is not true

// Heap invariant: Parent should always be greater than or equal to child ( or less than or equal to, for min heap)
// Every heap is a complete binary tree, so you can use Array to efficiently represent it and calculate the child indices

// Heap, every element must be Equatable

// Remove: log(n),
// Insert: long(n)
// search: n
// peek: O(1)
// HeapSort: nlog(n)
// shiftDown, shiftUp: log(n)
struct Heap<Element: Equatable> {
  fileprivate var elements: [Element] = []
  let variant: (Element, Element) -> Bool // To determine the min or max heap
  
  var count: Int {
    return elements.count
  }
  
  var isEmpty: Bool {
    return elements.isEmpty
  }
  
  init(from elements: [Element], with variant: @escaping (Element, Element) -> Bool ) {
    self.elements = elements
    self.variant = variant
    createHeap()
  }
  
  func getChildIndices(of parent: Int) -> (left: Int, right: Int) {
    let leftIndex =  2 * parent + 1
    return (leftIndex, leftIndex + 1)
  }
  
  func getParentIndex(of children: Int) -> Int {
    return (children - 1)/2
  }
  
  func peek() -> Element? {
    return elements.first
  }
  
  mutating func createHeap() {
    guard !elements.isEmpty else { return }
    for parent in stride(from: elements.count/2 - 1, through: 0, by: -1) {
      shiftDown(for: parent)
    }
  }
  
  mutating func shiftDown(for index: Int, upto count: Int? = nil) {
    let count = count ?? self.count
    let parentIndex = index
    while true {
      let (leftIndex, rightIndex) = getChildIndices(of: index)
      var optionalSwapIndex: Int?
      if leftIndex < count && variant(elements[leftIndex], elements[parentIndex]) {
        optionalSwapIndex = leftIndex
      }
      if rightIndex < count && variant(elements[rightIndex], elements[optionalSwapIndex ?? parentIndex]) {
        optionalSwapIndex = rightIndex
      }
      guard let swapIndex = optionalSwapIndex else { return }
      elements.swapAt(swapIndex, parentIndex)
      shiftDown(for: swapIndex)
    }
  }
  
  mutating func shiftUp(for index: Int) {
    var childIndex = index
    var parentIndex = getParentIndex(of: index)

    while childIndex > 0 && variant(elements[childIndex], elements[parentIndex]) {
      elements.swapAt(childIndex, parentIndex)
      childIndex = parentIndex
      parentIndex = getParentIndex(of: childIndex)
    }
  }
  
  mutating func insert(_ element: Element) {
    elements.append(element)
    shiftUp(for: elements.count - 1)
  }
  
  mutating func remove(at index: Int) -> Element? {
    guard index < count, index > 0 else { return nil }
    if index == count - 1 {
      return elements.removeLast()
    } else {
      elements.swapAt(index, count - 1)
      defer {
        shiftDown(for: index)
        shiftUp(for: index)
      }
      return elements.removeLast()
    }
  }
  
  mutating func removeRoot() -> Element? {
    guard !isEmpty else { return nil }
    elements.swapAt(0, count - 1)
    let originalRoot = elements.removeLast()
    shiftDown(for: 0)
    return originalRoot
  }
}

extension Array where Element: Equatable {
  init(_ heap: Heap<Element>) {
    var heap = heap
    // HeapSort // nlogn operation
    for index in heap.elements.indices.reversed() { // n times
      heap.elements.swapAt(0, index)
      heap.shiftDown(for: 0, upto: index) // log(n) operation
    }
    self = heap.elements
  }
  
  func isHeap(sortedBy variant: @escaping (Element, Element) -> Bool) -> Bool {
    if isEmpty { return true }
    for parentIndex in stride(from: count/2 - 1, through: 0, by: -1) {
      let parent = self[parentIndex]
      let leftChildIndex = 2 * parentIndex + 1
      if leftChildIndex < count && variant(self[leftChildIndex], parent) {
        return false
      }
      let rightChildIndex = leftChildIndex + 1
      if rightChildIndex < count && variant(self[rightChildIndex], parent) {
        return false
      }
    }
    return true
  }
}

let array = [1, 12, 3, 4, 1, 6, 8, 7]
var heap = Heap(from: array, with: >) // Max heap
print(heap.removeRoot())
let sortedArray = Array(heap)
print(sortedArray)

print(array.isHeap(sortedBy: >))
print(sortedArray.isHeap(sortedBy: >))

let heapArray = [5,4,2,4,3,1]
print(heapArray.isHeap(sortedBy: >))



// Abstract Data Structure and can be created by multiple different ways
// Enqueue and dequeue based on priority
// 1) SortedArray: priority enqueue: O(n), dequeue based on max/min priority: O(1)
// 2) Balanced Binary Search Tree: priority enqueue: O(long(n)), dequeue based on max/min priority: O(long(n))
// 3) Heap: priority enqueue: O(long(n)), dequeue based on max/min priority: O(1)

protocol Queue {
  associatedtype Element
  var isEmpty: Bool { get }
  var peek: Element? { get }
  mutating func enqueue(_ element: Element)
  mutating func dequeue() -> Element?
}

struct PriorityQueue<Element: Equatable>: Queue {
  var heap: Heap<Element>

  var isEmpty: Bool {
    heap.isEmpty
  }
  
  var peek: Element? {
    return heap.peek()
  }
  
  init(from elements: [Element], with variant: @escaping (Element, Element) -> Bool ) {
    self.heap = Heap(from: elements, with: variant)
  }
  
  mutating func enqueue(_ element: Element) {
    heap.insert(element)
  }
  
  mutating func dequeue() -> Element? {
    return heap.removeRoot()
  }
}
