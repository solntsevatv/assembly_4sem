EXTRN ROWS: BYTE
EXTRN COLS: BYTE
EXTRN MATRIX: BYTE

PUBLIC INSYMB
PUBLIC CRLF
PUBLIC INPUT_MATRIX
PUBLIC OUTPUT_MATRIX

CODESEG SEGMENT PARA PUBLIC 'CODE'

; Input symbol with echo.
INSYMB:
    MOV AH, 1
    INT 21H
    RET

; Echo symbol.
OUTSYMB:
    MOV AH, 2
    INT 21H
    RET

; Carriage return + line feed.
CRLF:
    MOV AH, 2
    MOV DL, 13
    INT 21H
    MOV DL, 10
    INT 21H
    RET

; Echo space symbol.
PRINTSPACE:
    MOV AH, 2
    MOV DL, ' '
    INT 21H
    RET

INPUT_MATRIX:
    XOR SI, SI
    XOR BX, BX
    MOV CL, ROWS
    INMAT:
        MOV CL, COLS
        INROW:
            CALL INSYMB
            MOV MATRIX[BX], AL
            INC BX
            CALL PRINTSPACE
            LOOP INROW
        CALL CRLF
        MOV CL, ROWS
        SUB CX, SI
        INC SI
        LOOP INMAT
     
    CALL CRLF
    RET

OUTPUT_MATRIX:
    ; Output matrix in matrix style.
    XOR DI, DI
    XOR BX, BX
    XOR CH, CH
    MOV CL, ROWS
    OUTMAT:
        MOV CL, COLS
        OUTROW:
            MOV DL, MATRIX[BX]
            CALL OUTSYMB
            INC BX
            CALL PRINTSPACE
            LOOP OUTROW
        CALL CRLF
        MOV CL, ROWS
        MOV SI, DI
        SUB CX, SI
        INC DI
        LOOP OUTMAT
    RET
CODESEG ENDS
END INSYMB