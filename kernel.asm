org 0x8600
jmp 0x0000:main

data:
;strings
score db ' SCORE ',13
pontos db ' 02040 ',13
bilau db '            ',13
level db ' LEVEL ', 13
nivel db '   6   ',13
; mapa do jogo
map db '0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000',13


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
	
_init:

	mov ah,4fh
	mov al,02h
	mov bx,10h
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
	
	mov ch,0
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
	
	mov ch,0 ; zera o high
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
	mov cl,19
	div cl
	mov al,ah
	mov ah,0
	; resposta em al
	ret
	
clear_window:

	mov dh,2
	.for5:   ; printa telinha escura da direita
		inc dh
		cmp dh,9
		je .fimfor5
		mov dl,66
		mov si,bilau
		call prints
		jmp .for5
	.fimfor5:

	ret
	
flip_window:

	cmp al,0
	je .ifA
	cmp al,1
	je .ifB
	cmp al,2
	je .ifC
	cmp al,3
	je .ifD
	cmp al,4 ; condicionais
	je .ifE
	cmp al,5
	je .ifF
	cmp al,6
	je .ifG
	cmp al,7
	je .ifH
	cmp al,8
	je .ifI
	cmp al,9
	je .ifJ
	cmp al,10
	je .ifK
	cmp al,11
	je .ifL
	cmp al,12
	je .ifM
	cmp al,13
	je .ifN
	cmp al,14
	je .ifO
	cmp al,15
	je .ifP
	cmp al,16
	je .ifQ
	cmp al,17
	je .ifR
	cmp al,18
	je .ifS
	
	;:::::::::::::::::::::::
	.ifA:
		call draw_A    ; para printar os 19 poligonos
	jmp .fimfunction
	.ifB:
		call draw_B
	jmp .fimfunction
	.ifC:
		call draw_C
	jmp .fimfunction
	.ifD:
		call draw_D
	jmp .fimfunction
	.ifE:
		call draw_E
	jmp .fimfunction
	.ifF:
		call draw_F
	jmp .fimfunction
	.ifG:
		call draw_G
	jmp .fimfunction
	.ifH:
		call draw_H
	jmp .fimfunction
	.ifI:
		call draw_I
	jmp .fimfunction
	.ifJ:
		call draw_J
	jmp .fimfunction
	.ifK:
		call draw_K
	jmp .fimfunction
	.ifL:
		call draw_L
	jmp .fimfunction
	.ifM:
		call draw_M
	jmp .fimfunction
	.ifN:
		call draw_N
	jmp .fimfunction
	.ifO:
		call draw_O
	jmp .fimfunction
	.ifP:
		call draw_P
	jmp .fimfunction
	.ifQ:
		call draw_Q
	jmp .fimfunction
	.ifR:
		call draw_R
	jmp .fimfunction
	.ifS:
		call draw_S
	
	.fimfunction:
	ret
	
while: ; loop que rodara o jogo

	call rand ; primeira peça do jogo
	push ax
	.run:
		 pop bx
		 call clear_window ; janelinha esquerda
		 call rand ; peca aleatoria
		 push ax
		 push bx
		 call flip_window ; atualiza
		 ;pop bx
		 ;call down ; desce nova peca
		 
	.gameover
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
