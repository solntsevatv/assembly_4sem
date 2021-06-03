EXTRN X: byte
PUBLIC exit

SD2 SEGMENT para 'DATA'
	Y db 'Y'
SD2 ENDS

SC2 SEGMENT para public 'CODE'
	assume CS:SC2, DS:SD2
exit:
	mov ax, seg X ; переместили сюда сегментный адрес Х
	mov es, ax
	mov bh, es:X ; поместили адрес от es со смещением Х

	mov ax, SD2 ; ссылка на У
	mov ds, ax

	xchg ah, Y ; exchange - обмен, теперь У хранит старший байт ах
	xchg ah, ES:X  ; теперь аh хранит ES:X, ES:X - Y
	xchg ah, Y	; по сути ah не изменилось, а вот в У теперь ES:X

	mov ah, 2
	mov dl, Y ; вывод ES:X (символ Х)
	int 21h
	
	mov ax, 4c00h
	int 21h
SC2 ENDS
END