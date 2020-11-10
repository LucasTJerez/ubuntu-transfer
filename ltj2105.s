arrayMode:	
	li $v0, 0
	# $a0 is the array [0,2,4,6,6,8]
	# $s0 = current mode
	# $s1 = occurences of current mode
	# $s2 = sum of current modes
	# $s3 = number of modes
	# $s4 = current number we are counting
	# $s5 = count of current number

	# $t0 = counter from 0 - 5
	li $t0, 0

	addi $sp, $sp, -4
	sw $ra, 0($sp) # store the OG return address

	
	move $t1, $a0 # create pointer pointing to arr[0]
	
	
	li $s0, 0 # current mode = 0
	li $s1, 0 # current mode occurences = 0
	li $s2, 0 # sum(current modes) = 0
	li $s3, 0 # number of current modes = 0
	li $s4, 0
	li $s5, 0


	
	loop:
		beq $t0, 6, end # base case: $t0 == 6

		lw $s4, 0($t1) # load the current word we are counting 
		li $s5, 0 # set current count to 0

		move $t2, $t0 # set j = i
		move $t3, $t1	# create pointer to arr[i]

		loop2:
			beq $t2, 6, end2 # base case: $t2 == 6

			jal check_occurence # if arr[j] == current number: increment current count

			addi $t3, $t3, 4 # move array pointer over
			addi $t2, $t2, 1 # j++
			j loop2
	end2: # continue with initial loop

		jal eval_new_occurance


		addi $t1, $t1, 4 # move array pointer over
		addi $t0, $t0, 1
		j loop


	end:
		div $s2, $s3 
		mflo $t0 
		move $v0, $t0

		lw $ra, 0($sp)
		addi $sp, $sp, 4
		jr $ra

eval_new_occurance:
	# if b < f
	li $t5, 0
	slt $t5, $s1, $s5 # if current mode occurences < current number occurences
	bnez $t5, set_new_mode

	beq $s1, $s5, increment_sum_and_count # if current mode occurences == current number occurences

	jr $ra
	


set_new_mode:
	move $s0, $s4
	move $s1, $s5
	move $s2, $s4
	li $s3, 1
	jr $ra

increment_sum_and_count:
	add $s2, $s2, $s4
	addi $s3, $s3, 1
	jr $ra



	
check_occurence:
	lw $t5, 0($t3) # get the number at arr[j]
	beq $t5, $s4, increment_current_count # check if arr[j] = current number
	jr $ra
increment_current_count:
	addi $s5, $s5, 1
	jr $ra



######################################################## DO NOT REMOVE THIS SEPARATOR


bugsy:	

	li $t0, 1
	beq $a0, $t0, basecase # if x == 1: return 2

	# we are going to have to make a recursive call here, so save ra into stack
	j recur
	

basecase:
	li $v0, 2
	jr $ra

recur:
	

	# if 3 < x: return 3 * bugsy(x-1)
	li $t0, 3
	slt $t1, $t0, $a0 
	bnez $t1, recur1

	# else: return 2 * bugsy(x-1)
	li $s0, 2
	j recursize_step

recur1:
	# we need to store 3 into stack
	li $s0, 3
	j recursize_step

recursize_step:
	addi $sp, $sp, -8
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	addi $a0, $a0, -1
	jal bugsy
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	addi $sp, $sp, 8
	mult $v0, $s0
	mflo $v0	
	jr $ra




######################################################## DO NOT REMOVE THIS SEPARATOR


isPrime:

	# if n < 2: return 0
	li $t0, 2
	slt $t1, $a0, $t0
	bnez $t1, not_prime 

	# if n == i: return 1
	beq $a0, $a1, prime 

	# if n % i == 0: return 0
	div $a0, $a1  
    mfhi $t1
	beqz $t1, not_prime
	
	# recursive step
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	addi $a1, $a1, 1
	jal isPrime

	lw $ra, 0($sp)
	addi $sp, $sp, 4

	jr $ra
	


not_prime:
	li $v0, 0
	jr $ra

prime:
	li $v0, 1
	jr $ra




######################################################## DO NOT REMOVE THIS SEPARATOR


main:
	
	#
	# Test calls to arrayMode()
	#
	jal print_newline
	
	# arrayMode([0, 2, 4, 6, 6, 8]) = 6
	la $a0, arrayTest1 
	jal arrayMode 
	move $a0, $v0
	jal print_int
	jal print_newline

	# arrayMode([0, 2, 2, 2, 2, 0]) = 2
	la $a0, arrayTest2
	jal arrayMode 
	move $a0, $v0
	jal print_int
	jal print_newline

	# arrayMode([0, 2, 2, 6, 6, 10]) = 4
	la $a0, arrayTest3
	jal arrayMode 
	move $a0, $v0
	jal print_int
	jal print_newline

	# arrayMode([-2, -4, -2, -4, 6, 10]) = -3
	la $a0, arrayTest4
	jal arrayMode 
	move $a0, $v0
	jal print_int

	
	#
	# Test calls to bugsy()
	#
	jal print_newline
	
	# bugsy(1) = 2
	li $a0, 1
	jal bugsy
	move $a0, $v0
	jal print_int
	jal print_newline

	# bugsy(5) = 72
	li $a0, 5
	jal bugsy
	move $a0, $v0
	jal print_int
	jal print_newline

	# bugsy(7) = 648
	li $a0, 7
	jal bugsy
	move $a0, $v0
	jal print_int
	jal print_newline

	# bugsy(12) = 157464
	li $a0, 12
	jal bugsy
	move $a0, $v0
	jal print_int

	
	#
	# Test calls to isPrime()
	#
	jal print_newline
	
	# isPrime(10, 2) = 0
	li $a0, 10
        li $a1, 2
	jal isPrime
	move $a0, $v0
	jal print_int
	jal print_newline

	# isPrime(17, 2) = 1
	li $a0, 17
        li $a1, 2
	jal isPrime
	move $a0, $v0
	jal print_int
	jal print_newline

	# isPrime(100, 2) = 0
	li $a0, 100
        li $a1, 2
	jal isPrime
	move $a0, $v0
	jal print_int
	jal print_newline

	# isPrime(227, 2) = 1
	li $a0, 227
        li $a1, 2
	jal isPrime
	move $a0, $v0
	jal print_int

	
	# exit
	li $v0, 10
	syscall	


	
print_int:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	li $v0, 1
	syscall
	jal print_newline
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra

print_newline:
 	li $v0, 11
 	li $a0, 10
 	syscall
	jr $ra


.data

arrayTest1: .word 0, 2, 4, 6, 6, 8
arrayTest2: .word 0, 2, 2, 2, 2, 0
arrayTest3: .word 0, 2, 2, 6, 6, 10
arrayTest4: .word -2, -4, -2, -4, 6, 10
