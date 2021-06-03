SD1 SEGMENT para public 'DATA'
	S1 db 'Y' ; байт под У
	db 65535 - 2 dup ('$') ; выделены байты и заполнены 0
SD1 ENDS

SD2 SEGMENT para public 'DATA'
	S2 db 'E' ; байт под Е
	db 65535 - 2 dup ('&') ; выделены байты и заполнены 0
SD2 ENDS

SD3 SEGMENT para public 'DATA'
	S3 db 'S' ; байт под S
	db 65535 - 2 dup (0) ; выделены байты и заполнены 0
SD3 ENDS

CSEG SEGMENT para public 'CODE'
	assume CS:CSEG, DS:SD1
output:
	mov ah, 2 ; вывод символа
	int 21h
	mov dl, 13 ; \r возврат каретки
	int 21h
	mov dl, 10 ; \n перевод на другую строку
	int 21h
	ret
main:
	mov ax, SD1
	mov ds, ax
	mov dl, S1
	call output
assume DS:SD2
	mov ax, SD2
	mov ds, ax
	mov dl, ds:S2
	call output
assume DS:SD3
	mov ax, SD3
	mov ds, ax
	mov dl, S3
	call output
	
	mov ax, 4c00h
	int 21h
CSEG ENDS
END main