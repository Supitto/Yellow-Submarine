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
	mov edx, OFFSET sup_mapa
	call WriteString
	mov edx, OFFSET lado_mapa
	mov ecx, 30
L:
	call WriteString
	loop L
	mov edx, OFFSET sup_mapa
	call WriteString
	popad
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