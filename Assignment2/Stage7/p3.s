.text
    mov r0,#2
    mov r1,#5
    smull r3,r2,r1,r0 @r2,r3 = r0 * r1
    umull r3,r2,r1,r0
.end