#include <stdio.h>
#include <stdint.h>

// Counting leading zero of given value

uint16_t clz(uint64_t x)
{
    x |= (x >> 1);
    x |= (x >> 2);
    x |= (x >> 4);
    x |= (x >> 8);
    x |= (x >> 16);
    x |= (x >> 32);
    
    /* count ones (population count) */
    x -= ((x >> 1) & 0x5555555555555555);
    x = ((x >> 2) & 0x3333333333333333) + (x & 0x3333333333333333);
    x = ((x >> 4) + x) & 0x0f0f0f0f0f0f0f0f;
    x += (x >> 8);
    x += (x >> 16);
    x += (x >> 32);

    return (64 - (x & 0x7f));
}

// Find Longest String of 1-Bits
/* 
    Examples:
        Given a uint32_t 0x3ff3f3f8
        binary expression: 0011 1111 1111 0011 1111 0011 1111 1000
        The logest sqeunce:  starting at x20 ending at x29               
*/
int maxstr1(uint32_t x)
{   
    int k;   
    for (k = 0; x != 0; k++) x = x & 2*x;   
    return k; 
}

int main()
{
    // uint64_t x = 0x0001a0a00001000a;
    uint32_t y = 0x3ff3f3f8;
    
    return 0;
}