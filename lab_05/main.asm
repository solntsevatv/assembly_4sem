PUBLIC ROWS
PUBLIC COLS
PUBLIC MATRIX

EXTRN INSYMB: NEAR
EXTRN CRLF: NEAR
EXTRN INPUT_MATRIX: NEAR
EXTRN OUTPUT_MATRIX: NEAR

; Stack segment.
STACKSEG SEGMENT PARA STACK 'STACK'
    DB 100 DUP(0)
STACKSEG ENDS

; Matrix segment.
DATASEG SEGMENT PARA 'DATA'
    RMSG DB 'Enter matrix rows: $'
    CMSG DB 'Enter matrix columns: $'
    MMSG DB 'Enter matrix:$'
    RESMSG DB 'Output matrix:$'
    ROWS DB 0
    COLS DB 0
    MATRIX DB 9 * 9 DUP(?)
DATASEG ENDS

; Main code segment.
CODESEG SEGMENT PARA PUBLIC 'CODE'
    ASSUME CS:CODESEG, DS:DATASEG, SS:STACKSEG


; УДАЛЕНИЕ СТОЛБЦА
DELETE_COL:
    XOR BH, BH 
    MOV DI, 1 ; НОМЕР ТЕКУЩЕЙ СТРОКИ
    MOV CL, ROWS
    SUB CX, 1 ; ЗАДАЛИ ЦИКЛ
    CMP CX, 0
    JE NO_DELETE
    DELETE_LAST_COL:
        XOR AH, AH
        MOV AL, COLS
        ADD AX, 1 ; ПОМЕСТИЛИ В АХ КОЛ-ВО СТОЛБЦОВ
        MOV CL, ROWS
        SUB CX, DI ; ПОМЕСТИЛИ В АХ КОЛ-ВО ОСТАВШИХСЯ СТРОК
        MUL CL 
        MOV CX, AX ; ПОСЧИТАЛИ КОЛ-ВО ЯЧЕЕК МАТРИЦЫ ДЛЯ СДВИГА

        MOV BL, COLS
        MOV AX, DI
        MUL BL
        MOV BX, AX ; ПОСЧИТАЛИ ТЕКУЩИЙ ИНДЕКС ЯЧЕЙКИ МАТРИЦЫ

        ; СМЕЩЕНИЕ НА 1 ЯЧЕЙКУ ВЛЕВО
        CHANGE_LAST_SYMB:
            ADD BX, 1
            MOV DL, MATRIX[BX]
            SUB BX, 1
            MOV MATRIX[BX], DL
            ADD BX, 1
            LOOP CHANGE_LAST_SYMB

        MOV CH, 0
        MOV CL, ROWS
        SUB CX, DI
        INC DI
        LOOP DELETE_LAST_COL
    NO_DELETE:
    RET

CHANGE_COLS:
    MOV BX, DI
    MOV CL, ROWS
    COLEXCHANGE:
        ADD BX, 1
        MOV DL, MATRIX[BX]
        SUB BX, 1
        MOV MATRIX[BX], DL

        MOV AH, 0
        MOV AL, COLS
        ADD BX, AX
        LOOP COLEXCHANGE

    MOV CL, COLS
    SUB CX, DI
    SUB CX, 1
    INC DI

    LOOP CHANGE_COLS
RET

; Main code segment.
MAIN:
    ; DATASEG preparation.
    MOV AX, DATASEG
    MOV DS, AX

    ; Input invitation.
    MOV AH, 9
    MOV DX, OFFSET RMSG
    INT 21H

    ; Input ROWS.
    CALL INSYMB
    MOV ROWS, AL
    SUB ROWS, '0'
    CALL CRLF

    ; Input invitation.
    MOV AH, 9
    MOV DX, OFFSET CMSG
    INT 21H

    ; Input COLS.
    CALL INSYMB
    MOV COLS, AL
    SUB COLS, '0'
    CALL CRLF

    ;ПРОВЕРКА НА РАВЕНСТВО НУЛЮ ДЛЯ СТОЛБЦОВ
    XOR CH, CH
    MOV CL, COLS
    CMP CL, 0
    JE NO_OUTPUT

    ;ПРОВЕРКА НА РАВЕНСТВО НУЛЮ ДЛЯ СТРОК
    MOV CL, ROWS
    CMP CL, 0
    JE NO_OUTPUT

    ; Input invitation.
    MOV AH, 9
    MOV DX, OFFSET MMSG
    INT 21H
    CALL CRLF

    CALL INPUT_MATRIX
    
    XOR SI, SI ; ИНДЕКС СТОЛБЦА
    MOV CL, COLS ; ЗАДАЕМ ЦИКЛ
    FORCOLS:
        MOV BX, SI ; ИНДЕКС ТЕКУЩЕГО ЭЛЕМЕНТА В МАТРИЦЕ
        XOR DI, DI ; СУММА ЭЛЕМЕНТОВ В СТОЛБЦЕ
        MOV CL, ROWS ; ПЕРЕОПРЕДЕЛЯЕМ ЦИКЛ
        FORROWS:
            XOR DH, DH
            MOV DL, MATRIX[BX]
            ADD DI, DX
            MOV AH, 0
            MOV AL, COLS
            ADD BX, AX ; УВЕЛИЧИВАЕМ ИНДЕКС ЭЛЕМЕНТА НА КОЛИЧЕСТВО СТОЛБЦОВ
            LOOP FORROWS

        ; ПРОВЕРКА СУММЫ НА ЧЕТНОСТЬ
        TEST DI, 1
        JNZ ODD ; НЕЧЕТНОЕ

        ; ЕСЛИ ПРОВЕРЯЕТСЯ ПОСЛЕДНИЙ СТОЛБЕЦ, НО ОБМЕН НЕ НУЖЕН, 
        ; ПРОСТО УМЕНЬШАЕМ КОЛИЧЕСТВО
        MOV CL, COLS
        SUB CX, SI 
        SUB CX, 1
        CMP CX, 0
        JE NO_EXCHANGE

        ; СДВИГ СТОЛБЦОВ
        MOV DI, SI
        CALL CHANGE_COLS

        NO_EXCHANGE:
        ; УМЕНЬШАЕМ НА 1 КОЛИЧЕСТВО СТОЛБЦОВ
        XOR DH, DH
        MOV DL, COLS
        SUB DX, 1
        MOV COLS, DL
        SUB SI, 1
        ; УДАЛЕНИЕ СТОЛБЦА
        CALL DELETE_COL

        ODD: 
        MOV CL, COLS 
        SUB CX, SI
        INC SI
        
        LOOP FORCOLS

    ;ПРОВЕРКА НА РАВЕНСТВО НУЛЮ ДЛЯ СТОЛБЦОВ
    XOR CH, CH
    MOV CL, COLS
    CMP CL, 0
    JE NO_OUTPUT

    ;ПРОВЕРКА НА РАВЕНСТВО НУЛЮ ДЛЯ СТРОК
    MOV CL, ROWS
    CMP CL, 0
    JE NO_OUTPUT

    ; ВЫВОД МАТРИЦЫ
    MOV AH, 9
    MOV DX, OFFSET RESMSG
    INT 21H
    CALL CRLF
    CALL OUTPUT_MATRIX

    ; КОНЕЦ ПРОГРАММЫ
    NO_OUTPUT:
    MOV AX, 4C00H
    INT 21H
CODESEG ENDS
END MAIN