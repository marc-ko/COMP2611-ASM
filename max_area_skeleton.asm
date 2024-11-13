	# Define the height array and its length for the test case
	# Do not change the names of those variables

	# You can try with these examples to check the correctness of your program:

	# height: .word 1,1
	# n:      .word 2
	# expected output: 1

	# height: .word 1,2,1
	# n:      .word 3
	# expected output: 2

	# height: .word 4,3,2,1,4
	# n:      .word 5
	# expected output: 16
.data


height: .word   1, 2, 4, 3
n:      .word   4
	# expected output: 4
.text
        .globl  main

main:
	# Load the address of the height array into $a0
	la      $a0,            height                 # $a0 = address of height array

	# Load n (length of the array) into $a1
	lw      $a1,            n                      # $a1 = n

	# Call the MaxContainer function
	jal     MaxContainer

	# The result (maximum area) is now in $v0
	# Print the result
	move    $a0,            $v0                    # Move the result into $a0 for printing

	li      $v0,            1                      # Syscall code for print integer
	syscall

	# Exit the program
	li      $v0,            10                     # Syscall code for exit
	syscall

	# Procedure: MaxContainer
	# Purpose: Calculate the maximum area of water that can be contained
	# Input:
	#   $a0 - Address of the height array
	#   $a1 - Length of the array (n)
	# Output:
	#   $v0 - The maximum area calculated
MaxContainer:
	# Initialize stack and save registers
	addi    $sp,            $sp,    -12
	sw      $ra,            0($sp)
	sw      $s0,            4($sp)                 # Save $s0 (left pointer)
	sw      $s1,            8($sp)                 # Save $s1 (right pointer)

	# Initialize left and right pointers, and max area
	li      $s0,            0                      # left pointer = 0
	sub     $s1,            $a1,    1              # right pointer = n - 1
	li      $v0,            0                      # max area initialized to 0

while:
	# Exit condition: if left >= right
	bge     $s0,            $s1,    exit

	# Calculate width = right - left
	sub     $t0,            $s1,    $s0

	# Load height[left] into $t2 and height[right] into $t3
	sll     $t4,            $s0,    2              # $t4 = left * 4 (offset in bytes)
	add     $t4,            $t4,    $a0            # $t4 = address of height[left]
	lw      $t2,            0($t4)                 # $t2 = height[left]

	sll     $t5,            $s1,    2              # $t5 = right * 4 (offset in bytes)
	add     $t5,            $t5,    $a0            # $t5 = address of height[right]
	lw      $t3,            0($t5)                 # $t3 = height[right]

	# Determine min_height = min(height[left], height[right])
	slt     $t6,            $t2,    $t3            # $t6 = 1 if height[left] < height[right]
	beq     $t6,            $zero,  UseRightHeight
	move    $t7,            $t2                    # $t7 = min_height = height[left]
	j       CalculateArea

UseRightHeight:
	move    $t7,            $t3                    # $t7 = min_height = height[right]

CalculateArea:
	# Calculate area = min_height * width
	mult    $t7,            $t0                    # $t7 * width (min_height * width)
	mflo    $t8                                    # $t8 = area

	# Update max area if current area is greater
	bgt     $t8,            $v0,    UpdateMaxArea
	j       MovePointers

UpdateMaxArea:
	move    $v0,            $t8                    # max_area = area

MovePointers:
	# Move pointers based on the smaller height
	# If height[left] < height[right], increment left pointer; else decrement right pointer
	slt     $t6,            $t2,    $t3
	bne     $t6,            $zero,  IncrementLeft
	sub     $s1,            $s1,    1              # right--
	j       while

IncrementLeft:
	addi    $s0,            $s0,    1              # left++
	j       while

exit:
	# Restore saved registers and deallocate stack space
	lw      $ra,            0($sp)
	lw      $s0,            4($sp)
	lw      $s1,            8($sp)
	addi    $sp,            $sp,    12
	jr      $ra                                    # Return with max area in $v0