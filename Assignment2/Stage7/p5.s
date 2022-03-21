.text
    mov r0, #264 @store bits [15 downto 8]
    mov r1,#2
    mov r3,#0
    mov r4,#-1
    str r4,[r3]
    strb r0,[r3,#2]
    ldrh r2,[r3] @ unsigned half word
	ldrb r2,[r3,#3]
	ldrb r2,[r3,#2]
	 
.end