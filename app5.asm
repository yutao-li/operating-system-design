
extrn _al:near 
extrn _bl:near 
extrn _cl:near 
extrn _dl:near 
extrn _ah:near 
extrn _bh:near 
extrn _ch:near 
extrn _dh:near 
extrn _searchstart:near  
extrn _row:near 
extrn _col:near 
extrn _es:near 
extrn _di:near 
extrn _ax:near 
extrn _bx:near 
extrn _cx:near
extrn _dx:near
extrn _j:near 
.8086
_TEXT segment byte public 'CODE'
assume cs:_TEXT,ds:_DATA,es:_DATA
DGROUP group _TEXT,_DATA,_BSS
org 100h 
start:
	jmp start1 
	toprow equ 8 
	botrow equ 15 
	lefcol equ 26 
	attrib db ? 
	row db 0 
	shadow db 19 dup (0dbh)
	menu db 0c9h,17 dup (0cdh),0bbh  
	db 0bah,'countstringlength',0bah  
	db 0bah,'program switch   ',0bah 
	db 0bah,'greedy snake     ',0bah 
	db 0bah,'semaphore control',0bah
	db 0bah,'interupt         ',0bah
	db 0bah,'documentcatalogue',0bah
	db 0c8h,17 dup (0cdh),0bch 
	prompt db 'to select an item , use <up/down> arrow'
	db ' and press <enter>.'
	db 13,10,'press <esc> to exit.'
	intro db 'countstringlength outputs the length of string you have input.' 
	;escape db 0 
	lenin equ $-intro 
	intro1 db 'program switch can execute multiprocess.'
	lenin1 equ $-intro1
	intro2 db 'greedy snake is exactly the well-known game.'
	lenin2 equ $-intro2
	intro3 db 'semaphore control shows the synchronization of multiprocess.'
	lenin3 equ $-intro3
	intro4 db 'interupt executes the clock and keyboard interupts.'
	;escape db 0 
	lenin4 equ $-intro4
	intro5 db 'documentcatalogue shows the document catalogue of the FAT12 file.'
	lenin5 equ $-intro5
	;stack dq ?
start1:
	xor	ah, ah	; 功能号ah=0（复位磁盘驱动器）
	xor	dl, dl	; dl=0（软驱，硬盘和U盘为80h）
	int	13h		; 磁盘服务BIOS调用
	mov ax,cs
	mov ds,ax; DS = CS
	mov es,ax; ES = CS
	mov	di, 100h  	; ES:DI -> BaseOfkernal :0100 

	call near ptr _searchstart 	
	;jmp $
a1:
	mov ax,cs
	mov ds,ax; DS = CS
	mov es,ax; ES = CS
	xor ax,ax 
	mov ss,ax 
	call q10clear 
	;mov escape,0 
	mov row,botrow+4 
a20:
	call b10menu
	mov row,toprow+1 
	mov attrib,16h
	call d10disply 
	call c10input
	mov ax,0600h
	call q10clear
	;jmp $
	jmp a1
	jump1 dw 100h,5500h 
	jump2 dw 100h,6500h 
	jump3 dw 100h,8000h
	jump4 dw 100h,3000h
	jump5 dw 100h,8500h
	jump6 dw 100h,3500h
	include supple5.asm
	jmp $
_TEXT ends
_DATA segment word public 'DATA'
_DATA ends
_BSS	segment word public 'BSS'
_BSS ends
end start