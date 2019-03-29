;Jogo da Velha: ULTRA
org 0x7E00
jmp 0x0000:start

titulo db 'Jogo da Velha', 13
ultra db 'ULTRA', 13
iniciar db ' Iniciar Jogo', 13
guia db ' Guia', 13

;Regras:
tituloGuia db '-- GUIA --', 13
introducao db 'O jogo e similar ao classico Jogo da Velha, mas agora muito mais estrategico!', 13
pontos db 'Obtenha pontos para conjurar habilidades e derrote seu oponente!', 13
tituloObjetivo db 'OBJETIVO: ', 13
objetivo db 'Coloque 3 pecas adjacentes para vencer.', 13
tituloJogabilidade db 'JOGABILIDADE:', 13
jogabilidade1 db '> Digite de 1-9 para ver o que acontece', 13
jogabilidade2 db '> Colocar uma peca encerra o turno.', 13
jogabilidade3 db '> Colocar 2 pecas adjacentes concede 1 ponto ao jogador.', 13
jogabilidade4 db '> PONTOS sao consumidos ao conjurar habilidades para modificar o tabuleiro.', 13
tituloHabilidades db 'HABILIDADES:', 13
tituloHack db 'H - HACKEAR', 13
hack db 'Hackeia o tabuleiro, modificando-o aleatoriamente e encerra o turno.', 13
custoHack db '- 2 , 1', 13
tituloRecall db 'J - RETROCEDER', 13
recall db 'Retorna o tabuleiro ao seu estado 3 turnos atras.', 13
custoRecall db '- 3 , 2', 13
tituloPEM db 'K - PULSO ELETROMAGNETICO', 13
PEM db 'Libera um pulso que troca as pecas na fronteira do tabuleiro.', 13, 10, $
custoPEM db '- 1 , 1', 13


start:
	; Modo vídeo.
	mov ah, 0
	mov al, 12h
	int 10h

	call telaInicial

	jmp exit

telaInicial:

	;Colorindo a tela de cinza claro.
	mov ah, 0xb  
	mov bh, 0     
	mov bl, 7   
	int 10h 

	;Setando o cursor.
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
		mov bl, 0xf
		int 10h

		call delay

		cmp al, 13
		jne printTitulo

	call animacaoColorida

	call menu

	cmp cx, 2
	je telaRegras

	call jogo

	telaRegras:

		; Modo vídeo novamente para limpar a tela.
		mov ah, 0
		mov al, 12h
		int 10h

		mov ah, 0xb  
		mov bh, 0     
		mov bl, 4   
		int 10h

		mov ah, 02h
		mov bh, 00h
		mov dh, 02h
		mov dl, 07h
		int 10h

		mov bl, 0xf
		mov si, tituloGuia
		call printString

		mov ah, 02h
		mov bh, 00h
		mov dh, 05h
		mov dl, 01h
		int 10h
		mov si, introducao
		call printString

		mov ah, 02h
		mov bh, 00h
		mov dh, 06h
		mov dl, 01h
		int 10h
		mov si, pontos
		call printString
		
		;Objetivo.
		mov ah, 02h
		mov bh, 00h
		mov dh, 08h
		mov dl, 01h
		int 10h
		mov si, tituloObjetivo
		mov bl, 0xe
		call printString

		mov ah, 02h
		mov bh, 00h
		mov dh, 08h
		mov dl, 11
		int 10h
		mov si, objetivo
		mov bl, 0xf
		call printString

		;Jogabilidade e conjunto de regras.
		mov ah, 02h
		mov bh, 00h
		mov dh, 10
		mov dl, 01h
		int 10h
		mov si, tituloJogabilidade
		mov bl, 0xe
		call printString

		mov ah, 02h
		mov bh, 00h
		mov dh, 11
		mov dl, 01h
		int 10h
		mov si, jogabilidade1
		mov bl, 0xf
		call printString
		
		mov ah, 02h
		mov bh, 00h
		mov dh, 12
		mov dl, 01h
		int 10h
		mov si, jogabilidade2
		call printString

		mov ah, 02h
		mov bh, 00h
		mov dh, 13
		mov dl, 01h
		int 10h
		mov si, jogabilidade3
		call printString

		mov ah, 02h
		mov bh, 00h
		mov dh, 14
		mov dl, 01h
		int 10h
		mov si, jogabilidade4
		call printString

		;Habilidades.
		mov ah, 02h
		mov bh, 00h
		mov dh, 17
		mov dl, 01h
		int 10h
		mov si, tituloHabilidades
		mov bl, 0xe
		call printString

		mov ah, 02h
		mov bh, 00h
		mov dh, 19
		mov dl, 05h
		int 10h
		mov si, tituloHack
		mov bl, 0xd
		call printString

		mov ah, 02h
		mov bh, 00h
		mov dh, 19
		mov dl, 17
		int 10h
		mov si, custoHack
		mov bl, 0xe
		call printString

		mov ah, 02h
		mov bh, 00h
		mov dh, 20
		mov dl, 05h
		int 10h
		mov si, hack
		mov bl, 0xf
		call printString

		mov ah, 02h
		mov bh, 00h
		mov dh, 22
		mov dl, 05h
		int 10h
		mov si, tituloRecall
		mov bl, 9h
		call printString

		mov ah, 02h
		mov bh, 00h
		mov dh, 22
		mov dl, 20
		int 10h
		mov si, custoRecall
		mov bl, 0xe
		call printString

		mov ah, 02h
		mov bh, 00h
		mov dh, 23
		mov dl, 05h
		int 10h
		mov si, recall
		mov bl, 0xf
		call printString

		mov ah, 02h
		mov bh, 00h
		mov dh, 25
		mov dl, 05h
		int 10h
		mov si, tituloPEM
		mov bl, 0xA
		call printString

		mov ah, 02h
		mov bh, 00h
		mov dh, 25
		mov dl, 31
		int 10h
		mov si, custoPEM
		mov bl, 0xe
		call printString

		mov ah, 02h
		mov bh, 00h
		mov dh, 26
		mov dl, 05h
		int 10h
		mov si, PEM
		mov bl, 0xf
		call printString

		mov ah, 02h
		mov bh, 00h
		mov dh, 28
		mov dl, 05h
		int 10h

		mov ah, 0xe
		mov al, '>'
		mov bh, 0
		mov bl, 0xe
		int 10h

		mov si, iniciar
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
	mov al, '>'
	mov bh, 0
	mov bl, 0xf
	int 10h

	mov si, iniciar
	call printString

	mov ah, 02h
	mov bh, 00h
	mov dh, 12h
	mov dl, 11h
	int 10h

	mov si, guia
	call printString

	mov cx, 1 ;CX contém a posição da seta.
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

	Baixo:
		cmp cx, 2
		je Cima

		;Os 4 grupos de instruções abaixo deslocam a seta para baixo.

		mov ah, 02h
		mov bh, 00h
		mov dh, 10h
		mov dl, 10h
		int 10h

		mov ah, 0xe
		mov al, 0
		mov bh, 0
		mov bl, 0xf
		int 10h

		mov ah, 02h
		mov bh, 00h
		mov dh, 12h
		mov dl, 10h
		int 10h

		mov ah, 0xe
		mov al, '>'
		mov bh, 0
		mov bl, 0xf
		int 10h

		mov cx, 2
		jmp mudancaSeta

	Cima:
		cmp cx, 1
		je Baixo

		;Os 4 grupos de instruções abaixo deslocam a seta para cima.

		mov ah, 02h
		mov bh, 00h
		mov dh, 10h
		mov dl, 10h
		int 10h

		mov ah, 0xe
		mov al, '>'
		mov bh, 0
		mov bl, 0xf
		int 10h

		mov ah, 02h
		mov bh, 00h
		mov dh, 12h
		mov dl, 10h
		int 10h

		mov ah, 0xe
		mov al, 0
		mov bh, 0
		mov bl, 0xf
		int 10h

		mov cx, 1
		jmp mudancaSeta

animacaoColorida:

	;Colorindo a tela de amarelo.
	mov ah, 0xb  
	mov bh, 0     
	mov bl, 0xE   
	int 10h	

	mov ah, 02h
	mov bh, 00h
	mov dh, 08h
	mov dl, 24h
	int 10h

	mov bl, 1
	mov si, ultra
	call printUltra
	call delay

	;Colorindo a tela de azul.
	mov ah, 0xb  
	mov bh, 0     
	mov bl, 1   
	int 10h

	mov ah, 02h
	mov bh, 00h
	mov dh, 08h
	mov dl, 24h
	int 10h

	mov bl, 2
	mov si, ultra
	call printUltra
	call delay

	;Colorindo a tela de verde.
	mov ah, 0xb  
	mov bh, 0     
	mov bl, 2   
	int 10h

	mov ah, 02h
	mov bh, 00h
	mov dh, 08h
	mov dl, 24h
	int 10h

	mov bl, 4
	mov si, ultra
	call printUltra
	call delay

	;Colorindo a tela de vermelho (fim).
	mov ah, 0xb  
	mov bh, 0     
	mov bl, 4   
	int 10h

	mov ah, 02h
	mov bh, 00h
	mov dh, 08h
	mov dl, 24h
	int 10h

	mov bl, 0xe
	mov si, ultra
	call printUltra
ret

printUltra:
	lodsb

	mov ah, 0xe
	mov bh, 0
	int 10h

	cmp al, 13
	jne printUltra
ret

printString:
	lodsb

	mov ah, 0xe
	mov bh, 0
	int 10h

	cmp al, 13
	jne printString
ret

delay:
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
