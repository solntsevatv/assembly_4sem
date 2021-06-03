#include <stdio.h>
#include "../inc/processing.h"

int main() 
{
    // 32 bit
    puts("32 bit - float");
    print_32_bit_result();
    asm_print_32_bit_result();
    puts("\n**********\n");

    // 64 bit
    puts("64 bit - double");
    print_64_bit_result();
    asm_print_64_bit_result();
    puts("\n**********\n");

    // 80 bit
#ifndef X87
    puts("80 bit - double");
    print_80_bit_result();
    asm_print_80_bit_result();
    puts("\n**********\n");
#endif

    // compare sin
    sin_compare();

    return 0;
}