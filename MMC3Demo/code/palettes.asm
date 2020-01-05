loadPalette:
    tax
    
    lda #$3F
    sta PPUADDR
    lda #$00
    sta PPUADDR
    
    lda palettes_lo, x
    sta temp16
    lda palettes_hi, x
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

palettes_lo:
    .db <palette00, <palette01, <palette02, <palette03, <palette04, <palette05, <palette06, <palette07, <palette08, <palette09
palettes_hi:
    .db >palette00, >palette01, >palette02, >palette03, >palette04, >palette05, >palette06, >palette07, >palette08, >palette09
    
palette00:
    .db $0F, $21, $11, $01
palette01:
    .db $0F, $26, $16, $06
palette02:
palette03:
palette04:
palette05:
palette06:
palette07:
palette08:
palette09:
    .db $0F, $20, $10, $00