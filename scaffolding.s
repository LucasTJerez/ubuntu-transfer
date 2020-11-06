.text

max:
	# At the start of max, the two arguments can be found in $a0 and $a1.
	# Replace the line below with your function implementation.
	li $v0, 0

    
	# Your return value should be in $v0 prior to returning. 
	# To return from max, use 'jr $ra'
	jr $ra


######################################################## DO NOT REMOVE THIS SEPARATOR


fibonacci:	
	# At the start of fibonacci, the argument can be found in $a0.
	# Replace the line below with your code.
	li $v0, 0
    
	# Your return value should be in $v0 prior to returning. 
	# To return, use 'jr $ra'
	jr $ra

######################################################## DO NOT REMOVE THIS SEPARATOR


minimumBills:	
	# At the start of minimumBills, the argument can be found in $a0.
	# Replace the line below with your code.
	li $v0, 0
    
	# Your return value should be in $v0 prior to returning. 
	# To return, use 'jr $ra'
	jr $ra

######################################################## DO NOT REMOVE THIS SEPARATOR


fizzbuzz:	
	# Do not remove this code.  It is necessary for the subcalls to the print functions.
	addi $sp, $sp, -4
	sw   $ra, 0($sp)

	# Put your code here.
	# To print an integer, put the integer in $a0 and execute 'jal print_int'
	# To print a string, make the appropriate function call:
	#     'jal print_fizz', 'jal print_buzz', 'jal print_fizzbuzz'

	
return_from_fizzbuzz:	
	# return to calling function
	lw   $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra	

######################################################## DO NOT REMOVE THIS SEPARATOR


main:
	
	#
	# Test calls to max()
	#
	jal print_newline
	
	# max(10,11) = 11
	li $a0, 10
	li $a1, 11
	jal max
	move $a0, $v0
	jal print_int

	# max(11,10) = 11
	li $a0, 11
	li $a1, 10
	jal max
	move $a0, $v0
	jal print_int

	# max(10,-5) = 10
	li $a0, 10
	li $a1, -5
	jal max
	move $a0, $v0
	jal print_int

	# max(-5, 0) = 0
	li $a0, -5
	li $a1, 0
	jal max
	move $a0, $v0
	jal print_int

	
	#
	# Test calls to fibonacci()
	#
	jal print_newline
	
	# fibonacci(0) = 0
	li $a0, 0
	jal fibonacci
	move $a0, $v0
	jal print_int

	# fibonacci(4) = 3
	li $a0, 4
	jal fibonacci
	move $a0, $v0
	jal print_int

	# fibonacci(5) = 5
	li $a0, 5
	jal fibonacci
	move $a0, $v0
	jal print_int

	# fibonacci(44) = 701408733
	li $a0, 44
	jal fibonacci
	move $a0, $v0
	jal print_int

	
	#
	# Test calls to minimumBills()
	#
	jal print_newline
	
	# minimumBills(10) = 1
	li $a0, 10
	jal minimumBills
	move $a0, $v0
	jal print_int

	# minimumBills(40) = 4
	li $a0, 40
	jal minimumBills
	move $a0, $v0
	jal print_int

	# minimumBills(57) = 8
	li $a0, 57
	jal minimumBills
	move $a0, $v0
	jal print_int

	# minimumBills(156) = 17
	li $a0, 156
	jal minimumBills
	move $a0, $v0
	jal print_int

	
	#
	# Test calls to fizzbuzz()
	#
	jal print_newline
	
	# fizzbuzz(10) 
	li $a0, 10
	jal fizzbuzz
	jal print_newline

	# fizzbuzz(20) 
	li $a0, 20
	jal fizzbuzz
	jal print_newline

	# fizzbuzz(100) 
	li $a0, 100
	jal fizzbuzz

	
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

print_string:
	li $v0, 4
	syscall
	jr $ra
	
print_fizz:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	la $a0, fizz_string
	jal print_string
	jal print_newline
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra

print_buzz:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	la $a0, buzz_string
	jal print_string
	jal print_newline
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra

print_fizzbuzz:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	la $a0, fizzbuzz_string
	jal print_string
	jal print_newline
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra

	

.data

fizz_string: .asciiz "fizz"
buzz_string: .asciiz "buzz"
fizzbuzz_string: .asciiz "fizzbuzz"
