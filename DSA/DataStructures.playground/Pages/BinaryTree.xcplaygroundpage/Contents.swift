class Node<Element> {
  var value: Element
  var left: Node<Element>?
  var right: Node<Element>?
  
  init(value: Element, left: Node<Element>? = nil, right: Node<Element>? = nil) {
    self.value = value
    self.left = left
    self.right = right
  }
}

extension Node {
  func preOrderTraversal(visit: (Element) -> Void) {
    visit(self.value)
    left?.preOrderTraversal(visit: visit)
    right?.preOrderTraversal(visit: visit)
  }
  
  func inOrderTraversal(visit: (Element) -> Void) {
    left?.preOrderTraversal(visit: visit)
    visit(self.value)
    right?.preOrderTraversal(visit: visit)
  }
  
  func postOrderTraversal(visit: (Element) -> Void) {
    left?.preOrderTraversal(visit: visit)
    right?.preOrderTraversal(visit: visit)
    visit(self.value)
  }
  
  func serialize(visit: (Element?) -> Void) {
    visit(self.value)
    if let left = left {
      left.serialize(visit: visit)
    } else {
      print("self: \(self.value) left: nil")
      visit(nil)
    }
    if let right = right {
      right.serialize(visit: visit)
    } else {
      print("self: \(self.value) right: nil")
      visit(nil)
    }
  }
  
}

func deserialize<Element>(from array: inout [Element?]) -> Node<Element>? {
  guard let value = array.removeLast() else {
    return nil
  }
  let node = Node(value: value)
  node.left = deserialize(from: &array)
  node.right = deserialize(from: &array)
  return node
}

func deserialize<Element>(from array: [Element?]) -> Node<Element>? {
  var reversedArray = Array(array.reversed())
  return deserialize(from: &reversedArray)
}

var binaryTree: Node<Int> = Node<Int>(value: 10)
let five = Node(value: 5)
let fifteen = Node(value: 15)
let three = Node(value: 3)
let eight = Node(value: 8)
let thirteen = Node(value: 13)
binaryTree.left = five
binaryTree.right = fifteen
five.left = three
five.right = eight
fifteen.left = thirteen

var preOrderList: [Int] = []
var inOrderList: [Int] = []
var postOrderList: [Int] = []
binaryTree.preOrderTraversal { preOrderList.append($0) }
binaryTree.inOrderTraversal { inOrderList.append($0) }
binaryTree.postOrderTraversal { postOrderList.append($0) }
print(preOrderList)
print(inOrderList)
print(postOrderList)

// Serialize a binary tree into an array
var searializeList: [Int?] = []
binaryTree.serialize { searializeList.append($0) }
print(searializeList)
let root = deserialize(from: searializeList)
root?.preOrderTraversal { print("node: \($0)")}
