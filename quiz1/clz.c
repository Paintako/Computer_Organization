#include <stdio.h>
#include <stdint.h>

// Counting leading zero of given value
uint16_t clz(uint32_t x)
{
    x |= (x >> 1);
    x |= (x >> 2);
    x |= (x >> 4);
    x |= (x >> 8);
    x |= (x >> 16);
    // x |= (x >> 32);
    
    /* count ones (population count) */
    x -= ((x >> 1) & 0x5555555555555555);
    x = ((x >> 2) & 0x3333333333333333) + (x & 0x3333333333333333);
    x = ((x >> 4) + x) & 0x0f0f0f0f0f0f0f0f;
    x += (x >> 8);
    x += (x >> 16);
    // x += (x >> 32);

    return (32 - (x & 0x7f));
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

int fmaxstr1(unsigned x, int *apos) {   
    unsigned y;   
    int s;   
    if (x == 0) {*apos = 32; return 0;}   
    y = x & (x << 1);   
    if (y == 0) {s = 1; goto L1;}   
    x = y & (y << 2);   
    if (x == 0) {s = 2; x = y; goto L2;}   
    y = x & (x << 4);   
    if (y == 0) {s = 4; goto L4;}   
    x = y & (y << 8);   
    if (x == 0) {s = 8; x = y; goto L8;}   
    if (x == 0xFFFF8000) {*apos = 0; return 32;}   
    s = 16; 
    
    L16: y = x & (x << 8);     
    if (y != 0) {s = s + 8; x = y;} 

    L8:  y = x & (x << 4);     
    if (y != 0) {s = s + 4; x = y;} 

    L4:  y = x & (x << 2);     
    if (y != 0) {s = s + 2; x = y;} 

    L2:  y = x & (x << 1);     
    if (y != 0) {s = s + 1; x = y;} 
    L1:  *apos = clz(x);   
    return s; 
}

int main()
{
    // 0011 1111 1111 
    uint32_t y = 0x0Af3f3f8;

    int *z;
    printf("%d\n",maxstr1(y));
    printf("%d\n", fmaxstr1(y,z));
    printf("%d\n",*z);
    
    return 0;
}