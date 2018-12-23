    ;org 0a00h
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
    org 100h					; 程序加载到100h，可用于生成COM
start:
	;xor ax,ax					; AX = 0   程序加载到0000：100h才能正确执行
    mov ax,cs
	mov es,ax					; ES = 0
	mov ds,ax					; DS = CS
	;mov es,ax					; ES = CS
	mov	ax,0B800h				; 文本窗口显存起始地址
	mov	gs,ax					; GS = B800h
	mov word[x],0 
	mov word[y],41 
	mov byte[chard1],'A'
	mov byte[attrd1],0x82 
	mov byte[rdul],Dn_Rt
int33:
loopd1:	
    mov al,1
    cmp al,byte[rdul]
	jz  DnRt
    mov al,2
    cmp al,byte[rdul]
	jz  UpRt
    mov al,3
    cmp al,byte[rdul]
	jz  UpLt
    mov al,4
    cmp al,byte[rdul]
	jz  DnLt
    jmp $	
DnRt:
	inc word[x]
	inc word[y]
	mov bx,word[x]
	mov ax,12
	sub ax,bx
    jz  dr2ur
	mov bx,word[y]
	mov ax,80
	sub ax,bx
    jz  dr2dl
	jmp show
dr2ur:
	mov bx,word[y]
	mov ax,80 
	sub ax,bx
    jnz  n1
	dec word[x]
	dec word[y]
	mov byte[rdul],Up_Lt
	inc byte[chard1]
	cmp byte[chard1],'Z'
	jbe nord11
	mov byte[chard1],'A'
nord11:
	inc byte[attrd1]
	cmp byte[attrd1],0x8f 
	jbe incd11
	mov byte[attrd1],0x82
incd11:
	jmp show
n1:    
	mov word[x],11
    mov byte[rdul],Up_Rt	
	inc byte[chard1]
	cmp byte[chard1],'Z'
	jbe nord12
	mov byte[chard1],'A'
nord12:
	inc byte[attrd1]
	cmp byte[attrd1],0x8f 
	jbe incd17
	mov byte[attrd1],0x82
incd17:
    jmp show
dr2dl:
     mov word[y],79
     mov byte[rdul],Dn_Lt
	inc byte[chard1]
	cmp byte[chard1],'Z'
	jbe nord13
	mov byte[chard1],'A'
nord13:
	inc byte[attrd1]	
	cmp byte[attrd1],0x8f 
	jbe incd12
	mov byte[attrd1],0x82
incd12:	
    jmp show

UpRt:
	dec word[x]
	inc word[y]
	mov bx,word[y]
	mov ax,80
	sub ax,bx
    jz  ur2ul
	mov bx,word[x]
	mov ax,-1
	sub ax,bx
    jz  ur2dr
	jmp show
ur2ul:
    mov bx,word[x]
	mov ax,-1
	sub ax,bx
    jnz n2
	inc word[x]
	dec word[y]
	mov byte[rdul],Dn_Lt
	inc byte[chard1]
	cmp byte[chard1],'Z'
	jbe nord14
	mov byte[chard1],'A'
nord14:
	inc byte[attrd1]
	cmp byte[attrd1],0x8f 
	jbe incd13
	mov byte[attrd1],0x82
incd13:
	jmp show
 n2:
	mov word[y],79
    mov byte[rdul],Up_Lt	
	inc byte[chard1]
	cmp byte[chard1],'Z'
	jbe nord15
	mov byte[chard1],'A'
nord15:
	inc byte[attrd1]
	cmp byte[attrd1],0x8f 
	jbe incd14
	mov byte[attrd1],0x82
incd14:
    jmp show
ur2dr:
    mov word[x],1
    mov byte[rdul],Dn_Rt	
	inc byte[chard1]
	cmp byte[chard1],'Z'
	jbe nord16
	mov byte[chard1],'A'
nord16:
	inc byte[attrd1]
	cmp byte[attrd1],0x8f 
	jbe incd15
	mov byte[attrd1],0x82
incd15:
    jmp show
UpLt:
	dec word[x]
	dec word[y]
	mov bx,word[x]
	mov ax,-1
	sub ax,bx
    jz  ul2dl
	mov bx,word[y]
	mov ax,40
	sub ax,bx
    jz  ul2ur
	jmp show

ul2dl:
	mov bx,word[y]
	mov ax,40
	sub ax,bx
    jnz  n3
    inc word[x]
	inc word[y]
	mov byte[rdul],Dn_Rt
	inc byte[chard1]
	cmp byte[chard1],'Z'
	jbe nord17
	mov byte[chard1],'A'
nord17:
	inc byte[attrd1]
	cmp byte[attrd1],0x8f 
	jbe incd16
	mov byte[attrd1],0x82
incd16:
	jmp show
n3:     
    mov word[x],1
    mov byte[rdul],Dn_Lt
	inc byte[chard1]
	cmp byte[chard1],'Z'
	jbe nord18
	mov byte[chard1],'A'
nord18:
	inc byte[attrd1]	
	cmp byte[attrd1],0x8f 
	jbe incd18
	mov byte[attrd1],0x82
incd18:	
    jmp show
ul2ur:
    mov word[y],42
    mov byte[rdul],Up_Rt	
	inc byte[chard1]
	cmp byte[chard1],'Z'
	jbe nord19
	mov byte[chard1],'A'
nord19:
	inc byte[attrd1]
	cmp byte[attrd1],0x8f 
	jbe incd19
	mov byte[attrd1],0x82
incd19:
    jmp show	
DnLt:
	inc word[x]
	dec word[y]
	mov bx,word[y]
	mov ax,40
	sub ax,bx
    jz  dl2dr
	mov bx,word[x]
	mov ax,12
	sub ax,bx
    jz  dl2ul
	jmp show
dl2dr:
  	mov bx,word[x]
	mov ax,12
	sub ax,bx
    jnz n4
    dec word[x]
	inc word[y]
	mov byte[rdul],Up_Rt
	inc byte[chard1]
	cmp byte[chard1],'Z'
	jbe nord110
	mov byte[chard1],'A'
nord110:
	inc byte[attrd1]
	cmp byte[attrd1],0x8f 
	jbe incd110
	mov byte[attrd1],0x82
incd110:
	jmp show
 n4:  
	mov word[y],42
    mov byte[rdul],Dn_Rt	
	inc byte[chard1]
	cmp byte[chard1],'Z'
	jbe nord111
	mov byte[chard1],'A'
nord111:
	inc byte[attrd1]
	cmp byte[attrd1],0x8f 
	jbe incd111
	mov byte[attrd1],0x82
incd111:
    jmp show	
dl2ul:
    mov word[x],11
    mov byte[rdul],Up_Lt	
	inc byte[chard1]
	cmp byte[chard1],'Z'
	jbe nord112
	mov byte[chard1],'A'
nord112:
	inc byte[attrd1]
	cmp byte[attrd1],0x8f 
	jbe incd112
	mov byte[attrd1],0x82
incd112:
    jmp show	
show:	
    mov ax,0600h
	mov dx,0b4fh
	mov cx,0029h
	mov bh,0
	int 10h
    xor ax,ax                 ; 计算显存地址
    mov ax,word[x]
	mov bx,80
	mul bx
	add ax,word[y]
	mov bx,2
	mul bx
	mov bp,ax
    mov ah,byte[attrd1];  0000：黑底、1111：亮白字（默认值为07h）
	mov al,byte[chard1]			;  AL = 显示字符值（默认值为20h=空格符）
	mov word[gs:bp],ax  		;  显示字符的ASCII码值
	mov cx,0ffh
lpd1: 
	dec word[ddcount]
    jnz lpd1
	mov word[ddcount],0ffffh
	dec cx
	jnz lpd1

	jmp int33 
datadef:	
	count dw delay
    dcount dw ddelay
	ddcount dw 0ffffh
   rdul db Dn_Rt         ; 向右下运动
    x   dw 0
    y   dw 41
    chard1 db 'A'
	attrd1 db 0x82
    times 1022-($-$$) db 0
    db 0x55,0xaa