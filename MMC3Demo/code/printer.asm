print:
    tay
    lda (messages_lo),y
    sta temp16
    lda (messages_hi),y
    sta temp16+1
    
    ldy #$ff
print_next:
    iny
    lda (temp16),y
    beq print_done
    sta PPUADDR
    iny
    lda (temp16),y
    sta PPUADDR
    iny
print_loop:
    lda (temp16),y
    beq print_next
    sta PPUDATA
    iny
    bne print_loop
print_done:
    rts
