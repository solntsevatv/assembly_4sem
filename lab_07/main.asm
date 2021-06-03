.MODEL TINY
.CODE
.186
ORG 100H

main:
    JMP init

    SPEED DB 00011111b
    CURR_HANDLER DD ?
    IS_WORK DB 0
    SECONDS DB 0

init PROC
    ; Сохранить адрес предыдущего обработчика прерывания 1Ch
    MOV AX, 351ch
    INT 21h

    ; WORD PTR нужно интерпретировать, как операнд размером в слово
    MOV WORD PTR CURR_HANDLER, BX
    MOV WORD PTR CURR_HANDLER + 2, ES ; (возвращается в ES:BX)

    CMP ES:IS_WORK, 1

    ; если ==, то turn_off, иначе turn_on
    JE turn_off

turn_on:
    XOR IS_WORK, 1

    ; Установить наш обработчик
    MOV AX, 251ch
    MOV DX, offset autorepeat_handler
    INT 21h

    MOV DX, offset init
    ; Возвращает управление DOS, оставляя часть памяти распределенной, 
    ; так что последующие программы не будут перекрывать программный 
    ; код или данные в этой памяти.
    INT 27h

turn_off:
    XOR IS_WORK, 1
    ; Восстановить предыдущий обработчик прерывания 1Ch.
    MOV AX, 251ch
    MOV DX, WORD PTR ES:CURR_HANDLER
    MOV DS, WORD PTR ES:CURR_HANDLER + 2

    INT 21h

    ; команда F3h отвечает за параметры режима автоповтора нажатой клавиши
    MOV AL, 0f3h
    ; Копирует число из источника (AL, АХ или ЕАХ) в порт ввода-вывода
    ; Порт 60h доступен для записи и обычно принимает пары байтов 
    ; последовательно: первый - код команды, второй - данные
    OUT 60h, AL

    MOV AL, 0h
    OUT 60h, AL

    ; завершение программы
    MOV AH, 4ch
    INT 21h

init endp

autorepeat_handler PROC FAR
    ; Поместить в стек значение регистра FLAGS
    PUSHF
    ; Поместить в стек значения всех 16-битных регистров общего назначения
    PUSHA

    ; читать время из "постоянных" (CMOS) часов реального времени
    ; выход: CH = часы в коде BCD   (пример: CX = 1243H = 12:43)
    ;        CL = минуты в коде BCD
    ;        DH = секунды в коде BCD
    ; выход: CF = 1, если часы не работают
    MOV AH, 02h
    INT 1AH
    
    JC finish_autorepeat_handler ; ПЕРЕХОД, ЕСЛИ CF==1

    ; если секунды одинаковые, то сразу переходим к концу
    CMP SECONDS, DH
    JE finish_autorepeat_handler

    MOV SECONDS, DH
    DEC SPEED
    
    ; команда F3h отвечает за параметры режима автоповтора нажатой клавиши
    MOV AL, 0f3h
    ; Копирует число из источника (AL, АХ или ЕАХ) в порт ввода-вывода
    ; Порт 60h доступен для записи и обычно принимает пары байтов 
    ; последовательно: первый - код команды, второй - данные
    OUT 60h, AL

    MOV AL, SPEED
    OUT 60h, AL

    CMP SPEED, 0h
    JNE finish_autorepeat_handler

    MOV SPEED, 00011111b ; 2 cимвола в секунду

finish_autorepeat_handler:
    ; Извлечь из стека значения всех 16-битных регистров общего назначения
    POPA
    ; Извлечение регистра флагов из стека
    POPF

    JMP CS:CURR_HANDLER ; возвращение к обработчику, запомненному в ините

autorepeat_handler endp

end main