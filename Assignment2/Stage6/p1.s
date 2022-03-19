.text
    mov r0, #1
    mov r1, #2
    mov r3,#0
    str r3,[r1,#-2]
    strh r0,[r1]
    ldrh r2,[r1]
    ldrh r2,[r1,#-2]
.end
