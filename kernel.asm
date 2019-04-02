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
map db '0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000',13


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

	;; incompleto
	
	
	
	

	ret
	
print_mapa: ;printar o tabuleiro de jogo

	mov si,map
	mov cl,0
	dec cl
	.for:
		inc cl
		cmp cl,161
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
	
start_game:

	
	call reset ; reset data
	call print_data
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	ret
	
main:

	xor ax,ax
	mov ds,ax
	mov es,ax
	
	call _init
	call draw_background
	call start_game ;onde eu choro e minha mae nao ve


end:
