INCLUDE Irvine32.inc

desenhaSubmarino PROTO, xy:WORD
apagaSubmarino PROTO, xy:WORD

.data
	ajuda1 byte "#         Ajuda :                                                              #",0
	ajuda2 byte "#                Utilize as setas do teclado para mover o submarino            #",0
	ajuda3 byte "#                Se voce tocar na borda (#) ou em um obstaculo (+) voce morre  #",0
	ajuda4 byte "#                Se voce resgatar os 4 Beatles voce ganha                      #",0
	topo byte "################################################################################",0
	linha_branca byte "#                                                                              #",0
	linha0 byte "#      __ __     _ _              _____     _                 _                #",0
	linha1 byte "#     |  |  |___| | |___ _ _ _   |   __|_ _| |_ _____ ___ ___|_|___ ___        #",0
	linha2 byte "#     |_   _| -_| | | . | | | |  |__   | | | . |     | .'|  _| |   | -_|       #",0
	linha3 byte "#       |_| |___|_|_|___|_____|  |_____|___|___|_|_|_|__,|_| |_|_|_|___|       #",0
	linha4 byte "#                                             __                               #",0
	linha5 byte "#                                            $F'?                              #",0
	linha6 byte "#                                        e$$.?b='                              #",0
	linha7 byte "#                                       '?$$L $ cc                             #",0
	linha8 byte "#                                     ,dc.`$P $ $'                             #",0
	linha9 byte "#                                     `'' ,,,;,,,,,,                           #",0
	linha10 byte "#                                        '''''''''''                           #",0
	linha11 byte "#                                       dMMMMMMMMMMP'.                         #",0
	linha12 byte "#                                       MF .---. ?M d$                         #",0
	linha13 byte "# cd$$$$$$$c,                          .M | ::: | M $$$                        #",0
	linha14 byte "# n.`$$$$$$$$h,.                       JM | ``` | ).`'''''''''.MMn.            #",0
	linha15 byte "# MM $$$$$$$$$$$$cc:::::::::$$'|'MMMMMMMMMMMMMMMMMMP==============??''''''=:::.#",0
	linha16 byte "# MM $$$$$$$$$$$$$$c;;;;;;;c$$ | 'MMMMMMMMMMMMMMM' _,--------------````,hcccc$ #",0
	linha17 byte "# PP $$$$$$$$$$$$$$$$$$$$$$$$P'.::::::::::::::::::' +--------------------+$$P' #",0
	linha18 byte "# ==?$$?????$$$$$$$$$$$$$$$'.:'`.,c' '$' '$' '$'    | Pressione :        |$'   #",0
	linha19 byte "#         ,,_)$$$$$$$$$$$$F.:'.d$$$, ,$, ,$, ,$, ,$$|                    |'    #",0
	linha20 byte "#         T''_?$$$$$$$$$$$':: $$$$$$$$$$$$$$$$$$$$$$| 1 - Para jogar     |     #",0
	linha21 byte "#         `''      `'`       d$$$$$$$$$$$F''''''''''| 2 - Se quer ajuda  |     #",0
	linha22 byte "#                                `''''''' ``````````| 3 - Para sair      |     #",0
	linha23 byte "#                                                   +--------------------+     #",0
	NUMERO_DE_OBSTACULOS = 100
	BEATLES_RESGATADOS WORD ?
	char_mapa BYTE '#'
	vetorDeObstaculos WORD NUMERO_DE_OBSTACULOS DUP(?)
	vetorDeBeatles WORD 4 DUP(?)
	perdeu1 byte "#                  _|      _|    _|_|      _|_|_|    _|_|                      #",0
	perdeu2 byte "#                  _|      _|  _|    _|  _|        _|    _|                    #",0
	perdeu3 byte "#                  _|      _|  _|    _|  _|        _|_|_|_|                    #",0
	perdeu4 byte "#                    _|  _|    _|    _|  _|        _|                          #",0
	perdeu5 byte "#                      _|        _|_|      _|_|_|    _|_|_                     #",0
	perdeu6 byte "#                                              _|                              #",0
	perdeu7 byte "#       _|_|_|       _|_|     _|  _|_|     _|_|_|     _|_|     _|    _|        #",0
	perdeu8 byte "#       _|    _|   _|    _|   _|_|       _|    _|   _|    _|   _|    _|        #",0
	perdeu9 byte "#       _|    _|   _|_|_|_|   _|_|       _|    _|   _|_|_|_|   _|    _|        #",0
	perdeu10 byte "#       _|    _|   _|         _|_|       _|    _|   _|         _|    _|        #",0
	perdeu11 byte "#       _|    _|   _|         _|         _|    _|   _|         _|    _|        #",0
	perdeu12 byte "#       _|_|_|       _|_|_|   _|           _|_|_|     _|_|_|     _|_|_|        #",0
	perdeu13 byte "#       _|                                                                     #",0

	vitoria1 byte "#                                   Parabens                                   #",0
	vitoria2 byte "#                   .::     .::   .::       .:::   .::                         #",0
	vitoria3 byte "#                    .::   .::  .::  .::  .::    .:   .::                      #",0
	vitoria4 byte "#                     .:: .::  .::    .::.::    .::::: .::                     #",0
	vitoria5 byte "#                      .:.::    .::  .::  .::   .:                             #",0
	vitoria6 byte "#                       .::       .::       .:::  .::::                        #",0
	vitoria7 byte  "#    .::         .::                                                 .::.::    #",0
	vitoria8 byte  "#     .::       .::                                                  .::.::    #",0
	vitoria9 byte  "#      .::     .::     .::    .:: .::     .:::   .::    .::  .::     .::.::    #",0
	vitoria10 byte "#       .::   .::    .:   .::  .::  .:: .::    .:   .:: .::  .::     .: .:     #",0
	vitoria11 byte "#        .:: .::    .::::: .:: .::  .::.::    .:::::.:: .::  .::     .: .:     #",0
	vitoria12 byte "#         .::::     .:         .::  .:: .::   .:        .::  .::               #",0
	vitoria13 byte "#          .::        .::::   .:::  .::   .:::  .::::     .::.::     .::.::    #",0

	cabeloPaul BYTE "//||\\",0
	olhoPaul BYTE	"` @ @\",0
	narizPaul BYTE	"   >  ",0
	bocaPaul BYTE	"   -  ",0
	nomePaul BYTE   " Paul ",0

	cabeloJohn BYTE "////\\",0
	olhoJohn BYTE	"/`O-O'",0
	narizJohn BYTE	"   ]  ",0
	bocaJohn BYTE	"   -  ",0
	nomeJohn BYTE   " John ",0

	cabeloGeorge BYTE "//\|\\ ",0
	olhoGeorge BYTE	  "//o o//",0
	narizGeorge BYTE  " ) | ( ",0
	bocaGeorge BYTE   "   -   ",0
	nomeGeorge BYTE   "George ",0

	cabeloRingo BYTE "///||\",0
	olhoRingo BYTE	 "  a a ",0
	narizRingo BYTE  "   _) ",0
	bocaRingo BYTE   "   ~  ",0
	nomeRingo BYTE   "Ringo ",0

	
.code
main PROC
Inicio:
	mov eax, white+(black*16)
	call SetTextColor
	mov ebx, 0 
	mov ecx, 0
	mov esi, 0
	mov eax, 0
	mov edx, 0
	mov esi, 0
	mov BEATLES_RESGATADOS, 0
	call Clrscr						   ;// limpa a tela para inicial o jogo 
	call desenhaIni
	call Clrscr
	.if ebx == 0
		jmp fim
	.endif
	.if ebx == 1
		call ajuda
		jmp Inicio
	.endif
	mov cx, 0000000100000001b		   ;// posicao inicial do Submarino com x = 1 e y = 1
	;push ebx
	call desenhamapa
	call Randomize
	call preencheVetor
	call Randomize
	call preencheVetorBeatles
	call desenhaVetorBeatles
	call desenhaVetorObstaculos
	;pop ebx
	push esi
L:
	
	.if ebx == 0
		jmp fim
	.endif
        .if ebx == 2
		call Clrscr
		call vitoria
		jmp Inicio 
	.endif
	.if ebx == 3
		call Clrscr
		call derrota
		jmp Inicio
	.endif
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
	mov eax, 75
	call Delay
	call colisao
	jmp L
	
fim:
	mov eax, white + (16*black)
	call SetTextColor
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
	mov edx, OFFSET topo
	call WriteString
	mov edx, OFFSET linha_branca
	call WriteString 
	call WriteString 
	call WriteString 
	call WriteString 
	call WriteString 
	call WriteString 
	call WriteString 
	call WriteString 
	call WriteString 
	call WriteString 
	call WriteString 
	call WriteString
	call WriteString 
	call WriteString 
	call WriteString
	call WriteString 
	call WriteString 
	call WriteString 
	call WriteString 
	call WriteString 
	call WriteString 
	call WriteString 
	call WriteString 
	call WriteString 
	call WriteString 
	call WriteString 
	call WriteString 
	call WriteString 
	call WriteString 
	call WriteString 
	mov edx, OFFSET topo
	call WriteString 
	popad
	call crlf
	ret
desenhaMapa ENDP

desenhaSubmarino PROC, xy:WORD
.code
	pushad                             ;//Joga os registradores na pilha
	mov dx, xy
	mov al, 244                        ;//Guarda o S no al para ser desenhado
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
	
	mov esi, OFFSET vetorDeBeatles
	mov eax, 0
	.IF bx == [esi]
		mov [esi], ax
		add BEATLES_RESGATADOS, 1
		call desenhaPaul
		jmp fim
	.ENDIF

	.IF bx == [esi + 2]
		mov [esi + 2], ax
		add BEATLES_RESGATADOS, 1
		call desenhaJohn
		jmp fim
	.ENDIF

	.IF bx == [esi + 4]
		mov [esi + 4], ax
		add BEATLES_RESGATADOS, 1
		call desenhaGeorge
		jmp fim
	.ENDIF

	.IF bx == [esi+6]
		mov [esi+6], ax 
		add BEATLES_RESGATADOS, 1
		call desenhaRingo
		jmp fim
	.ENDIF

	.IF BEATLES_RESGATADOS == 4
		jmp ganhoumiseravi
	.endif
	jmp fim

ganhouMiseravi:

	mov ebx, 2
	jmp fim
deuRuim: 
	mov ebx, 3	
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
	.if bx == 0000000100000001b
		jmp EncheVetor
	.endif
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
	mov ebx, OFFSET vetorDeBeatles
	mov al, 01
	push eax
	mov eax, lightMagenta+(16*Blue)
	call SetTextColor
	pop eax
	mov dx, [ebx]
	call GoToXY
	call WriteChar
	push eax
	mov eax, lightGreen+(16*Blue)
	call SetTextColor
	pop eax
	mov dx, [ebx+2]	
	call GoToXY
	call WriteChar	
	push eax
	mov eax, white+(16*Blue)
	call SetTextColor
	pop eax
	mov dx, [ebx+4]
	call GoToXY
	call WriteChar
	push eax
	mov eax, lightRed+(16*Blue)
	call SetTextColor
	pop eax
	mov dx, [ebx+6]
	call GoToXY
	call WriteChar
	popad
ret
desenhaVetorBeatles ENDP

desenhaPaul PROC
.code
	pushad
	call Gotoxy
	mov eax, white+(16 * lightBlue)
	call SetTextColor
	mov dl, 0
	mov dh, 32
	call Gotoxy
	mov edx, OFFSET cabeloPaul
	call WriteString
	mov dl, 0
	mov dh, 33
	call Gotoxy		
	mov edx, OFFSET olhoPaul
	call WriteString
	mov dl, 0
	mov dh, 34
	call Gotoxy
	mov edx, OFFSET narizPaul
	call WriteString
	mov dl, 0
	mov dh, 35
	call Gotoxy
	mov edx, OFFSET bocaPaul
	call WriteString
	mov dl, 0
	mov dh, 36
	call Gotoxy
	mov edx, OFFSET nomePaul
	call WriteString
	popad
ret
desenhaPaul ENDP

desenhaJohn PROC
.code
	pushad
	mov eax, white+(16 * lightGreen)
	call SetTextColor
	mov dl, 23
	mov dh, 32
	call Gotoxy
	mov edx, OFFSET cabeloJohn
	call WriteString
	mov dl, 23
	mov dh, 33
	call Gotoxy
	mov edx, OFFSET olhoJohn
	call WriteString
	mov dl, 23
	mov dh, 34
	call Gotoxy
	mov edx, OFFSET narizJohn
	call WriteString
	mov dl, 23
	mov dh, 35
	call Gotoxy
	mov edx, OFFSET bocaJohn
	call WriteString
	mov dl, 23
	mov dh, 36
	call Gotoxy
	mov edx, OFFSET nomeJohn
	call WriteString

	popad
ret
desenhaJohn ENDP

desenhaGeorge PROC
.code
	pushad
	mov eax, white+(16 * lightRed)
	call SetTextColor
	mov dl, 47
	mov dh, 32
	call Gotoxy
	mov edx, OFFSET cabeloGeorge
	call WriteString
	mov dl, 47
	mov dh, 33
	call Gotoxy
	mov edx, OFFSET olhoGeorge
	call WriteString
	mov dl, 47
	mov dh, 34
	call Gotoxy
	mov edx, OFFSET narizGeorge
	call WriteString
	mov dl, 47
	mov dh, 35
	call Gotoxy
	mov edx, OFFSET bocaGeorge
	call WriteString
	mov dl, 47
	mov dh, 36
	call Gotoxy
	mov edx, OFFSET nomeGeorge
	call WriteString
	popad
ret
desenhaGeorge ENDP

desenhaRingo PROC
.code
	pushad
	mov eax, white+(16 * lightMagenta)
	call SetTextColor
	mov dl, 71
	mov dh, 32
	call Gotoxy
	mov edx, OFFSET cabeloRingo
	call WriteString
	mov dl, 71
	mov dh, 33
	call Gotoxy
	mov edx, OFFSET olhoRingo
	call WriteString
	mov dl, 71
	mov dh, 34
	call Gotoxy
	mov edx, OFFSET narizRingo
	call WriteString
	mov dl, 71
	mov dh, 35
	call Gotoxy
	mov edx, OFFSET bocaRingo
	call WriteString
	mov dl, 71
	mov dh, 36
	call Gotoxy
	mov edx, OFFSET nomeRingo
	call WriteString
	popad
ret
desenhaRingo ENDP

desenhaIni PROC



.code
	push edx
	push eax	
	mov edx, OFFSET topo
	call WriteString
	mov edx, OFFSET linha_branca
	call WriteString
	mov edx, OFFSET linha_branca
	call WriteString
	mov edx, OFFSET linha_branca
	call WriteString
	mov edx, OFFSET linha0
	call WriteString
	mov edx, OFFSET linha1
	call WriteString
	mov edx, OFFSET linha2
	call WriteString
	mov edx, OFFSET linha3
	call WriteString
	mov edx, OFFSET linha4
	call WriteString
	mov edx, OFFSET linha5
	call WriteString
	mov edx, OFFSET linha6
	call WriteString
	mov edx, OFFSET linha7
	call WriteString
	mov edx, OFFSET linha8
	call WriteString
	mov edx, OFFSET linha9
	call WriteString
	mov edx, OFFSET linha10
	call WriteString
	mov edx, OFFSET linha11
	call WriteString
	mov edx, OFFSET linha12
	call WriteString
	mov edx, OFFSET linha13
	call WriteString
	mov edx, OFFSET linha14
	call WriteString
	mov edx, OFFSET linha15
	call WriteString
	mov edx, OFFSET linha16
	call WriteString
	mov edx, OFFSET linha17
	call WriteString
	mov edx, OFFSET linha18
	call WriteString
	mov edx, OFFSET linha19
	call WriteString
	mov edx, OFFSET linha20
	call WriteString
	mov edx, OFFSET linha21
	call WriteString
	mov edx, OFFSET linha22
	call WriteString
	mov edx, OFFSET linha23
	call WriteString
	mov edx, OFFSET linha_branca
	call WriteString
	mov edx, OFFSET linha_branca
	call WriteString
	mov edx, OFFSET topo
	call WriteString
L:
	call ReadKey
	.if ax == 561 
		mov ebx, 4
		jmp fim
	.endif	
	.if ax == 818
		mov ebx, 1
		jmp fim
	.endif
	.if ax == 1075
		mov ebx, 0
		jmp fim
	.endif
	jmp L
fim:
	pop eax
	pop edx	
	ret
desenhaIni ENDP

derrota PROC
.code
	push edx
	mov edx, OFFSET topo
	call WriteString
	mov edx, OFFSET linha_branca
	call WriteString
	call WriteString
	call WriteString
	call WriteString
	call WriteString
	mov edx, OFFSET perdeu1
	call WriteString
	mov edx, OFFSET perdeu2
	call WriteString
	mov edx, OFFSET perdeu3
	call WriteString
	mov edx, OFFSET perdeu4
	call WriteString
	mov edx, OFFSET perdeu5
	call WriteString
	mov edx, OFFSET linha_branca
	call WriteString
	call WriteString
	call WriteString
	call WriteString
	mov edx, OFFSET perdeu6
	call WriteString
	mov edx, OFFSET perdeu7
	call WriteString
	mov edx, OFFSET perdeu8
	call WriteString
	mov edx, OFFSET perdeu9
	call WriteString
	mov edx, OFFSET perdeu10
	call WriteString
	mov edx, OFFSET perdeu11
	call WriteString
	mov edx, OFFSET perdeu12
	call WriteString
	mov edx, OFFSET perdeu13
	call WriteString
	call WriteString
	mov edx, OFFSET linha_branca
	call WriteString
	call WriteString
	call WriteString
	call WriteString
	call WriteString
	call WriteString
	call WriteString
	call WriteString
	mov edx, OFFSET topo
	call WriteString
	push eax
	mov eax, 2000
	call Delay
	pop eax
	pop edx
	ret
derrota ENDP

vitoria PROC
	push edx
	mov edx, OFFSET topo
	call WriteString
	mov edx, OFFSET linha_branca
	call WriteString
	call WriteString
	call WriteString
	mov edx, OFFSET vitoria1
	call WriteString
	mov edx, OFFSET linha_branca
	call WriteString
	call WriteString
	mov edx, OFFSET vitoria2
	call WriteString
	mov edx, OFFSET vitoria3
	call WriteString
	mov edx, OFFSET vitoria4
	call WriteString
	mov edx, OFFSET vitoria5
	call WriteString
	mov edx, OFFSET vitoria6
	call WriteString
	mov edx, OFFSET linha_branca
	call WriteString
	call WriteString
	call WriteString
	mov edx, OFFSET vitoria7
	call WriteString
	mov edx, OFFSET vitoria8
	call WriteString
	mov edx, OFFSET vitoria9
	call WriteString
	mov edx, OFFSET vitoria10
	call WriteString
	mov edx, OFFSET vitoria11
	call WriteString
	mov edx, OFFSET vitoria12
	call WriteString
	mov edx, OFFSET vitoria13
	call WriteString
	mov edx, OFFSET linha_branca
	call WriteString
	call WriteString
	call WriteString
	call WriteString
	call WriteString
	call WriteString
	mov edx, OFFSET topo
	call WriteString
	pop edx
	push eax
	mov eax, 2000
	call Delay
	pop eax
	ret
vitoria ENDP

ajuda PROC
	push edx
	mov edx, OFFSET topo
	call WriteString
	mov edx, OFFSET linha_branca
	call WriteString
	call WriteString
	call WriteString
	call WriteString
	call WriteString
	call WriteString
	call WriteString
	call WriteString
	call WriteString
	mov edx, OFFSET ajuda1
	call WriteString
	mov edx, OFFSET linha_branca
	call WriteString
	mov edx, OFFSET ajuda2
	call WriteString
	mov edx, OFFSET ajuda3
	call WriteString
	mov edx, OFFSET ajuda4
	call WriteString
	mov edx, OFFSET linha_branca
	call WriteString
	call WriteString
	call WriteString
	call WriteString
	call WriteString
	call WriteString
	call WriteString
	call WriteString
	call WriteString
	call WriteString
	call WriteString
	call WriteString
	call WriteString
	mov edx, OFFSET topo
	call WriteString
	pop edx
	push eax
	mov eax, 5000
	call Delay
	pop eax
	ret
ajuda ENDP

END main
