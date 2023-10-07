.data
w1: .word 0x55555555
w2: .word 0x33333333
w3: .word 0x0f0f0f0f
w4: .word 0x0000007f

test: .word 0x00000001

.text
main:
    
    la t0, test
    lw a0, 0(t0)
    jal clz
    
    li, a7, 1
    ecall
    
    # ecalls in ripes:
    # loading some values into 'a7' register and call 'ecall' can envoke corrsponding envirment calls
    # e.g. 10 is for exiting program
    # Exit program
    li a7, 10
    ecall
    
clz:
    # a0 shold be argument passed into function clz
    # i.e. clz()
    mv s0, a0
    srli s1, s0, 1 # x >> 1
    or s0, s0, s1 # x |= (x >> 1);
    
    srli s1, s0, 2 
    or s0, s0, s1 # x |= (x >> 2); 
    
    srli s1, s0, 4 
    or s0, s0, s1 # x |= (x >> 4); 
    
    srli s1, s0, 8
    or s0, s0, s1 # x |= (x >> 8);
    
    srli s1, s0, 16
    or s0, s0, s1 # x |= (x >> 16);
    
    # load w1's address, which contains value 0x55555555
    # using 'la' instuction
    # la pseudoinstruction which is used to load symbol addresses
    
    la t0, w1
    lw t0, 0(t0)
        
    srli s1, s0, 1 # x >> 1
    and s1, s1, t0 # ((x >> 1) & 0x5555555555555555);
    sub s0, s0, s1 
    
    la t0, w2 
    lw t0, 0(t0)
    srli s1, s0, 2 # x >> 2
    and s1, s1, t0 # s1: x >> 2 + 0x33333333
    and s2, s0, t0 # s2: x & 0x33333333
    add s0, s1, s2 
    
    la t0, w3
    lw t0, 0(t0) # t0: 0x0f0f0f0f
    srli s1, s0, 4 # s1: x >> 4
    add s1, s0, s1 # s1 : x + x >> 4
    and s0, s1, t0 # s0 = ((x >> 4) + x) & 0x0f0f0f0f0f0f0f0f;
    
    srli s1, s0, 8
    add s0, s0, s1
    
    srli s1, s0, 16
    add s0, s0, s1
    
    la t0, w4
    lw t0, 0(t0)
    and s0, s0, t0 # x & 0x7f
    
    li t1, 32
    sub a0, t1, s0
    jr ra # return, can write as pseudocode 'ret'
