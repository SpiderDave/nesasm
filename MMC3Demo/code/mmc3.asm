MMC3Setup:
    lda #$00
    sta $8000
    sta $8001
    sta $a000
    sta $a001
    sta $c000
    sta $c001
    sta $e000
    ldx #$05
LoopMMC3Setup:
    stx $8000
    lda MMC3SetupTable,x
    sta $8001
    dex
    bpl LoopMMC3Setup
    rts
MMC3SetupTable:
    .db $00, $02, $04, $05, $06, $07

; restores $10-$4000 rom, back to $8000-$BFFF ram
RestoreBank:
    lda #$00
    jsr BankSwap
    rts
        
; Bankswap routine
; example usage:
;
;    lda #$01
;    jsr BankSwap
;
;    jsr somewhere_in_bank_01
;
;    jmp RestoreBank
;    rts
BankSwap:
    pha
    asl
    pha
    lda #$06
    sta $8000
    pla
    sta $8001
    ora #$01
    pha
    lda #$07
    sta $8000
    pla
    sta $8001
    pla
    rts

setMirroring:
    sta $a000
    rts