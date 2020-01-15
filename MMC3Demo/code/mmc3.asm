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
    
; setLeftCHR sets both left CHR banks
; setRightCHR sets all 4 right CHR banks
;
; The chr is divided like this (but it can be 
; inverted to switch which side gets 2 and which
; side gets 4 banks).
;
;______________________  ______________________
;| 0                  |  | 2                  |
;|                    |  |____________________|
;|                    |  | 3                  |
;|____________________|  |____________________|
;| 1                  |  | 4                  |
;|                    |  |____________________|
;|                    |  | 5                  |
;|____________________|  |____________________|

    
setLeftCHR:
    ; left chr
    sta temp1
    lda #$00
    sta $8000
    lda temp1
    asl
    asl
    asl
    ora #$00
    sta $8001

    lda #$01
    sta $8000
    lda temp1
    asl
    asl
    asl
    ora #$02
    sta $8001
rts


setRightCHR:
    ; right chr
    sta temp1
    lda #$02
    sta $8000
    lda temp1
    asl
    asl
    asl
    ora #$04
    sta $8001

    lda #$03
    sta $8000
    lda temp1
    asl
    asl
    asl
    ora #$05
    sta $8001

    lda #$04
    sta $8000
    lda temp1
    asl
    asl
    asl
    ora #$06
    sta $8001

    lda #$05
    sta $8000
    lda temp1
    asl
    asl
    asl
    ora #$07
    sta $8001
rts
