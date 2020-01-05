; ines header
      .db "NES",$1A                                 ; iNES signature
      .db $04                                       ; Number of 0x4000 PRG ROM banks
      .db $01                                       ; Number of 0x2000 CHR ROM banks
      .db $41                                       ; Mirroring and mapper lower nibble
      .db $00                                       ; mapper upper nibble
      
      .db $00,$00,$00,$00,$00,$00,$00,$00           ; unused 


.include code\banks.asm
.include code\nesRegisters.asm
.include code\constants.asm

.include code\mmc3.asm

.include code\printer.asm
.include code\palettes.asm

.include code\messages.asm

NMI:
    inc vblanked
    rti
IRQ:
    rti

Reset:
    .include code\reset.asm
    
main:
    lda #$00            ; load main display message
    jsr print
    
    lda #$00            ; Use default palette
    jsr loadPalette
    
mainLoop:
    jsr readJoy
    
    jsr waitframe
    lda buttonsPress
    cmp #$80
    bne buttonNotPressed
    
    ; execute code here when pressing A
    jsr showError
    
buttonNotPressed:
    ;bit PPUSTATUS
    lda #$00
    sta PPUSCROLL
    lda $40
    sta PPUSCROLL
    lda #$1a
    sta PPUMASK
    
    ;lda #$80
    lda #$90
    sta PPUCTRL
    
    jmp mainLoop
    
showError:
    lda #$02
    sta OAMDMA
    
    lda #$01            ; load error message
    jsr print

    lda #$01            ; Use error palette
    jsr loadPalette

    rts

readJoy:
    .include code\joypad.asm

waitframe:
    lda #$00
    sta vblanked
waitloop:
    lda vblanked
    beq waitloop
    rts

    .org $fffa
    
    .dw NMI
    .dw Reset
    .dw IRQ

.incbin data/chr00.chr



