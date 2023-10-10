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

fmaxstr:
    # a0: unsinged x
    # a1: address of apos
    mv s0, a0 # s0: x
    li s1, 0 # s1: y
    mv s2, a1 # s2: *apos
    li s3, 0 # s3: s

    bne x0, s0, skip_0
    li t0, 32 # set t0 as 32
    sw t0, 0(s2) # store t0 into apos
    li a0, 0 # retrun 0
    jr ra
    skip_0:
    
    srli t0, s0, 1 # t0 = x << 1
    and s1, s0, t0 # s1 = y, y = x & x << 1
    
    bne x0, s1 skip
    li s3, 1 # s = 1
    j L1
    skip:
    
    srli t1, s1, 2 # t1 = y << 2
    and s0, s1, t1 # x = y & y << 2
    
    bne x0, s0, skip_2
    li s3, 2 # s = 2
    mv s0, s1 # x = y
    j L2
    skip_2:
    
    srli t0, s0, 4 # t0 = x << 4
    and s1, s0, t0 # t1 = y = x & (x << 4 )
    
    bne x0, s1, skip_4
    li s3, 4 # s = 4
    j L4
    skip_4:
        
    srli t1, s1, 8 # y << 8 
    and s0, s1, t1 # x = y & y << 8
    
    bne x0, s0, skip_8
    li s3, 8 # s = 8
    mv s0, s1 # x = y
    j L8
    skip_8:
    
    la t0, w5 
    lw t0, 0(t0)
    bne s0, t0, skip_16
    lw x0, 0(x0) # *apos = 0
    li a0, 32
    jr ra # return 0
    skip_16:
        
    L16:
        srli t0, s0, 8 # x << 8
        and s1, s0, t0 # t1 = y, y = x & x << 8
        beq x0, t1, pass_16
        addi s3, s3, 8
        mv s0, t1
    
    pass_16:
        
    L8:
        srli t0, s0, 4 # x << 4
        and s1, s0, t0 # s1 = y, y = x & x << 4
        beq x0, t1, pass_8
        addi s2, s2, 4
        mv s0, s1
    pass_8:
     
        
    L4:
        # y = x & x << 2
        srli t0, s0, 2 # x << 2
        and s1, s0, t0  # s1 = y, y = x & x << 2
        beq x0, t1, pass_4
        addi s3, s3, 2
        mv s0, s1
    pass_4:
        
    L2:
        srli t0, s0, 1 # x << 2
        and s1, s0, t0  # t1 = y, y = x & x << 2
        beq x0, s1, pass_2
        addi s3, s3, 1
        mv s0, s1
    pass_2:
        
    L1:
        # clz(x)
        # put x into a0
        addi a0, s0, 0
        addi sp, sp, -12
        sw ra, 0(sp) # store ra
        sw s2, 4(sp)
        sw s3, 8(sp)
        jal clz
        lw a0, 0(s2) # *apos = clz(x)
        lw ra, 0(sp)
        lw s2, 4(sp)
        lw s3, 8(sp)
        addi sp, sp, 12
        
    add a0, s3, x0 # return s
    jr ra