INCLUDE Irvine32.inc

desenhasubmarino PROTO, xy : BYTE      ;Prototipo da função desenha submarino
apagasubmarino PROTO, xy : BYTE        ;Prototipo da função apaga submarino


.code

main PROC
	call desenhamapa
	call waitMsg
	exit
main ENDP

desenhamapa PROC
.code
	pushad
	mov dl, 0						   ;// coluna inicial para desenhar a linha de cima do tabuleiro
	mov dh, 0						   ;// linha inicial para desenhar a linha de cima do tabuleiro
	mov ecx, 30						   ;// numero de linhas

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
	popad
	call crlf
	ret
desenhamapa ENDP


desenhasubmarino PROC, xy:BYTE
.code
	pushad                             ;//Joga os registradores na pilha
	mov al, 'S'                        ;//Guarda o S no al para ser desenhado
	mov dx, xy                         ;//Move o x para dh e o y par dl
	call Gotoxy						   ;//Move o cursor
	call WriteChar                     ;//Desenha o submarino
	popad							   ;//Retorna os registradores da pilha
	ret								   ;//Fim da função
desenhasubmarino ENDP

apagasubmarino PROC, xy : BYTE
.code
	pushad                             ;//Joga os registradores na pilha
	mov al, ' '                        ;//Guarda o S no al para ser desenhado
	mov dx, xy                         ;//Move o x para dh e o y par dl
	call Gotoxy						   ;//Move o cursor
	call WriteChar                     ;//Desenha o submarino
	popad							   ;//Retorna os registradores da pilha
	ret								   ;//Fim da função
apagasubmarino ENDP


END main