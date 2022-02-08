.extern UsefulFunctions
.extern start
.text
	
	ldr r0, =string1ists
	ldr r1, =string1ists
	add r1,r1,#4
	mov r2,#0
	mov r4,#1
	mov r5,#1
	mov r6,#0
	
	
	bl start
	mov r4,r0
	mov r5,#0
printStrings:
	ldr r0,[r4,r5,LSL #2]
	bl prints
	add r5,r5,#1
	cmp r5,r1
	bne printStrings
	mov r0,#0x18
	swi 0x123456

.data
params: 
	.word 0,0,0
string1:
	.asciz "a"
	
string2:
	.asciz "b"
	
string1ists: 
	.align 4
	.word string1,string2
comparisonmode:
	.space 4, 0
duplicateremoval:
	.space 4, 0