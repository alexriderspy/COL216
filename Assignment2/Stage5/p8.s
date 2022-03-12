.text
    mov r0, #-1
    mov r1, #1
    cmp r0,r1
    adc r3,r0,r1 
    sbc r4,r3,#8
    rsc r5,r4,r3 
.end
