.text 
mov r0,#1
mov r1,#2
tst r0,r1 @sets the ZF
teq r0,r1 @should not set ZF
.end