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

setCHR:
    lda #$00
    sta $8000
    lda CHR0
    sta $8001

    lda #$01
    sta $8000
    lda CHR1
    sta $8001
    
    lda #$02
    sta $8000
    lda CHR2
    sta $8001

    lda #$03
    sta $8000
    lda CHR3
    sta $8001

    lda #$04
    sta $8000
    lda CHR4
    sta $8001

    lda #$05
    sta $8000
    lda CHR5
    sta $8001
rts
    
setLeftCHR:
    tax
    stx CHR0
    inx
    inx
    stx CHR1
    jsr setCHR
rts
setRightCHR:
    tax
    stx CHR2
    inx
    stx CHR3
    inx
    stx CHR4
    inx
    stx CHR5
    jsr setCHR
rts
    
setLeftCHRDirect:
    tax
    lda #$00
    sta $8000
    stx $8001

    lda #$01
    sta $8000
    inx
    inx
    stx $8001
rts


setRightCHRDirect:
    tax
    lda #$02
    sta $8000
    stx $8001
    
    lda #$03
    sta $8000
    inx
    stx $8001
    
    lda #$04
    sta $8000
    inx
    stx $8001
    
    lda #$05
    sta $8000
    inx
    stx $8001
rts
