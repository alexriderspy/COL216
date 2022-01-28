.global start
.text

@r0 has pointer to 1st list of strings
@r1 has pointer to 2nd list of strings
@r2 has comparison mode - 0 if case-insensitive, 1 means case-sensitive.
@r3,r12 will be used to maintain i,j where i is number of strings processed in list 1, j is the number of strings processed in list 2.-caller needs to store them
@r4 has number of strings in 1st list
@r5 has number of strings in 2nd list
@r6 has duplicate removal option - 0 if duplicates not to be removed, 1 if duplicates are to be removed.
@r0 has the final merged list
@r1 has the final length of the merged list
@r8 maintains the length of final merged list


@r0 = 0 means equal, r1 = 1 means 1st is less, r2 = 2 means 1st is more.

start:
	mov r3,#0
	mov r12,#0
	mov r8,#0
	str lr,[sp,#-4]!
merge: 

	str r2,[sp,#-4]!
	str r3,[sp,#-4]!
	@handle if one of the lists is empty or both are empty
	str r0,[sp,#-4]!
	str r1,[sp,#-4]!
	ldr r9,[r0]
	ldr r10,[r1]
	mov r0,r9
	mov r1,r10
	bl compare
	cmp r0,#0
	beq equal
	cmp r0,#1
	beq less
	cmp r0,#2
	beq greater
	@do something to handle if r0 returns garbage value
equal:
	
	ldr r1,[sp,#0]
	ldr r0,[sp,#4]
	ldr r3,[sp,#8]
	ldr r2,[sp,#12]
	add sp,sp,#16
	
	str r9,[sp,#-4]!
	
	add r0,r0,#4
	add r3,r3,#1
	add r8,r8,#1
	cmp r6,#0
	beq eq1
	add r12,r12,#1
	add r1,r1,#4
	cmp r3,r4
	bne ch2nd
	@this assumes that 1st list has ended.
	cmp r12,r5
	beq endofboth
	bne endof1st
ch2nd:
	cmp r12,r5
	beq endof2nd
	b merge
	
eq1:	
	cmp r3,r4
	beq endof1st
	b merge
less:

	ldr r1,[sp,#0]
	ldr r0,[sp,#4]
	ldr r3,[sp,#8]
	ldr r2,[sp,#12]
	add sp,sp,#16
	
	
	str r9,[sp,#-4]!
	
	add r0,r0,#4
	add r3,r3,#1
	add r8,r8,#1
	cmp r3,r4
	beq endof1st
	b merge
endof1st:
	
	ldr r10,[r1]
	str r10,[sp,#-4]!

	
	add r1,r1,#4
	add r12,r12,#1
	add r8,r8,#1
	cmp r12,r5
	beq endofboth
	b endof1st
greater:
	ldr r1,[sp,#0]
	ldr r0,[sp,#4]
	ldr r3,[sp,#8]
	ldr r2,[sp,#12]
	add sp,sp,#16

	str r10,[sp,#-4]!
	
	add r1,r1,#4
	add r12,r12,#1
	add r8,r8,#1
	cmp r12,r5
	beq endof2nd
	b merge
endof2nd:
	
	ldr r9,[r0]
	str r9,[sp,#-4]!
	
	add r0,r0,#4
	add r3,r3,#1
	add r8,r8,#1
	cmp r3,r4
	beq endofboth
	b endof2nd	
endofboth:
	sub r0,r0,r4,LSL #2
	mov r4,r0
	
	mov r1,sp
	add r1,r1,r8,LSL #2
	sub r1,r1,#4
	mov r3,#0
	
loop:
	ldr r7,[r1]
	str r7,[r0]
	add r0,r0,#4
	sub r1,r1,#4
	add r3,r3,#1
	cmp r3,r8
	beq final
	b loop
	
final:
	mov r0,r4
	mov r1,r8
	add sp,sp,r8,LSL #2
	ldr pc,[sp],#4
	
	
	