PUBLIC rev_number

EXTRN MAIN_NUMBER : WORD

CodeSeg SEGMENT PARA PUBLIC 'Code'

rev_number PROC NEAR
    NOT MAIN_NUMBER
    INC MAIN_NUMBER
    OR MAIN_NUMBER, 8000h
    ret
rev_number ENDP

CodeSeg ENDS
END