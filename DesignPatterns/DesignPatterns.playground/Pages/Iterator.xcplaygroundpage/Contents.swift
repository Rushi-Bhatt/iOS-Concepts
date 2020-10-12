import Foundation
import UIKit

public struct Queue<T> {
  private var array: [T?] = []
  private var head = 0 // Index of first non-nil element in the array
  
  public var isEmpty: Bool {
    return count == 0
  }
  
  public var count: Int {
    return array.count - head
  }
  
  public mutating func enqueue(_ element: T) {
    array.append(element)
  }
  
  public mutating func dequeue() -> T? {
    guard head < array.count,
      let element = array[head] else {
        return nil
    }
    array[head] = nil
    head += 1
    let percentage = Double(head)/Double(array.count)
    if array.count > 50,
      percentage > 0.25 {
      array.removeFirst(head)
      head = 0
    }
    return element
  }
}

//MARK:- Iterator Protocol Conformance
extension Queue: Sequence {
  public func makeIterator() -> IndexingIterator<Array<T>> {
    let nonEmptyValues = Array(array[head ..< array.count]) as! [T]
    return nonEmptyValues.makeIterator()
  }
}

public struct Ticket {
  enum Priority {
    case low, medium, high
  }
  var desciption: String
  var priority: Priority
}

extension Ticket {
  var sortIndex: Int {
    switch self.priority {
      case .low: return 0
      case .medium: return 1
      case .high: return 2
    }
  }
}

var ticket1 = Ticket(desciption: "Ticket1", priority: .low)
var ticket2 = Ticket(desciption: "Ticket2", priority: .medium)
var ticket3 = Ticket(desciption: "Ticket3", priority: .high)
var ticket4 = Ticket(desciption: "Ticket4", priority: .medium)
var ticketQueue : Queue<Ticket> = Queue()
ticketQueue.enqueue(ticket1)
ticketQueue.enqueue(ticket2)
ticketQueue.enqueue(ticket3)
ticketQueue.enqueue(ticket4)

// See how we can iterate on the Queue using the for-in loop, becuase of the Sequence protocol conformance
for ticket in ticketQueue {
  print(ticket.desciption)
}

// Here you get sorted method for free, because you conform to Sequence protocol instead of just IteratorProtocol
let sortedTickets = ticketQueue.sorted { $0.sortIndex > $1.sortIndex }
print("Sorted based on the Priority")
for ticket in sortedTickets {
  print(ticket.desciption)
}


