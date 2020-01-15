loadLevel:

    lda #$05                    ; Use palette 05
    ldy #$01                    ; Put in palette slot 1
    jsr loadPalette

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
    ; ----------------------------

    lda #$23
    sta PPUADDR         ; Write address high byte to PPU
    lda #$40
    sta PPUADDR         ; Write address low byte to PPU
    
    ldy #$10
-
    lda #$20
    sta PPUDATA
    lda #$21
    sta PPUDATA
    dey
    bne -

    ldy #$10
-
    lda #$30
    sta PPUDATA
    lda #$31
    sta PPUDATA
    dey
    bne -

    lda #$20
    sta PPUADDR         ; Write address high byte to PPU
    lda #$80
    sta PPUADDR         ; Write address low byte to PPU
    
    ldy #$10
-
    lda #$20
    sta PPUDATA
    lda #$21
    sta PPUDATA
    dey
    bne -

    ldy #$10
-
    lda #$30
    sta PPUDATA
    lda #$31
    sta PPUDATA
    dey
    bne -

    ; -- top blocks attributes ----
    lda #$23
    sta PPUADDR         ; Write address high byte to PPU
    lda #$c8
    sta PPUADDR         ; Write address low byte to PPU
    
    lda #$05
    ldy #$09
-
    sta PPUDATA
    dey
    bne -
    ; -----------------------------

    ; -- bottom blocks attributes --
    lda #$23
    sta PPUADDR         ; Write address high byte to PPU
    lda #$f0
    sta PPUADDR         ; Write address low byte to PPU
    
    lda #$50
    ldy #$09
-
    sta PPUDATA
    dey
    bne -
    ; -----------------------------


rts