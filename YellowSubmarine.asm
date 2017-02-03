INCLUDE Irvine32.inc

desenhaSubmarino PROTO, xy:WORD
apagaSubmarino PROTO, xy:WORD

.data
	NUMERO_DE_OBSTACULOS = 200
	BEATLES_RESGATADOS WORD ?
	char_mapa BYTE '#'
	vetorDeObstaculos WORD NUMERO_DE_OBSTACULOS DUP(?)
	vetorDeBeatles WORD 4 DUP(?)
	
.code
main PROC
	mov ecx, 0
	mov esi, 0
	mov BEATLES_RESGATADOS, 0
	call Clrscr						   ;// limpa a tela para inicial o jogo 
	mov cx, 0000000100000001b		   ;// posicao inicial do Submarino com x = 1 e y = 1
	call desenhamapa
	call preencheVetor
	call desenhaVetorObstaculos
	call preencheVetorBeatles
	call desenhaVetorBeatles
	push esi
L:
	invoke apagaSubmarino, cx
	call ReadKey
	pop esi
	call leTecla
	.IF esi == 1
		sub cl, 1
	.ENDIF

	.IF esi == 2
		add cl, 1
	.ENDIF

	.IF esi == 3
		sub ch, 1
	.ENDIF

	.IF esi == 4
		add ch, 1
	.ENDIF
	push esi

	invoke desenhaSubmarino, cx
	mov eax, 200
	call Delay
	call colisao
	cmp ebx, 0
	je fim
	jmp L
	
fim:
	mov dl, 0
	mov dh, 32
	call Gotoxy
	mov eax, white + (16*black)
	call SetTextColor
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
	mov al, 244                        ;//Guarda o S no al para ser desenhado
	mov dx, xy                         ;//Move o x para dh e o y par dl
	call Gotoxy						   ;//Move o cursor
	push eax						   ;// Coloca eax na pilha
	mov eax, yellow+(16*black)		   ;// Seta amarelo como Cor do Submarino
	call setTextColor
	pop eax							   ;// Tira eax da Pilha
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
	.IF ax == 4B00h
		mov esi, 1
	.ENDIF

	.IF ax == 4D00h
		mov esi, 2
	.ENDIF

	.IF ax == 4800h
		mov esi, 3
	.ENDIF

	.IF ax == 5000h
		mov esi, 4
	.ENDIF
ret
leTecla ENDP	

colisao PROC
.code
	push ecx
	.if ch <=0 || ch >= 30 || cl <=0 || cl >= 79 
		jmp deuRuim
	.endif
	mov bx, cx
	mov ecx, NUMERO_DE_OBSTACULOS
	mov esi, OFFSET vetorDeObstaculos
L:
	.IF bx == [esi] 
		jmp deuRuim
	.endif
	add esi, 2
	loop L
	
	mov ecx, 4
	mov esi, OFFSET vetorDeBeatles

L2:
	.IF bx == [esi]
		add BEATLES_RESGATADOS, 1
	.ENDIF

	.IF BEATLES_RESGATADOS == 4
		jmp deuRuim
	.ENDIF
	add esi, 2
	loop L2
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
	mov ecx, NUMERO_DE_OBSTACULOS
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
	add esi, 2
	loop EncheVetor
	popad
ret
preencheVetor ENDP

desenhaVetorObstaculos PROC
.code 
	pushad
	mov ecx, NUMERO_DE_OBSTACULOS
	mov esi, 0
	mov ebx, OFFSET vetorDeObstaculos
desenha:
	mov dx, [ebx + esi]
	call GoToXY
	mov al, '+'
	push eax
	mov eax, gray+(black * 16)
	call SetTextColor
	pop eax
	call WriteChar
	add esi, 2
	loop desenha
	popad
ret
desenhaVetorObstaculos ENDP

preencheVetorBeatles PROC
.code
	pushad
	mov eax, 0 
	mov ecx, 4
	mov esi, OFFSET vetorDeBeatles
EncheVetor:
	mov eax, 29
	call RandomRange
	inc eax
	mov bh, al
	mov eax, 78
	call RandomRange
	inc eax
	mov bl, al
	
	push ecx
VoltaTudo:	
	mov ecx, NUMERO_DE_OBSTACULOS
	mov edx, OFFSET vetorDeObstaculos
	mov eax, ecx
ComparaComObstaculos:
	.IF bx == [edx]
		mov eax, 29
		call RandomRange
		inc eax
		mov bh, al
		mov eax, 78
		call RandomRange
		inc eax
		mov bl, al
		jmp VoltaTudo
	.ELSE
		add edx, 2
	.ENDIF
	loop ComparaComObstaculos
	pop ecx
	mov [esi], bx
	add esi, 2
	loop EncheVetor
	popad
	ret								   
preencheVetorBeatles ENDP

desenhaVetorBeatles PROC
.code 
	pushad
	mov ecx, 4
	mov esi, 0
	mov ebx, OFFSET vetorDeBeatles
desenha:
	mov dx, [ebx + esi]
	call GoToXY
	mov al, 01
	.IF esi == 0
		push eax
		mov eax, lightMagenta+(black * 16)
		call SetTextColor
		pop eax
	.ENDIF

	.IF esi == 2
		push eax
		mov eax, lightGreen+(black * 16)
		call SetTextColor
		pop eax
	.ENDIF

	.IF esi == 4
		push eax
		mov eax, white+(black * 16)
		call SetTextColor
		pop eax
	.ENDIF

	.IF esi == 6
		push eax
		mov eax, lightRed+(black * 16)
		call SetTextColor
		pop eax
	.ENDIF
	call WriteChar
	add esi, 2
	loop desenha
	popad
ret
desenhaVetorBeatles ENDP

END main


