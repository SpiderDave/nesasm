removeAllSprites:
    ldy #$00
    lda #$f8
removeSprites_loop:
    sta SpriteY,y
    iny
    iny
    iny
    iny
    bne removeSprites_loop
    rts