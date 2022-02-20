.text
mov r0, #0
mov r1, #0
Loop: add r0, r0, r1
add r1, r1, #1
cmp r1, #3
bne Loop
.end