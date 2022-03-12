.extern atoi,itoa,fgets,prints,strlen
.extern start
.extern mergesort

@auxiliaryinfo,#0 -> 1st string size, #4 ->2nd string size, #8 -> comparison mode, #12 -> duplicate removal mode
@atoi function checks if input string is a number or not, if not, it returns an error message

.text
	ldr r8, =auxiliaryinfo
	ldr r4, =strings       @stores list of strings
	ldr r5, =stringpointers    @stores list of pointers to strings
	
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
	str r0,[r8,#0]  @r8 #0 has size of list of strings
	
	ldr r0, =second_string
	bl prints
	
	
	mov r6,#0
stringinput1: @take in strings in a loop
	mov r0,r4
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
		
	@r5 is what I will pass in to my mergesort function
	@r2 has comp mode
	@r6 has duplicate removal mode
	
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
	
	ldr r0, =ninth_string  @checks if comparison mode has value (0,1) or something else.
	bl prints
	mov r0,#0x18
	swi 0x123456
e1:
	str r0,[r8,#4]
	
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
	ldr r0, =ninth_string  @checks if duplicate removal mode has value (0,1) or something else.
	bl prints
	mov r0,#0x18
	swi 0x123456
e2:
	
	str r0,[r8,#8]
	
fn:
	mov r0,r5
	ldr r1,[r8]
	ldr r2,[r8,#4]
	ldr r6,[r8,#8]
	
	bl mergesort @code branches into mergesort routine
	
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
printStrings:   @prints all the strings in a loop
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
strings: 
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
	.asciz "Enter the size of list of strings:\n"
second_string:
	.asciz "Enter the list of strings:\n"
fifth_string:
	.asciz "Enter the comparison mode(0 if case-insensitive and 1 if case-sensitive):\n"
sixth_string:
	.asciz "Enter the duplicate removal option (0 if duplicates not to be removed and 1 if duplicates are to be removed):\n"
seventh_string:
	.asciz "The final sorted list of strings:\n"
eighth_string:
	.asciz "The size of final sorted list of strings:\n"
ninth_string:
	.asciz "Invalid input\n"
	
tenth_string:
	.asciz "Input list is not sorted/contain duplicates.\n"