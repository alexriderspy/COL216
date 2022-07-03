.global func
.text
main: 
	mov r0,#1
func:
	ldr r2, =consts
	ldr r1, [r2], #4
	and r3, r1, r0
	and r0, r1, r0, LSR #1
	add r0, r0, r3

	ldr r1, [r2], #4
	and r3, r1, r0
	and r0, r1, r0, LSR #2
	add r0, r0, r3

	ldr r1, [r2], #4
	and r3, r1, r0
	and r0, r1, r0, LSR #4
	add r0, r0, r3

	ldr r1, [r2], #4
	and r3, r1, r0
	and r0, r1, r0, LSR #8
	add r0, r0, r3

	ldr r1, [r2], #4
	and r3, r1, r0
	and r0, r1, r0, LSR #16
	add r0, r0, r3

	mov r1,r0
	mov r0,#0x18
	swi 0x123456

.data

consts: .word 0x55555555, 0x33333333, 0x0f0f0f0f, 0x00ff00ff, 0x0000ffff
    .end