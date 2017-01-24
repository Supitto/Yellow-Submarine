INCLUDE Irvine32.inc

desenhaSubmarino PROTO, xy:WORD
apagaSubmarino PROTO, xy:WORD

.data
	char_mapa byte '*'

.code
main PROC
	call desenhamapa
	invoke desenhaSubmarino, 0000000100000001b
	mov dl, 0
	mov dh, 32
	call Gotoxy
	call waitMsg
	exit
main ENDP

desenhaMapa PROC
.code
	pushad
	mov dl, 0						   ;// coluna inicial para desenhar a linha de cima do tabuleiro
	mov dh, 0						   ;// linha inicial para desenhar a linha de cima do tabuleiro
	mov ecx, 80						   ;// numero de linhas

									   ;// desenha linha de cima 
L:
	call Gotoxy						   ;// vai apra a posi��o dh, dl
	push edx						   ;// manda para a pilha o valor de dl e dh
	mov edx, OFFSET char_mapa		   ;// prepara para desenhar *
	call WriteString                   ;// escreve *
	pop edx                            ;// volta para a pilha valor de dl e dh
	inc dl                             ;// incrementa valor da coluna
	loop L

	                                   ;// desenha a coluna mais � direita 
	mov dl, 0
	mov dh, 1
	mov ecx, 30
L2:
	call Gotoxy
	push edx
	mov edx, OFFSET char_mapa
	call WriteString
	pop edx
	inc dh                             ;// incrementa valor da linha
	loop L2

			                           ;// desenha a coluna mais � esquerda
	mov dl, 79  					   ;// posicao da ultima * da linha de cima
	mov dh, 0
	mov ecx, 30
L3:
	call Gotoxy
	push edx
	mov edx, OFFSET char_mapa
	call WriteString
	pop edx
	inc dh					           ;// incrementa valor da linha
	loop L3

	mov dl, 1                          ;// desenha linha de baixo
	mov dh, 30
	mov ecx, 79	
L4:								
	call Gotoxy
	push edx
	mov edx, OFFSET char_mapa
	call WriteString
	pop edx
	inc dl
	loop L4

	popad
	call crlf
	ret
desenhaMapa ENDP

desenhaSubmarino PROC, xy:WORD
.code
	pushad                             ;//Joga os registradores na pilha
	mov al, 'S'                        ;//Guarda o S no al para ser desenhado
	mov dx, xy                         ;//Move o x para dh e o y par dl
	call Gotoxy						   ;//Move o cursor
	call WriteChar                     ;//Desenha o submarino
	popad							   ;//Retorna os registradores da pilha
	ret								   ;//Fim da função
desenhaSubmarino ENDP

apagaSubmarino PROC, xy : WORD
.code
	pushad                             ;//Joga os registradores na pilha
	mov al, ' '                        ;//Guarda o S no al para ser desenhado
	mov dx, xy                         ;//Move o x para dh e o y par dl
	call Gotoxy						   ;//Move o cursor
	call WriteChar                     ;//Desenha o submarino
	popad							   ;//Retorna os registradores da pilha
	ret								   ;//Fim da função
apagaSubmarino ENDP

END main