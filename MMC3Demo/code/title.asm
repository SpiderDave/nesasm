drawTitle:
    ; Draw random stars ----------
    bit PPUSTATUS       ; Reset address latch flip-flop
    lda #$20
    sta PPUADDR         ; Write address high byte to PPU
    lda #$20
    sta PPUADDR         ; Write address low byte to PPU

    ldy #$00
--
    ldx #$10
-
    jsr rng
    ora #$f1
    
    cmp #$f4
    bcc + 
    lda #$00
+
    
    sta PPUDATA
    dex
    bne -
    dey
    bne --

    lda #$04
    jsr print
    
rts

title:
    jsr waitframe
    jsr readJoy

    lda buttonsRelease
    cmp #$10
    bne +
    lda #mode_playing
    sta mode
    jsr loadLevel
    jmp mainLoop
+
    
jmp title