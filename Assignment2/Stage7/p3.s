.text
    mov r0, #-2
    mov r1,#2
    mov r3,#0
    str r0,[r3]
    ldrsb r2,[r3,#3] @r2 should have -1
    ldrsb r2,[r3,#0] @r2 should have -2
    ldrsb r2,[r3,#1] @r2 should have -1
    ldrsb r2,[r3,#2] @r2 should have -1
.end