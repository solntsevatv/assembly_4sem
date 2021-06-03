#include "../inc/general.h"

void c_scalar_prod(float *dst, const vector_t *src_a, const vector_t *src_b) 
{
    *dst = 
        src_a->buf[0] * src_b->buf[0] +  // x1 * x2
        src_a->buf[1] * src_b->buf[1] +  // y1 * y2
        src_a->buf[2] * src_b->buf[2];   // z1 * z2
}

void sse_scalar_prod(float *dst, const vector_t *src_a, const vector_t *src_b) 
{
    __asm__(".intel_syntax noprefix\n\t"
            "movaps xmm0, %1\n\t"
            "movaps xmm1, %2\n\t"
            "mulps xmm0, xmm1\n\t"      // Выполняет параллельное умножение четырех пар чисел с плавающей запятой. Результат записывается в приемник
            "movhlps xmm1, xmm0\n\t"    // Копирует старшие 64 бита источника в младшие 64 бита приемника.
            "addps xmm0, xmm1\n\t"      // Выполняет параллельное сложение четырех пар чисел с плавающей запятой. Результат записывается в приемник.
            "movaps xmm1, xmm0\n\t"   
            "shufps xmm0, xmm0, 1\n\t"  // В младшие два числа приемника помещает любые из четырех чисел, находившихся в приемнике [пр, ист, индекс]
            "addps xmm0, xmm1\n\t"
            "movss %0, xmm0\n\t"        // Копирует младшие 64 бита из источника в приемник
    :"=m"(*dst)
    :"m"(src_a->buf), "m"(src_b->buf)
    :"xmm0", "xmm1");
}

