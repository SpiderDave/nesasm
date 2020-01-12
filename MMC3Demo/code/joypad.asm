readJoy:
    lda buttons
    sta buttonsRelease

    lda buttons
    sta buttonsPress

    jsr readJoy2
reread:
    lda buttons
    pha
    jsr readJoy2
    pla
    cmp buttons
    bne reread


    lda buttonsPress
    eor buttons
    and buttons
    sta buttonsPress
    
    lda buttons
    eor #$ff
    and buttonsRelease
    sta buttonsRelease
    rts

readJoy2:
; At the same time that we strobe bit 0, we initialize the ring counter
; so we're hitting two birds with one stone here
    lda #$01
    ; While the strobe bit is set, buttons will be continuously reloaded.
    ; This means that reading from JOY1 will only return the state of the
    ; first button: button A.
    sta JOY1
    sta buttons
    lsr a        ; now A is 0
    ; By storing 0 into JOY1, the strobe bit is cleared and the reloading stops.
    ; This allows all 8 buttons (newly reloaded) to be read from JOY1.
    sta JOY1
joypadLoop:
    lda JOY1
    lsr a           ; bit0 -> Carry
    rol buttons  ; Carry -> bit0; bit 7 -> Carry
    bcc joypadLoop
    rts
