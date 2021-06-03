PUBLIC read8s
PUBLIC read_input

PUBLIC MAIN_NUMBER

EXTRN rev_number : NEAR
EXTRN CRLF    : NEAR


DataSeg SEGMENT PARA PUBLIC 'Data'
    MAIN_NUMBER DW 0
    REV_FLAG    DB 0
    INVITE_NUM  DB "Enter number (8 signed): $"
DataSeg ENDS

CodeSeg SEGMENT PARA PUBLIC 'Code'
    ASSUME DS: DataSeg, CS: CodeSeg

read8s PROC NEAR
    call CRLF
    call CRLF
    MOV DX, OFFSET INVITE_NUM
    MOV AH, 09h
    INT 21h

    MOV REV_FLAG, 0
    XOR DX, DX
    MOV BX, 5
    MOV AH, 01h

    read_digit:
        INT 21h

        CMP AL, '-'
        JNE proc_digit

        MOV REV_FLAG, 1
        JMP read_digit

        proc_digit:
        SUB AL, '0'
        MOV CL, 3
        SAL DX, CL
        ADD DL, AL

        DEC BX
        JNZ read_digit
    
    MOV MAIN_NUMBER, DX
    CMP REV_FLAG, 1
    JNE end_read
    call rev_number

    end_read:
    ret
read8s ENDP

read_input PROC NEAR
    MOV AH, 01h
    INT 21h
    XOR AH, AH
    SUB AL, '0'
    MOV CL, 2
    MUL CL
    MOV SI, AX
    ret
read_input ENDP

CodeSeg ENDS
END