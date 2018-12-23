    ;org 0e00h
    ri equ 1                  ;D-Down,U-Up,R-right,L-Left
    dow equ 2                  ;
    lf equ 3                  ;
    up equ 4                  ;
    delay equ 5000					; 计时器延迟计数,用于控制画框的速度
    ddelay equ 580					; 计时器延迟计数,用于控制画框的速度
    Dn_Rt equ 1                  ;D-Down,U-Up,R-right,L-Left
    Up_Rt equ 2                  ;
    Up_Lt equ 3                  ;
    Dn_Lt equ 4                  ;
    ;delay equ 5000					; 计时器延迟计数,用于控制画框的速度
    ;ddelay equ 580					; 计时器延迟计数,用于控制画框的速度
Start:
org 100h 
	mov ax,cs 
	mov ds,ax					; DS = CS
	mov es,ax					; ES = CS
	mov	ax,0B800h				; 文本窗口显存起始地址
	mov	gs,ax					; GS = B800h	
	mov byte[rdul1],ri 
	mov word[x0],13 
	mov word[y0],41 
	mov byte[chard2],'A'
	mov byte[attrd2],0x82 
int34:
loopd2:
	;jmp $ 6000h:0147
	
    mov al,1
	mov bl,byte[rdul1]
    cmp al,bl 
	jz  rx
    mov al,2
    cmp al,bl 
	jz  down
    mov al,3
    cmp al,bl 
	jz  left
    mov al,4
    cmp al,bl 
	jz  upp
    jmp $	
	
rx:
	;jmp $
	inc word[y0]
	;jmp $
	mov bx,word[y0]
	mov ax,80
	sub ax,bx
    jz  r2d
	mov ax,word[x0]
	mov bx,80
	mul bx
	add ax,word[y0]
	mov bx,2
	mul bx
	mov bx,ax
	cmp byte [gs:bx],41h
	jae r2d
	jmp show1
r2d:
	inc word[x0]
	dec word[y0]
	mov byte[rdul1],dow
	cmp byte[attrd2],0x8f 
	jb incd21
	mov byte[attrd2],0x81
incd21:
	inc byte[attrd2]
	jmp show1

down:
	inc word[x0]
	mov bx,word[x0]
	mov ax,25
	sub ax,bx
    jz  d2l
	mov ax,word[x0]
	mov bx,80
	mul bx
	add ax,word[y0]
	mov bx,2
	mul bx
	mov bx,ax
    cmp byte [gs:bx],41h
	jae d2l
	jmp show1
d2l:
	dec word[x0]
	dec word[y0]
	mov byte[rdul1],lf
	cmp byte[attrd2],0x8f 
	jb incd22
	mov byte[attrd2],0x81
incd22:
	inc byte[attrd2]
nord23:
	jmp show1


left:
	dec word[y0]
	mov bx,word[y0]
	mov ax,41
	sub ax,bx
    jz  l2u
	mov ax,word[x0]
	mov bx,80
	mul bx
	add ax,word[y0]
	mov bx,2
	mul bx
	mov bx,ax
    cmp byte [gs:bx],41h
	jae  l2u
	jmp show1

l2u:
    dec word[x0]
	inc word[y0]
	mov byte[rdul1],up
	cmp byte[attrd2],0x8f 
	jb incd23
	mov byte[attrd2],0x81
incd23:
	inc byte[attrd2]

	jmp show1

upp:
	dec word[x0]
	mov bx,word[x0]
	mov ax,-1
	sub ax,bx
    jz  u2r
	mov ax,word[x0]
	mov bx,80
	mul bx
	add ax,word[y0]
	mov bx,2
	mul bx
	mov bx,ax
    cmp byte [gs:bx],41h
	jae  u2r
	cmp byte [gs:bx],2dh
	jz  u2r
	jmp show1
u2r:
    inc word[x0]
	inc word[y0]
	mov byte[rdul1],ri
	cmp byte[attrd2],0x8f 
	jb incd24
	mov byte[attrd2],0x81
incd24:
	inc byte[attrd2]
	inc byte[chard2]
	cmp byte[chard2],'Z'
	jbe nord21
	mov byte[chard2],'A'
nord21:
	;jmp show1
show1:	
	mov cx,0ffh
lpd2: 
	dec word[ddcount]
    jnz lpd2
	mov word[ddcount],0ffffh
	dec cx
	jnz lpd2
    xor ax,ax                 ; 计算显存地址
    mov ax,word[x0]
	mov bx,80
	mul bx
	add ax,word[y0]
	mov bx,2
	mul bx
	mov bp,ax
    mov ah,byte[attrd2];  0000：黑底、1111：亮白字（默认值为07h）
	mov al,byte[chard2]			;  AL = 显示字符值（默认值为20h=空格符）
	mov word[gs:bp],ax  		;  显示字符的ASCII码值

	jmp int34 
	count dw delay
    dcount dw ddelay
	ddcount dw 0ffffh
    rdul1 db ri         ; 向右下运动
    x0   dw 13
    y0   dw 41
	chard2 db 'A'
	attrd2 db 0x82

	
	
