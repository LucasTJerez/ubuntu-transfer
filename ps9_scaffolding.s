arrayMode:	
	# Put your code here.
	li $v0, 0
	jr $ra

######################################################## DO NOT REMOVE THIS SEPARATOR


bugsy:	
	# Put your code here.
	li $v0, 0
	jr $ra

######################################################## DO NOT REMOVE THIS SEPARATOR


isPrime:	
	# Put your code here.
	li $v0, 0
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
