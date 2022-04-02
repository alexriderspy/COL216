.text
    mov r0,#0 
    cmp r0,#0
    moveq r1,#1
    cmp r1,#2
    movlt r2,#2
    addgt r3,r2,r0
    sublts r4,r1,r2
.end