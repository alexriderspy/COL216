.text
    mov r0, #12
    mov r1, #5
    str r1, [r0]
    add r1, r1, #2
    str r1, [r0, #4]
    ldr r2, [r0]
    ldr r3, [r0, #4]
    sub r4, r3, r2
.end
