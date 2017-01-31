INCLUDE Irvine32.inc

desenhaSubmarino PROTO, xy:WORD
apagaSubmarino PROTO, xy:WORD

.data
	char_mapa BYTE '#'
	vetorDeObstaculos WORD 200 DUP(?)

.code
main PROC
	mov ecx, 0
	call Clrscr						   ;// limpa a tela para inicial o jogo 
	mov cx, 0000000100000001b		   ;// posicao inicial do Submarino com x = 1 e y = 1
	call desenhamapa
	call preencheVetor
	call desenhaVetorObstaculos
L:
	invoke apagaSubmarino, cx
	call ReadKey
	call leTecla
	invoke desenhaSubmarino, cx
	mov eax, 50
	call Delay
	call colisao
	cmp ebx, 0
	je fim
	jmp L
	mov dl, 0
	mov dh, 32
	call Gotoxy

principal:
	invoke apagaSubmarino, cx
	call colisao
	
	invoke desenhaSubmarino, cx
	mov eax, 500
	call Delay
	cmp esi,4
	jl principal
fim:

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
	call Gotoxy						   ;// vai apra a posicao dh, dl
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

apagaSubmarino PROC, xy:WORD
.code
	pushad                             ;//Joga os registradores na pilha
	mov al, ' '                        ;//Guarda o S no al para ser desenhado
	mov dx, xy                         ;//Move o x para dh e o y par dl
	call Gotoxy						   ;//Move o cursor
	call WriteChar                     ;//Desenha o submarino
	popad							   ;//Retorna os registradores da pilha
	ret								   ;//Fim da função
apagaSubmarino ENDP


leTecla PROC
.code
	cmp ax, 4B00h
	je Esq

	cmp ax, 4D00h
	je Dir

	cmp ax, 4800h
	je Up

	cmp ax, 5000h
	je Baixo

	jmp Fim

Dir:
	;//call andandoDir
	add cl, 1
	jmp Fim

Esq:
	;//call andadoEsq
	sub cl, 1
	jmp Fim

Up:
	;//call andandoUp
	sub ch, 1
	jmp Fim

Baixo:
	;//call andandoBaixo
	add ch, 1
	jmp Fim

Fim:
	ret
leTecla ENDP	

colisao PROC
.code
	push ecx
	.if ch <=0 || ch >= 30 || cl <=0 || cl >= 79 
		jmp deuRuim
	.endif
	mov bx, cx
	mov ecx, 200
	mov esi, OFFSET vetorDeObstaculos
L:
	.IF bx == [esi] 
		jmp deuRuim
	.endif
	add esi, 4
	loop L
	jmp fim
deuRuim: 
	mov ebx, 0	
fim:	
	pop ecx
	ret
colisao ENDP

preencheVetor PROC
.code 
	pushad
	mov eax, 0 ;// seta eax como 0
	mov ecx, 200
	mov esi, OFFSET vetorDeObstaculos
EncheVetor:
	mov eax, 29
	call RandomRange
	inc eax
	mov bh, al
	mov eax, 78
	call RandomRange
	inc eax
	mov bl, al
	mov [esi], bx
	add esi, 4
	loop EncheVetor
	popad
ret
preencheVetor ENDP

desenhaVetorObstaculos PROC
.code 
	pushad
	mov ecx, 200
	mov esi, 0
	mov ebx, OFFSET vetorDeObstaculos
desenha:
	mov dx, [ebx + esi]
	call GoToXY
	mov al, '^'
	call WriteChar
	add esi, 4
	loop desenha
	popad
ret
desenhaVetorObstaculos ENDP

END main


