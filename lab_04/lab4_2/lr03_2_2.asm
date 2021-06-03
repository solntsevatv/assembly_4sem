SD1 SEGMENT para common 'DATA' ; сегмент "наложен" на сегмент из другого модуля
	C1 LABEL byte ; ссылка на первый байт этого сегмента
	ORG 1h ; Программный счетчик - внутренняя переменная ассемблера, равная 
			; смещению текущей команды или данных относительно начала сегмента.
			; Для преобразования меток в адреса используется именно значение 
			; этого счетчика.
	C2 LABEL byte ; ссылка на второй байт этого сегмента
SD1 ENDS

CSEG SEGMENT para 'CODE'
	ASSUME CS:CSEG, DS:SD1 ; инструкция, какой сегментный 
						   ;регистр с каким сегментом связан
main:
	mov ax, SD1
	mov ds, ax
	mov ah, 2
	mov dl, C1
	int 21h
	mov dl, C2
	int 21h
	mov ax, 4c00h
	int 21h
CSEG ENDS
END main