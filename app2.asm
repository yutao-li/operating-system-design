extrn _al:near 
extrn _bl:near 
extrn _cl:near 
extrn _dl:near 
extrn _ah:near 
extrn _bh:near 
extrn _ch:near 
extrn _dh:near 
extrn _cmain:near  
extrn _row:near 
extrn _col:near 
extrn _es:near 
extrn _di:near 
extrn _ax:near 
extrn _bx:near 
extrn _cx:near
extrn _dx:near
extrn _Current_Process:near 
extrn _Save_Process:near 
extrn _Schedule:near 
;extrn _Have_Program
extrn _special:near 
extrn _Program_Num:near 
extrn _CurrentPCBno:near 
extrn _Segment:near  
extrn _maintain:near 
extrn _pcb_list:near 
.8086
_TEXT segment byte public 'CODE'
assume cs:_TEXT,ds:_DATA,es:_DATA
DGROUP group _TEXT,_DATA,_BSS
org 100h 
start:
	xor	ah, ah	; 功能号ah=0（复位磁盘驱动器）
	xor	dl, dl	; dl=0（软驱，硬盘和U盘为80h）
	int	13h		; 磁盘服务BIOS调用
	mov ax,cs
	mov ds,ax; DS = CS
	mov es,ax; ES = CS
	push es 
	xor ax,ax 
	mov es,ax 
	mov ax,word ptr es:[20h]
	mov cs:clip,ax 
	mov ax,word ptr es:[22h]
	mov cs:clcs,ax 
	pop es 
	call near ptr _cmain
	sti 
back:
	cmp word ptr cs:[_Program_Num],0 
	jnz back
	retf
	;jmp $
	Finite dw 0	
	count db 0
	clcs dw 0 
	clip dw 0 

	;fsgs dw 0 
public _debug
_debug proc 
	push ax 
	push bx 
	push cx 
	;mov al,byte ptr [_al]
	lea bx,_pcb_list
	mov cx,word ptr cs:[_CurrentPCBno]
	mov ax,word ptr cs:[_Program_Num]
	;jmp $ ;65145
	pop cx 
	pop bx 
	pop ax 
	;mov al,byte ptr [_al]
	;jmp $ ;65122
	ret 
_debug endp 
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


Pro_Timer:
;*****************************************
;*                Save                   *
; ****************************************
	;jmp $
    cmp word ptr cs:[_Program_Num],0
	jnz Save
	jmp No_Progress
Save:
	inc cs:Finite
	cmp cs:Finite,2500
	jnz Lee 
    mov word ptr cs:[_CurrentPCBno],0
	mov cs:Finite,0
	mov word ptr cs:[_Program_Num],0
	push es 
	push ax 
	xor ax,ax 
	mov es,ax 
	mov ax,cs:clip 
	mov word ptr es:[20h],ax 
	mov ax,cs:clcs
	mov word ptr es:[22h],ax 
	pop ax 
	pop es 
	;mov word ptr[_Segment],2000h
	;jmp $
	jmp Pre
Lee:

	push bx 
	push ax 
	lea bx,_pcb_list 
	;call _debug
	mov ax,word ptr cs:[_CurrentPCBno]
	push bx 
	mov bl,34 
	mul bl 
	pop bx 
	add bx,ax 
	mov cs:[bx],ss 
	add bx,2 
	.386 
	mov cs:[bx],gs 
	add bx,2 
	mov cs:[bx],fs 
	.8086 
	add bx,2 
	mov cs:[bx],es 
	add bx,2 
	mov cs:[bx],ds 
	add bx,2 
	mov cs:[bx],di 
	add bx,2 
	mov cs:[bx],si 
	add bx,2 
	mov cs:[bx],bp  
	add bx,2 
	mov cs:[bx],sp 
	add bx,2 
	mov bp,bx 
	pop ax 
	pop bx 
	mov cs:[bp],bx 
	add bp,2 
	mov cs:[bp],dx 
	add bp,2 
	mov cs:[bp],cx 
	add bp,2 
	mov cs:[bp],ax 
	add bp,2 
	pop cs:[bp]
	add bp,2 
	pop cs:[bp]
	add bp,2 
	pop cs:[bp]
	mov ax, cs
	mov ds, ax
	mov es, ax
	;call near ptr _Schedule 
	lea bx,_pcb_list 
	;call _debug
	mov ax,word ptr [_CurrentPCBno]
	push bx 
	mov bl,34 
	mul bl 
	pop bx 
	add bx,ax 
	add bx,32 
	mov word ptr es:[bx],1 
	inc word ptr [_CurrentPCBno]
	mov ax,word ptr [_CurrentPCBno]
	cmp ax,word ptr [_Program_Num]
	jna na
	mov word ptr [_CurrentPCBno],1 
na:
	cmp word ptr es:[bx],0 
	jz Pre 
	mov word ptr es:[bx],2 
	;call _debug
Pre:
	mov ax, cs
	mov ds, ax
	mov es, ax
	lea bp,_pcb_list 
	mov ax,word ptr [_CurrentPCBno]
	mov bl,34 
	mul bl 
	add bp,ax 
	;call near ptr _Current_Process

	mov ss,word ptr ds:[bp+0]         
	mov sp,word ptr ds:[bp+16] 

	cmp word ptr ds:[bp+32],0 
	jnz No_First_Time

;*****************************************
;*                Restart                *
; ****************************************
Restart:
	
    ;call near ptr _special
	;push word ptr [_Program_Num]
	push word ptr ds:[bp+30]
	push word ptr ds:[bp+28]
	push word ptr ds:[bp+26]
	
	push word ptr ds:[bp+2]
	push word ptr ds:[bp+4]
	push word ptr ds:[bp+6]
	push word ptr ds:[bp+8]
	push word ptr ds:[bp+10]
	push word ptr ds:[bp+12]
	push word ptr ds:[bp+14]
	push word ptr ds:[bp+18]
	push word ptr ds:[bp+20]
	push word ptr ds:[bp+22]
	push word ptr ds:[bp+24]
	pop ax
	pop cx
	pop dx
	pop bx
	pop bp
	pop si
	pop di
	pop ds
	pop es
	.386
	;call near ptr _maintain
	;call _debug
	pop fs
	pop gs
	.8086
	;pop word ptr [_Program_Num]
	;call _debug
	push ax         
	mov al,20h
	out 20h,al
	out 0A0h,al
	pop ax
	iret

No_First_Time:	
	add sp,10 
	jmp Restart
	
No_Progress:
    call another_Timer
	
	push ax         
	mov al,20h
	out 20h,al
	out 0A0h,al
	pop ax
	iret
	
	

SetTimer: 
    push ax
    mov al,34h   ; 设控制字值 
    out 43h,al   ; 写控制字到控制字寄存器 
    mov ax,29830 ; 每秒 20 次中断（50ms 一次） 
    out 40h,al   ; 写计数器 0 的低字节 
    mov al,ah    ; AL=AH 
    out 40h,al   ; 写计数器 0 的高字节 
	pop ax
	ret

public _setClock
_setClock proc
    push ax
	push bx
	push cx
	push dx
	push ds
	push es
	
    call SetTimer
    xor ax,ax
	mov es,ax
	mov word ptr es:[20h],offset Pro_Timer
	mov ax,cs
	mov word ptr es:[22h],cs
	
	pop ax
	mov es,ax
	pop ax
	mov ds,ax
	pop dx
	pop cx
	pop bx
	pop ax
	ret
_setClock endp


another_Timer:
    push ax
	push bx
	push cx
	push dx
	push bp
    push es
	push ds
	
	mov ax,cs
	mov ds,ax

	cmp count,0
	jz case1
	cmp count,1
	jz case2
	cmp count,2
	jz case3
	
case1:	
    inc count
	mov al,'/'
	jmp show
case2:	
    inc count
	mov al,'\'
	jmp show
case3:	
    mov count,0
	mov al,'|'
	jmp show
	
show:
    mov bx,0b800h
	mov es,bx
	mov ah,0ah
	mov es:[((80*24+79)*2)],ax
	
	pop ax
	mov ds,ax
	pop ax
	mov es,ax
	pop bp
	pop dx
	pop cx
	pop bx
	pop ax
	ret
public _clrkey
_clrkey proc 
tes:
	mov ah,1 
	int 16h 
	jz re 
	mov ah,0 
	int 16h 
	jmp tes
re:
	ret 
_clrkey endp 
;include supple2.asm 
_TEXT ends
_DATA segment word public 'DATA'
_DATA ends
_BSS	segment word public 'BSS'
_BSS ends
end start