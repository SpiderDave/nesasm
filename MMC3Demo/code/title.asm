drawTitle:
    bit PPUSTATUS       ; Reset address latch flip-flop
    lda #$20
    sta PPUADDR         ; Write address high byte to PPU
    lda #$00
    sta PPUADDR         ; Write address low byte to PPU

    ; - Blank nametable ------------
    lda #$00            ; Tile
    ldx #$f0
-
    sta PPUDATA
    sta PPUDATA
    sta PPUDATA
    sta PPUDATA
    dex
    cpx #$00
    bne -
    ; ------------------------------

    ; ------------------------------
    bit PPUSTATUS       ; Reset address latch flip-flop
    lda #$23
    sta PPUADDR         ; Write address high byte to PPU
    lda #$c0
    sta PPUADDR         ; Write address low byte to PPU

    lda #$00
    ldx #$40
-
    sta PPUDATA
    dex
    cpx #$00
    bne -
    ; ------------------------------

    lda #$04            ; Title message
    jsr print
    lda #$02            ; version
    jsr print
    
    lda #$00
    jsr setLeftCHR
    lda #$0c
    jsr setRightCHR

rts

title:
    jsr readJoy

    lda buttonsRelease
    cmp #$10
    bne title
    lda #$04
    jsr setRightCHR

    lda #mode_playing
    sta mode
    jsr loadLevel
    jmp mainLoop
