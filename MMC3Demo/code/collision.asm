checkCollision:
        ldx #$00
-
        lda objectType,x
        cmp #$02
        beq +
        cmp #$03
        beq +
        jmp ++
+
        ldy #$00
--        
        lda objectType,y
        cmp #$04
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