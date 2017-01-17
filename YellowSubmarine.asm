INCLUDE Irvine32.inc
.data
	sup_mapa byte '******************************************************************************'
	lado_mapa byte'*                                                                            *'
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
	call crlf
	mov edx, OFFSET lado_mapa
	mov ecx, 30
L:
	call WriteString
	call crlf
	loop L
	mov edx, OFFSET sup_mapa
	call WriteString
	call crlf
	popad
	ret
desenhamapa ENDP
END main