.global compare
.text
@ r0 has pointer to s1, r1 has pointer to s2, r2 has comparison mode
@ comparison mode 0 means case-insensitive and comparison mode 1 means case-sensitive	
@ r0 = #0 => equal, r0 = #1 => 1st is less, r0 = #2 => 1st is more

compare:
	cmp r2,#1
	beq Loop1
	bne Loop0
@case-sensitive mode
Loop1:
	ldrb r2,[r0]
	cmp r2,#0
	beq endofone
	ldrb r3,[r1]
	cmp r3,#0
	beq greater
	cmp r2,r3
	beq equal1
	bgt greater
	blt less
@ in case-insensitive mode, convert upper to lower.
Loop0: 
	ldrb r2,[r0]
	cmp r2,#0
	beq endofone
	ldrb r3,[r1]
	cmp r3,#0
	beq greater
	cmp r2,#'a
	blt caps1 
	cmp r2,#'z
	ble chr3
caps1:
	cmp r2,#'A
	blt chr3
	cmp r2,#'Z
	ble changer2
chr3:
	cmp r3,#'a
	blt caps2
	cmp r3,#'z
	ble Body
caps2:
	cmp r3,#'A
	blt Body
	cmp r3,#'Z
	ble changer3
Body:	
	cmp r2,r3
	beq equal0
	bgt greater
	blt less
changer3:
	add r3,r3,#32
	b chr3
changer2:
	add r2,r2,#32
	b chr3
less:
	mov r0,#1
	b ret
greater: 
	mov r0,#2
	b ret
ret: 
	mov pc,lr
equal1: 
	add r0,r0,#1
	add r1,r1,#1
	b Loop1
equal0:
	add r0,r0,#1
	add r1,r1,#1
	b Loop0
endofone: 
	ldrb r3,[r1]
	cmp r3,#0
	beq endofboth
	b less
endofboth: 
	mov r0,#0
	b ret

.end
@ r0 = #0 => equal, r0 = #1 => 1st is less, r0 = #2 => 1st is more