loadLevel:
    lda #$01
    sta skipNMI                 ; skip (most of) NMI code.
    

    LDA #$00                    ; Turn off rendering
    sta PPUMASK
    jsr waitframe

    lda #$05                    ; Use palette 05
    ldy #$01                    ; Put in palette slot 1
    jsr loadPalette

    ; Draw random stars ----------
    bit PPUSTATUS               ; Reset address latch flip-flop
    lda #$20
    sta PPUADDR                 ; Write address high byte to PPU
    lda #$20
    sta PPUADDR                 ; Write address low byte to PPU

    ldy #$e8
--
    ldx #$04
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
    
    ; -- Draw top tiles ----------
    lda #$20
    sta PPUADDR                 ; Write address high byte to PPU
    lda #$80
    sta PPUADDR                 ; Write address low byte to PPU
    
    ldy #$10
-
    lda #$20                    ; Tile upper left
    sta PPUDATA
    lda #$21                    ; tile upper right
    sta PPUDATA
    dey
    bne -

    ldy #$10
-
    lda #$30                    ; Tile lower left
    sta PPUDATA
    lda #$31                    ; Tile lower right
    sta PPUDATA
    dey
    bne -
    ; ----------------------------
    
    ; -- Draw bottom tiles -------
    lda #$23
    sta PPUADDR                 ; Write address high byte to PPU
    lda #$20
    sta PPUADDR                 ; Write address low byte to PPU
    
    ldy #$10
-
    lda #$20                    ; Tile upper left
    sta PPUDATA
    lda #$21                    ; Tile upper right
    sta PPUDATA
    dey
    bne -

    ldy #$10
-
    lda #$30                    ; Tile lower left
    sta PPUDATA
    lda #$31                    ; Tile lower right
    sta PPUDATA
    dey
    bne -
    ; ----------------------------
    
    ; -- top blocks attributes ----
    lda #$23
    sta PPUADDR                 ; Write address high byte to PPU
    lda #$c8
    sta PPUADDR                 ; Write address low byte to PPU
    
    lda #$05                    ; Attributes
    ldy #$08
-
    sta PPUDATA
    dey
    bne -
    ; -----------------------------
    
    ; -- bottom blocks attributes --
    lda #$23
    sta PPUADDR                 ; Write address high byte to PPU
    lda #$f0
    sta PPUADDR                 ; Write address low byte to PPU
    
    lda #$55                    ; Attributes
    ldy #$08
-
    sta PPUDATA
    dey
    bne -
    ; -----------------------------
    
    lda #$03                    ; print hud
    jsr print
    
    bit PPUSTATUS               ; Reset address latch flip-flop
    lda #$00                    ; reset PPU address to avoid glitches.
    sta PPUADDR
    sta PPUADDR
    lda scrollX_hi
    sta PPUSCROLL               ; reset Scroll since some of this stuff corrupts it.
    lda scrollY_hi
    sta PPUSCROLL
    
    jsr waitframe
    lda #$1e                    ; Turn on rendering
    sta PPUMASK


    lda #$00
    sta skipNMI

rts