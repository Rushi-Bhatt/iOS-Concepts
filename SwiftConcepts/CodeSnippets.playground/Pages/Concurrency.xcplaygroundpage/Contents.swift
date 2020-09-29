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


