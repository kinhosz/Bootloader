org 0x500; 
jmp 0x000: start


str1 db 'Loading structures for the kernel',0
str2 db 'Setting up protected mode', 0
str3 db 'Loading kernel in memory', 0
str4 db 'Running kernel', 0
dot db '.', 0
finalDot db '.', 10, 13, 0

printString: 
;; Printa a string que esta em si    
	
	lodsb
	cmp al, 0
	je exit

	mov ah, 0xe
	int 10h	

	mov dx, 100;tempo do delay
	call delay 
	
	jmp printString
exit:
ret

delay: 
;; Função que aplica um delay(improvisado) baseado no valor de dx
	mov bp, dx
	back:
	dec bp
	nop
	jnz back
	dec dx
	cmp dx,0    
	jnz back
ret

printDots:
;; Printa os pontos das reticências
	mov cx, 2

	for:
		mov si, dot
		call printString
		mov dx, 600
		call delay
	dec cx
	cmp cx, 0
	jne for

	mov dx, 1200
	call delay
	mov si, finalDot
	call printString
	
ret


limpaTela:
;; Limpa a tela dos caracteres colocados pela BIOS
	; Set the cursor to top left-most corner of screen
	mov dx, 0 
    mov bh, 0      
    mov ah, 0x2
    int 0x10

    ; print 2000 blanck chars to clean  
    mov cx, 2000 
    mov bh, 0
    mov al, 0x20 ; blank char
    mov ah, 0x9
    int 0x10
    
    ;Reset cursor to top left-most corner of screen
    mov dx, 0 
    mov bh, 0      
    mov ah, 0x2
    int 0x10
ret

start:
	mov bl, 10 ; Seta cor dos caracteres para verde
	call limpaTela
	
	mov si, str1
	call printString
	call printDots

	mov si, str2
	call printString
	call printDots

	mov si, str3
	call printString
	call printDots

	mov si, str4
	call printString
	call printDots

;Carrega na memoria o kernel
	xor ax, ax
	mov ds, ax

;Resetando o disco floppy, forçando também a setar todas as trilhas para 0
reset:
	mov ah,0		
	mov dl,0		
	int 13h			
	jc reset		;em caso de erro, tenta de novo, 

load_menu:
;Setando a posição do disco onde kernel.asm foi armazenado(ES:BX = [0x7E00:0x0])
	mov ax,0x7E0	;0x7E0<<1 + 0 = 0x7E00
	mov es,ax
	xor bx,bx		;Zerando o offset

;Setando a posição da Ram onde o menu será lido
	mov ah, 0x02	;comando de ler setor do disco
	mov al,4		;quantidade de blocos ocupados pelo menu
	mov dl,0		;drive floppy

;Usaremos as seguintes posições na memoria:
	mov ch,0		;trilha 0
	mov cl,3		;setor 3
	mov dh,0		;cabeca 0
	int 13h
	jc load_menu	;em caso de erro, tenta de novo

break:	
	jmp 0x7e00		;Pula para a posição carregada

times 510-($-$$) db 0		
dw 0xaa55					


