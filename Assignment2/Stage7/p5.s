.text
    mov r0,#2
    mov r1,#5
    mov r2,#10
    mov r3,#0
    smlal r2,r3,r1,r0 @ r3,r2 = r0 * r1 + r3,r2
    umlal r2,r3,r1,r0 @ r3,r2 = r0 * r1 + r3,r2
.end