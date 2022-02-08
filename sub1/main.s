.extern UsefulFunctions
.extern compare
.text
	ldr r0, =first_string
	bl prints
	ldr r0, =string1
	mov r1,#80
	mov r2,#0
	bl fgets
	mov r4,r0
	ldr r0, =second_string
	bl prints
	ldr r0, =string2
	bl fgets
	mov r5,r0
	ldr r0, =mode
	bl prints
	ldr r0, =comparisonmode
	bl fgets
	bl atoi
	mov r2,r0
	ldr r0, =newline
	bl prints
	mov r0,r4
	mov r1,r5
	bl compare
	cmp r0,#0
	beq printequal
	cmp r0,#1
	beq printless
	cmp r0,#2
	beq printgreater
printless:
	ldr r0, =less
	bl prints
	mov r0,#0x18
	swi 0x123456
printgreater:
	ldr r0, =greater
	bl prints
	mov r0,#0x18
	swi 0x123456

printequal:	
	ldr r0, =equal
	bl prints
	mov r0,#0x18
	swi 0x123456

.data
params: 
	.word 0,0,0
less: 
	.asciz "First string is less than the second\n"
greater:
	.asciz "First string is greater than the second\n"
equal:
	.asciz "Both strings are equal\n"
string1: 
	.space 100, 0
string2:
	.space 100, 0
comparisonmode:
	.space 1, 0
newline:
	.asciz "\n"
first_string:
	.asciz "Enter first string:\n"
second_string:
	.asciz "Enter second string:\n"
mode:
	.asciz "Enter comparison mode (0 for case-insensitive and 1 for case-sensitive):\n"
	