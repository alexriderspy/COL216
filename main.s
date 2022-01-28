.extern atoi,itoa,fgets,prints
.extern start
.extern checkIfDup
.extern checkIfSorted
@auxiliaryinfo,#0 -> 1st string size, #4 ->2nd string size, #8 -> comp, #12 -> dup
.text
	ldr r8, =auxiliaryinfo
	ldr r4, =string1ists
	ldr r5, =stringpointers
	
	ldr r0, =first_string
	bl prints
	ldr r0, =info
	mov r1,#40
	mov r2,#0
	bl fgets
	bl atoi
	
	cmp r0,#0
	bgt e3
		
	ldr r0, =ninth_string
	bl prints
	mov r0,#0x18
	swi 0x123456
e3:
	str r0,[r8,#0]
	
	ldr r0, =second_string
	bl prints
	
	
	mov r6,#0
stringinput1:
	mov r0,r4
	@take in strings in a loop

	mov r1,#40
	mov r2,#0
	bl fgets
	
	str r0,[r5,r6,LSL #2]
	bl strlen
	add r4,r4,r0
	add r4,r4,#2
	add r6,r6,#1
	ldr r7,[r8,#0]

	cmp r6,r7
	bne stringinput1
	
list2:
	
	ldr r0, =third_string
	bl prints
	ldr r0, =info
	
	mov r1,#40
	mov r2,#0
	bl fgets
	
	bl atoi
	cmp r0,#0
	bgt e4
	ldr r0, =ninth_string
	bl prints
	mov r0,#0x18
	swi 0x123456
e4:
	str r0,[r8,#4] 
	
	
	ldr r0, =fourth_string
	bl prints
	
	mov r0,#0
	ldr r7,[r8]
	add r0,r0,r7
	ldr r7,[r8,#4]
	add r0,r0,r7
	str r0,[r8,#8]
	ldr r6,[r8]
	
stringinput2:
	mov r0,r4
	@take in strings in a loop

	mov r1,#40
	mov r2,#0
	bl fgets
	str r0,[r5,r6,LSL #2]
	bl strlen
	add r4,r4,r0
	add r4,r4,#2
	add r6,r6,#1
	ldr r7,[r8,#8]
	cmp r6,r7
	bne stringinput2

	
	ldr r0, =fifth_string
	bl prints
	ldr r0, =comp
	mov r1,#40
	mov r2,#0
	bl fgets
	bl atoi
	cmp r0,#0
	beq e1
	cmp r0,#1
	beq e1
	ldr r0, =ninth_string
	bl prints
	mov r0,#0x18
	swi 0x123456
e1:
	str r0,[r8,#12]
	
	ldr r0, =sixth_string
	bl prints
	ldr r0, =dupli
	mov r1,#40
	mov r2,#0
	bl fgets
	bl atoi
	cmp r0,#0
	beq e2
	cmp r0,#1
	beq e2
	ldr r0, =ninth_string
	bl prints
	mov r0,#0x18
	swi 0x123456
e2:
	
	str r0,[r8,#16]
	
	@error checking
	
	@first is sorted or not
	
	mov r0,r5
	ldr r1,[r8]
	ldr r2,[r8,#12]
	bl checkIfSorted
	
	@second is sorted or not
	
	add r0,r5,r1,LSL #2
	ldr r1,[r8,#4]
	bl checkIfSorted
	
	ldr r6,[r8,#16]
	cmp r6,#0
	beq fn

	mov r0,r5
	ldr r1,[r8]
	ldr r2,[r8,#12]
	bl checkIfDup
	
	add r0,r5,r1,LSL #2
	ldr r1,[r8,#4]
	bl checkIfDup
	

fn:
	mov r0,r5
	ldr r2,[r8]
	add r2,r5,r2,LSL #2
	mov r1,r2
	
	ldr r4,[r8,#0]
	ldr r5,[r8,#4]
	ldr r2,[r8,#12]
	ldr r6,[r8,#16]
	
	bl start @code branches into merge routine
	
	mov r4,r0
	
	ldr r0, =eighth_string
	bl prints
	
	mov r5,r1
	mov r0,r1
	ldr r1, =info2
	bl itoa
	bl prints
	ldr r0,=newline
	bl prints
	ldr r0,=seventh_string
	bl prints
	mov r1,r5
	mov r5,#0
printStrings:
	ldr r0,[r4,r5,LSL #2]
	bl prints
	ldr r0,=newline
	bl prints
	add r5,r5,#1
	cmp r5,r1
	bne printStrings
	mov r0,#0x18
	swi 0x123456

.data
params: 
	.word 0,0,0
string1ists: 
	.align 4
	.space 1000, 0
	
stringpointers:
	.align 4
	.space 200,0
info2:
	.space 40,0
info:
	.space 40,0
auxiliaryinfo:
	.space 40,0
comp:
	.space 4,0
dupli:
	.space 4,0
newline:
	.asciz "\n"
first_string:
	.asciz "E:\n"
second_string:
	.asciz "E:\n"
third_string:
	.asciz "E:\n"
fourth_string:
	.asciz "E:\n"
fifth_string:
	.asciz "E:\n"
sixth_string:
	.asciz "E:\n"
seventh_string:
	.asciz "The final list of strings:\n"
eighth_string:
	.asciz "The size of final list of strings:\n"
ninth_string:
	.asciz "Invalid input\n"
tenth_string:
	.asciz "Input list is not sorted/contain duplicates.\n"