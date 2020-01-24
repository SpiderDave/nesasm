pauseMusic:
    lda NEA
    beq +

    lda NEA_STATUS
    and #%00000001
    beq +
    
    lda #%00000001              ; pause/resume
    sta NEA_CONTROL
    
    rts
+

    lda #$02
    jsr BankSwap
    
    jsr pause_song
    
    jsr RestoreBank
    rts

; resume doesn't quite yet work for NEA
; need to track if it's nea or ggsound playing
resumeMusic:
    lda NEA
    beq +

    lda NEA_STATUS
    and #%00000001
    beq +

    lda #%00000001              ; pause/resume
    sta NEA_CONTROL
    
    rts
+
    lda #$02
    jsr BankSwap
    
    jsr resume_song
    
    jsr RestoreBank
    rts


playMusic:
    lda NEA
    beq +

    lda #%00000010              ; Make sure to stop music because it will
    sta NEA_CONTROL             ; continue if there's an error.

    lda current_song
    
    sta NEA_PLAYBGM             ; play music
    lda NEA_STATUS
    and #%00000100              ; Check for error
    beq +                       ; branch to play sound normally if so
    
    lda #$02                    ; stop normal music
    jsr BankSwap
    lda #$ff
    sta sound_param_byte_0
    jsr play_song
    jsr RestoreBank
    
    rts
+
    lda #$02
    jsr BankSwap
    
    lda current_song
    sta sound_param_byte_0
    jsr play_song
    
    jsr RestoreBank
rts

playSfx:
    pha
    lda NEA
    beq +
    pla
    sta NEA_PLAYSFX
    pha
    lda NEA_STATUS
    and #%00000100
    beq +
    pla
    rts
+
    lda #$02
    jsr BankSwap

    pla
    sta sound_param_byte_0
    lda #soundeffect_one
    sta sound_param_byte_1
    jsr play_sfx
    
    jsr RestoreBank
rts


CheckNEA:
    lda NEA_SIGNATURE
    cmp #'N'
    bne +
    lda NEA_SIGNATURE+1
    cmp #'E'
    bne +
    lda NEA_SIGNATURE+2
    cmp #'A'
    bne +
    lda #$01
    sta NEA
+
rts

initSound:
    if USE_NEA
        jsr CheckNEA                ; Check for Mesen HD Pack audio API
    endif
    
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
    ifdef sfx_list
        lda #<(sfx_list)
        sta sound_param_word_1
        lda #>(sfx_list)
        sta sound_param_word_1+1
    endif
    lda #<(instrument_list)
    sta sound_param_word_2
    lda #>(instrument_list)
    sta sound_param_word_2+1
    ifdef dpcm_list
        lda #<dpcm_list
        sta sound_param_word_3
        lda #>dpcm_list
        sta sound_param_word_3+1
    endif
    jsr sound_initialize
    
    jsr RestoreBank
rts