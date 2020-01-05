;;; Init CPU
    sei
    cld
    jsr MMC3Setup
    ldx #$c0
    stx JOY2
    ldx #$00
    stx APUSTATUS
    
    ldx #$ff
    txs
    inx
    stx PPUCTRL
    
    stx PPUMASK

    lda #$08
    sta $4011

;;; Init machine
wait0001:
    bit PPUSTATUS
    bpl wait0001

    lda #$10
    sta $4011

    ldx #$00
    ldy #$ef
    txa
ramclrloop:
    sta $00,x
    sta $100,x
    sta $200,x
    sta $300,x
    sta $400,x
    sta $500,x
    sta $600,x
    sta $700,x
    inx
    bne ramclrloop
    
    ;initialize sprites
    lda #$EF
ramclrloop2:
    sta $200,x
    inx
    bne ramclrloop2

    lda #$14
    sta $4011

wait0002:
    bit PPUSTATUS
    bpl wait0002

    lda #%10000000
    sta PPUCTRL
    
clear_vram:
    lda #$00
    sta PPUADDR
    sta PPUADDR
    tay
    ldx #$06
clear_loop:
    sta PPUDATA
    sta PPUDATA
    sta PPUDATA
    sta PPUDATA
    sta PPUDATA
    sta PPUDATA
    sta PPUDATA
    sta PPUDATA
    dey
    bne clear_loop
    dex
    bne clear_loop
    
    ;sprite DMA
    lda #$02
    sta OAMDMA



