org 0x7C00; (offset)0x7c000 + 0x0000
jmp 0x0000:start; garantir cs == 0x0000

start:
	xor ax, ax
	mov ds, ax

;Resetando o disco floppy, forçando também a setar todas as trilhas para 0
reset:
	mov ah,0		
	mov dl,0		
	int 13h			
	jc reset		;em caso de erro, tenta de novo, 

;Carrega na memoria o boot2
load_Boot2:
;Setando a posição do disco onde boot2.asm foi armazenado(ES:BX = [0x500:0x0])
	mov ax,0x50		;0x50<<1 + 0 = 0x500
	mov es,ax
	xor bx,bx		;Zerando o offset

;Setando a posição da Ram onde o boot2 será lido
	mov ah, 0x02	;comando de ler setor do disco
	mov al,1		;quantidade de blocos ocupados por boot2
	mov dl,0		;drive floppy

;Usaremos as seguintes posições na memoria:
	mov ch,0		;trilha 0
	mov cl,2		;setor 2
	mov dh,0		;cabeca 0
	int 13h
	jc load_Boot2	;em caso de erro, tenta de novo

break:	
	jmp 0x500 		;Pula para a posição carregada

end: 
times 510-($-$$) db 0		; preenche o resto do setor com zeros 
dw 0xaa55					; coloca a assinatura de boot no final do setor