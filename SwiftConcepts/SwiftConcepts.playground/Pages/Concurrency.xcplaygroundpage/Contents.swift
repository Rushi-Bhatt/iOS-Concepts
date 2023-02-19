import Foundation

//Q1: Sync vs Serial, Async vs Concurrent
//Q2: Benefits of Operation over GCD:
//1. Operation Dependencies: addDependency(_:) and removeDependency(_:)
//2. KVO-Compliant Properties: you can observe these properties to control other parts of your application
//3. Operations can be paused, resumed, and cancelled. Once you dispatch a task using Grand Central Dispatch, you no longer have control or insight into the execution of that task.
//Q3:
// How will you modify this code on high level so that
// we only upload post after all photos upload is done?
// You can use GCD or operations, your choice
// upload takes an optional completion block
//func publish(_ post: Post) {
//    for photo in post.photos {
//        upload(photo)
//    }
//    upload(post)
//}
// How will you modify this code on high level so that
// we only upload post after both photo and video upload is done?

//A3:
//func publish(_ post: Post) {
//    let group = DispatchGroup()
//    for photo in post.photos {
//        group.enter()
//        upload(photo) {
//          print("Upload done")
//          group.leave()
//      }
//    }
//  group.notify(queue: DispatchQueue.global() { upload(post) }
//}



//Q4: What are the Challenges of Concurrent Programming?
//Sharing of resources or race condition
//Mutual exclusion
//Deadlocks
//Starvation
//Priority inversion

//Q5: Are you familiar with reader writer problem in iOS? how to resolve that?
//Using concurrent queues with barriers helps us improve and speed up our code while eliminating the readers-writers problem
//Make writing task as barrier task so it will only be done on seril queue

let serialQueue = DispatchQueue(label: "serialQueueSample")
serialQueue.async {
    print("serialQueueSample - 1")
}
serialQueue.sync {
    sleep(1)
    print("serialQueueSample - 2")
}
serialQueue.sync {
    print("serialQueueSample - 3")
}
serialQueue.sync {
    print("serialQueueSample - 4")
}

func ambiguous() -> Int { 5 }
func ambiguous() -> String { "Fildo" }

(ambiguous as () -> String)()

let concurrentQueue = DispatchQueue(label: "concurrentQueueSample", attributes: .concurrent)
  concurrentQueue.async {
    print("concurrentQueueSample - 1")
  }
  concurrentQueue.async {
    sleep(2)
    print("concurrentQueueSample - 2")
  }
  concurrentQueue.async {
    sleep(1)
    print("concurrentQueueSample - 3")
  }
  concurrentQueue.async {
    print("concurrentQueueSample - 4")
  }

class LZPRPTTrick {
    let first = "Patrick"
    let last = "Chase"
    lazy var full = first + last // Illegal
}
