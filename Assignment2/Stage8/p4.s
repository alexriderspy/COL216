.text
    mov r0,#0
    mov r1,#1
    cmp r0,#0
    streq r1,[r0]
    cmp r0,r1
    ldrgth r2,[r0]
    ldrltb r2,[r0]
.end