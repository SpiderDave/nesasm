include code\ggsound\ggsound.inc

; ines header
    .db "NES",$1A                                 ; iNES signature
    .db $04                                       ; Number of 0x4000 PRG ROM banks
    .db $01                                       ; Number of 0x2000 CHR ROM banks
    .db $41                                       ; Mirroring and mapper lower nibble
    .db $00                                       ; mapper upper nibble

    .db $00,$00,$00,$00,$00,$00,$00,$00           ; unused 

; Zero page variables
    .base $0000
    .enum $0000

    include code\zeroPage.asm
    include code\ggsound\ggsound_zp.inc
    
    .ende


; RAM variables
    .base $0200
    .enum $0200
    
    include code\ram.asm
    include code\ggsound\ggsound_ram.inc
    
    .ende


.include code\banks.asm
.include code\nesRegisters.asm
.include code\constants.asm

.include code\mmc3.asm

.include code\printer.asm
.include code\palettes.asm

.include code\messages.asm

.include code\sprites.asm

NMI:
    lda #$00
    sta vblanked
    
    pha
    txa
    pha
    tya
    pha
    php
    
    lda #$02
    jsr BankSwap
    
    soundengine_update
    
    jsr RestoreBank
    
    lda #$01
    sta vblanked
    
    plp
    pla
    tay
    pla
    tax
    pla
    
    rti
IRQ:
    rti

Reset:
    .include code\reset.asm
    
main:
    jsr removeAllSprites
    
    lda #$00            ; load main display message
    jsr print
    
    lda #$02            ; load version display message
    jsr print
    
    lda #$00            ; Use default palette
    jsr loadPalette
    
    lda #$02
    jsr BankSwap

    ;initialize modules
    lda SOUND_REGION_NTSC
    tax
    sta sound_param_byte_0
    lda #<(song_list)
    sta sound_param_word_0
    lda #>(song_list)
    sta sound_param_word_0+1
    lda #<(sfx_list)
    sta sound_param_word_1
    lda #>(sfx_list)
    sta sound_param_word_1+1
    lda #<(instrument_list)
    sta sound_param_word_2
    lda #>(instrument_list)
    sta sound_param_word_2+1
    lda #<dpcm_list
    sta sound_param_word_3
    lda #>dpcm_list
    sta sound_param_word_3+1
    jsr sound_initialize
    
    lda #$02
    sta current_song
    sta sound_param_byte_0
    jsr play_song
    
    jsr RestoreBank

    
mainLoop:
    jsr waitframe
    jsr readJoy
    
    lda buttonsPress
    cmp #$80                ; Check if A pressed
    bne buttonNotPressed    ; branch if not
    
    lda #$00                ; Turn off rendering
    sta PPUMASK
    jsr waitframe
    
    lda #$01                ; Disable sound engine updates
    sta sound_disable_update
    
    jsr showError
    
    lda #%00011110          ; Turn on rendering
    sta PPUMASK
    jsr waitframe
    
    lda #$02
    jsr BankSwap
    
    lda #$03
    sta current_song
    sta sound_param_byte_0
    jsr play_song
    
    jsr RestoreBank
    
    lda #$00                ; Enable sound engine updates
    sta sound_disable_update
    
buttonNotPressed:
    ;bit PPUSTATUS
    lda #$00
    sta PPUSCROLL
    lda #$00
    sta PPUSCROLL
    lda #$1a
    sta PPUMASK
    
    ;lda #$80
    lda #$90
    sta PPUCTRL
    
    lda #$02
    sta OAMDMA
    
    jmp mainLoop
    
showError:
    
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



