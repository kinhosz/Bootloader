org 0x8600
jmp 0x0000:main

data:
;strings
score db ' SCORE ',13
pontos db ' 02040 ',13
bilau db '             ',13
level db ' LEVEL ', 13
nivel db '   6   ',13
; mapa do jogo
map db '0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000',13

;CORES
; BLOCO 1  = 1 SEM MOVIMENTO
; BLOCO 2~5 = 14 L
; BLOCO 6~7 = 15 MENOR MAIOR
; BLOCO 8~9 = 9 MAIOR MENOR 
; BLOCO 10~13 = 4 LINDO
; BLOCO 14 ~ 17 = 3 L INVERSO
; BLOCO 18 ~ 19= 11 BARRA
; algumas cores davam um erro de execucao no codigo (???)

_init:

	mov ah,4fh
	mov al,02h
	mov bx,10h
	int 10h
	ret
	
prints:

	.loop:
		lodsb
		cmp al,13
		je .fimloop
		call set_cursor
		call putchar
		inc dl
		jmp .loop
	
	.fimloop:
	ret

set_cursor:

	mov ah,02h
	mov bh,0
	int 10h
	ret

putchar:

	mov ah,0ah
	mov bl,4
	mov bh,0
	mov cx,1
	int 10h
	ret

draw_pixel:

	mov ah,0ch
	mov bh,0
	int 10h
	ret
	
draw_background:

	mov cx,0
	mov dx,0
	dec dx
	
	;; printa o plano de fundo
	.for1:
		mov cx,0
		dec cx
		inc dx
		cmp dx,350
		je .fimfor1
		.for2:
			inc cx
			cmp cx,640
			je .for1
			mov al,2
			call draw_pixel
			jmp .for2
	.fimfor1:
	; para printar o campo de jogo no centro
	; coluna 110 ~ 510
	; linha 5 ~ 345
	; pixels = 20*20
	mov dx,5
	.for3:
		mov cx,110
		inc dx
		cmp dx,345
		je .fimfor3
			.for4:
			inc cx
			cmp cx,511
			je .for3
			mov al,0
			call draw_pixel
			jmp .for4
	.fimfor3:
	;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	mov dh,1 ;posicao inicial do cursor
	mov dl,3
	mov si,score
	call prints
	call print_pontos
	
	call clear_window
	
	mov dh,7
	mov dl,3
	mov si,level
	call prints
	mov dh,9
	mov dl,3
	mov si,nivel
	call prints
	
	
	ret
	
print_pontos: ;essa funcao so existe pq a pontuacao mudara constantemente

	mov dh,3
	mov dl,3
	mov si,pontos
	call prints
	ret
	
reset:

	; zera a pontuaçao
	mov si,pontos
	mov di,pontos
	.for1:
		lodsb
		cmp al,' '
		je .if1
		cmp al,13
		je .fimfor1
		mov al,48
		.if1: ;nao altera o caracter
		stosb
		jmp .for1
	.fimfor1:
	; zera o nivel
	mov si,nivel
	mov di,nivel
	.for2:
		lodsb
		cmp al,' '
		je .if2
		cmp al,13
		je .fimfor2
		mov al,49
		.if2: ;nao altera o caracter
		stosb
		jmp .for2
	.fimfor2:
	;zera o mapa
	mov si,map
	mov di,map
	.for3:
		lodsb
		cmp al,13
		je .fimfor3
		mov al,48
		stosb
		jmp .for3
	.fimfor3:
	
	ret

print_bloco: 

	; coluna 111 ~ 510
	; linha 5 ~ 320
	; pixels = 25*25 
	; cl = position
	; al = cor
	
	;mov ch,0
	sub al,48
	push ax ; guarda a cor do pixel
	push cx ; guarda cx
	mov ax,cx
	mov dl,13 ; qtd de linha
	div dl;
	mov al,ah; al = resto
	mov ah,0
	mov dx,320 ; >>>>>>>>consertou meu bug<<<<<
	mov cl,25
	mul cl ; ax = 25 * dif
	sub dx,ax ; dx = pos inicial do for
	pop cx ; recupera cx
	push dx ; armazena a posicao inicial da linha
	
	;mov ch,0 ; zera o high
	mov ax,cx
	mov cl,13
	div cl ; al = quociente
	mov ah,0
	mov cx,0
	mov cl,25 
	mul cl ; ax = acrescimo
	mov dx,111 ;>>>>>>>>consertou meu bug<<<<<
	add dx,ax ; dx = posicao coluna inicial
	pop cx ; cx = inicio linha
	pop ax; al = cor, ah = lixo
	push cx ; cx = linha -> errado
	push dx ; dx = coluna -> errado
	; swap
	pop cx ; cx = coluna -> certo
	pop dx ; dx = linha -> correto
	
	; temos:
	; cx = coluna inicial
	; dx = linha inicial
	; al = cor do pixel
	
	mov bx,0 ; contador
	push bx ; armazena na pilha, ->> bx1
	add cx,25
	dec dx
	
	.for1:
		pop bx
		cmp bx,25
		je .fimfor1
		sub cx,25
		inc dx
		inc bx ; incrementa
		push bx ; armazena novamente na pilha
		mov bx,0 ; reciclagem rsrs
		.for2:
			cmp bx,25
			je .for1
			call draw_pixel
			inc bx
			inc cx
			jmp .for2
	.fimfor1:
	

	ret
	
print_mapa: ;printar o tabuleiro de jogo

	mov si,map
	mov cl,0
	dec cl
	.for:
		inc cl
		cmp cl,208
		je .fimfor1
		lodsb
		push si ; push, pois posso perder o valor
		push cx
		call print_bloco
		pop cx
		pop si ; recuperando, bb
		jmp .for
	.fimfor1:
		
	ret
	
print_data:

	mov dh,9
	mov dl,3
	mov si,nivel
	call prints ;print new nivel
	call print_pontos
	call print_mapa

	ret
rand:

	mov ah,02h
	int 1Ah
	; ch = hour
	; cl = minutes
	; dh = seconds
	; gerar numeros aleatorios
	mov al,dh
	mov ah,0
	inc cl
	mul cl
	mov cl,9
	div cl
	mov al,ah
	mov ah,0
	mov al,3
	ret
	
clear_window:

	mov dh,2
	.for5:   ; printa telinha escura da direita
		inc dh
		cmp dh,11
		je .fimfor5
		mov dl,66
		mov si,bilau
		call prints
		jmp .for5
	.fimfor5:

	ret
	
	
;funcoes que printam bloquinhos
draw_A:

	push ax
	push cx
	call print_bloco
	pop cx
	pop ax
	dec cx
	push ax
	push cx
	call print_bloco
	pop cx
	pop ax
	add cx,13
	push ax
	push cx
	call print_bloco
	pop cx
	pop ax
	inc cx
	call print_bloco

	ret
	
draw_B:

	push cx
	push ax
	call print_bloco
	pop ax
	pop cx
	add cx,13
	push cx
	push ax
	call print_bloco
	pop ax
	pop cx
	sub cx,13
	inc cx
	push cx
	push ax
	call print_bloco
	pop ax
	pop cx
	inc cx
	call print_bloco

	ret
	
draw_C:

	push cx
	push ax
	call print_bloco
	pop ax
	pop cx
	dec cx
	push cx
	push ax
	call print_bloco
	pop ax
	pop cx
	inc cx
	add cx,13
	push cx
	push ax
	call print_bloco
	pop ax
	pop cx
	add cx,13
	push cx
	push ax
	call print_bloco

	ret
	
draw_D:

	push cx
	push ax
	call print_bloco
	pop ax
	pop cx
	sub cx,13
	push cx
	push ax
	call print_bloco
	pop ax
	pop cx
	add cx,13
	dec cx
	push cx
	push ax
	call print_bloco
	pop ax
	pop cx
	dec cx
	push cx
	push ax
	call print_bloco

	ret

draw_E:

	push cx
	push ax
	call print_bloco
	pop ax
	pop cx
	inc cx
	push cx
	push ax
	call print_bloco
	pop ax
	pop cx
	dec cx
	sub cx,13
	push cx
	push ax
	call print_bloco
	pop ax
	pop cx
	sub cx,13
	push cx
	push ax
	call print_bloco
	
	ret
	
draw_F:

	push cx
	push ax
	call print_bloco
	pop ax
	pop cx
	inc cx
	push cx
	push ax
	call print_bloco
	pop ax
	pop cx
	dec cx
	sub cx,13
	push cx
	push ax
	call print_bloco
	pop ax
	pop cx
	dec cx
	push cx
	push ax
	call print_bloco
	
	ret
	
draw_G:

	push cx
	push ax
	call print_bloco
	pop ax
	pop cx
	add cx,13
	push cx
	push ax
	call print_bloco
	pop ax
	pop cx
	sub cx,13
	inc cx
	push cx
	push ax
	call print_bloco
	pop ax
	pop cx
	sub cx,13
	push cx
	push ax
	call print_bloco

	ret
	
draw_H:

	push cx
	push ax
	call print_bloco
	pop ax
	pop cx
	dec cx
	push cx
	push ax
	call print_bloco
	pop ax
	pop cx
	inc cx
	sub cx,13
	push cx
	push ax
	call print_bloco
	pop ax
	pop cx
	inc cx
	push cx
	push ax
	call print_bloco

	ret
	
draw_I:

	push cx
	push ax
	call print_bloco
	pop ax
	pop cx
	sub cx,13
	push cx
	push ax
	call print_bloco
	pop ax
	pop cx
	add cx,13
	inc cx
	push cx
	push ax
	call print_bloco
	pop ax
	pop cx
	add cx,13
	push cx
	push ax
	call print_bloco
	
	ret
	
flip_window:
	
	cmp ax,0
	je .ifA
	cmp ax,1
	je .ifB
	cmp ax,2
	je .ifC
	cmp ax,3
	je .ifD
	cmp ax,4 ; condicionais
	je .ifE
	cmp ax,5
	je .ifF
	cmp ax,6
	je .ifG
	cmp ax,7
	je .ifH
	cmp ax,8
	je .ifI
	
	;:::::::::::::::::::::::
	.ifA:
		mov cx,103 ;seta posicao
		add cx,128
		mov al,1 ;seta cor
		call draw_A    ; para printar os 19 poligonos
	jmp .fimfunction
	.ifB:
		mov al,14 ; cor
		mov cx,101
		add cx,128
		call draw_B
	jmp .fimfunction
	.ifC:
		mov al,14 ; cor
		mov cx,103
		add cx,128
		call draw_C
	jmp .fimfunction
	.ifD:
		mov al,14 ; cor
		mov cx,103
		add cx,141
		call draw_D
	jmp .fimfunction
	.ifE:
		mov al,14 ; cor
		mov cx,128
		add cx,128
		call draw_E
	jmp .fimfunction
	.ifF:
		mov al,15
		mov cx,115
		add cx,128
		call draw_F
	jmp .fimfunction
	.ifG:
		mov al,15
		mov cx,102
		add cx,141
		call draw_G
	jmp .fimfunction
	.ifH:
		mov al,9
		mov cx,115
		add cx,128
		call draw_H
	jmp .fimfunction
	.ifI:
		mov al,9
		mov cx,115
		add cx,128
		call draw_I
	jmp .fimfunction
	
	.fimfunction:
	ret
	

;;;;;;;;;;;;;;;;serie de funcoes para verificar se eh possivel o 
;;;;;;;;;;;;;;;; encaixe de um bloco em uma determinada posicao
;;;;;;;;;;;;;;; fudeu papai
val_A:

	;cx = referencia
	;bl = flag
	;al = valor a ser avaliado
	
	cmp cx,208
	ja .fail
	cmp cx,0
	je .fail
	cmp cx,13
	je .fail
	cmp cx,26
	je .fail
	cmp cx,39
	je .fail
	cmp cx,52
	je .fail
	cmp cx,65
	je .fail
	cmp cx,78
	je .fail
	cmp cx,91
	je .fail
	cmp cx,104
	je .fail
	cmp cx,117
	je .fail
	cmp cx,130
	je .fail
	cmp cx,143
	je .fail
	cmp cx,156
	je .fail
	cmp cx,169
	je .fail
	cmp cx,182
	je .fail
	cmp cx,195
	je .fail
	cmp cx,195
	jae .fail
	
	
	push cx
	mov si,map
	add si,cx
	lodsb
	cmp al,48
	jne .fail
	pop cx
	dec cx
	mov si,map
	add si,cx
	lodsb
	push cx
	cmp al,48
	jne .fail
	pop cx
	add cx,13
	mov si,map
	add si,cx
	lodsb
	push cx
	cmp al,48
	jne .fail
	pop cx
	inc cx
	mov si,map
	add si,cx
	lodsb
	cmp al,48
	jne .fail
	
	mov bl,1
	jmp .fim
	.fail:
	mov bl,0
	.fim:
	ret

	
val_B:

	cmp cx,208
	ja .fail
	cmp cx,195
	jae .fail

	push cx
	mov si,map
	add si,cx
	lodsb
	cmp al,48
	jne .fail
	pop cx
	add cx,13
	push cx
	mov si,map
	add si,cx
	lodsb
	cmp al,48
	jne .fail
	pop cx
	sub cx,13
	inc cx
	push cx
	mov si,map
	add si,cx
	lodsb
	cmp al,48
	jne .fail
	pop cx
	inc cx
	mov si,map
	add si,cx
	lodsb
	cmp al,48
	jne .fail
	
	mov bl,1
	jmp .fim
	.fail:
	mov bl,0
	.fim:
	ret
	
val_C:

	cmp cx,208
	ja .fail
	cmp cx,0
	je .fail
	cmp cx,13
	je .fail
	cmp cx,26
	je .fail
	cmp cx,39
	je .fail
	cmp cx,52
	je .fail
	cmp cx,65
	je .fail
	cmp cx,78
	je .fail
	cmp cx,91
	je .fail
	cmp cx,104
	je .fail
	cmp cx,117
	je .fail
	cmp cx,130
	je .fail
	cmp cx,143
	je .fail
	cmp cx,156
	je .fail
	cmp cx,169
	je .fail
	cmp cx,182
	je .fail
	cmp cx,182
	jae .fail
	
	push cx
	mov si,map
	add si,cx
	lodsb
	cmp al,48
	jne .fail
	pop cx
	dec cx
	push cx
	mov si,map
	add si,cx
	lodsb
	cmp al,48
	jne .fail
	pop cx
	inc cx
	add cx,13
	push cx
	mov si,map
	add si,cx
	lodsb
	cmp al,48
	jne .fail
	pop cx
	add cx,13
	push cx
	mov si,map
	add si,cx
	lodsb
	cmp al,48
	jne .fail

	mov bl,1
	jmp .fim
	.fail:
	mov bl,0
	.fim:
	ret
	
val_D:

	cmp cx,208
	ja .fail
	cmp cx,13
	jb .fail
	
	cmp cx,13
	je .fail
	cmp cx,14
	je .fail
	cmp cx,26
	je .fail
	cmp cx,27
	je .fail
	cmp cx,39
	je .fail
	cmp cx,40
	je .fail
	cmp cx,52
	je .fail
	cmp cx,53
	je .fail
	cmp cx,65
	je .fail
	cmp cx,66
	je .fail
	cmp cx,78
	je .fail
	cmp cx,79
	je .fail
	cmp cx,91
	je .fail
	cmp cx,92
	je .fail
	cmp cx,104
	je .fail
	cmp cx,105
	je .fail
	cmp cx,117
	je .fail
	cmp cx,118
	je .fail
	cmp cx,130
	je .fail
	cmp cx,131
	je .fail
	cmp cx,143
	je .fail
	cmp cx,144
	je .fail
	cmp cx,156
	je .fail
	cmp cx,157
	je .fail
	cmp cx,169
	je .fail
	cmp cx,170
	je .fail
	cmp cx,182
	je .fail
	cmp cx,183
	je .fail
	
	cmp cx,195
	jae .fail
	
	push cx
	mov si,map
	add si,cx
	lodsb
	cmp al,48
	jne .fail
	pop cx
	sub cx,13
	push cx
	mov si,map
	add si,cx
	lodsb
	cmp al,48
	jne .fail
	pop cx
	add cx,13
	dec cx
	push cx
	mov si,map
	add si,cx
	lodsb
	cmp al,48
	jne .fail
	pop cx
	dec cx
	push cx
	mov si,map
	add si,cx
	lodsb
	cmp al,48
	jne .fail

	mov bl,1
	jmp .fim
	.fail:
	mov bl,0
	.fim:
	ret

val_E:


	cmp cx,208
	ja .fail
	cmp cx,208
	ja .fail
	cmp cx,26
	jb .fail
	
	push cx
	mov si,map
	add si,cx
	lodsb
	cmp al,48
	jne .fail
	pop cx
	inc cx
	push cx
	mov si,map
	add si,cx
	lodsb
	cmp al,48
	jne .fail
	pop cx
	dec cx
	sub cx,13
	push cx
	mov si,map
	add si,cx
	lodsb
	cmp al,48
	jne .fail
	pop cx
	sub cx,13
	push cx
	mov si,map
	add si,cx
	lodsb
	cmp al,48
	jne .fail
	
	mov bl,1
	jmp .fim
	.fail:
	mov bl,0
	.fim:
	ret
	
val_F:

	cmp cx,208
	ja .fail
	cmp cx,208
	ja .fail
	cmp cx,0
	je .fail
	cmp cx,13
	je .fail
	cmp cx,26
	je .fail
	cmp cx,39
	je .fail
	cmp cx,52
	je .fail
	cmp cx,65
	je .fail
	cmp cx,78
	je .fail
	cmp cx,91
	je .fail
	cmp cx,104
	je .fail
	cmp cx,117
	je .fail
	cmp cx,130
	je .fail
	cmp cx,143
	je .fail
	cmp cx,156
	je .fail
	cmp cx,169
	je .fail
	cmp cx,182
	je .fail
	cmp cx,195
	je .fail
	cmp cx,13
	jb .fail
	
	push cx
	mov si,map
	add si,cx
	lodsb
	cmp al,48
	jne .fail
	pop cx
	inc cx
	push cx
	mov si,map
	add si,cx
	lodsb
	cmp al,48
	jne .fail
	pop cx
	dec cx
	sub cx,13
	push cx
	mov si,map
	add si,cx
	lodsb
	cmp al,48
	jne .fail
	pop cx
	dec cx
	push cx
	mov si,map
	add si,cx
	lodsb
	cmp al,48
	jne .fail
	
	mov bl,1
	jmp .fim
	.fail:
	mov bl,0
	.fim:
	ret
	
val_G:

	cmp cx,208
	ja .fail
	cmp cx,0
	je .fail
	cmp cx,13
	je .fail
	cmp cx,26
	je .fail
	cmp cx,39
	je .fail
	cmp cx,52
	je .fail
	cmp cx,65
	je .fail
	cmp cx,78
	je .fail
	cmp cx,91
	je .fail
	cmp cx,104
	je .fail
	cmp cx,117
	je .fail
	cmp cx,130
	je .fail
	cmp cx,143
	je .fail
	cmp cx,156
	je .fail
	cmp cx,169
	je .fail
	cmp cx,182
	je .fail
	cmp cx,13
	jb .fail
	cmp cx,195
	ja .fail
	
	push cx
	mov si,map
	add si,cx
	lodsb
	cmp al,48
	jne .fail
	pop cx
	add cx,13
	push cx
	mov si,map
	add si,cx
	lodsb
	cmp al,48
	jne .fail
	pop cx
	sub cx,13
	inc cx
	push cx
	mov si,map
	add si,cx
	lodsb
	cmp al,48
	jne .fail
	pop cx
	sub cx,13
	push cx
	mov si,map
	add si,cx
	lodsb
	cmp al,48
	jne .fail

	mov bl,1
	jmp .fim
	.fail:
	mov bl,0
	.fim:
	ret
	
val_H:

	cmp cx,208
	ja .fail
	cmp cx,0
	je .fail
	cmp cx,13
	je .fail
	cmp cx,26
	je .fail
	cmp cx,39
	je .fail
	cmp cx,52
	je .fail
	cmp cx,65
	je .fail
	cmp cx,78
	je .fail
	cmp cx,91
	je .fail
	cmp cx,104
	je .fail
	cmp cx,117
	je .fail
	cmp cx,130
	je .fail
	cmp cx,143
	je .fail
	cmp cx,156
	je .fail
	cmp cx,169
	je .fail
	cmp cx,182
	je .fail
	cmp cx,13
	jb .fail
	
	push cx
	mov si,map
	add si,cx
	lodsb
	cmp al,48
	jne .fail
	pop cx
	dec cx
	push cx
	mov si,map
	add si,cx
	lodsb
	cmp al,48
	jne .fail
	pop cx
	inc cx
	sub cx,13
	push cx
	mov si,map
	add si,cx
	lodsb
	cmp al,48
	jne .fail
	pop cx
	inc cx
	push cx
	mov si,map
	add si,cx
	lodsb
	cmp al,48
	jne .fail

	mov bl,1
	jmp .fim
	.fail:
	mov bl,0
	.fim:
	ret
	
val_I:

	cmp cx,208
	ja .fail
	cmp cx,13
	jb .fail
	cmp cx,195
	ja .fail
	
	push cx
	mov si,map
	add si,cx
	lodsb
	cmp al,48
	jne .fail
	pop cx
	sub cx,13
	push cx
	mov si,map
	add si,cx
	lodsb
	cmp al,48
	jne .fail
	pop cx
	add cx,13
	inc cx
	push cx
	mov si,map
	add si,cx
	lodsb
	cmp al,48
	jne .fail
	pop cx
	add cx,13
	push cx
	mov si,map
	add si,cx
	lodsb
	cmp al,48
	jne .fail
	
	mov bl,1
	jmp .fim
	.fail:
	mov bl,0
	.fim:
	ret

	
verify:

	cmp ax,0
	je .ifA
	cmp ax,1
	je .ifB
	cmp ax,2
	je .ifC
	cmp ax,3
	je .ifD
	cmp ax,4 ; condicionais (calma, isso nao eh um Djavu)
	je .ifE
	cmp ax,5
	je .ifF
	cmp ax,6
	je .ifG
	cmp ax,7
	je .ifH
	cmp ax,8
	je .ifI
	
	;:::::::::::::::::::::::
	.ifA:
		mov cx,103 ;seta posicao
		;add cx,128
		;mov al,1 ;seta cor
		push cx
		call val_A    ; para printar os 19 poligonos
	jmp .fimfunction
	.ifB:
		;mov al,14 ; cor
		mov cx,101
		;add cx,128
		push cx
		call val_B
	jmp .fimfunction
	.ifC:
		;mov al,14 ; cor
		mov cx,103
		;add cx,128
		push cx
		call val_C
	jmp .fimfunction
	.ifD:
		;mov al,14 ; cor
		mov cx,103
		;add cx,141
		push cx
		call val_D
	jmp .fimfunction
	.ifE:
		;mov al,14 ; cor
		mov cx,128
		;add cx,128
		push cx
		call val_E
	jmp .fimfunction
	.ifF:
		;mov al,15
		mov cx,115
		;add cx,128
		push cx
		call val_F
	jmp .fimfunction
	.ifG:
		;mov al,15
		mov cx,102
		;add cx,141
		push cx
		call val_G
	jmp .fimfunction
	.ifH:
		;mov al,9
		mov cx,115
		;add cx,128
		push cx
		call val_H
	jmp .fimfunction
	.ifI:
		;mov al,9
		mov cx,115
		;add cx,128
		push cx
		call val_I
	jmp .fimfunction
	
	.fimfunction:
	pop cx
	;retorna a flag '''bl''' da validade
	ret
	
set_initial:

	cmp ax,0
	je .ifA
	cmp ax,1
	je .ifB
	cmp ax,2
	je .ifC
	cmp ax,3
	je .ifD
	cmp ax,4 ; condicionais (calma, isso nao eh um Djavu)
	je .ifE
	cmp ax,5
	je .ifF
	cmp ax,6
	je .ifG
	cmp ax,7
	je .ifH
	cmp ax,8
	je .ifI
	
	;:::::::::::::::::::::::
	.ifA:
		mov cx,103 ;seta posicao
		
	jmp .fimfunction
	.ifB:
		;mov al,14 ; cor
		mov cx,101
		
	jmp .fimfunction
	.ifC:
		;mov al,14 ; cor
		mov cx,103
		
	jmp .fimfunction
	.ifD:
		;mov al,14 ; cor
		mov cx,103
		
	jmp .fimfunction
	.ifE:
		;mov al,14 ; cor
		mov cx,128
		
	jmp .fimfunction
	.ifF:
		;mov al,15
		mov cx,115
		
	jmp .fimfunction
	.ifG:
		;mov al,15
		mov cx,102
		
	jmp .fimfunction
	.ifH:
		;mov al,9
		mov cx,115
	
	jmp .fimfunction
	.ifI:
		;mov al,9
		mov cx,115
		
	jmp .fimfunction
		
	
	.fimfunction:
	; retorna a pos cx
	ret
	
animation:
	
	cmp ax,0
	je .ifA
	cmp ax,1
	je .ifB
	cmp ax,2
	je .ifC
	cmp ax,3
	je .ifD
	cmp ax,4 ; condicionais
	je .ifE
	cmp ax,5
	je .ifF
	cmp ax,6
	je .ifG
	cmp ax,7
	je .ifH
	cmp ax,8
	je .ifI
	
	;:::::::::::::::::::::::
	.ifA:
		mov cx,103 ;seta posicao
		mov al,1 ;seta cor
		call draw_A    ; para printar os 19 poligonos
	jmp .fimfunction
	.ifB:
		mov al,14 ; cor
		mov cx,101
		call draw_B
	jmp .fimfunction
	.ifC:
		mov al,14 ; cor
		mov cx,103
		call draw_C
	jmp .fimfunction
	.ifD:
		mov al,14 ; cor
		mov cx,103
		call draw_D
	jmp .fimfunction
	.ifE:
		mov al,14 ; cor
		mov cx,128
		call draw_E
	jmp .fimfunction
	.ifF:
		mov al,15
		mov cx,115
		call draw_F
	jmp .fimfunction
	.ifG:
		mov al,15
		mov cx,102
		call draw_G
	jmp .fimfunction
	.ifH:
		mov al,9
		mov cx,115
		call draw_H
	jmp .fimfunction
	.ifI:
		mov al,9
		mov cx,115
		call draw_I
	jmp .fimfunction
	
	.fimfunction:
	ret

apague_bloco:
	
	cmp ax,0
	je .ifA
	cmp ax,1
	je .ifB
	cmp ax,2
	je .ifC
	cmp ax,3
	je .ifD
	cmp ax,4 ; condicionais
	je .ifE
	cmp ax,5
	je .ifF
	cmp ax,6
	je .ifG
	cmp ax,7
	je .ifH
	cmp ax,8
	je .ifI
	
	;:::::::::::::::::::::::
	.ifA:
		mov cx,103 ;seta posicao
		mov al,0 ;seta cor
		call draw_A    ; para printar os 19 poligonos
	jmp .fimfunction
	.ifB:
		mov al,0 ; cor
		mov cx,101
		call draw_B
	jmp .fimfunction
	.ifC:
		mov al,0 ; cor
		mov cx,103
		call draw_C
	jmp .fimfunction
	.ifD:
		mov al,0 ; cor
		mov cx,103
		call draw_D
	jmp .fimfunction
	.ifE:
		mov al,0 ; cor
		mov cx,128
		call draw_E
	jmp .fimfunction
	.ifF:
		mov al,0
		mov cx,115
		call draw_F
	jmp .fimfunction
	.ifG:
		mov al,0
		mov cx,102
		call draw_G
	jmp .fimfunction
	.ifH:
		mov al,0
		mov cx,115
		call draw_H
	jmp .fimfunction
	.ifI:
		mov al,0
		mov cx,115
		call draw_I
	jmp .fimfunction
	
	
	.fimfunction:
	ret

down:




	ret

while: ; loop que rodara o jogo

	call rand ; primeira peça do jogo
	push ax
	.run:
		 
		 call clear_window ; janelinha esquerda
		 call rand ; peca aleatoria
		 mov ah,0
		 pop bx
		 push ax
		 push bx ; vai que, ne?
		 call flip_window ; atualiza
		 pop bx
		 mov ax,bx
		 push ax ; precaucao
		 call set_initial ; posicao inicial em cx
		 pop ax
		 push cx
		 push ax
		 call verify ; verifica se mais uma peca pode entrar em jogo
		 cmp bl,0
		 je .gameover
		 pop ax
		 pop cx
		 push ax
		 push cx
		 call animation ;printa primeiro bloquinho
		 pop cx
		 pop ax
		 ;call down
		 
		 jmp .run
	.gameover:
	ret
	
start_game:

	.continue:
	call reset ; reset data
	call print_data
	call while
	.n_continue:
	ret
	
main:

	xor ax,ax
	mov ds,ax
	mov es,ax
	
	call _init
	call draw_background
	call start_game ;onde eu choro e minha mae nao ve
	
end:
	