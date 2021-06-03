#include "stdio.h"

void my_strcpy(char *dst, char *src, int len);
int my_strlen(const char *str)
{
    long int len;
    //AT&T Assembler code for GCC
    // причем расширенный AT&T, отсюда по 2 %
    // /n/t нужно для выравнивания, чтобы дизассемблированный код выглядел красиво
    asm
    (
        "movl %%edi, %%ebx\n\t"
        "inc %%ebx\n\t"
        "xor %%al, %%al\n\t"
        "next:\n\t\t"
        /* Команда SCASB сравнивает регистр AL с байтом в ячейке памяти по адресу ES:DI 
        и устанавливает флаги аналогично команде CMP. После выполнения команды, 
        регистр DI увеличивается на 1, если флаг DF = 0, или уменьшается на 1, если DF = 1. */
            "scasb\n\t\t"
            "JNE next\n\t"
        "sub %%ebx, %%edi\n\t"
        :"=D"(len) // выход, "=" означает, что операнд для данной инструкции предназначен только для записи.
        :"D"(str) // вход, D = Регистры edi, rdi и их версии
        :"al", "ebx" //Регистры, изменяемые вставкой
    );
    return len;
}

int main()
{
    int len;
    char before[32], *middle = before + 3, *after = middle + 3;
    char messg[] = "BMSTU MDPL LAB 8";

    len = my_strlen(messg);
    printf("String lenght = %d\n", len);
    
    //         rdi    rsi    edx
    my_strcpy(middle, messg, len);
    printf("Coppied string: %s\n", middle);

    my_strcpy(before, middle, len);
    printf("Span before: %s\n", before);

    my_strcpy(after, before, len);
    printf("Span after: %s\n", after);

    my_strcpy(after, after, len);
    printf("Identic strings: %s\n", after);

    return 0;
}