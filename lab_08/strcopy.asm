global my_strcpy

section .text
my_strcpy:
    ; rcx - длина строки
    xor rcx, rcx
    mov ecx, edx ; Количество символов для записи
    inc ecx ; для копирования нулевого/первого символа тоже

    ; rsi - которую копируем
    ; rdi - куда копируем
    cmp rdi, rsi
    JE cpy_exit
    JB cpy_forward ; если меньше
    JMP cpy_backward

    cpy_forward:
        rep movsb ; копирует из rsi в rdi
        ret

    cpy_backward:
        add rsi, rcx
        add rdi, rcx
        
        std ; Устанавливает флаг DF в 1, так что при последующих строковых операциях
            ; регистры DI и SI будут уменьшаться.
        rep movsb
        cld ; Сбрасывает флаг DF в 0, так что при последующих строковых операциях регистры DI и SI будут увеличиваться.
        ret

    cpy_exit:
        ret