.text

max:
	# At the start of max, the two arguments can be found in $a0 and $a1.
	# Replace the line below with your function implementation.
	li $v0, 0
	ble $a0, $a1, max1
	move $v0, $a0
	jr $ra

max1:
	move $v0, $a1
	jr $ra


######################################################## DO NOT REMOVE THIS SEPARATOR


fibonacci:	
	# At the start of fibonacci, the argument can be found in $a0.
	# Replace the line below with your code.
	li $v0, 0

	
	li $t0, 0 # initialize the sum to 0
	li $t1, 0 # initialize the counter to 0
	li $t2, 0 # initialize previous val to 0

	j fib
	

	
fib:
	blt $t1, $a0, fibBranch # counter < a0? fibBranch

 	move $v0, $t0
 	jr $ra

 fibBranch:
 	beqz $t1, fibBranchZero # counter = 0? fibBranch

 	move $t3, $t0 # create temporary sum
	
 	add $t0, $t0, $t2 # sum = sum + previous val

 	move $t2, $t3 # set previous value equal to previous sum

 	addi $t1, 1

 	j fib


fibBranchZero:
 	addi $t0, 1 # if the current sum is 0, add 1 to the sum
 	addi $t1, 1 # add one to counter
 	j fib

######################################################## DO NOT REMOVE THIS SEPARATOR


minimumBills:	
	# At the start of minimumBills, the argument can be found in $a0.
	# Replace the line below with your code.
	li $v0, 0

	move $t0, $a0 # currentMoney = totalMoney
	li $t1, 0 # count = 0
	
	j countBills

countBills:

	li $t2, 10
	bge $t0, $t2, subtract10

	li $t2, 5
	bge $t0, $t2, subtract5

	li $t2, 1

	bge $t0, $t2, subtract1


	move $v0, $t1
	jr $ra


subtract10: # subtract 10 from currentMoney and add 1 to count
	sub $t0, $t0, $t2
	addi $t1, 1 
	j countBills

subtract5: # subtract 5 from currentMoney and add 1 to count
	sub $t0, $t0, $t2
	addi $t1, 1 
	j countBills

subtract1: # subtract 1 from currentMoney and add 1 to count
	sub $t0, $t0, $t2
	addi $t1, 1 
	j countBills


    
	

######################################################## DO NOT REMOVE THIS SEPARATOR


fizzbuzz:	
	# Do not remove this code.  It is necessary for the subcalls to the print functions.
	addi $sp, $sp, -4
	sw   $ra, 0($sp)

	li $t0, 1 # count = 1
	move $t9, $a0 # create a copy of input

	j printNumbers

printNumbers:

	bgt $t0, $t9, return_from_fizzbuzz # if count > input, return

	li $t3, 0
	li $t5, 0


	move $t1, $t0 # create copy of count for checking divisibility
	j divisibleByThree
returnDivisibleByThree:
	move $t1, $t0 # create copy of count for checking divisibility
	j divisibleByFive
returnDivisibleByFive:
	bgtz $t3, printThree
	bgtz $t5, printFive
	move $a0, $t0
	jal print_int
	j afterPrint
afterPrint:
	addi $t0, 1
	j printNumbers


printThree:
	bgtz $t5, printThreeAndFive
	jal print_fizz
	j afterPrint

printFive:
	jal print_buzz
	j afterPrint

printThreeAndFive:
	jal print_fizzbuzz
	j afterPrint




divisibleByThree:
	bgtz $t1, subtractThree
	beqz $t1, threeDivides
	j returnDivisibleByThree
subtractThree:
	addi $t1, -3
	j divisibleByThree
threeDivides:
	li $t3, 1
	j returnDivisibleByThree

divisibleByFive:
	bgtz $t1, subtractFive
	beqz $t1, fiveDivides
	j returnDivisibleByFive
subtractFive:
	addi $t1, -5
	j divisibleByFive
fiveDivides:
	li $t5, 1
	j returnDivisibleByFive







divisibleByFive:
	jal print_buzz
	j returnDivisibleByFive
	




	
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
