//Q1)Given a sorted array nums, remove the duplicates in-place such that each element appear only once and returns the new length.
//Given nums = [0,0,1,1,1,2,2,3,3,4],
//
//Your function should return length = 5, with the first five elements of nums being modified to 0, 1, 2, 3, and 4 respectively.
//It doesn't matter what values are set beyond the returned length.

func removeDuplicates(_ nums: inout [Int]) -> Int {
    if nums.count == 0 || nums.count == 1 {
        return nums.count
    }
    var stPoint: Int = 0
    var curPoint: Int = 1
    while curPoint < nums.count {
        if nums[curPoint] != nums[stPoint] {
            stPoint = stPoint + 1
            nums.swapAt(stPoint, curPoint)
        }
        curPoint = curPoint + 1
    }
    return stPoint + 1
}

var nums = [0,0,1,1,1,2,2,3,3,4]
var ans = removeDuplicates(&nums)
print(nums)

//Check if Binary tree is BST or not?
