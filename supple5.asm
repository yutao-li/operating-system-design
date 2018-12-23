b10menu proc 
	push ax 
	push bx 
	push cx 
	push dx 
	push bp 
	mov ax,1301h 
	mov bx,0060h
	lea bp,shadow 
	mov cx,19 
	mov dh,toprow+1 
	mov dl,lefcol+1 
b20:
	int 10h 
	inc dh 
	cmp dh,botrow+2 
	jne b20 
	mov attrib,71h 
	mov ax,1300h 
	mov bl,attrib
	mov bh,0 
	lea bp,menu 
	mov cx,19 
	mov dh,toprow
	mov dl,lefcol
b30:
	int 10h 
	add bp,19 
	inc dh 
	cmp dh,botrow+1 
	jne b30 
	mov ax,1301h 
	mov bl,attrib
	xor bh,bh 
	lea bp,prompt
	mov cx,79 
	mov dh,botrow+2
	mov dl,0 
	int 10h 
	
	mov ax,1301h 
	mov bl,attrib
	xor bh,bh 
	mov dh,19 
	mov dl,0 
	lea bp,intro 
	mov cx,lenin 
	int 10h 
	
	mov ax,1301h 
	mov bl,attrib
	xor bh,bh 
	mov dh,20
	mov dl,0 
	lea bp,intro1 
	mov cx,lenin1 
	int 10h 
	
	mov ax,1301h 
	mov bl,attrib
	xor bh,bh 
	mov dh,21 
	mov dl,0 
	lea bp,intro2 
	mov cx,lenin2 
	int 10h 
	
	mov ax,1301h 
	mov bl,attrib
	xor bh,bh 
	mov dh,22 
	mov dl,0 
	lea bp,intro3
	mov cx,lenin3
	int 10h 
	
	mov ax,1301h 
	mov bl,attrib
	xor bh,bh 
	mov dh,23
	mov dl,0 
	lea bp,intro4
	mov cx,lenin4
	int 10h 
	
	mov ax,1301h 
	mov bl,attrib
	xor bh,bh 
	mov dh,24
	mov dl,0 
	lea bp,intro5
	mov cx,lenin5
	int 10h 
	pop bp 
	pop dx 
	pop cx 
	pop bx 
	pop ax 
	ret 
b10menu endp 

c10input proc 
	push ax 
	push bx 
	push cx 
	push dx 
	push bp 
	;push es 
c20:
	mov ah,10h 
	int 16h 
	cmp ah,50h
	je c30 
	cmp ah,48h
	je c40 
	cmp al,0dh 
	je c80 
	cmp al,1bh
	jne c20 
	call _clr
	jmp $
	jmp c90 
c30:
	mov attrib,71h 
	call d10disply 
	inc row 
	cmp row,botrow-1
	jbe c50 
	mov row,toprow+1 
	jmp c50 
c40:
	mov attrib,71h 
	call d10disply
	dec row 
	cmp row,toprow+1 
	jae c50 
	mov row,botrow-1 
c50:
	mov attrib,17h 
	call d10disply 
	jmp c20 
c80:
	cmp row,9 
	jnz cmp1
	lea bx,jump1
	call dword ptr [bx]
	jmp c90 
cmp1:
	cmp row,10  
	jnz cmp2
	lea bx,jump2
	call dword ptr [bx]
c90:
	pop bp 
	pop dx 
	pop cx 
	pop bx 
	pop ax 
	ret 
cmp2:
	cmp row,11 
	jnz cmp3
	lea bx,jump3
	call dword ptr [bx] 
	jmp c90 
cmp3:
	cmp row,12 
	jnz cmp4
	lea bx,jump4
	call dword ptr [bx] 
	jmp c90 
cmp4:
	cmp row,13  
	jnz cmp5
	lea bx,jump5
	call dword ptr [bx] 
	jmp c90 
cmp5:
	lea bx,jump6
	call dword ptr [bx] 
	jmp c90 
c10input endp 

d10disply proc 
	push ax 
	push bx 
	push cx 
	push dx 
	push bp
	push si 
	xor ah,ah 
	mov al,row 
	sub ax,toprow
	mov bh,19 
	imul bh  
	lea si,menu+1 
	add si,ax 
	mov ax,1300h 
	xor bh,bh 
	mov bl,attrib 
	mov bp,si 
	mov cx,17 
	mov dh,row 
	mov dl,lefcol+1 
	int 10h 
	pop si 
	pop bp 
	pop dx 
	pop cx 
	pop bx 
	pop ax 
	ret 
d10disply endp 

q10clear proc 
	push ax 
	push bx 
	push cx 
	push dx 
	mov ax,0600h 
	mov bh,61h 
	mov cx,0 
	mov dx,184fh
	int 10h 
	pop dx 
	pop cx 
	pop bx 
	pop ax 
	ret 
q10clear endp 
	
public _debug 
_debug proc 
	;mov bx,word ptr [_bx]
	mov ax,word ptr [_ax]
	;mov di,word ptr [_di]
	mov cx,word ptr [_j]
	;mov ax,word ptr [_ax]
	;mov es,word ptr [_es]
	;jmp $ ;9000h:4b2h
	;mov ax,0
	ret 
_debug endp 
public _LABEL_FILE_LOADED 
_LABEL_FILE_LOADED proc 
	mov al,byte ptr [_al]
	cmp al,'1'
	jnz next
	lea bx,jump1
	jmp cal 
next:
	cmp al,'2'
	jnz next1
	lea bx,jump2
	jmp cal 
next1:
	lea bx,jump3
cal:
	call dword ptr [bx]
	mov ax,9000h
	mov es,ax 
	mov ds,ax 
	ret					; ��������
_LABEL_FILE_LOADED endp 



public _lodsw
_lodsw proc
	push es 
	push di 
	mov ax,word ptr [_es]  
	mov es,ax
	mov di,word ptr [_di]
	mov ax,es:[di]
	pop di 
	pop es 
	ret 
_lodsw endp 

public _lodsb
_lodsb proc
	push es 
	push di 
	mov ax,word ptr [_es]  
	mov es,ax
	mov di,word ptr [_di]
	mov al,es:[di]
	pop di 
	pop es 
	ret 
_lodsb endp 

public _show 
_show proc 	
	push es 
	push bx 
	push ax
	mov ax,0b800h
	mov es,ax 
	mov bx,word ptr [_bx]
	mov al,byte ptr [_al]
	mov es:[bx],al 
	inc bx 
	mov al,0eh 
	mov es:[bx],al 
	pop ax 
	pop bx 
	pop es 
	ret 
_show endp 

public _set
_set proc 
	push ax 
	push dx 
	push bx 
	mov ah,2 
	mov bh,0 
	mov dh,byte ptr [_row] 
	mov dl,byte ptr [_col] 
	int 10h 
	pop bx 
	pop dx 
	pop ax 
	ret 
_set endp 


public _readp
_readp proc
testing:
	mov ah,1 
	int 16h 
	jz testing 
	mov ah,0
	int 16h 
	ret
_readp endp

public _ReadSector
;----------------------------------------------------------------------------
; ��������ReadSector
;----------------------------------------------------------------------------
; ���ã��ӵ� AX��������ʼ����CL����������ES:BX��
_ReadSector proc
	; -----------------------------------------------------------------------
	; �������������������ڴ����е�λ�� (������->����š���ʼ��������ͷ��)
	; -----------------------------------------------------------------------
	; ��������Ϊ x
	;                             �� ����� = y >> 1
	;       x              �� �� y ��
	;   -------------- 	=> ��      �� ��ͷ�� = y & 1
	;  ÿ�ŵ�������        ��
	;                      �� �� z => ��ʼ������ = z + 1
	push es 
	push bp		; ����BP
	push bx 
	mov ax,word ptr [_es]
	mov es,ax 
	mov ax,word ptr [_ax]
	mov cl,byte ptr [_cl]
	mov bx,word ptr [_bx]
	mov bp, sp	; ��BP=SP
	sub	sp, 2 	; �ٳ������ֽڵĶ�ջ���򱣴�Ҫ����������: byte [bp-2]
	mov	byte [bp-2], cl	; ѹCL��ջ�������ʾ�����������Ĵ��ݲ�����
	push bx			; ����BX
	mov	bl, 18	; BL=18���ŵ���������Ϊ����
	div	bl			; AX/BL����y��AL�С�����z��AH��
	inc	ah			; z ++������̵���ʼ������Ϊ1��
	mov	cl, ah		; CL <- ��ʼ������
	mov	dh, al		; DH <- y
	shr	al, 1		; y >> 1 ���ȼ���y/BPB_NumHeads��������2����ͷ��
	mov	ch, al		; CH <- �����
	and	dh, 1		; DH & 1 = ��ͷ��
	pop	bx			; �ָ�BX
	; ���ˣ�"����š���ʼ��������ͷ��"��ȫ���õ�
	mov	dl, 0	; �������ţ�0��ʾ����A��
.GoOnReading: ; ʹ�ô����ж϶�������
	mov	ah, 2				; ���ܺţ���������
	mov	al, byte [bp-2]		; ��AL������
	;call _debug
	int	13h				; ���̷���BIOS����
	jc	.GoOnReading	; �����ȡ����CF�ᱻ��Ϊ1��
						; ��ʱ�Ͳ�ͣ�ض���ֱ����ȷΪֹ
	add	sp, 2			; ջָ��+2
	pop bx 
	pop	bp				; �ָ�BP
	pop es 
	ret
;----------------------------------------------------------------------------
_ReadSector endp 

public _clr
_clr proc
	mov ax,600h
	mov cx,0
	mov dx,184fh
	mov bh,0
	int 10h
	ret
_clr endp

public _delay
_delay proc
	mov cx,04ffh
loop2:
	push cx 
	mov cx,0ffffh
loop1:	
	push cx 
	mov cx,0ffffh
	rep nop
	pop cx 
	loop loop1 
	pop cx 
	loop loop2 
	ret
_delay endp

