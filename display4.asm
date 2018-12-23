
   org 100h					; 程序加载到100h，可用于生成COM
   Dn_Rt equ 1                  ;D-Down,U-Up,R-right,L-Left
    Up_Rt equ 2                  ;
    Up_Lt equ 3                  ;
    Dn_Lt equ 4                  ;
    delay equ 5000					; 计时器延迟计数,用于控制画框的速度
    ddelay equ 580					; 计时器延迟计数,用于控制画框的速度
    ri equ 1                  ;D-Down,U-Up,R-right,L-Left
    dow equ 2                  ;
    lf equ 3                  ;
    up equ 4                  ;
Start:
	org 100h 
	mov ax,cs 
	mov ds,ax					; DS = CS
	mov es,ax					; ES = CS
	mov	ax,0B800h				; 文本窗口显存起始地址
	mov	gs,ax	
	mov word[x1],13 
	mov word[x2],13 
	mov word[x3],13 
	mov word[x4],13 
	mov word[y1],0 
	mov word[y2],1 
	mov word[y3],2 
	mov word[y4],3 
	mov byte[chard3],'A'
	mov byte[attrd3],0x82 
int35:
loopd3:
    mov al,2
    cmp al,byte[rdu1]
	jz  down1
    mov al,1
    cmp al,byte[rdu1]
	jz  right1
    mov al,3
    cmp al,byte[rdu1]
	jz  left1
     mov al,4
     cmp al,byte[rdu1]
	jz  upp1
      jmp $	
loop2:
    mov al,1
    cmp al,byte[rdu2]
	jz  right2
    mov al,2
    cmp al,byte[rdu2]
	jz  down2
    mov al,3
    cmp al,byte[rdu2]
	jz  left2
     mov al,4
     cmp al,byte[rdu2]
	jz  upp2
      jmp $	
loop3:
    mov al,1
    cmp al,byte[rdu3]
	jz  right3
    mov al,2
    cmp al,byte[rdu3]
	jz  down3
    mov al,3
    cmp al,byte[rdu3]
	jz  left3
     mov al,4
     cmp al,byte[rdu3]
	jz  upp3
     jmp $	
loop4:
    mov al,1
    cmp al,byte[rdu4]
	jz  right4
    mov al,2
    cmp al,byte[rdu4]
	jz  down4
    mov al,3
    cmp al,byte[rdu4]
	jz  left4
     mov al,4
     cmp al,byte[rdu4]
	jz  upp4
     jmp $	
right1:
    inc word[y1]
    cmp word[y1],40
	jz r2d1
	jmp loop2
r2d1:
	dec word[y1]
	inc word[x1] 
	mov byte[rdu1],dow
	jmp loop2

down1:
	inc word[x1]
	mov bx,word[x1]
	mov ax,25
	sub ax,bx
    jz  d2l1
	jmp loop2
d2l1:
	dec word[x1]
	dec word[y1]
	mov byte[rdu1],lf
	jmp loop2


left1:
	dec word[y1]
	mov bx,word[y1]
	mov ax,-1
	sub ax,bx
    jz  l2u1
	jmp loop2

l2u1:
    dec word[x1]
	inc word[y1]
	mov byte[rdu1],up
	jmp loop2


upp1:
	dec word[x1]
	mov bx,word[x1]
	mov ax,12
	sub ax,bx
    jz  u2r1
	jmp loop2
u2r1:
    inc word[x1]
	inc word[y1]
	mov byte[rdu1],ri
	jmp loop2

right2:
    inc word[y2]
    cmp word[y2],40
	jz r2d2
	jmp loop3
r2d2:
	dec word[y2]
	inc word[x2] 
	mov byte[rdu2],dow
	jmp loop3

down2:
	inc word[x2]
	mov bx,word[x2]
	mov ax,25
	sub ax,bx
    jz  d2l2
	jmp loop3
d2l2:
	dec word[x2]
	dec word[y2]
	mov byte[rdu2],lf
	jmp loop3


left2:
	dec word[y2]
	mov bx,word[y2]
	mov ax,-1
	sub ax,bx
    jz  l2u2
	jmp loop3

l2u2:
    dec word[x2]
	inc word[y2]
	mov byte[rdu2],up
	jmp loop3


upp2:
	dec word[x2]
	mov bx,word[x2]
	mov ax,12
	sub ax,bx
    jz  u2r2
	jmp loop3
u2r2:
    inc word[x2]
	inc word[y2]
	mov byte[rdu2],ri
	jmp loop3
	
right3:
    inc word[y3]
    cmp word[y3],40
	jz r3d3
	jmp loop4
r3d3:
	dec word[y3]
	inc word[x3] 
	mov byte[rdu3],dow
	jmp loop4

down3:
	inc word[x3]
	mov bx,word[x3]
	mov ax,25
	sub ax,bx
    jz  d3l3
	jmp loop4
d3l3:
	dec word[x3]
	dec word[y3]
	mov byte[rdu3],lf
	jmp loop4


left3:
	dec word[y3]
	mov bx,word[y3]
	mov ax,-1
	sub ax,bx
    jz  l3u3
	jmp loop4

l3u3:
    dec word[x3]
	inc word[y3]
	mov byte[rdu3],up
	jmp loop4


upp3:
	dec word[x3]
	mov bx,word[x3]
	mov ax,12
	sub ax,bx
    jz  u3r3
	jmp loop4
u3r3:
    inc word[x3]
	inc word[y3]
	mov byte[rdu3],ri
	jmp loop4
	
right4:
    inc word[y4]
    cmp word[y4],40
	jz r4d4
	jmp showd3
r4d4:
	dec word[y4]
	inc word[x4] 
	mov byte[rdu4],dow
	jmp showd3

down4:
	inc word[x4]
	mov bx,word[x4]
	mov ax,25
	sub ax,bx
    jz  d4l4
	jmp showd3
d4l4:
	dec word[x4]
	dec word[y4]
	mov byte[rdu4],lf
	jmp showd3


left4:
	dec word[y4]
	mov bx,word[y4]
	mov ax,-1
	sub ax,bx
    jz  l4u4
	jmp showd3

l4u4:
    dec word[x4]
	inc word[y4]
	mov byte[rdu4],up
	jmp showd3


upp4:
	dec word[x4]
	mov bx,word[x4]
	mov ax,12
	sub ax,bx
    jz  u4r4
	jmp showd3
u4r4:
    inc word[x4]
	inc word[y4]
	mov byte[rdu4],ri
	jmp showd3
	
showd3:	
    mov ax,0600h
	mov dx,1827h
	mov cx,0d00h
	mov bh,0
	int 10h
	cmp byte[attrd3],0x8f 
	jbe incd3
	mov byte[attrd3],0x82
incd3:
    xor ax,ax                 ; 计算显存地址
    mov ax,word[x1]
	mov bx,80
	mul bx
	add ax,word[y1]
	mov bx,2
	mul bx
	mov bp,ax
    mov ah,byte[attrd3];  0000：黑底、1111：亮白字（默认值为07h）
	mov al,byte[chard3]			;  AL = 显示字符值（默认值为20h=空格符）
	mov word[gs:bp],ax  		;  显示字符的ASCII码值
    
    xor ax,ax                 ; 计算显存地址
    mov ax,word[x2]
	mov bx,80
	mul bx
	add ax,word[y2]
	mov bx,2
	mul bx
	mov bp,ax
    mov ah,byte[attrd3];  0000：黑底、1111：亮白字（默认值为07h）
	mov al,byte[chard3]			;  AL = 显示字符值（默认值为20h=空格符）
	mov word[gs:bp],ax  		;  显示字符的ASCII码值
	
	xor ax,ax                 ; 计算显存地址
    mov ax,word[x3]
	mov bx,80
	mul bx
	add ax,word[y3]
	mov bx,2
	mul bx
	mov bp,ax
    mov ah,byte[attrd3];  0000：黑底、1111：亮白字（默认值为07h）
	mov al,byte[chard3]			;  AL = 显示字符值（默认值为20h=空格符）
	mov word[gs:bp],ax  		;  显示字符的ASCII码值
	
	xor ax,ax                 ; 计算显存地址
    mov ax,word[x4]
	mov bx,80
	mul bx
	add ax,word[y4]
	mov bx,2
	mul bx
	mov bp,ax
    mov ah,byte[attrd3];  0000：黑底、1111：亮白字（默认值为07h）
	mov al,byte[chard3]			;  AL = 显示字符值（默认值为20h=空格符）
	mov word[gs:bp],ax  		;  显示字符的ASCII码值
	mov cx,0ffh
lp: 
	dec word[ddcount]
    jnz lp
	mov word[ddcount],0ffffh
	dec cx
	jnz lp
	;jmp loopd3

	jmp int35 
	count dw delay
    dcount dw ddelay
	ddcount dw 0ffffh
    rdu1 db ri         ; 向右下运动
	rdu2 db ri
	rdu3 db ri
	rdu4 db ri
    x1   dw 13 
    y1   dw 0 
	x2    dw 13 
	y2  dw 1 
	x3 dw 13
	y3 dw 2 
	x4 dw 13 
	y4 dw 3
    chard3 db 'A'
	attrd3 db 0x82