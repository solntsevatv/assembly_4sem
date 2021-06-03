EXTRN output_X: near ; указан идентификатор, определенный в другом модуле
					 ; near переход в пределах того же сегмента

STK SEGMENT PARA STACK 'STACK'
	db 100 dup('$') ; выделяется память под стек 100 (в 10 сс) байт
				  ; и заполняется нулями. PARA - выравн. 16 байт
STK ENDS

DSEG SEGMENT PARA PUBLIC 'DATA'
	X db 'R' ; выделяется память под X 1 байт
DSEG ENDS

CSEG SEGMENT PARA PUBLIC 'CODE'
	assume CS:CSEG, DS:DSEG, SS:STK ; инструкция, какой сегментный 
									;регистр с каким сегментом связан
main:
	mov ax, DSEG
	mov ds, ax

	call output_X ; вызов процедуры

	mov ax, 4c00h ; завершение программы
	int 21h ; программное прерывание
CSEG ENDS

PUBLIC X ; описывает идентификатор, доступный из др. модулей

END main