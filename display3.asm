	;org 1200h
    ri equ 1                  ;D-Down,U-Up,R-right,L-Left
    dow equ 2                  ;
    lf equ 3                  ;
    up equ 4   	;
    delay equ 5000					; ��ʱ���ӳټ���,���ڿ��ƻ�����ٶ�
    ddelay equ 580					; ��ʱ���ӳټ���,���ڿ��ƻ�����ٶ�
    Dn_Rt equ 1                  ;D-Down,U-Up,R-right,L-Left
    Up_Rt equ 2                  ;
    Up_Lt equ 3                  ;
    Dn_Lt equ 4                  ;
Start:
	org 100h 
	mov ax,cs 
	mov ds,ax					; DS = CS
	mov es,ax					; ES = CS
	mov	ax,0B800h				; �ı������Դ���ʼ��ַ
	mov	gs,ax					; GS = B800h	
	mov word[xd4],6 
	mov word[yd4],20 
	mov word[incre],1 
int36:
	cmp word[xd4],0 
	jb return
	cmp word[xd4],12 
	ja return 
	cmp word[yd4],0 
	jb return
	cmp word[yd4],40 
	ja return 
	call showd4 

	mov cx,word[incre]
	cmp word[incre],0
	jge yplus 
	neg cx 
ysubs:
	dec word[yd4]
	;cmp word[yd4],0 
	;jb return
	;cmp word[yd4],40 
	;ja return 
	cmp word[yd4],0 
	jb return
	cmp word[yd4],40 
	ja return 
	call showd4 
	loop ysubs 
	jmp xx
yplus:
	inc word[yd4]
	;cmp word[yd4],0 
	;jb return
	;cmp word[yd4],40 
	;ja return 
	cmp word[yd4],0 
	jb return
	cmp word[yd4],40 
	ja return 
	call showd4 
	loop yplus 

xx:
	mov cx,word[incre]
	;add ax,word[incre]
	cmp word[incre],0 
	jge xplus 
	neg cx 
xsubs:
	dec word[xd4]
	cmp word[xd4],0 
	jb return
	cmp word[xd4],12 
	ja return 
	;cmp word[yd4],0 
	;jb return
	;cmp word[yd4],12 
	;ja return 
	call showd4 
	loop xsubs 
	jmp update
xplus:
	inc word[xd4]
	cmp word[xd4],0 
	jb return
	cmp word[xd4],12 
	ja return 
	;cmp word[yd4],0 
	;jb return
	;cmp word[yd4],12 
	;ja return 
	call showd4 
	loop xplus 
	
update:
	neg word[incre]
	cmp word[incre],0 
	jl minus
	inc word[incre]
	jmp return 
minus:
	dec word[incre]
return:	

	jmp int36 
showd4:	
	push ax 
	push bx 
    xor ax,ax                 ; �����Դ��ַ
    mov ax,word[xd4]
	mov bx,80
	mul bx
	add ax,word[yd4]
	mov bx,2
	mul bx
	mov bp,ax
    mov ah,0eh;  0000���ڵס�1111�������֣�Ĭ��ֵΪ07h��
	mov al,'$'			;  AL = ��ʾ�ַ�ֵ��Ĭ��ֵΪ20h=�ո����
	mov word[gs:bp],ax  		;  ��ʾ�ַ���ASCII��ֵ
	;mov cx,1
	push cx 
	mov cx,0ffh
lpd2: 
	dec word[ddcount]
    jnz lpd2
	mov word[ddcount],0ffffh
	dec cx
	jnz lpd2
	pop cx

	;dec cx
	;jnz lpd1
	pop bx 
	pop ax 
	ret 
	count dw delay
    dcount dw ddelay
	ddcount dw 0ffffh
	xd4 dw 6 
	yd4 dw 20 
	incre dw 1 