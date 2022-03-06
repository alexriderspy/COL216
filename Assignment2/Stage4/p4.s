.text
mov r0, #0
mov r1, #0
Loop1: add r0, r0, r1
add r1, r1, #1
cmn r1, #-3
bne Loop1
.end