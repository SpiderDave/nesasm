handleBounds:
    ; handle player bounds

    lda objectX_hi
    cmp #$0a
    bcs +
    lda #$0a
    sta objectX_hi
+
    cmp #$f0
    bcc +
    lda #$f0
    sta objectX_hi
+
    
    
    lda objectY_hi
    cmp #$20
    bcs +
    lda #$20
    sta objectY_hi
+
    cmp #$d8
    bcc +
    lda #$d8
    sta objectY_hi
+
    rts