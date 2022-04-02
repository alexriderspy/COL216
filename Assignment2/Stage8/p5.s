.text
    mov r0, #1
    mov r1, #2
    mov r2, #3
    cmp r0,#1
    mlaeq r4,r0,r1,r2
    cmp r0,r1
    mulgt r5,r0,r1
    mov r3,#2
    mov r4,#5
    smulllt r3,r2,r4,r3
    mov r3, #0
    umlallt r2,r3,r1,r0 @ r3,r2 = r0 * r1 + r3,r2 ; 1*2 + 0,3 = 0,5
.end