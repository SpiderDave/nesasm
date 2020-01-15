checkCollision:
        ldx #$00
-
        lda objectType,x
        cmp #$02            ; player shot 1
        beq +
        cmp #$03            ; player shot 2
        beq +
        jmp ++
+
        ldy #$00
--        
        lda objectType,y
        cmp #$04            ; enemy ship
        bne +++
        
        lda objectX_hi,x
        adc #$04
        and #$f0
        sta temp
        
        lda objectX_hi,y
        adc #$04
        and #$f0
        cmp temp
        bne +++
        
        lda objectY_hi,x
        adc #$04
        and #$f0
        sta temp
        
        lda objectY_hi,y
        adc #$04
        and #$f0
        cmp temp
        bne +++

        
        lda #$00
        sta objectType,x
        sta objectType,y
        
        lda #$02
        jsr BankSwap

        lda #$02
        sta sound_param_byte_0
        lda #soundeffect_two
        sta sound_param_byte_1
        jsr play_sfx
        
        jsr RestoreBank

        
        
        jmp ++
+++
        iny
        cpy #maxObjects
        bne --
        
++
        inx
        cpx #maxObjects
        bne -
        rts