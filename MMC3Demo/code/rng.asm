; Returns a random 8-bit number in A (0-255)
;
; Requires a 2-byte value on the zero page called "seed".
; Initialize seed to any value except 0 before the first call to prng.
; (A seed value of 0 will cause prng to always return 0.)
;
; This is a 16-bit Galois linear feedback shift register with polynomial $0039.
; The sequence of numbers it generates will repeat after 65535 calls.
rng:
    lda seed+1
    pha ; store copy of high byte
    ; compute seed+1 ($39>>1 = %11100)
    lsr ; shift to consume zeroes on left...
    lsr
    lsr
    sta seed+1 ; now recreate the remaining bits in reverse order... %111
    lsr
    eor seed+1
    lsr
    eor seed+1
    eor seed+0 ; recombine with original low byte
    sta seed+1
    ; compute seed+0 ($39 = %111001)
    pla ; original high byte
    sta seed+0
    asl
    eor seed+0
    asl
    eor seed+0
    asl
    asl
    asl
    eor seed+0
    sta seed+0
    rts