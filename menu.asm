;inicio zenio
;Tetris: O Classico
org 0x7E00
jmp 0x0000:start

;Menu Principal
titulo db '  Tetris', 13
classico db 'O Classico', 13
jogar db ' Jogar', 13
instrucoes db ' Instrucoes/Creditos', 13

;Instruções
tituloInstrucoes db 'Instrucoes', 13
tituloObjetivo db 'Objetivo: ', 13
objetivo db 'Preencher o menor `espaco vertical` possivel.', 13
com db 'Comandos:', 13
comando1 db '-> tecla `d` para rotacionar a figura para a direita', 13
comando2 db '-> tecla `a` para rotacionar a figura para a esquerda', 13
vai db ' Ir para o Jogo', 13

;Créditos
cred db 'Creditos', 13
membro1 db '-Jose Carlos(jcsc)', 13
membro2 db '-Alexsandro Jose(ajs6)', 13
membro3 db '-Zenio Angelo(zaon)', 13

start:
	; Modo vídeo
	mov ah, 0
	mov al, 12h
	int 10h

	call menuPrincipal

	jmp exit

menuPrincipal:

	;Colorindo a tela de verde
	mov ah, 0xb  
	mov bh, 0     
	mov bl, 2
	int 10h 

	;Setando o cursor
	mov ah, 02h
	mov bh, 00h
	mov dh, 07h
	mov dl, 20h
	int 10h

	mov si, titulo
	printTitulo:
		lodsb
		mov ah, 0xe
		mov bh, 0
		mov bl, 4
		int 10h
		call delay
		cmp al, 13
		jne printTitulo

	call print_subTitulo

	call menu

	cmp cx, 2
	je telaInstCred

	call jogo

	telaInstCred:

		;Modo vídeo novamente para limpar a tela
		mov ah, 0
		mov al, 12h
		int 10h

		;Colorindo novamente a tela de verde
		mov ah, 0xb  
		mov bh, 0     
		mov bl, 2   
		int 10h

		;Instruções
		mov ah, 02h
		mov bh, 00h
		mov dh, 02h
		mov dl, 22h
		int 10h

		mov bl, 0xe
		mov si, tituloInstrucoes
		call printString

		;Objetivo
		mov ah, 02h
		mov bh, 00h
		mov dh, 05h
		mov dl, 01h
		int 10h
		mov si, tituloObjetivo
		mov bl, 0xe
		call printString

		mov ah, 02h
		mov bh, 00h
		mov dh, 05h
		mov dl, 11
		int 10h
		mov si, objetivo
		mov bl, 0xf
		call printString
		
		;Comandos
		mov ah, 02h
		mov bh, 00h
		mov dh, 08h
		mov dl, 01h
		int 10h
		mov si, com
		mov bl, 0xe
		call printString

		mov ah, 02h
		mov bh, 00h
		mov dh, 08h
		mov dl, 11
		int 10h
		mov si, comando1
		mov bl, 0xf
		call printString

		mov ah, 02h
		mov bh, 00h
		mov dh, 09h
		mov dl, 11
		int 10h
		mov si, comando2
		mov bl, 0xf
		call printString

		;Creditos
		mov ah, 02h
		mov bh, 00h
		mov dh, 11
		mov dl, 22h
		int 10h
		mov si, cred
		mov bl, 0xe
		call printString
		
		mov ah, 02h
		mov bh, 00h
		mov dh, 12
		mov dl, 01h
		int 10h
		mov si, membro1
		mov bl, 0xf
		call printString

		mov ah, 02h
		mov bh, 00h
		mov dh, 13
		mov dl, 01h
		int 10h
		mov si, membro2
		mov bl, 0xf
		call printString

		mov ah, 02h
		mov bh, 00h
		mov dh, 14
		mov dl, 01h
		int 10h
		mov si, membro3
		mov bl, 0xf
		call printString

		;Ir para o jogo
		mov ah, 02h
		mov bh, 00h
		mov dh, 26
		mov dl, 01h
		int 10h

		mov ah, 0xe
		mov al, 175
		mov bh, 0
		mov bl, 0xe
		int 10h

		mov si, vai
		call printString

		esperaEnter:
			mov ah, 0
			int 16h
			cmp al, 13
			jne esperaEnter	

	call jogo	
			
ret
menu:
	mov ah, 02h
	mov bh, 00h
	mov dh, 10h
	mov dl, 10h
	int 10h

	mov ah, 0xe
	mov al, 175
	mov bh, 0
	mov bl, 4
	int 10h

	mov si, jogar
	call printString

	mov ah, 02h
	mov bh, 00h
	mov dh, 12h
	mov dl, 11h
	int 10h

	mov si, instrucoes
	call printString

	mov cx, 1 ;CX contém a posição da seta
	call mudancaSeta

	
ret

mudancaSeta:
	
	mov ah, 0
	int 16h

	cmp al, 's'
	je Baixo

	cmp al, 'w'
	je Cima

	cmp al, 13
	jne mudancaSeta

	ret

	Baixo: ;Faz o apontador se deslocar para baixo
		cmp cx, 2
		je Cima

		mov ah, 02h
		mov bh, 00h
		mov dh, 10h
		mov dl, 10h
		int 10h

		mov ah, 0xe
		mov al, 0
		mov bh, 0
		mov bl, 4
		int 10h

		mov ah, 02h
		mov bh, 00h
		mov dh, 12h
		mov dl, 10h
		int 10h

		mov ah, 0xe
		mov al, 175
		mov bh, 0
		mov bl, 4
		int 10h

		mov cx, 2
		jmp mudancaSeta

	Cima: ;Faz o apontador se deslocar para cima
		cmp cx, 1
		je Baixo

		mov ah, 02h
		mov bh, 00h
		mov dh, 10h
		mov dl, 10h
		int 10h

		mov ah, 0xe
		mov al, 175
		mov bh, 0
		mov bl, 4
		int 10h

		mov ah, 02h
		mov bh, 00h
		mov dh, 12h
		mov dl, 10h
		int 10h

		mov ah, 0xe
		mov al, 0
		mov bh, 0
		mov bl, 4
		int 10h

		mov cx, 1
		jmp mudancaSeta

print_subTitulo: ;Seta a posição onde "O Clássico" será printado e deixa a palavra vermelha
	mov ah, 02h
	mov bh, 00h
	mov dh, 08h
	mov dl, 20h
	int 10h
	mov bl, 4
	mov si, classico
	call printClassico
	call delay

ret

printClassico: ;Printa a palavra "O Clássico"
	lodsb
	mov ah, 0xe
	mov bh, 0
	int 10h
	cmp al, 13
	jne printClassico
ret

printString: ;Printa uma palavra ou frase na tela
	lodsb
	mov ah, 0xe
	mov bh, 0
	int 10h
	cmp al, 13
	jne printString
ret

delay: ;Simula uma pausa na execução
	mov bp, 350
	mov dx, 350
	delay2:
		dec bp
		nop
		jnz delay2
	dec dx
	jnz delay2

ret

jogo:
;Setando a posição do disco onde kernel.asm foi armazenado(ES:BX = [0x500:0x0])
	mov ax,0x860		;0x50<<1 + 0 = 0x500
	mov es,ax
	xor bx,bx		;Zerando o offset

;Setando a posição da Ram onde o jogo será lido
	mov ah, 0x02	;comando de ler setor do disco
	mov al,8		;quantidade de blocos ocupados por jogo
	mov dl,0		;drive floppy

;Usaremos as seguintes posições na memoria:
	mov ch,0		;trilha 0
	mov cl,7		;setor 2
	mov dh,0		;cabeca 0
	int 13h
	jc jogo	;em caso de erro, tenta de novo

break:	
	jmp 0x8600 		;Pula para a posição carregada


exit: