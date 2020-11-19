wordDecrypt:
	# substitute your code here
	li $v0, 0
	li $v1, 0
	jr $ra


######################################################## DO NOT REMOVE THIS SEPARATOR


isCandidate:
	# substitute your code here
	li $v0, 0
	jr $ra


######################################################## DO NOT REMOVE THIS SEPARATOR


addAndVerify:	
	# substitute your code here
	li $v0, 0
	jr $ra


######################################################## DO NOT REMOVE THIS SEPARATOR


main:
	# save regs
	addi $sp, $sp, -12
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)	

	
	############## test calls to wordDecrypt ##############

	# wordDecrypt test 1
	la $a0, wordDecryptTestVector1
	jal testWordDecrypt

	# wordDecrypt test 2
	la $a0, wordDecryptTestVector2
	jal testWordDecrypt

	# wordDecrypt test 3
	la $a0, wordDecryptTestVector3
	jal testWordDecrypt

	# wordDecrypt test 4
	la $a0, wordDecryptTestVector4
	jal testWordDecrypt

	# wordDecrypt test 5
	la $a0, wordDecryptTestVector5
	jal testWordDecrypt

	# wordDecrypt test 6
	la $a0, wordDecryptTestVector6
	jal testWordDecrypt

	# wordDecrypt test 7
	la $a0, wordDecryptTestVector7
	jal testWordDecrypt

	############## test calls to isCandidate ##############

	# isCandidate test 1
	la $a0, isCandidateTestVector1
	jal testIsCandidate
 
	# isCandidate test 2
	la $a0, isCandidateTestVector2
	jal testIsCandidate
 
	# isCandidate test 2
	la $a0, isCandidateTestVector2
	jal testIsCandidate
 
	# isCandidate test 3
	la $a0, isCandidateTestVector3
	jal testIsCandidate
 
	# isCandidate test 4
	la $a0, isCandidateTestVector4
	jal testIsCandidate
 
	# isCandidate test 5
	la $a0, isCandidateTestVector5
	jal testIsCandidate
 
	# isCandidate test 6
	la $a0, isCandidateTestVector6
	jal testIsCandidate
 
	# isCandidate test 7
	la $a0, isCandidateTestVector7
	jal testIsCandidate
 
	# isCandidate test 8
	la $a0, isCandidateTestVector8
	jal testIsCandidate
 
	# isCandidate test 9
	la $a0, isCandidateTestVector9
	jal testIsCandidate
 
	# isCandidate test 10
	la $a0, isCandidateTestVector10
	jal testIsCandidate
 
	# isCandidate test 11
	la $a0, isCandidateTestVector11
	jal testIsCandidate
 
	# isCandidate test 12
	la $a0, isCandidateTestVector12
	jal testIsCandidate
 
	# isCandidate test 13
	la $a0, isCandidateTestVector13
	jal testIsCandidate

	############## test calls to addAndVerify ##############

 	# addAndVerify test 1
 	la $a0, addAndVerifyTestVector1
 	jal testAddAndVerify

 	# addAndVerify test 2
 	la $a0, addAndVerifyTestVector2
 	jal testAddAndVerify

 	# addAndVerify test 3
 	la $a0, addAndVerifyTestVector3
 	jal testAddAndVerify

 	# addAndVerify test 4
 	la $a0, addAndVerifyTestVector4
 	jal testAddAndVerify
	

	############## end of test calls ##############	

	# s0: current key
	# s1: terminal key
	li $s0, 0x01
	li $s1, 0xff

tryKeysLoopTop:
	# check if done
	beq $s0, $s1, mainReturn

	# print key to be tried
	la $a0, tryingKeyMsg
	jal print_string
	move $a0, $s0
	jal print_int
	
	# prep a2 with replicated key byte
	move $a2, $s0
	sll $a2, $a2, 8
	or $a2, $a2, $s0
	sll $a2, $a2, 8
	or $a2, $a2, $s0
	sll $a2, $a2, 8
	or $a2, $a2, $s0

	# call addAndVerify
	la $a0, encryptedPhrase
	la $a1, decryptionSpace
	jal addAndVerify

	# check result
	beqz $v0, tryNextKey

	# good key!
	jal print_newline
	la $a0, decryptionSpace
	jal print_string
	
tryNextKey:	
	addi $s0, $s0, 1
	b tryKeysLoopTop

mainReturn:	
	# restore regs & return
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)	
	addi $sp, $sp, 12
	jr $ra

	
############## helper function to test wordDecrypt ##############

testWordDecrypt:
	# save regs
	addi $sp, $sp, -20
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)	

	# save test vector address 
	move $s0, $a0
	
	# print test case
	la $a0, wordDecryptTestCase
	jal print_string
	lw $a0, 0($s0)
	jal print_hexword
	jal print_space
	jal print_plus
	jal print_space
	lw $a0, 4($s0)
	jal print_hexword
	jal print_space
	jal print_plus
	jal print_space
	lw $a0, 8($s0)
	jal print_int
	jal print_space
 	jal print_equals
	jal print_space
 	lw $a0, 12($s0)
 	jal print_hexword
 	jal print_comma
	jal print_space
 	lw $a0, 16($s0)
 	jal print_int
	jal print_newline
	
 	# call wordDecrypt
 	lw $a0, 0($s0)
 	lw $a1, 4($s0)
 	lw $a2, 8($s0)
	jal wordDecrypt
	
 	# save returned values
 	move $s1, $v0
 	move $s2, $v1

	# use s3 to count errors
	li $s3, 0

  	# check sum against expected
  	lw $t1, 12($s0)
  	beq $t1, $s1, sumCheckDone

	# print sum error
	la $a0, sumNoGood
	jal print_string
	move $a0, $s1
	jal print_int
	jal print_newline
	addi $s3, $s3, 1

sumCheckDone:	
	# check carry against expected
	lw $t2, 16($s0)
	beq $t2, $s2, carryCheckDone

	# print carry error
	la $a0, carryNoGood
	jal print_string
	move $a0, $s2
	jal print_int
	jal print_newline
	addi $s3, $s3, 1	

carryCheckDone:
	# if errors, skip pass message
	bnez $s3, testWordDecryptReturn
	la $a0, allGood
	jal print_string
	jal print_newline

testWordDecryptReturn:
	# restore regs
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	addi $sp, $sp, 20

	# return
	jr $ra
	
############## helper function to test isCandidate ##############

testIsCandidate:	
	# save regs
	addi $sp, $sp, -12
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)

	# s0: test vector address 
	move $s0, $a0
	
	# print test case
	la $a0, isCandidateTestCase
	jal print_string
	addi $a0, $s0, 4
	jal print_string
	jal print_equals
	lw $a0, 0($s0)
	jal print_int
	jal print_newline
	
	# call function under test
	lw $a0, 4($s0)
	jal isCandidate

 	# s1: returned value
 	move $s1, $v0

  	# check against expected
  	lw $t1, 0($s0)
  	beq $t1, $s1, isCandidateTestPass

	# print error message
	la $a0, isCandidateTestFailMsg
	jal print_string
	move $a0, $s1
	jal print_int
	jal print_newline
	
testIsCandidateReturn:	
	# restore regs
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	addi $sp, $sp, 12

	# return
	jr $ra	

isCandidateTestPass:	
	# print success message
	la $a0, isCandidateTestPassMsg
	jal print_string
	b testIsCandidateReturn
	
############## helper function to test addAndVerify ##############

testAddAndVerify:	
	# save regs
	addi $sp, $sp, -12
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)

	# s0: test vector
	move $s0, $a0

	# print test phrase
	la $a0, addAndVerifyTestPhrase
	jal print_string

	# s1: pointer to word in phrase
	addi $s1, $s0, 8
	
	# print phrase
phrasePrintLoopTop:	
	lw $a0, 0($s1)
	beqz $a0, phrasePrintLoopExit
	jal print_hexword
	jal print_space
	addi $s1, $s1, 4
	b phrasePrintLoopTop
phrasePrintLoopExit:	

	# print test key
	la $a0, addAndVerifyTestKey
	jal print_string
	lw $a0, 0($s0)
	jal print_int

	# print expected result
	la $a0, addAndVerifyExpectedResult
	jal print_string
	lw $a0, 4($s0)
	jal print_int
	
	# prep key, replicating byte 4x
	lw $a2, 0($s0)
	move $t0, $a2
	sll $a2, $a2, 8
	or $a2, $a2, $t0
	sll $a2, $a2, 8
	or $a2, $a2, $t0
	sll $a2, $a2, 8
	or $a2, $a2, $t0

	# call function under test
	# a0: encrypted string
	# a1: space
	# a2: key
	addi $a0, $s0, 8
	la $a1, decryptionSpace
	jal addAndVerify

	# s1: return value
	move $s1, $v0
	
	# compare to expected
	lw $t0, 4($s0)
	beq $s1, $t0, testAddAndVerifyPass

	# wrong result
	la $a0, addAndVerifyTestFailMsg
	jal print_string
	move $a0, $s1
	jal print_int
	jal print_newline
	b testAddAndVerifyReturn

testAddAndVerifyPass:	
	la $a0, addAndVerifyTestPassMsg
	jal print_string
	
testAddAndVerifyReturn:	
	# restore regs
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	addi $sp, $sp, 12

	# return
	jr $ra	

	
############## printer helpers ##############

print_int:
	li $v0, 1
	syscall
	jr $ra

print_newline:
 	li $v0, 11
 	li $a0, '\n'
 	syscall
	jr $ra

print_plus:
 	li $v0, 11
 	li $a0, '+'
 	syscall
	jr $ra

print_colon:
 	li $v0, 11
 	li $a0, ':'
 	syscall
	jr $ra
	
print_equals:
 	li $v0, 11
 	li $a0, '='
 	syscall
	jr $ra

print_comma:
 	li $v0, 11
 	li $a0, ','
 	syscall
	jr $ra

print_space:
 	li $v0, 11
 	li $a0, ' '
 	syscall
	jr $ra
	
print_string:
	li $v0, 4
	syscall
	jr $ra

print_hexword:
	# save regs
	addi $sp, $sp, -12
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)

	# s0: hexword
	move $s0, $a0
	# s1: nibble mask
	li $s1, 0xf0000000

	# print 0
	li $a0, 0
	li $v0, 1
	syscall
 
	# print x
	li $a0, 'x'
	li $v0, 11
	syscall

	# print nibble
	and $a0, $s0, $s1
	srl $a0, $a0, 28
	jal print_hexchar

	# print nibble
	srl $s1, $s1, 4
	and $a0, $s0, $s1
	srl $a0, $a0, 24
	jal print_hexchar

	# print nibble
	srl $s1, $s1, 4
	and $a0, $s0, $s1
	srl $a0, $a0, 20
	jal print_hexchar

	# print nibble
	srl $s1, $s1, 4
	and $a0, $s0, $s1
	srl $a0, $a0, 16
	jal print_hexchar

	# print nibble
	srl $s1, $s1, 4
	and $a0, $s0, $s1
	srl $a0, $a0, 12
	jal print_hexchar

	# print nibble
	srl $s1, $s1, 4
	and $a0, $s0, $s1
	srl $a0, $a0, 8
	jal print_hexchar

	# print nibble
	srl $s1, $s1, 4
	and $a0, $s0, $s1
	srl $a0, $a0, 4
	jal print_hexchar

	# print nibble
	srl $s1, $s1, 4
	and $a0, $s0, $s1
	srl $a0, $a0, 0
	jal print_hexchar
	
	# restore regs
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	addi $sp, $sp, 12

 	jr $ra

print_hexchar:
	la $t0, hexchars
	add $t0, $t0, $a0
	lbu $a0, 0($t0)
	li $v0, 11
	syscall
	jr $ra
	
.data

encryptedPhrase: .word 0x5f7fb06, 0xfb06f2f8, 0xc0704fb, 0xf9fbf7f3, 0x6f306fb, 0x700f809, 0xf805f30b, 0xf300f808, 0xf7080706, 0x60700f8, 0x8f3faf3, 0x4f5f2f7, 0xf7fdf5f4, 0x801f2f7, 0x1f5f304, 0xf2f6f7f7, 0x605f7ff, 0xf2f7f9f3, 0xfaf401f7, 0x0

decryptionSpace:	
	.align 4
	.space 400  # 400 bytes of space, more than enough...
	
tryingKeyMsg:	.asciiz "\nTrying key: "

hexchars:	.asciiz "0123456789abcdef"
	
############## test data for wordDecrypt ##############

wordDecryptTestCase: .asciiz "\nCurrent wordDecrypt test case: "
sumNoGood:       .asciiz "  SUM result is WRONG: "
carryNoGood:     .asciiz "  CARRY result is WRONG: "
allGood:         .asciiz "  PASSES TEST"

wordDecryptTestVector1: .word 0x00000064, 0x000000c8, 1, 0x0000012d, 0
wordDecryptTestVector2: .word 0x0000ea60, 0x00007530, 1, 0x00015f91, 0
wordDecryptTestVector3: .word 0x000927c0, 0x000493e0, 1, 0x000dbba1, 0
wordDecryptTestVector4: .word 0x7ffffff8, 0x7ffffff8, 0, 0xfffffff0, 0
wordDecryptTestVector5: .word 0xffffff9c, 0x00001388, 0, 0x00001324, 1
wordDecryptTestVector6: .word 0x0000c524, 0xffecf480, 1, 0xffedb9a5, 0
wordDecryptTestVector7: .word 0x0000c524, 0xffff89a1, 0, 0x00004ec5, 1
	
	
############## test data for isCandidate ##############

isCandidateTestCase: .asciiz "\nCurrent isCandidate test case: "
isCandidateTestPassMsg: .asciiz "  PASSES TEST\n"
isCandidateTestFailMsg: .asciiz "  INCORRECT result: "

isCandidateTestVector1:
	.word 1
	.asciiz "HIHO"
isCandidateTestVector2:
        .word 0
        .asciiz "Bo^3"
isCandidateTestVector3:
        .word 1
        .asciiz "ABCD"
isCandidateTestVector4:
        .word 1
        .asciiz "@@@@"
isCandidateTestVector5:
        .word 0
        .asciiz "abcd"
isCandidateTestVector6:
        .word 0
        .asciiz " %AB"
isCandidateTestVector7:
        .word 0
        .asciiz " BCD"
isCandidateTestVector8: 
        .word 0
        .asciiz "A CD"
isCandidateTestVector9:
        .word 0
        .asciiz "AB D"
isCandidateTestVector10:
        .word 0
        .asciiz "ABC "
isCandidateTestVector11:
        .word 1
        .asciiz "@ZAP"
isCandidateTestVector12:
        .word 0
        .asciiz "HOW?"
isCandidateTestVector13:
        .word 0
        .asciiz "NOP["

############## test data for addAndVerify ##############

# format is: key, result, encode phrase
addAndVerifyTestVector1:	.word 12, 1, 0x433c3d3c, 0x433e3d3e, 0
addAndVerifyTestVector2:	.word 25, 0, 0x433c3d3c, 0x433e3d3e, 0		
addAndVerifyTestVector3:	.word 17, 1, 0x493e492f, 0x443e482f, 0x3c3e3c41, 0x33333d30, 0x48333330, 0x3041323e, 0
addAndVerifyTestVector4:	.word 20, 0, 0x493e492f, 0x443e482f, 0x3c3e3c41, 0x33333d30, 0x48333330, 0x3041323e, 0

addAndVerifyTestPhrase:	    .asciiz "\nCurrent addAndVerify test phrase: "
addAndVerifyTestKey:	    .asciiz "\nCurrent addAndVerify test key: "
addAndVerifyExpectedResult: .asciiz "\nExpected addAndVerify result: "	
addAndVerifyTestPassMsg:    .asciiz "\n  PASSES TEST\n"
addAndVerifyTestFailMsg:    .asciiz "\n  INCORRECT result: "

