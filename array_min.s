.text
	
# a0: len
# a1: ptr
#if len == 0: return MAXVAL
#else: return min(arr[0], arr_min(len - 1, ptr + 4))
array_min:
	
	beqz $a0, array_min_basecase #if len == 0: return MAXVAL	
	
	#recurse (else: return min(arr[0], arr_min(len-1, ptr+4))
	addi $sp, $sp, -8
	sw $ra, 0($sp)
	sw $s0 , 4($sp)

	#read first integer in array into s0
	#s0 is what you are supposed to be reserving, so add it to the stack
	lw $s0, 0($a1)

	addi $a0, $a0, -1
	addi $a1, $a1, 4 #ptr + 4
	jal array_min
	
	#return min(s0, v0)
	slt $t0, $s0, $v0 
	bnez $t0, array_min_s0_smaller
	b array_min_return_v0
	
array_min_return_v0:

	lw $ra, 0($sp)
	lw $s0, 4($sp)
	addi $sp, $sp, 8

	jr $ra
	# return v0

array_min_s0_smaller:
	move $v0, $s0
	b array_min_return_v0

array_min_basecase:
	li $v0, 0x7fffffff
	jr $ra

main:	
	# push ra onto stack
	# you subtract by 4 to grow the stack (lower address = grow)
	addi $sp, $sp, -4
	sw $ra, 0($sp) #storing a 4 byte address into stack
	
	#call array_min
	li $a0, 5
	la $a1, test_array # load array into a1
	jal array_min
	move $a0, $v0
	jal print_int
	

	# pop ra off of stack
	lw $ra, 0($sp)
	addi $sp, $sp, 4

	# return to caller
	jr $ra

print_int:
	# load 1 into v0 to print int
	# load 10 into v0 to print string
	# -43 is stored in $a0 which is fed into syscall	
	li $v0, 1
	syscall
	jr $ra
.data
test_array:	.word 3, 5, -9, 3, 1 # words are 32 bits (4 bytes)
