import Foundation

/* Binary Seach:
 Identification: If question mentions the keyword "sorted", then most likely we can apply have binary seach
 if the array is "unsorted", then also we can apply Binary seach in some cases, but the determination on which direction to go to, will be based on some criteria. (Binary seach on answer concept, like peak element)
 One thing that can be sure about binary seach is the fact that, in each comparison, the seach space will be halved
 */

/* Problem 1: Binary seach: Given a sorted array a, and elemenent n, find the index of n in the array, return -1 otherwise
 I/P:
 arr = [1,2,3,4,5,6,7,8,9,10]
 n = 2
 O/P: 1
 */
func binarySearch(arr: [Int], n: Int, order: @escaping (Int, Int) -> Bool) -> Int {
  guard arr.count > 0 else { return -1 }
  var start: Int = 0
  var end: Int = arr.count - 1
  
  while start <= end {
    // let mid: Int = (start + end)/2
    // Notice how instead of doing above, we are using different formula, because if start and end are big integers such that start+end > Int.max, then there will be an overflow
    // Below formula removes that case by always doing (end-start)/2 and adding that small num to the start
    let mid: Int = start + (end-start)/2
    if arr[mid] == n {
      return mid
    } else if order(arr[mid], n) {
      start = mid + 1
    } else {
      end = mid - 1
    }
  }
  return -1
}

binarySearch(arr: [1,2,3,4,5], n: 4, order: <)

/* Problem 2: Order unknown search: Given a sorted array a and no information on whether its ascending or descending, and elemenent n, find the index of n.
 */

func orderUnknownSortedSeach(arr: [Int], n: Int) -> Int {
  guard arr.count > 0 else { return -1 }
  if arr.count == 1 {
    return arr.first == n ? 0 : -1
  }
  if arr[0] > arr[1] {
    return binarySearch(arr: arr, n: n, order: >)
  } else {
    return binarySearch(arr: arr, n: n, order: <)
  }
}

orderUnknownSortedSeach(arr: [5,4,3,2,1], n: 2)

/* Problem 3: First and last occurence of element: Given a sorted array a and and elemenent n, find the first and last occurence of n in the array.
 I/P: [2,4,10,10,10,15,20], n=10
 O/P: first: 2, last: 4
 
 Same as binary search, but once we find one occurence (mid), instead of returning mid index, we are storing it in result and keep updating it with new mid going left(for first occurence) or going right(for last occurence)
 */

enum Occurence {
  case first, last
}
func findOccurence(in arr: [Int], for n: Int, occurence: Occurence) -> Int {
  guard arr.count > 0 else { return -1 }
  var start = 0
  var end = arr.count - 1
  var result = -1
  while start <= end {
    let mid = start + (end-start)/2
    if arr[mid] == n {
      result = mid
      switch occurence {
      case .first:
        //To find the first occurence, go left side
        end = mid - 1
      case .last:
        //To find the last occurence, go right side
        start = mid + 1
      }
    } else if arr[mid] < n {
      start = mid + 1
    } else {
      end = mid - 1
    }
  }
  return result
}

findOccurence(in: [2,4,10,10,10,15,20], for: 10, occurence: .first)

/* Problem 4: Count of an element in sorted Array: Given a sorted array a and and elemenent n, find the # of occurence of n in the array.
  I/P: [2,4,10,10,10,15,20], n=10
  O/P: 3
 
 Explanation: since its sorted array, we can find the index of last and first occurence of the element, and find count = (last-first)+1
 */

func findNumberOfOccurences(in arr: [Int], for n: Int) -> Int {
  guard arr.count > 0 else { return 0 }
  let first = findOccurence(in: arr, for: n, occurence: .first)
  let last = findOccurence(in: arr, for: n, occurence: .last)
  guard first != -1 && last != -1 else { return 0 }
  return last - first + 1
}

findNumberOfOccurences(in: [2,4,10,10,10,15,20], for: 10)
findNumberOfOccurences(in: [2,4,11,11,12,15,20], for: 10)

/* Problem 5: Number of times sorted array is rotated: Given a ascending sorted array, find out how many times its rotated
I/P: arr = [8,10,12,14,16,2,4,6]
O/P: 3
Explanation: number of rotation is always equal to the index of minimum element in the array (AntiClockWise) or (total count-index of minimun element in array)(clockwise)
 So in above case, index of 2 is 5, total elements = 8, so
 times of rotation (anticlock): 5
 times of rotation (clockwise): 3 (8-5)
 
 so if we find the index of minimum element, we can find the number of rotations.
 a number in rotated sorted array is minimum is its surrounded by bigger numbers both side, and that should be the first element in the array when it wasnt rotated
 so if min element is at mid index, then mid-1 and mid+1 should be bigger than min
 
 next: mid + 1 -> can also be written as (mid + 1) % N -> to point to the first index for the last element
 prev: mid - 1 -> can also be written as (mid + N - 1) % N -> to point to the last index for the first element
 Base condition: If array is already sorted, i.e first < last, then no rotation happened
 
 Now if we cant find mid the first run, then we need to reduce the array by going left or right. But which side?
 [8,10,12,14,16,2,4,6]
  s        m        e
 here prev and next of m are not bigger, so, we need to go to the right to find min. element, which is also unsorted side. (mid 14 > end 6)
 so always move to the unsorted side, by comparing start and mid, and mid and end.
 
 so three steps:
 1) find the index of min. element
 2) to do that, find the mid where prev and next are bigger
 3) Now if we cant find that mid, then we need to go either left or right , but where? Always go to the unsorted side.
 */

func numberOfRotations(for arr: [Int]) -> Int {
  guard arr.count > 1 else { return 0 }
  guard let first = arr.first, let last = arr.last, first >= last else {
    //Still sorted, no rotation happened
    return 0
  }
  var start = 0
  var end = arr.count - 1
  while start <= end {
    let mid = start + (end-start)/2
    let prev = (mid + arr.count - 1) % arr.count
    let next = (mid + 1) % arr.count
    
    if arr[mid] <= arr[prev] && arr[mid] <= arr[next] {
      // found the min. element at mid
      return arr.count - mid
      // or return mid for anticlock rotations
    } else if arr[0] >= arr[mid] {
      // Unsorted array on left, seach only in that
      end = mid - 1
    } else if arr[mid] >= arr[arr.count-1] {
      // Unsorted array on right, seach only in that
      start = mid + 1
    }
  }
  return 0
}

numberOfRotations(for: [8,10,12,14,16,2,4,6])

/* Problem 6: Find element in rotated sorted array: Given a ascending sorted array, find out how many times its rotated
 I/P: arr = [8,10,12,14,16,2,4,6], n: 16
 O/P: 4
 
 I/P: arr = [8,10,12,14,16,2,4,6], n: 15
 O/P: -1
 
 Explanation: based on the above question, we can find the min element of the sorted rotated array.
 The characteristic of min element is that both side of min elements are always the sorted arrays. start to min.-1 and min to end arrays are always sorted.
 So instead of applying BS to one sorted array, we will find min. element, and get 2 sorted arrays, one each side. And apply BS in each of them to find the element
 
 min_index = (arr.count - numberOfRotations(for: arr)) % arr.count
 
 Important to use  % arr.count for already sorted array, otherwise min index of min element will be arr.count - 1 instead of 0
*/

func findInRotatedSorted(arr: [Int], n: Int) -> Int {
  guard arr.count > 0 else { return -1 }
  
  let min_index = (arr.count - numberOfRotations(for: arr)) % arr.count
  let left = binarySearch(arr: Array(arr[0...min_index]), n: n, order: <)
  let right = binarySearch(arr: Array(arr[min_index...]), n: n, order: <)
  
  if left != -1 { return left }
  return right
}

findInRotatedSorted(arr: [8,10,12,14,16,2,4,6], n: 16)
findInRotatedSorted(arr: [2,4,6,8,10,12,14,16], n: 16)
findInRotatedSorted(arr: [8,10,12,14,16,2,4,6], n: 15)

/* Problem 7: Find an element in nearly sorted array:
 Nearly sorted array: array is nearly sorted if an element which is supposed to be at ith position, is in these positions (i-1, i, i+1)
 I/P: [5,10,30,20,40], n: 20
 O/P: 3
 Explanation:

 */
func findInNearlySortedArr(arr: [Int], n: Int) -> Int {
  guard arr.count > 0 else { return -1 }
  var start = 0
  var end = arr.count - 1
  while start <= end {
    let mid = start + (end-start)/2
    if arr[mid] == n {
      return mid
    } else if mid-1 >= start && arr[mid-1] == n {
      // Notive we are not using prev index (like in rotated array)
      // here we need to check if mid is the first element, then mid-1 will be out of bounds (not last index like rotated array)
      return mid - 1
    } else if mid+1 <= end && arr[mid+1] == n {
      // Notive we are not using next index (like in rotated array)
      // here we need to check if mid is the last element, then mid+1 will be out of bounds (not 0th index like rotated array)
      return mid + 1
    } else if arr[mid] < n {
      start = mid + 2 // Notice we are moving by 2, since mid + 1 we already compared
    } else if arr[mid] > n {
      end = mid - 2 // Notice we are moving by 2, since mid - 1 we already compared
    }
  }
  return -1
}

findInNearlySortedArr(arr: [5,10,30,20,40], n: 20)

/* Problem 8: Find the floor of an element in sorted array:
 Floor of an element n: if n is present in the array, then n
 else, return the greatest element smaller than n.
 
 I/P: [2,4,6,8,10,12,14,16,18] n: 15
 O/P: 14
 
 I/P: [2,4,6,8,10,12,14,16,18] n: 12
 O/P: 12
 
 Explanation: Run a normal BS, if we find the element as mid, then return it
 else, if mid < n, then we have one possible candidate, so store it
 if mid > n, then we dont care about those values, since it will never be a floor
 */

func floorElement(in arr: [Int], for n: Int) -> Int {
  guard arr.count > 0 else { return -1 }
  var start = 0
  var end = arr.count - 1
  var result = -1
  while start <= end {
    let mid = start + (end-start)/2
    
    if arr[mid] == n {
      return arr[mid] //floor is same as the element
    } else if arr[mid] < n {
      result = arr[mid] // store the value of mid as a candidate everytime we find smaller mid than n
      start = mid + 1
    } else if arr[mid] > n {
      end = mid - 1
    }
  }
  return result
}

floorElement(in: [2,4,6,8,10,12,14,16,18], for: 14)
floorElement(in: [2,4,6,8,10,12,14,16,18], for: 15)
floorElement(in: [2,4,6,8,10,12,14,16,18], for: 19)

/* Problem 9: Find the ceil of an element in sorted array:
 Ceil of an element n: if n is present in the array, then n
 else, return the smallest element greater than n.
 
 I/P: [2,4,6,8,10,12,14,16,18] n: 15
 O/P: 16
 
 I/P: [2,4,6,8,10,12,14,16,18] n: 12
 O/P: 12
 
 Explanation: Run a normal BS, if we find the element as mid, then return it
 else, if mid > n, then we have one possible candidate, so store it
 if mid < n, then we dont care about those values, since it will never be a floor
 */

func CeilElement(in arr: [Int], for n: Int) -> Int {
  guard arr.count > 0 else { return -1 }
  var start = 0
  var end = arr.count - 1
  var result = -1
  while start <= end {
    let mid = start + (end-start)/2
    
    if arr[mid] == n {
      return arr[mid] //floor is same as the element
    } else if arr[mid] < n {
      start = mid + 1
    } else if arr[mid] > n {
      result = arr[mid] // store the value of mid as a candidate everytime we find greater mid than n
      end = mid - 1
    }
  }
  return result
}

CeilElement(in: [2,4,6,8,10,12,14,16,18], for: 14)
CeilElement(in: [2,4,6,8,10,12,14,16,18], for: 15)
CeilElement(in: [2,4,6,8,10,12,14,16,18], for: 1)

/* Problem 10: Next alphabetic element: Given a sorted array of character, and a key, find the next alphabetic element of key from the array.
 I/P: ["a", "c", "f", "h"], n = "f"
 O/P: "h"
 
 I/P: ["a", "c", "f", "h"], n = "h"
 O/P: "#"
 
 Explanation: Same as Ceil problem with 1 difference:
 In ceil problem, if arr[mid] == n, then you return that, as ceil(5) is 5
 here, we dont need to return that, we need to continue the search and return next element from the array
 So why not just return array[mid+1]?
 well, because array might have duplicates, and we dont want to give the same element in that case. Consider below example:
 
 I/P: ["a", "c", "f", "f", "h"], n = "f"
 O/P: "h" (simply returning arr[mid+1] would have returned "f", not "h")
 */

func nextAlphabeticElement(in arr: [Character], for n: Character) -> Character {
  var result: Character = "#"
  guard arr.count > 0 else { return result }
  var start = 0
  var end = arr.count - 1
  while start <= end {
    let mid = start + (end-start)/2
    if arr[mid] == n {
      // Continue the search of the right side, to find the next element higher than n
      start = mid + 1
    } else if arr[mid] < n {
      start = mid + 1
    } else if arr[mid] > n {
      result = arr[mid] // store the value of mid as a candidate everytime we find greater mid than n
      end = mid - 1
    }
  }
  return result
}

nextAlphabeticElement(in: ["a", "c", "f", "f", "h"], for: "f")
nextAlphabeticElement(in: ["a", "c", "f", "f", "h"], for: "h")
nextAlphabeticElement(in: ["a", "c", "f", "f", "h"], for: "g")
nextAlphabeticElement(in: ["a", "c", "f", "f", "h"], for: "c")

/* Find position of an element in infinite sorted array:
I/P: [1,3,5,7,9,11,13,15,17,19....], n = 13
O/P: 6
Explanation: If it was a finite sorted array, we would have applied Binary seach here, with start as 0 and end as arr.count - 1
 but for Infinite array, we dont know where the end is.
 so we can start by taking the end as 1 and keep 2x ing the end till its smaller than the n
 each time, we will make old_end as new start, and 2*old_end as new end
 
 Here, its upto us to decide on what iterations we want to increase the end by. if we increase it by 10x, then each BS will be lengthier and increases the complexity
 
 finally once we find the start and end, apply BS on that array slice, and add it to start
*/

func findInInfiniteArray(arr: [Int], n: Int) -> Int {
  guard arr.count > 0 else { return -1 }
  guard arr.count >= 2 else { return binarySearch(arr: arr, n: n, order: <) }
  var start = 0
  var end = 1
  while arr[end] < n {
    start = end
    end = end * 2
  }
  return start + binarySearch(arr: Array(arr[start...end]), n: n, order: <) //Dont forget to add it to the start
}

findInInfiniteArray(arr: [1,3,5,7,9,11,13,15,17,19], n: 13)

/* Find index of first 1 in binary sorted infinite array:
 I/P: [0,0,0,0,0,0,0,0,1,1,1,....]
 O/P: 8
 
 Explanation: If you observe closely, it is a combined problem of
 1) Finding element in infinite array
 2) Finding first occurence of an element
 */
func indexOfFirst1(in arr:[Int]) -> Int {
  let n = arr.count
  guard n > 0 else { return -1 }
  guard n >= 2 else { return arr[0] == 1 ? 0 : -1 }
  var start = 0
  var end = 1
  while arr[end] == 0 {
    start = end
    end = end * 2
  }
  return start + findOccurence(in: Array(arr[start...end]), for: 1, occurence: .first) //Dont forget to add it to the start
}

indexOfFirst1(in: [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1])

/* Minimum difference element in sorted array: Given a sorted array arr, and a key, find the element from the array which has the minimum absolute difference with the key
 I/P: arr = [1,3,4,6,8,10,15], key: 12
 O/P: 10
 
 Explanation: We can just find the floor and ceil value of the key, and see the difference between floor and key, and ceil and key
 if key is present, then diff = 0, and return key
 if key is not present, then return minimum of abs(floor - key), abs(ceil - key)
*/

func minimumElementDifference(in arr: [Int], with key: Int) -> Int {
  guard arr.count > 0 else { return -1 }
  let floor = floorElement(in: arr, for: key)
  let ceil = CeilElement(in: arr, for: key)
  if floor == ceil {
    // Element present in the array, return the same
    return key
  } else if abs(floor - key) < abs(ceil - key) {
    return floor
  } else {
    return ceil
  }
}

minimumElementDifference(in: [1,3,4,6,8,10,15], with: 12)
minimumElementDifference(in: [1,3,4,6,8,10,12,15], with: 12)

/* Binary seach on answer: Peak element:
A peak element is an element that is strictly greater than its neighbors.

Given an integer array nums, find a peak element, and return its index. If the array contains multiple peaks, return the index to any of the peaks.

You may imagine that nums[-1] = nums[n] = -∞.
You must write an algorithm that runs in O(log n) time.

Input: nums = [1,2,1,3,5,6,4]
Output: 5
Explanation: Your function can return either index number 1 where the peak element is 2, or index number 5 where the peak element is 6.
 
Here, as you can see, we only have the criteria for what we are looking for, so we can still apply binary seach on answer concept. For each mid, we check if its a peak element, if not, we move to one side. Now which side to go to?
 consider array [1,2,1,3,5,6,4], here mid = 3, which isnt a peak element, since 3<5
 so, what we can either go left, or right. But statistically,
 1 cant be a peak element, since 3 is already greater than 1
 5 can or can not be a peak element, depends on whats next of 5 but alteast 3<5.
 so we go right, and continue the process.
 
There will always be a peak on right side, no matter what, even if it ends up being a last element. for exp. consider 2 extreme scenrios where after 5, there are all increasing or decreasing numbers...
 [1,2,1,3,5,4,3,2] if we go right here, 5 becomes the peak
 [1,2,1,3,5,6,7,8] if we go right here, 8 becomes the peak
*/

func findPeak(in arr: [Int]) -> Int {
  let n = arr.count
  guard n > 0 else { return -1 }
  var start = 0
  var end = n - 1
  while start <= end {
    let mid = start + (end-start)/2
    if mid > 0 && mid < n-1 {
      if arr[mid] > arr[mid+1] && arr[mid] > arr[mid-1] {
        return mid
      } else if arr[mid+1] > arr[mid] {
        // Move towards right
        start = mid + 1
      } else if arr[mid-1] > arr[mid] {
        // Move towards left
        end = mid - 1
      }
    } else if mid == 0 {
      // First element only needs to be compared with next element
      return arr[0] > arr[1] ? 0 : 1
    } else if mid == n-1 {
      // Last element only needs to be compared with previous element
      return arr[n-1] > arr[n-2] ? n-1 : n-2
    }
  }
  return -1
}

findPeak(in: [1,2,1,3,5,6,7,8])
findPeak(in: [1,2,1,3,5,4,3,2])
findPeak(in: [1,2,1,3,5,6,4])

/* Find maximum element in Bitonic array:
Given an array of integers which is initially increasing and then decreasing, find the maximum value in the array.
Example :
Input: arr[] = {8, 10, 20, 80, 100, 200, 400, 500, 3, 2, 1}
Output: 500

Corner case (No decreasing part)
Input: arr[] = {10, 20, 30, 40, 50}
Output: 50

Corner case (No increasing part)
Input: arr[] = {120, 100, 80, 20, 0}
Output: 120

 Bitnoic array is different than rotated sorted array, rotated sorted array becomes sorted after x rotations, but bitonic array doesnt become sorted
 after x rotations

 if you observe carefully, maximum element in the bitonic array is going to be the peak element, as it will be surrounded by 2 smaller elements
 so this question is nothing but finding a peak element as prev question
 */

func findMaxInBitonicArray(arr: [Int]) -> Int {
  return findPeak(in: arr)
}

findMaxInBitonicArray(arr: [8, 10, 20, 80, 100, 200, 400, 500, 3, 2, 1])
findMaxInBitonicArray(arr: [10, 20, 30, 40, 50])
findMaxInBitonicArray(arr: [120, 100, 80, 20, 0])

/* Search an element in Bitonic array:
Given a Bitonic array, seach an index of element k.
I/P: [8, 10, 20, 80, 100, 200, 400, 500, 3, 2, 1], k: 80
O/P: 3
Explanation: The property of Bitnoic array is that its first increasing and then decreasing. Maximum value in the Bitonic array is the one that differentiates these 2 arrays. So if we split the array into 2 parts based on the peak element, we will get 2 sorted arrays, and then we can apply binary seach on each.
 [8, 10, 20, 80, 100, 200, 400, 500] and [3,2,1]
*/

func searchInBitonicArray(arr: [Int], n: Int) -> Int {
  guard arr.count > 0 else {
    return -1
  }
  let peakIndex = findMaxInBitonicArray(arr: arr)
  let increasingArray = Array(arr[0...peakIndex])
  let descrasingArray = Array(arr[(peakIndex+1)...])
  
  // Find in both arrays, and return the index
  return binarySearch(arr: increasingArray, n: n, order: >) != -1
    ? binarySearch(arr: increasingArray, n: n, order: >)
    : binarySearch(arr: descrasingArray, n: n, order: <)
}

searchInBitonicArray(arr: [8, 10, 20, 80, 100, 200, 400, 500, 3, 2, 1], n: 80)

/* Search in Row wise Column wise sorted array:
 Given an n x n matrix and a number x, find the position of x in the matrix if it is present in it. Otherwise, print “Not Found”. In the given matrix, every row and column is sorted in increasing order. The designed algorithm should have linear time complexity.
 
  Input: mat[4][4] = { {10, 20, 30, 40},
                       {15, 25, 35, 45},
                       {27, 29, 37, 48},
                       {32, 33, 39, 50}};
         x = 29
 Output: Found at (2, 1)
 
Explanation: all the rows are sorted, and all the columns are sorted, so (0, X) is less than (0, X+1) and (Y,0) < (Y+1,0) but that doesnt mean that (2,3) < (0,2), i.e in the column with 10, we also have 27 which is less than 20
So we cant simply apply Binary seach on first row, and then go from there.
Solution: Start with the top right corner, we know that
if key > arr[m][n]  than we need to go row ++ (down)
if key < arr[m][n] than we need to go col -- (left)
Continue this process until we find the element or we go out of range

Worst case it goes from top right to bottom left corner, and will have a complexity of O(m+n)
*/

func searchInSortedMatrix(arr: [[Int]], key: Int) -> (Int, Int) {
  let m = arr.count // Rows
  guard m > 0 else {
    return (-1,-1)
  }
  let n = arr[0].count // Cols
  
  var i = 0
  var j = n-1
  while i <= m && j >= 0 {
    if arr[i][j] == key {
      return (i,j)
    } else if arr[i][j] < key {
      print("Go down")
      i += 1
    } else if arr[i][j] > key {
      print(arr[i][j], key)
      print("Go left")
      j -= 1
    }
  }
  return (-1,-1)
}

searchInSortedMatrix(arr: [[10, 20, 30, 40],
                           [15, 25, 35, 45],
                           [27, 29, 37, 48],
                           [32, 33, 39, 50]], key: 29)


/* Allocate minimum number of max pages:
 Given number of pages in n different books and m students. The books are arranged in ascending order of number of pages.
 Every student is assigned to read some consecutive books.
 The task is to assign books in such a way that the maximum number of pages assigned to a student is minimum.
 
 Every student must read atleast 1 book.
 Book allocation must be in order

 Input : pages[] = {12, 34, 67, 90}
         m = 2
 Output : 113
 Explanation:
 There are 2 number of students. Books can be distributed
 in following fashion :
   1) [12] and [34, 67, 90]
       Max number of pages is allocated to student
       2 with 34 + 67 + 90 = 191 pages
   2) [12, 34] and [67, 90]
       Max number of pages is allocated to student
       2 with 67 + 90 = 157 pages
   3) [12, 34, 67] and [90]
       Max number of pages is allocated to student
       1 with 12 + 34 + 67 = 113 pages

 Of the 3 cases, Option 3 has the minimum pages = 113.
 
 Explanation: So here, we want to minimize the maximum number of pages for a student. So lets consider a scale indicating maximum number of pages for a student
 
 start.....x.....end

 
 To determine end, max pages for any student will be the sum of all pages
 to determine start, the lowest value for max pages will be the max of all books. so, [12,34,67,90] the way to distribute this is,
 each student must have min 1 book, so one of the student will atleast get just one book with max (90) pages (distribution 3)
 so thats the min.
 
 so the scale can now be...
 max(pages) ... x.... sum(pages)
 90 ... x... 203 in above example
 
 so, we have gotten our start and end, now we need to find the mid, and see if mid fits the criteria.
 That criteria is as follows:
 isValid(mid) => if we can allocate all the books to all the students, and each student is getting pages less than mid
 i.e in this case,
 
 scale: 90 ... 203, mid = 293/2  = 146
 distribution:
 student 1: 12 + 34 + 67 .....+ 90 (Nope, adding last 90 crosses the 146 mark), so 113 (< 146)
 student 2: 90 (<146)
 since we can distribute the books without crossing the mid value, and adding new students, this is a valid distribution for 146 mid.
 
 but we can do better, so, lets go left, start = 90, end = old mid = 146
 and re run the same.
 
 In the end, we will find a value that is exactly the distribution required.
 */

func allocateMinNumberOfMaxPages(in books: [Int], m: Int) -> Int {
  guard books.count > 0 else { return -1 }
  var start = books.max(by: <)!
  var end = books.reduce(0, +)
  var result = -1
  while start <= end {
    let mid = start + (end-start)/2
    if isPossible(books: books, mid: mid, students: m) {
      // Valid distribution can be done for m students with mid #of max pages, lets optimize more
      result = mid
      end = mid - 1
    } else {
      // Valid distribution cant be done for m students with mid #of max pages, lets increase the mid
      start = mid + 1
    }
  }
  return result
}

func isPossible(books: [Int], mid: Int, students: Int) -> Bool {
  var requiredStudents = 1
  var sum = 0
  for i in 0..<books.count {
    sum = sum + books[i]
    if sum > mid {
      requiredStudents += 1
      sum = books[i] //Initiate sum with last value, calculation stars for new student from here
      if requiredStudents > students { return false } // Fail early if already we need more students for distribution
    }
  }
  
  print("isPossible(books: [Int], mid: \(mid), students: \(students)", requiredStudents <= students)
  return requiredStudents <= students
}

allocateMinNumberOfMaxPages(in: [12,34,67,90], m: 2)
