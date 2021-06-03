PUBLIC print2s
PUBLIC print16u
PUBLIC CRLF

EXTRN MAIN_NUMBER : WORD

EXTRN rev_number  : NEAR

DataSeg SEGMENT PARA PUBLIC 'Data'
    OUT_BUFFER  DB 18 DUP('$')
    MASK16      DW 0F000h
    MASK8       DW 07000h
    MASK2       DW 08000h
DataSeg ENDS

CodeSeg SEGMENT PARA PUBLIC 'Code'
ASSUME DS: DataSeg

CRLF PROC NEAR
    PUSH AX
    MOV AL, DL
    
    MOV AH, 02h
    MOV DL, 10
    INT 21h
    MOV DL, 13
    INT 21h

    MOV DL, AL
    POP AX
    ret
CRLF ENDP

print16u PROC NEAR
    call CRLF
    call CRLF
    XOR SI, SI
    XOR CX, CX
    MOV DX, 4

    MOV BX, MAIN_NUMBER

    get_digit16u:
        MOV AX, MASK16
        AND AX, BX
        MOV CL, 4
        SHL BX, CL

        MOV CL, 4
        SHR AH, CL
        ADD AH, '0'

        CMP AH, ':'
        JL add_digit16

        ADD AH, 7 ; ЧИСЛО ПЕРЕВОДИМ В ЦИФРУ

        add_digit16:
        MOV OUT_BUFFER[SI], AH
        INC SI


        DEC DX
        JNZ get_digit16u

    MOV OUT_BUFFER[SI], '$'
    MOV AH, 09h
    MOV DX, OFFSET OUT_BUFFER
    INT 21h
    ret
print16u ENDP

print2s PROC NEAR
    call CRLF
    call CRLF
    XOR SI, SI
    XOR CX, CX

    MOV DX, 16
    MOV BX, MAIN_NUMBER

    TEST BX, MASK2
    JZ get_digit2s

    MOV DL, '-'
    MOV AH, 02h
    INT 21h

    DEC BX
    NOT BX
    MOV DX, 16

    get_digit2s:
        MOV AX, MASK2
        AND AX, BX
        SHL BX, 1

        MOV CL, 7
        SHR AH, CL
        ADD AH, '0'
        MOV OUT_BUFFER[SI], AH
        INC SI

        DEC DX
        JNZ get_digit2s

    MOV OUT_BUFFER[SI], '$'
    MOV AH, 09h
    MOV DX, OFFSET OUT_BUFFER
    INT 21h
    ret
print2s ENDP

CodeSeg ENDS
END