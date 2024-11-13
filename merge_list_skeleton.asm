	# MIPS Assembly Program Skeleton for MergeArray Procedure

	# You can try with these examples to check the correctness of your program:

	# nums1:   .word 1,7,9            # Input array nums1
	# nums2:   .word 0            # Input array nums2
	# m:       .word 3               # Size of nums1
	# n:       .word 0                # Size of nums2
	# expected output: 1,7,9

	# nums1:   .word 3,4,5,6            # Input array nums1
	# nums2:   .word 1,3,5            # Input array nums2
	# m:       .word 4               # Size of nums1
	# n:       .word 3                # Size of nums2
	# expected output: 1,3,3,4,5,5,6

.data
nums1:      .word   1, 2, 3                 # Input array nums1
nums2:      .word   2, 3, 5, 9              # Input array nums2
m:          .word   3                       # Size of nums1
n:          .word   4                       # Size of nums2
results:    .space  100                     # Assign space to results
newline:    .asciiz "\n"
	# expected output: 1,2,2,3,5,6
.text
            .globl  main

main:
	# Load addresses and sizes into registers
	la      $a0,        nums1                  # $a0 = address of nums1
	lw      $a1,        m                      # $a1 = m
	la      $a2,        nums2                  # $a2 = address of nums2
	lw      $a3,        n                      # $a3 = n
	la      $v0,        results                # $v0 = address of results array

	# Call MergeArray
	jal     MergeArray

	# Copy address to the results to s0
	move    $s0,        $v0

	# Prepare to print the results array
	lw      $t0,        m                      # $t0 = m
	lw      $t1,        n                      # $t1 = n
	add     $t2,        $t0,        $t1        # $t2 = total_length (m + n)
	li      $t3,        0                      # $t3 = index i = 0

print_loop:
	bge     $t3,        $t2,        print_done # If i >= total_length, printing done

	# Load results[i] into $a0
	sll     $t4,        $t3,        2          # $t4 = i * 4
	add     $t5,        $s0,        $t4        # $t5 = address of results[i]
	lw      $a0,        0($t5)                 # $a0 = results[i]

	# Print integer
	li      $v0,        1
	syscall

	# Print space
	li      $a0,        32                     # ASCII code for space
	li      $v0,        11
	syscall

	addi    $t3,        $t3,        1          # i++
	j       print_loop

print_done:
	# Exit the program
	li      $v0,        10
	syscall

	# MergeArray Procedure
	# Arguments:
	#   $a0: Address of nums1
	#   $a1: Size of nums1 (m)
	#   $a2: Address of nums2
	#   $a3: Size of nums2 (n)
	# The address of the results array is passed via the stack.

MergeArray:
	# Save registers that will be used
	# [You should save necessary registers here]
	la      $s1,        0($a0)                 # $s1 = address of nums1
	la      $s3,        0($a2)                 # $s3 = address of nums2

	li      $s2,        0                      # $s2 = i
	li      $s4,        0                      # $s4 = j
	li      $s5,        0                      # $s5 = k
	# Retrieve the address of results from the stack
	# [Load results array address into a register]
	la      $s6,        0($v0)                 # $s6 = address of results

	# Implement the merging logic here
	# [You should write the code to merge nums1 and nums2 into results]
Loop1:
	slt     $t7,        $s2,        $a1        # i < m
	slt     $t8,        $s4,        $a3        # j < n

	beq     $t7,        $zero,      Loop2
	beq     $t8,        $zero,      Loop2

	sll     $t6,        $s5,        2          # shifting[k]
	add     $t6,        $s6,        $t6        # &results[k]

	bgt     $t2,        $t4,        Loop1_Else # if nums1[i] > nums2[j] then go to else

	sll     $t2,        $s2,        2          # shifting [i]
	add     $t2,        $s1,        $t2        # &nums1[i]

	lw      $t1,        0($t2)                 # load nums1[i] w into $t2
	sw      $t1,        0($t6)                 # results[k] = nums1[i]

	addi    $s2,        $s2,        1          # i++
	addi    $s5,        $s5,        1          # k++

	j       Loop1                              # go to loop1
Loop1_Else:
	sll     $t4,        $s4,        2          # shifting [j]
	add     $t4,        $s3,        $t4        # &nums2[j]

	sll     $t6,        $s5,        2          # Shifting[k]
	add     $t6,        $s6,        $t6        # &results[k]

	lw      $t1,        0($t4)                 # load nums2[j] into $t4
	sw      $t1,        0($t6)                 # results[k] = nums2[j]

	addi    $s4,        $s4,        1          # j++
	addi    $s5,        $s5,        1          # k++

	j       Loop1                              # go to loop1


Loop2:
	slt     $t7,        $s2,        $a1        # i < m
	beq     $t7,        $zero,      Loop3

	sll     $t6,        $s5,        2          # shifting[k] * 4
	add     $t6,        $s6,        $t6        # &results[k]

	sll     $t2,        $s2,        2          # shifting [i] *4
	add     $t2,        $s1,        $t2        # &nums1[i]

	lw      $t1,        0($t2)                 # load nums1[i] w into $t2
	sw      $t1,        0($t6)                 # results[k] = nums1[i]

	addi    $s2,        $s2,        1          # i++
	addi    $s5,        $s5,        1          # k++
	j       Loop2
Loop3:
	slt     $t8,        $s4,        $a3        # j < n
	beq     $t8,        $zero,      Exit
	sll     $t4,        $s4,        2          # shifting [j] * 4
	add     $t4,        $s3,        $t4        # nums2[j]

	sll     $t6,        $s5,        2          # shifting[k] * 4
	add     $t6,        $s6,        $t6        # results[k]

	lw      $t1,        0($t4)                 # load nums2[j] into $t4
	sw      $t1,        0($t6)                 # results[k] = nums2[j]

	addi    $s4,        $s4,        1          # j++
	addi    $s5,        $s5,        1          # k++
	j       Loop3

Exit:
	# Return the address of results
	# la      $v0,        0($s6)                 # $v0 = address of results
	# Restore saved registers and return
	# [You should restore saved registers and return to caller]

	jr      $ra                                # Return to caller
