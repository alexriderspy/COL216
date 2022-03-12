@r2 has comparison mode
@r6 has duplicate removal option
@r0 has pointer to list of string addresses
@r1 has size of list of string addresses

.global mergesort

.text

mergesort:
	str lr,[sp,#-4]!
	cmp r1,#1
	beq ret
	@r3 has size/2
	mov r3,#0
	add r3,r3,r1,LSR #1 @r3 has size of first half
	@r4 has remaining size -> size - size/2
	sub r4,r1,r3
	str r1,[sp,#-4]! @r1 is the total size
	mov r1,r3
	
	bl mergesort
	
	add r0,r0,r1,LSL #2
	ldr r3,[sp,#0] @r3 has total size
	sub r1,r3,r1
	
	bl mergesort
	
	@r1 has size of second half
	@r0 has pointer to second half
	
	mov r5,r1
	ldr r3,[sp],#4
	sub r4,r3,r5
	mov r1,r0
	sub r0,r0,r4,LSL #2
		
	bl start
ret:
	ldr pc,[sp],#4
