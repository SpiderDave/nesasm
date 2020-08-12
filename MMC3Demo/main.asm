; asm6

; iNES header
    .db "NES",$1A                               ; iNES signature
    .db $04                                     ; Number of 0x4000 PRG ROM banks
    .db $02                                     ; Number of 0x2000 CHR ROM banks
    .db $41                                     ; Mirroring and mapper lower nibble
    .db $00                                     ; mapper upper nibble

    .db $00,$00,$00,$00,$00,$00,$00,$00         ; unused 

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

; Include constants, macros
include code\ggsound\ggsound.inc                ; GGSound
include code\nesRegisters.asm                   ; various NES-specific constants
include code\constants.asm                      ; other constants
include code\nea.asm                            ;
include code\banks.asm                          ; Bank asignments

; Now we are in the fixed bank at $c000
include code\joypad.asm
include code\printer.asm                        ; Screen print routine
include code\messages.asm
include code\paletteLoader.asm
include code\palettes.asm
include code\sprites.asm                        ; Sprite-related routines
include code\rng.asm                            ; Random number generator
;include code\jumpEngine.asm
include code\objects.asm                        ; load and handle game objects
include code\objectData.asm                     ; game object data
include code\collision.asm                      ; handle object collision
include code\bounds.asm                         ; handle object bounds
include code\timers.asm                         ; various timers
include code\stage.asm
include code\title.asm
include code\sound.asm
include code\sine.asm


NMI:
    pha                         ; push a,x,y on to the stack
    txa
    pha
    tya
    pha
    
    lda skipNMI                 ; This is for when we want to skip most of
    bne skipNMIStuff            ; the NMI, like when loading a lot of stuff.
    
    lda #$0c
    jsr setRightCHRDirect       ; Set CHR to hud tiles.  We use "Direct" here because it's temporary.

    ; hud irq stuff
    lda #$1e                    ; This value only matters for $c000 and $c001
    sta $e000                   ; Acknowledge any pending interrupts
    sta $c000                   ; Set IRQ counter to number of scanlines to wait
    sta $c001                   ; Write it again to the IRQ counter latch
    sta $e001                   ; Enable IRQ
    
    
    lda #$02                    ; transfer sprites from $0200 to the ppu
    sta OAMDMA
    
    jsr writeBufferToPPU
    
    lda #$90
    sta PPUCTRL
    
    ; Have to reset Scroll since some of this stuff corrupts it.
    ; Also, since we have a hud we'll set it to the hud scroll values.
    ; The game scroll values will be set in the irq.
    ;
    bit PPUSTATUS               ; Reset address latch flip-flop
    lda #$00                    ; reset PPU address to avoid glitches.
    sta PPUADDR
    sta PPUADDR
    lda #$fa                    ; Set this to give a little bit of padding to the hud text.  Neat!
    sta PPUSCROLL
    sta PPUSCROLL
    
skipNMIStuff:
    
    lda #$02
    jsr BankSwap
    
    soundengine_update
    
    jsr RestoreBank
    
    lda #$01
    sta vblanked
    
    pla                         ; pull y,x,a off the stack
    tay
    pla
    tax
    pla
    
    rti
IRQ:
    pha                         ; push a,x,y on to the stack
    txa
    pha
    tya
    pha

    sta $e000                   ; Acknowledge the IRQ and disable.
    
    bit PPUSTATUS               ; Reset address latch flip-flop
    lda scrollX_hi              ; Set our scroll values here after the hud split.
    sec
    sbc #$06
    sta PPUSCROLL
    lda scrollY_hi
    sec
    sbc #$06
    sta PPUSCROLL
    
    jsr setCHR                  ; Set CHR banks based on CHR0, CHR1, etc.
    
    pla                         ; pull y,x,a off the stack
    tay
    pla
    tax
    pla

    rti

; The reset vector and mmc3 initialize code must point into $E000-$FFFF
; because the state of the mapper at power-on is unspecified.
.pad $e000
include code\mmc3.asm

Reset:
    include code\reset.asm
main:
    lda #$01                    ; set mirroring to horizontal
    jsr setMirroring
    
    lda #$40                    ; disable frame counter to make irq work
    sta $4017
    
    cli                         ; Clear interrupt Disable Bit (so we can use irqs)
    
    lda #$01
    sta skipNMI                 ; skip (most of) NMI code.
    
    lda #$01
    sta mode
    
    LDA #$00
    sta PPUMASK
    jsr waitframe
    
    jsr drawTitle
    
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
    
    jsr removeAllSprites
    
    lda #$00                    ; Use palette 00
    ldy #$00                    ; Put in palette slot 0
    jsr loadPalette
    
    lda #$00                    ; Use palette 00
    ldy #$04                    ; Put in palette slot 4
    jsr loadPalette
    
    lda #$02                    ; Use palette 02
    ldy #$05                    ; Put in palette slot 5
    jsr loadPalette
    
    lda #$03                    ; Use palette 03
    ldy #$06                    ; Put in palette slot 6
    jsr loadPalette
    
    lda #$04                    ; Use palette 04
    ldy #$07                    ; Put in palette slot 7
    jsr loadPalette

    jsr loadObjects
    
    ; test objects
;    lda #$05
;    jsr createObject
;    lda #$60
;    sta objectX_hi,x
;    sta objectY_hi,x
;    lda #$60
;    sta objectVelocityY,x
;    lda #$00
;    sta objectVelocityY_hi,x
    
    
;    lda #$05
;    jsr createObject
;    lda #$60
;    sta objectX_hi,x
;    sta objectY_hi,x
;    lda #$9f
;    sta objectVelocityY,x
;    lda #$ff
;    sta objectVelocityY_hi,x
    
    ;jsr waitframe               ; Crashes without this after removing some code from here
    
    jsr initSound
    
;    lda #$00
;    sta current_song
;    jsr playMusic
    
    lda #$1e                    ; Turn on rendering
    sta PPUMASK
    
    jmp title                   ; Display title screen
    
mainLoop:
    jsr waitframe
    jsr readJoy
    
    lda paused
    beq +
    jsr pauseMusic
    lda buttonsPress
    cmp #JOY_SELECT             ; Press select while paused to reset
    bne +
    jmp Reset
+
    
    lda buttonsPress
    cmp #JOY_START              ; Pause
    bne +
    lda paused
    eor #$01
    sta paused
    bne +
    jsr resumeMusic
+
    lda paused
    bne mainLoop
    
    jsr handleTimers
    
    
    lda timer1                  ; generate enemies based on timer
    asl
    asl
    asl
    cmp #$08
    bne +
    lda #$04
    jsr createObject
    lda #$f8
    sta objectX_hi,x
    jsr rng
    lsr
    adc #$40
    sta objectY_hi,x
    lda #$2f
    sta objectVelocityX,x
    lda #$ff
    sta objectVelocityX_hi,x
    jsr rng
    and #$7f
    sta temp
    sta objectVelocityX,x
    sbc temp
+
    lda scrollX                 ; Scroll the level
    clc
    adc #scrollSpeed
    sta scrollX
    lda scrollX_hi
    adc #scrollSpeed_hi
    sta scrollX_hi
    
    lda scrollX_page
    adc #$00
    sta scrollX_page
    
    jsr handleObjects
    
    jsr checkCollision
    
    lda buttons
    and #JOY_UP                 ;up
    beq +
    lda objectY
    sec
    sbc #shipSpeed
    sta objectY
    lda objectY_hi
    sbc #shipSpeed_hi
    sta objectY_hi
    jmp ++
+
    lda buttons
    and #JOY_DOWN               ;down
    beq +
    lda objectY
    clc
    adc #shipSpeed
    sta objectY
    lda objectY_hi
    adc #shipSpeed_hi
    sta objectY_hi
    jmp ++
+
++
    lda buttons
    and #JOY_LEFT               ;left
    beq +
    lda objectX
    sec
    sbc #shipSpeed
    sta objectX
    lda objectX_hi
    sbc #shipSpeed_hi
    sta objectX_hi
    jmp ++
+
    lda buttons
    and #JOY_RIGHT              ;right
    beq +
    lda objectX
    clc
    adc #shipSpeed
    sta objectX
    lda objectX_hi
    adc #shipSpeed_hi
    sta objectX_hi
    jmp ++
+
++
    lda buttons
    and #JOY_B                  ;B
    beq +
    
    
    lda shootCooldown
    bne +
    
    lda #$01
    jsr playSfx
    
    lda #$02                    ; laser
    jsr createObject
    lda objectX_hi
    sta objectX_hi,x
    lda objectY_hi
    sta objectY_hi,x
    lda #$0c
    sta objectVelocityX_hi,x
    
    lda #$03                    ; laser
    jsr createObject
    lda objectX_hi
    sec
    sbc #$08
    sta objectX_hi,x
    lda objectY_hi
    sta objectY_hi,x
    lda #$0c
    sta objectVelocityX_hi,x
    
    lda #$06
    sta shootCooldown
    
    jmp ++
+

;    angle = 45
;    angle2 = 45+90
    angle = $01
    angle2 = #angle+$40
    lda buttonsRelease
    cmp #$20                    ;select
    bne ++
    ;lda timer1
    
    lda #angle2
    jsr sin_A
    
    sta objectVelocityX
    
    lda #angle
    jsr cos_A
    
    sta objectVelocityY
    
    lda #angle * 360/256
    jsr convertNumber
    
    ldx buffer1Offset
    
    lda #$20
    sta buffer1,x
    inx
    lda #$40
    sta buffer1,x
    inx
    lda #$03
    sta buffer1,x
    inx
    
    ldy hundreds
    lda hexTable, y
    sta buffer1,x
    inx
    ldy tens
    lda hexTable, y
    sta buffer1,x
    inx
    ldy ones
    lda hexTable, y
    sta buffer1,x
    inx
    stx buffer1Offset
++
    lda buttonsPress
    cmp #JOY_SELECT
    bne ++
    lda current_song
    cmp #sfx_num_tracks - 1
    bne +
    lda #$ff
    sta current_song
+
    inc current_song
    jsr playMusic
++
    jmp mainLoop

convertNumber:
    ldx #$00
    ldy #$00
-
    stx hundreds,y
    iny
    cpy #$03
    bne -
    ldy #$02
-
    cmp decimalPlaceValues, y
    bcc +
    sbc decimalPlaceValues, y
    inc hundreds,x
    jmp -
+
    cpy #$00
    beq +
    dey
    inx
    jmp -
+
rts

decimalPlaceValues:
    .db $01, $0a, $64

writeBufferToPPU:
    lda buffer1Offset
    beq bufferDone      ; If the buffer offset is 0, it's empty.  Skip to end.
    
    ldx #$00            ; Initialize x for our buffer index
bufferLoop1:
    ldy #$00
    
    bit PPUSTATUS       ; Reset address latch flip-flop
    lda buffer1,x       ; Load first byte from our buffer chunk
    sta PPUADDR         ; Write address high byte to PPU
    inx
    lda buffer1,x       ; Load first byte from our buffer chunk
    sta PPUADDR         ; Write address low byte to PPU
    inx
    
    lda buffer1,x       ; Get length of this chunk
    tay                 ; Store in y to indicate when this chunk is done
    inx
bufferLoop2:
    lda buffer1,x       ; Get next byte from buffer
    sta PPUDATA         ; Store byte in PPU
    inx                 ; Increase buffer index
    dey                 ; Decrease y
    bne bufferLoop2     ; If y is not 0, we haven't reached the end of this chunk
    
    cpx buffer1Offset   ; Check if our buffer index in x matches the stored buffer offset
    bne bufferLoop1     ; If not, read another chunk
    
    lda #$00            ; Reset our stored buffer offset
    sta buffer1Offset
bufferDone:
    rts

waitframe:
    lda #$00
    sta vblanked
waitloop:
    lda vblanked
    beq waitloop
    rts

; with ggsound, DPCM data MUST be at $C000 or later
.align 64
;include code\ggsound\track_dpcm.inc
include code\ggsound\shmup_dpcm.asm


    .org $fffa

    .dw NMI
    .dw Reset
    .dw IRQ

.incbin data/chr00.chr
.incbin data/chr01.chr
.incbin data/chr02.chr
.incbin data/chr03.chr
