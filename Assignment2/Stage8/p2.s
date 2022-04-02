.text
    mov r0,#2
    mov r1,#-5
    smulls r3,r2,r1,r0
    umlals r2,r3,r1,r0 @ r3,r2 = r0 * r1 + r3,r2 ; 1*2 + 0,3 = 0,5
    mov r0,#0
    muls r4,r0,r1
.end