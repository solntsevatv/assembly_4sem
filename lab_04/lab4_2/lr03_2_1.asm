STK SEGMENT para STACK 'STACK'
	db 100 dup('$') ; выделяется память под стек 100 (в 16 сс) байт
				  ; и заполняется нулями. PARA - выравн. 16 байт
STK ENDS

SD1 SEGMENT para common 'DATA' ; COMMON (сегменты будут “наложены” 
					; друг на друга по одним и тем же адресам памяти)
	W dw 3444h ; выделяется память под W = 3444h в размере 2 байта
SD1 ENDS
END
