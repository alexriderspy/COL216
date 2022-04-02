.text
   movs r0,#0
   movs r1,#-1
   adds r2,r0,r1
   subs r3,r1,r0,LSR #4
   ands r3,r1,r2,LSL #5
.end