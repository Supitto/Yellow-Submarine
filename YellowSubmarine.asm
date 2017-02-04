INCLUDE Irvine32.inc

desenhaSubmarino PROTO, xy:WORD
apagaSubmarino PROTO, xy:WORD

.data
	NUMERO_DE_OBSTACULOS = 100
	BEATLES_RESGATADOS WORD ?
	char_mapa BYTE '#'
	vetorDeObstaculos WORD NUMERO_DE_OBSTACULOS DUP(?)
	vetorDeBeatles WORD 4 DUP(?)

	cabeloPaul BYTE "//||\\",0Dh,0Ah,0
	olhoPaul BYTE	"` @ @\",0Dh,0Ah,0
	narizPaul BYTE	"   >  ",0Dh,0Ah,0
	bocaPaul BYTE	"   -  ",0Dh,0Ah,0
	nomePaul BYTE   " Paul ",0Dh,0Ah,0

	cabeloJohn BYTE "////\\",0Dh,0Ah,0
	olhoJohn BYTE	"/`O-O'",0Dh,0Ah,0
	narizJohn BYTE	"   ]  ",0Dh,0Ah,0
	bocaJohn BYTE	"   -  ",0Dh,0Ah,0
	nomeJohn BYTE   " John ",0Dh,0Ah,0

	cabeloGeorge BYTE "//\|\\ ",0Dh,0Ah,0
	olhoGeorge BYTE	  "//o o//",0Dh,0Ah,0
	narizGeorge BYTE  " ) | ( ",0Dh,0Ah,0
	bocaGeorge BYTE   "   -   ",0Dh,0Ah,0
	nomeGeorge BYTE   "George ",0Dh,0Ah,0

	cabeloRingo BYTE "///||\",0Dh,0Ah,0
	olhoRingo BYTE	 "  a a ",0Dh,0Ah,0
	narizRingo BYTE  "   _) ",0Dh,0Ah,0
	bocaRingo BYTE   "   ~  ",0Dh,0Ah,0
	nomeRingo BYTE   "Ringo ",0Dh,0Ah,0

	
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
	mov eax, 100
	call Delay
	call colisao
	cmp ebx, 0
	je fim
	jmp L
	
fim:
	mov dl, 0
	mov dh, 38
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
	mov eax, lightGreen+(16*Blue)
	call SetTextColor
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
	loop L2					          ;// desenha a coluna mais � esquerda
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

	mov dl, 1
	mov dh, 1
	mov ecx, 29
	mov al, ' '
L6:
	push ecx
	mov dl, 1
	mov ecx, 78
L5:
	call Gotoxy
	push eax						   ;// Coloca eax na pilha
	mov eax, black+(16*Blue)		  
	call setTextColor
	pop eax							   ;// Tira eax da Pilha
	call WriteChar                     ;//Desenha
	add dl, 1
	loop L5
	pop ecx
	add dh, 1
	loop L6
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
	mov eax, yellow+(16*Blue)		   ;// Seta amarelo como Cor do Submarino
	call setTextColor
	pop eax							   ;// Tira eax da Pilha
	call WriteChar                     ;//Desenha o submarino
	popad							   ;//Retorna os registradores da pilha
	ret								   ;//Fim da função
desenhaSubmarino ENDP

apagaSubmarino PROC, xy:WORD
.code
	pushad                             ;//Joga os registradores na pilha
	mov al, ' ' 
	push eax
	mov eax, black + (16*Blue)
	call SetTextColor
	pop eax								;//Guarda o S no al para ser desenhado
	mov dx, xy                         ;//Move o x para dh e o y par dl
	call Gotoxy						   ;//Move o cursor
	call WriteChar                   
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
	mov eax, 0

L2:
	.IF bx == [esi + eax] && eax == 4
		add BEATLES_RESGATADOS, 1
		call desenhaPaul
	.ENDIF

	.IF bx == [esi + eax] && eax == 2
		add BEATLES_RESGATADOS, 1
		call desenhaJohn
	.ENDIF

	.IF bx == [esi + eax] && eax == 6
		add BEATLES_RESGATADOS, 1
		call desenhaGeorge
	.ENDIF

	.IF bx == [esi + eax] && eax == 0
		add BEATLES_RESGATADOS, 1
		call desenhaRingo
	.ENDIF

	.IF BEATLES_RESGATADOS == 4
		jmp deuRuim
	.ENDIF
	add eax, 2
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
	mov eax, 008+(16*Blue)
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
		mov eax, lightMagenta+(16*Blue)
		call SetTextColor
		pop eax
	.ENDIF

	.IF esi == 2
		push eax
		mov eax, lightGreen+(16*Blue)
		call SetTextColor
		pop eax
	.ENDIF

	.IF esi == 4
		push eax
		mov eax, white+(16*Blue)
		call SetTextColor
		pop eax
	.ENDIF

	.IF esi == 6
		push eax
		mov eax, lightRed+(16*Blue)
		call SetTextColor
		pop eax
	.ENDIF
	call WriteChar
	add esi, 2
	loop desenha
	popad
ret
desenhaVetorBeatles ENDP

desenhaPaul PROC
.code
	pushad
	mov ecx, 5 
	mov dl, 0
	mov dh, 32
	call Gotoxy
	push eax
	mov eax, white+(16 * lightBlue)
	call SetTextColor
	pop eax

L1:
	.IF ecx == 5
		mov edx, OFFSET cabeloPaul
		call WriteString
	.ENDIF

	.IF ecx == 4
		mov edx, OFFSET olhoPaul
		call WriteString
	.ENDIF

	.IF ecx == 3
		mov edx, OFFSET narizPaul
		call WriteString
	.ENDIF

	.IF ecx == 2
		mov edx, OFFSET bocaPaul
		call WriteString
	.ENDIF

	.IF ecx == 1
		mov edx, OFFSET nomePaul
		call WriteString
	.ENDIF

	loop L1
	popad
ret
desenhaPaul ENDP

desenhaJohn PROC
.code
	pushad
	mov ecx, 5 
	push eax
	mov eax, white+(16 * lightGreen)
	call SetTextColor
	pop eax
L1:
	.IF ecx == 5
		mov dl, 23
		mov dh, 32
		call Gotoxy
		mov edx, OFFSET cabeloJohn
		call WriteString
	.ENDIF

	.IF ecx == 4
		mov dl, 23
		mov dh, 33
		call Gotoxy
		mov edx, OFFSET olhoJohn
		call WriteString
	.ENDIF

	.IF ecx == 3
		mov dl, 23
		mov dh, 34
		call Gotoxy
		mov edx, OFFSET narizJohn
		call WriteString
	.ENDIF

	.IF ecx == 2
		mov dl, 23
		mov dh, 35
		call Gotoxy
		mov edx, OFFSET bocaJohn
		call WriteString
	.ENDIF

	.IF ecx == 1
		mov dl, 23
		mov dh, 36
		call Gotoxy
		mov edx, OFFSET nomeJohn
		call WriteString
	.ENDIF

	loop L1
	popad
ret
desenhaJohn ENDP

desenhaGeorge PROC
.code
	pushad
	mov ecx, 5 
	push eax
	mov eax, white+(16 * lightRed)
	call SetTextColor
	pop eax
L1:
	.IF ecx == 5
		mov dl, 47
		mov dh, 32
		call Gotoxy
		mov edx, OFFSET cabeloGeorge
		call WriteString
	.ENDIF

	.IF ecx == 4
		mov dl, 47
		mov dh, 33
		call Gotoxy
		mov edx, OFFSET olhoGeorge
		call WriteString
	.ENDIF

	.IF ecx == 3
		mov dl, 47
		mov dh, 34
		call Gotoxy
		mov edx, OFFSET narizGeorge
		call WriteString
	.ENDIF

	.IF ecx == 2
		mov dl, 47
		mov dh, 35
		call Gotoxy
		mov edx, OFFSET bocaGeorge
		call WriteString
	.ENDIF

	.IF ecx == 1
		mov dl, 47
		mov dh, 36
		call Gotoxy
		mov edx, OFFSET nomeGeorge
		call WriteString
	.ENDIF

	loop L1
	popad
ret
desenhaGeorge ENDP

desenhaRingo PROC
.code
	pushad
	mov ecx, 5 
	push eax
	mov eax, white+(16 * lightMagenta)
	call SetTextColor
	pop eax
L1:
	.IF ecx == 5
		mov dl, 71
		mov dh, 32
		call Gotoxy
		mov edx, OFFSET cabeloRingo
		call WriteString
	.ENDIF

	.IF ecx == 4
		mov dl, 71
		mov dh, 33
		call Gotoxy
		mov edx, OFFSET olhoRingo
		call WriteString
	.ENDIF

	.IF ecx == 3
		mov dl, 71
		mov dh, 34
		call Gotoxy
		mov edx, OFFSET narizRingo
		call WriteString
	.ENDIF

	.IF ecx == 2
		mov dl, 71
		mov dh, 35
		call Gotoxy
		mov edx, OFFSET bocaRingo
		call WriteString
	.ENDIF

	.IF ecx == 1
		mov dl, 71
		mov dh, 36
		call Gotoxy
		mov edx, OFFSET nomeRingo
		call WriteString
	.ENDIF

	loop L1
	popad
ret
desenhaRingo ENDP

END main


