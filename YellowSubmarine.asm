INCLUDE Irvine32.inc

desenhaSubmarino PROTO, xy:WORD
apagaSubmarino PROTO, xy:WORD

.data
	NUMERO_DE_OBSTACULOS = 225		   ;//numero de obstaculos no mapa
	BEATLES_RESGATADOS WORD ?          ;//numero de Beatles resgatados

	nivelDificuldade DWORD 200		   ;// delay do jogo, ou seja, dificuldade
	char_mapa BYTE '#'				   ;// "alga", delimitador do mapa
	vetorDeObstaculos WORD NUMERO_DE_OBSTACULOS DUP(?) ;// definicao do vetor de obstaculos
	vetorDeBeatles WORD 4 DUP(?)	   ;// definicao do vetor de beatles

	cabeloPaul BYTE "//||\\",0Dh,0Ah,0 ;//desenho relativo aos Beatles
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

	dificuldade BYTE "Qual nivel de dificuldade vc deseja para o jogo [0, 1, 2, 3 ou 4]? ", 0 ;// string que pergunta dificuldade do jogo

	
.code
main PROC
gameplay:
	call Clrscr						   ;// limpa a tela para inicial o jogo 
	mov edx, OFFSET dificuldade		
	call WriteString				   ;// escreve na tela para escolha de dificuldade
	call readDec					   ;// usuario digita dificuldade
									   ;// tratamento para definir dificuldade
	.IF eax == 1
		mov nivelDificuldade, 250
	.ENDIF

	.IF eax == 2
		mov nivelDificuldade, 200
	.ENDIF

	.IF eax == 3
		mov nivelDificuldade, 150
	.ENDIF

	.IF eax == 4
		mov nivelDificuldade, 100
	.ENDIF

	.IF eax	> 4 || eax == 0            ;// se numero digitado for maior do que 4 ou 0 a escolha deve ser refeita
		jmp gameplay
	.ENDIF

	mov ecx, 0
	mov esi, 0
	mov BEATLES_RESGATADOS, 0          ;// numero de Beatles resgatados inicialmente e zero
	mov cx, 0000000100000001b		   ;// posicao inicial do Submarino com x = 1 e y = 1
	call desenhamapa                   ;// desenha o mapa
	call preencheVetor				   ;// preenche o vetor de Obstaculos
	call desenhaVetorObstaculos        ;// desenha obstaculos no mapa
	call preencheVetorBeatles          ;// preenche o vetor dos Beatles
	call desenhaVetorBeatles           ;// desenha os Beatles no mapa
	push esi
L:									   ;// loop principal
	invoke apagaSubmarino, cx		   ;// apaga o submarino da sua posicao atual
	call ReadKey                       ;// le tecla clicada por usuario
	pop esi
	call leTecla                       ;// chama procedimento que trata a tacla lida para determinar a movimentacao do submarino
	.IF esi == 1					   ;// se esi e 1 o submarino sobe
		sub cl, 1
	.ENDIF

	.IF esi == 2					   ;// se esi e 2 o submarino desce
		add cl, 1
	.ENDIF

	.IF esi == 3					   ;// se esi e 3 o submarino vai para a esquerda
		sub ch, 1
	.ENDIF

	.IF esi == 4					   ;// se esi e 4 o submarino vai para a direita
		add ch, 1
	.ENDIF
	push esi

	invoke desenhaSubmarino, cx		   ;// desenha o submarino na nova posicao determinada por ecx
	mov eax, nivelDificuldade		   ;// move para eax o delay ou seja a dificuldade do jogo e a velocidade do submarino
	call Delay                         ;// chama procemimento Irvine de Delay
	call colisao                       ;// verifica colisao
	cmp ebx, 0                         ;// se ebx == 0 colidiu entao jogo termina, ou seja vai para fim
	je fim                            
	jmp L							   ;// senao volta para o loop principal
	
fim:
	mov dl, 0						   ;// dl e dh sao setados para ficarem no fundo da tela quando termina o jogo
	mov dh, 38
	call Gotoxy
	mov eax, white + (16*black)        ;// tela volta a ser preto e branco
	call SetTextColor
	call waitMsg                       
	exit
main ENDP

desenhaMapa PROC					  ;// procedimento responsável por desenhar o mapa, o fundo que é o mar, e as algas que sao as delimitações de espaço
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
	mov edx, OFFSET char_mapa		   ;// prepara para desenhar #
	call WriteString                   ;// escreve #
	pop edx                            ;// volta para a pilha valor de dl e dh
	inc dl                             ;// incrementa valor da coluna
	loop L


	mov dl, 0
	mov dh, 1
	mov ecx, 30
L2:									   ;// desenha a coluna mais a direita, codigo analogo ao comentado acima 
	call Gotoxy
	push edx
	mov edx, OFFSET char_mapa
	call WriteString
	pop edx
	inc dh                             ;// incrementa valor da linha
	loop L2					         
	mov dl, 79  					   ;// posicao da ultima # da linha de cima
	mov dh, 0
	mov ecx, 30
L3:								       ;// desenha a coluna mais a esquerda, codigo analogo ao comentado acima 
	call Gotoxy
	push edx
	mov edx, OFFSET char_mapa
	call WriteString
	pop edx
	inc dh					           ;// incrementa valor da linha
	loop L3

	mov dl, 1                          
	mov dh, 30
	mov ecx, 79	
L4:									   ;// desenha linha de baixo, codigo analogo ao comentado acima 		
	call Gotoxy
	push edx
	mov edx, OFFSET char_mapa
	call WriteString
	pop edx
	inc dl
	loop L4

	mov dl, 1						   ;//pinta a parte interna do cercado # em azul
	mov dh, 1						   ;// usa de dois for para pintar todos os pixels da tela em azul, iniciando na coordenada (1,1)
	mov ecx, 29						   ;// e terminando em (29, 78)
	mov al, ' '						   ;// caracter espaço para pintar o interior de azul
L6:	
	push ecx						   ;// coloca ecx na pilha para fazer com que o for alterne entre 29 e 78 já que sao dois for utilizados
	mov dl, 1						   ;// linha igual a um pq o for passa para todas as colunas da linha 1
	mov ecx, 78						   ;// as 78 colunas de 1, depois de 2, 3, 4, e assim adiante
L5:
	call Gotoxy						   ;// vai para a posicao dl, dh
	push eax						   ;// Coloca eax na pilha
	mov eax, black+(16*Blue)		   ;// move a cor azul para eax 
	call setTextColor                  ;// seta a cor 
	pop eax							   ;// Tira eax da Pilha
	call WriteChar                     ;//Desenha
	add dl, 1						   ;//incrementa a coluna para passar por todas
	loop L5							   ;// termino do for interno
	pop ecx							   ;// tira ecx da pilha para tratar for externo
	add dh, 1                          ;// incrementa linha para pintar todas as colunas dessa linha
	loop L6							   ;// termino do for externo
	popad
	call crlf
	ret
desenhaMapa ENDP

desenhaSubmarino PROC, xy:WORD         ;//desenha os Submarino na tela
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

apagaSubmarino PROC, xy:WORD           ;// apaga o submarino da tela
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


leTecla PROC                           ;// procidimento responsável por ler tecla apertada por usuario
.code
	.IF ax == 4B00h                    ;// 4B00h e a tecla UP
		mov esi, 1                     ;// esi é colocado como 1 para ser tratato na funcao main
	.ENDIF

	.IF ax == 4D00h					   ;// 4D00h e a tecla UP
		mov esi, 2					   ;// esi é colocado como 2 para ser tratato na funcao main
	.ENDIF

	.IF ax == 4800h					   ;// 4800h e a tecla para esquerda
		mov esi, 3
	.ENDIF

	.IF ax == 5000h					   ;// 5000h e a tecla para direita
		mov esi, 4
	.ENDIF
ret
leTecla ENDP	

colisao PROC                           ;// trata colisao com lado, e com os beatles
.code
	push ecx
	.IF ch <=0 || ch >= 30 || cl <=0 || cl >= 79 ;// colisao com o lado
		jmp deuRuim					   ;// fim de jogo pois colidiu com lado
	.ENDIF

	mov bx, cx						   ;// move cx para bx
	mov ecx, NUMERO_DE_OBSTACULOS      ;// numero de vezes em que loop e realizado e o tamanho do vetor do numero de obstaculos
	mov esi, OFFSET vetorDeObstaculos  ;// esi aponta para aonde esta OFFSET de vetordeObstaculos
L:
	.IF bx == [esi]					   ;//se bx que e a posicao do submarino for igual a qualquer posicao dos 
		jmp deuRuim					   ;//termina jogo
	.endif
	add esi, 2                         ;//proxima posicao
	loop L							   ;// loop L
	
	mov ecx, 4                         ;//colisao com Beatles, analogo aos obstaculos acima
	mov esi, OFFSET vetorDeBeatles
	mov eax, 0

L2:
	.IF bx == [esi + eax] && eax == 4  ;// se colidiu e esta na 3 posicao sei que resgatou o Paul devido as cores em desenhaVetorBeatles
		add BEATLES_RESGATADOS, 1      ;// incrementa quantidade de beatles regatados
		call desenhaPaul			   ;// desenha embaixo na tela a face de Paul que foi resgatado
	.ENDIF

	.IF bx == [esi + eax] && eax == 2  
		add BEATLES_RESGATADOS, 1
		call desenhaJohn			   ;// desenha embaixo na tela a face de John que foi resgatado
	.ENDIF

	.IF bx == [esi + eax] && eax == 6
		add BEATLES_RESGATADOS, 1
		call desenhaGeorge			   ;// desenha embaixo na tela a face de George que foi resgatado
	.ENDIF

	.IF bx == [esi + eax] && eax == 0
		add BEATLES_RESGATADOS, 1
		call desenhaRingo			    ;// desenha embaixo na tela a face de Ringo que foi resgatado
	.ENDIF

	.IF BEATLES_RESGATADOS == 4		   ;//se Beatles resgatados igual a 4 termina o jogo
		jmp deuRuim		
	.ENDIF
	add eax, 2						  ;// proxima posicao para comparar
	loop L2
	jmp fim

deuRuim: 
	mov ebx, 0	
fim:	
	pop ecx
	ret
colisao ENDP

preencheVetor PROC				       ;// preenche vetor com obstaculos
.code 
	call Randomize                     ;//varia numeros aleatorios a serem gerados
	pushad
	mov eax, 0						   ;// seta eax como 0
	mov ecx, NUMERO_DE_OBSTACULOS      ;// numero de iteracoes e igual a NUMERO_DE_OBSTACULOS
	mov esi, OFFSET vetorDeObstaculos  ;// esi e setado como endereco do vetor
EncheVetor:
	mov eax, 29                        ;// intervalo de 0 a 29
	call RandomRange                   ;// gera numero aleatorio
	inc eax							   ;// de 1 a 29
	mov bh, al						   ;// linha a ser colocada na parte mais significativa de bx
	mov eax, 78                        ;// intervalo da coluna
	call RandomRange				   ;// gera numero aleatorio de 0 a 78
	inc eax                            ;// 1 a 78
	mov bl, al                         ;// coloca numero na parte menos significativa de bl
	mov [esi], bx					   ;// coloca no vetor
	add esi, 2						   ;// proxima posicao
	loop EncheVetor
	popad
ret
preencheVetor ENDP

desenhaVetorObstaculos PROC            ;// funcao responsavel por desenhar Vetor de Obstaculos
.code 
	pushad
	mov ecx, NUMERO_DE_OBSTACULOS      ;// numero de iteracoes e o tamanho do vetor de Obstaculos
	mov esi, 0                         ;// esi e setado como 0
	mov ebx, OFFSET vetorDeObstaculos  ;// ebx e colocado no endereco do vetor
desenha:
	mov dx, [ebx + esi]				   ;//dx e setado como posicao esi do vetor
	call GoToXY						   ;// move cursor para posicao ja que dx e dl e dh
	mov al, '+'                        ;// al recebe char de obstaculo
	push eax						   ;// coloca eax na pilha
	mov eax, 008+(16*Blue)             ;// move eax a cor cinza e fundo azul respectivo a cor da pedra e ao fundo azul
	call SetTextColor				   ;//seta cor
	pop eax							   ;// tira eax da pilha
	call WriteChar                     ;// escreve char
	add esi, 2                         ;// proxima posicao
	loop desenha
	popad
ret
desenhaVetorObstaculos ENDP

preencheVetorBeatles PROC              ;// preenche vetor dos Beatles, posicao dos Beatles nao pode ser a mesma do Obstaculo
.code
	call Randomize                     ;// gera numeros diferentes
	pushad
	mov eax, 0 
	mov ecx, 4						   ;// 4 Beatles, logo, vetor de tam = 4
	mov esi, OFFSET vetorDeBeatles
EncheVetor:							   ;// coloca posicao no vetor dos Beatles, analogo ao vetor de obstaculos
	mov eax, 29
	call RandomRange
	inc eax
	mov bh, al
	mov eax, 78
	call RandomRange
	inc eax
	mov bl, al
	
	push ecx						   ;// guarda valor do loop que preenche vetor do Beatle para compara numero aleatorio com vetor de Obstaculos
VoltaTudo:	                           ;// volta tudo significa que o valor aleatorio dos beatles bateu com valor aleatorio dos obstaculos				          
	mov ecx, NUMERO_DE_OBSTACULOS      ;// ecx recebe o numero de obstaculos
	mov edx, OFFSET vetorDeObstaculos  ;// edx recebe endereco do vetor de obstaculos
	mov eax, ecx                       
ComparaComObstaculos:				   ;// compara numero aleatorio com o vetor de obstaculos
	.IF bx == [edx]					   ;// se bx for igual a edx, ou seja se o num aleatorio for igual a posicao de obstaculo
		mov eax, 29                    ;// gera-se outro numero 
		call RandomRange
		inc eax
		mov bh, al
		mov eax, 78
		call RandomRange
		inc eax
		mov bl, al
		jmp VoltaTudo                  ;// volta tudo ja que e necessario comparar novo numero novamente
	.ELSE
		add edx, 2                     ;//se e diferente pode comparar com proximo do vetor de obstaculos
	.ENDIF
	loop ComparaComObstaculos          
	pop ecx							   ;// ecx volta a ser loop do vetor dos Beatles
	mov [esi], bx                      ;// se e diferente coloca no bx no vetor de Beatles
	add esi, 2						   ;// proxima posicao relativo a posicao de Beatle
	loop EncheVetor                    ;// proximo numero a se testar para colocar no vetor de Beatle, realiza-se 4 vezes
	popad
	ret								   
preencheVetorBeatles ENDP

desenhaVetorBeatles PROC               ;// funcao responsavel por desenhar vetor de Beatles
.code								   ;// cada cor de Beatle e relativa ao album sgt. peppers's lonely hearts club band
	pushad
	mov ecx, 4                         ;// tam do vetor de Beatles
	mov esi, 0                         ;// esi ira somar com OFFSET para cada valor do vetor sair com cor diferente
	mov ebx, OFFSET vetorDeBeatles
desenha:
	mov dx, [ebx + esi]                ;// recebe posicao para desenhar os beatles
	call GoToXY                        ;// vai ate posicao
	mov al, 01                         ;// 01 e o char ACII para a carinha
	.IF esi == 0                       
		push eax
		mov eax, lightMagenta+(16*Blue) ;// posicao 0 tem como cor fundo azul do mar e magenta para o Beatle, logo Ringo 
		call SetTextColor               ;// seta cor
		pop eax
	.ENDIF

	.IF esi == 2
		push eax
		mov eax, lightGreen+(16*Blue)  ;// posicao 1 tem cor verde logo John
		call SetTextColor
		pop eax
	.ENDIF

	.IF esi == 4
		push eax
		mov eax, white+(16*Blue)       ;// posicao 2 tem cor branca, ja que azul ja e o fundo, logo, Paul
		call SetTextColor
		pop eax
	.ENDIF

	.IF esi == 6
		push eax
		mov eax, lightRed+(16*Blue)    ;// posicao 3 tem cor vermelha, logo George
		call SetTextColor
		pop eax
	.ENDIF
	call WriteChar
	add esi, 2
	loop desenha
	popad
ret
desenhaVetorBeatles ENDP

desenhaPaul PROC                       ;// funcao responsavel por desenhar Paul quando salvo por submarino
.code
	pushad                             
	mov ecx, 5                         ;//ecx recebe 5 relativo ao numero de linhas que o desenho de Paul
	mov dl, 0                          ;// posicao do desenho em dl e dh
	mov dh, 32
	call Gotoxy                        ;// vai ate posicao
	push eax
	mov eax, white+(16 * lightBlue)    ;// cor do desenho
	call SetTextColor
	pop eax

L1:
	.IF ecx == 5                       ;// se for linha 5 desenha o cabelo de Paul
		mov edx, OFFSET cabeloPaul
		call WriteString
	.ENDIF

	.IF ecx == 4                       ;// se for linha 5 desenha o olho de Paul
		mov edx, OFFSET olhoPaul
		call WriteString
	.ENDIF

	.IF ecx == 3                       ;// se for linha 5 desenha o nariz de Paul
		mov edx, OFFSET narizPaul
		call WriteString
	.ENDIF

	.IF ecx == 2                        ;// se for linha 5 desenha a boca de Paul
		mov edx, OFFSET bocaPaul
		call WriteString
	.ENDIF

	.IF ecx == 1                       ;// se for linha 5 desenha o nome
		mov edx, OFFSET nomePaul
		call WriteString
	.ENDIF

	loop L1
	popad
ret
desenhaPaul ENDP

desenhaJohn PROC                       ;// funcao responsavel por desenhar John quando salvo por submarino  
.code
	pushad
	mov ecx, 5                     
	push eax    
	mov eax, white+(16 * lightGreen)   ;// cor de John
	call SetTextColor
	pop eax
L1:
	.IF ecx == 5                       ;// se for linha 5 desenha o cabelo de John
		mov dl, 23                     ;// dl e dh recebem a posicao do cursor para desenhar primeira linha de John
		mov dh, 32
		call Gotoxy
		mov edx, OFFSET cabeloJohn           
		call WriteString
	.ENDIF

	.IF ecx == 4                       ;// se for linha 4 desenha o olho de John
		mov dl, 23                     ;// dl e dh recebem a posicao do cursos para desenhar segunda linha de John
		mov dh, 33
		call Gotoxy
		mov edx, OFFSET olhoJohn
		call WriteString
	.ENDIF

	.IF ecx == 3                       ;// se for linha 3 desenha o nariz de John
		mov dl, 23                     ;// dl e dh recebem a posicao do cursos para desenhar terceira linha de John
		mov dh, 34
		call Gotoxy
		mov edx, OFFSET narizJohn
		call WriteString
	.ENDIF

	.IF ecx == 2                       ;// se for linha 3 desenha a boca de John
		mov dl, 23                     ;// dl e dh recebem a posicao do cursos para desenhar quarta linha de John
		mov dh, 35
		call Gotoxy
		mov edx, OFFSET bocaJohn
		call WriteString
	.ENDIF

	.IF ecx == 1                       ;// se for linha 3 desenha o nome
		mov dl, 23                     ;// dl e dh recebem a posicao do cursos para desenhar quinta linha de John
		mov dh, 36
		call Gotoxy
		mov edx, OFFSET nomeJohn
		call WriteString
	.ENDIF

	loop L1
	popad
ret
desenhaJohn ENDP

desenhaGeorge PROC                     ;// funcao responsavel por desenhar George quando salvo por submarino, analoga a funcao de John
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

desenhaRingo PROC                      ;// funcao responsavel por desenhar Ringo quando salvo por submarino, analoga a funcao de John
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


