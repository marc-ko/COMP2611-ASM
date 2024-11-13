	# Unique Paths Calculation in MIPS Assembly using Dynamic Programming
	# Computes the number of unique paths in an m x n grid

	# You can try with these examples to check the correctness of your program:

	# m: .word 2
	# n: .word 4
	# expected output: 4

	# m: .word 3
	# n: .word 4
	# expected output: 10

	# m: .word 4
	# n: .word 4
	# expected output: 20

	# m: .word 9
	# n: .word 2
	# expected output: 9

.data
m:  .word   9                                       # Example value for m (number of rows)
n:  .word   2                                       # Example value for n (number of columns)
dp: .space  400                                     # Allocate 100 words initialized to 0 for dp array

.text
    .globl  main

main:
	# Load m and n from the data segment
	lw      $a0,            m                          # $a0 = m
	lw      $a1,            n                          # $a1 = n

	# Call AllPaths procedure
	jal     AllPaths

	# The result is in $v0
	# Print the result
	move    $a0,            $v0                        # Move result to $a0 for printing
	li      $v0,            1                          # Syscall for print integer
	syscall

	# Print newline character
	li      $a0,            10                         # ASCII code for newline
	li      $v0,            11                         # Syscall for print character
	syscall

	# Exit the program
	li      $v0,            10                         # Syscall for exit
	syscall

	# Procedure: AllPaths
	# Calculates the number of unique paths from the top-left corner to the bottom-right corner of an m x n grid using dynamic programming.
	# Arguments:
	#   $a0: m (number of rows)
	#   $a1: n (number of columns)
	# Returns:
	#   $v0: number of unique paths

AllPaths:
	# Save registers that will be used
	# [Fill in code here to save registers]


	# Initialize variables
	# [Fill in code here to initialize variables]
	add     $t0,            $a0,    $0                 # $t0 = m
	add     $t1,            $a1,    $0                 # $t1 = n
	move    $s2,            $zero                      # i
	li      $s3,            1                          # j

	li      $s5,            1                          # one

	# Initialize dp[0..n-1] = 1
	# [Fill in code here to initialize dp array]
	la      $s1,            dp

ForLoopInit1:
	bge     $s2,            $t1,    ForLoopEnd1        # if i >= n, exit loop
	sll     $t3,            $s2,    2                  # shift [i] * 4
	add     $t3,            $s1,    $t3                # address of dp[i]

	sw      $s5,            0($t3)                     # dp[i] = j = 1

	addi    $s2,            $s2,    1                  # i++
	j       ForLoopInit1
ForLoopEnd1:

	# Loop over rows i from 1 to m-1
	# [Fill in code here to implement the DP logic]
	li      $s2,            1                          # i = 1

ForLoopNest1:
	bge     $s2,            $t0,    ForLoopNestEnd1    # if i >= m, exit loop
	li      $s3,            1                          # j = 1
ForLoopNest2:
	bge     $s3,            $t1,    ForLoopNestEnd2    # if j >= n, exit loop

	sll     $t6,            $s3,    2                  # shift [j] * 4
	add     $t6,            $s1,    $t6                # address of dp[j]
	lw      $t9,            0($t6)                     # dp[j]

	addi    $t8,            $s3,    -1                 # j - 1
	sll     $t8,            $t8,    2                  # shift [j - 1] * 4
	add     $t8,            $s1,    $t8                # address of dp[j - 1]

	lw      $t7,            0($t8)                     # dp[j - 1]

	move    $t8,            $0
	add     $t8,            $t7,    $t9                # dp[j] + dp[j - 1]

	sw      $t8,            0($t6)                     # dp[j] = dp[j] + dp[j - 1]

	addi    $s3,            $s3,    1                  # j++
	j       ForLoopNest2
ForLoopNestEnd2:
	addi    $s2,            $s2,    1                  # i++
	j       ForLoopNest1
ForLoopNestEnd1:
	# Retrieve the final result from dp[n - 1]
	# [Fill in code here to retrieve the result]
	addi    $t1,            $t1,    -1                 # n - 1
	sll     $t1,            $t1,    2                  # shift [n - 1] * 4
	add     $t1,            $s1,    $t1                # address of dp[n - 1]
	lw      $v0,            0($t1)                     # $v0 = dp[n - 1]

	# Restore registers and return
	# [Fill in code here to restore registers and return]
	jr      $ra                                        # Return to caller
