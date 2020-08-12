; Load a palette given the palette number (A register) and slot (Y register).
loadPalette:
    tax
    
    lda #$3F
    sta PPUADDR
    tya
    asl
    asl
    sta PPUADDR
    
    lda Palettes_low, x
    sta temp16
    lda Palettes_high, x
    sta temp16+1
    
    ldy #$00
    ldx #$04
loadPalette_loop:
    lda (temp16),y
    sta PPUDATA
    iny
    dex
    bne loadPalette_loop
    
    rts

