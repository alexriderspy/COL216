.text
Loop:
    swi
    @r0 has the 32 bit input, last 8 bits imp
    and r1,r0,#1
    cmp r1,#1
    @here we save it in memory
    bne Loop
    str
.end