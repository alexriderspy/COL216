@r0 has address of string pointers
@r1 has size of string list
@r2 has comparison mode

.global checkIfSorted

.text
checkIfSorted:

	stmfd	sp!, {r0-r6,lr}
	cmp r1,#1
	beq right
	mov r4,r0
	mov r5,r0
	add r5,r5,#4
	mov r6,r1
	sub r6,r6,#1
	mov r3,#0
	
loop:
	ldr r0,[r4]
	ldr r1,[r5]
	
	bl compare
	
	cmp r0,#1
	beq op
	cmp r0,#0
	beq op
	bne wrong
op:
	add r4,r4,#4
	add r5,r5,#4
	add r3,r3,#1
	cmp r3,r6
	bne loop
	beq right
wrong:
	ldr r0,=errormessage
	bl prints
	mov r0,#0x18
	swi 0x123456
right:
	ldmfd	sp!, {r0-r6,pc}



.data
errormessage:
	.asciz "Input is not sorted.\n"
