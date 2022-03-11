.text 
mov r0,#1
mov r1,#2
tst r0,r1 @sets the ZF
mov r3,#2
teq r3,r1 @sets ZF
.end