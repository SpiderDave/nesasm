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

.include code\printer.asm
.include code\palettes.asm

.include code\messages.asm

.include code\sprites.asm
.include code\rng.asm

NMI:
    pha                 ; push a,x,y on to the stack
    txa
    pha
    tya
    pha
    
    lda #$02            ; transfer sprites from $0200 to the ppu
    sta OAMDMA
    
    lda gameState
    bne +
    lda #$00            ; load main display message
    jsr print
    inc gameState
    
+

    lda gameState
    cmp #$02
    bne +
    jsr showError
    inc gameState
+
    
    lda #$02            ; load version display message
    jsr print
    
    lda #$00            ; palette 00
    
    ldy gameState
    cpy #$01
    beq +
    jsr rng             ; load a random number
    and #$03            ; limit to 0 - 3
+
    ldy #$00            ; palette slot 0
    
    jsr loadPalette
    
    lda #$90
    sta PPUCTRL
    
    lda #$00
    sta PPUADDR
    sta PPUADDR
    
    bit PPUSTATUS
    lda #$00
    sta PPUSCROLL
    lda #$00
    sta PPUSCROLL
    
    lda #$02
    jsr BankSwap
    
    soundengine_update
    
    jsr RestoreBank
    
    lda #$01
    sta vblanked
    
    pla                 ; pull y,x,a off the stack
    tay
    pla
    tax
    pla
    
    rti
IRQ:
    rti

; The reset vector and mmc3 initialize code must point into $E000-$FFFF
; because the state of the mapper at power-on is unspecified.
.pad $e000
.include code\mmc3.asm

Reset:
    .include code\reset.asm
main:
    jsr removeAllSprites
    inc seed                    ; Initialize rng with seed $0001
    
    jsr createStars
    
    ;ship
    ldy #$00
    lda #$04
    sta SpriteX,y
    lda #$30
    sta SpriteY,y
    lda #$00
    sta SpriteAttributes,y
    lda #$02
    sta spriteVelocityX,y
    lda #$10
    sta SpriteTile,y
    
    jsr waitframe               ; Crashes without this after removing some code from here
    
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
    
    lda #$1e                ; Turn on rendering
    sta PPUMASK
    
mainLoop:
    jsr waitframe
    jsr readJoy
    
    
    lda buttonsRelease
    cmp #$10                ; Reset if start was just released.
    bne +
    jmp Reset
+
    
    lda buttons
    and #$08                ;up
    cmp #$08
    bne +
    lda SpriteY
    sec
    sbc #$01
    sta SpriteY
    jmp ++
+
    lda buttons
    and #$04                ;down
    cmp #$04
    bne +
    lda SpriteY
    clc
    adc #$01
    sta SpriteY
    jmp ++
+
++
    lda buttons
    and #$02                ;left
    cmp #$02
    bne +
    lda SpriteX
    sec
    sbc #$01
    sta SpriteX
    jmp ++
+
    lda buttons
    and #$01                ;right
    cmp #$01
    bne +
    lda SpriteX
    clc
    adc #$01
    sta SpriteX
    jmp ++
+
++
    lda buttons
    and #$40                ;B
    cmp #$40
    bne +
    
    ldy #$04
    lda SpriteTile, y
    cmp #$13
    beq +
    
    jsr createLaser
    jmp ++
+

    lda buttonsPress
    cmp #$80                ; Check if A pressed
    bne buttonNotPressed    ; branch if not
    
    lda #$01                ; Disable sound engine updates
    sta sound_disable_update
    
    lda gameState
    cmp #$01
    bne +
    inc gameState

    lda #$02
    jsr BankSwap
    
    lda #$03
    sta current_song
    sta sound_param_byte_0
    jsr play_song
    
    jsr RestoreBank

+
    
    lda #$00                ; Enable sound engine updates
    sta sound_disable_update
    
++
buttonNotPressed:
    jsr handleStars
    
    jmp mainLoop
showError:
    lda #$01            ; load error message
    jsr print

    lda #$01            ; Use error palette
    ldy #$00            ; palette slot 0
    jsr loadPalette
    
    rts

handleStars:
    ldy #$10
-
    lda spriteVelocityX,y
    sta temp

    lda SpriteX,y
    sec
    sbc temp
    sta SpriteX,y
    iny
    iny
    iny
    iny
    bne -

    ; lasers
    ldy #$04
    ldx #$03
-
    lda #$f8
    sta SpriteY,y
    
    lda SpriteTile,y
    cmp #$12
    beq ++
    
    lda spriteVelocityX,y
    sta temp

    lda SpriteX,y
    clc
    adc temp
    sta SpriteX,y
    cmp #$f0
    bcc +
    
    lda #$12
    sta SpriteTile,y
+
    
    lda SpriteY
    sta SpriteY,y
++
    iny
    iny
    iny
    iny
    
    dex
    bne -


rts


createLaser:
    ldy #$04
    ldx #$03
-
    txa
    asl
    asl
    asl
    clc
    adc SpriteX
    sec
    sbc #$0f
    sta SpriteX,y
    lda SpriteY
    sta SpriteY,y
    lda #$00
    sta SpriteAttributes,y
    lda #$10
    sta spriteVelocityX,y
    lda #$13
    sta SpriteTile,y
    
    iny
    iny
    iny
    iny

    dex
    bne -

    rts

createStars:
    lda #$02            ; Use palette 02
    ldy #$04            ; palette slot 4
    jsr loadPalette
    
    
    ldy #$10
-
    jsr rng
    sta SpriteX,y
    jsr rng
    sta SpriteY,y
    lda #$20
    sta SpriteAttributes,y
    jsr rng
    and #$03
    sta spriteVelocityX,y
    clc
    adc #$02
    sta SpriteTile,y

    iny
    iny
    iny
    iny
    bne -
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



