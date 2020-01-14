loadObjects:
    ldx #$00
    ldy #$00
-
    jsr resetObject
    lda objectsTest, y
    cmp #$ff
    beq doneLoadingObjects
    sta objectType, x
    iny
    lda objectsTest, y
    sta objectX_hi, x
    iny
    lda objectsTest, y
    sta objectY_hi, x
    
    stx temp3
    sty temp4
    lda objectType, x
    jsr createObject2
    ldx temp3
    ldy temp4
    
    inx
    iny
    bne -                   ; unconditional branch
doneLoadingObjects:
rts

createObject:
    sta temp                ; save contents of A for later
    
    ldx #$ff
getUnusedObjectLoop:
    inx
    lda objectType,x
    bne getUnusedObjectLoop
    ; ----------------------
    jsr resetObject
    lda temp                ; load stored contents from earlier
    sta objectType,x
createObject2:
    tay
    
    lda objectData_lo, y
    sta temp1
    lda objectData_hi, y
    sta temp2
    ldy #$00
    lda (temp1), y
    sta objectTile,x
    iny
    lda (temp1), y
    sta objectAttributes, x
    
rts

deleteObject:
    lda #$00
    sta objectType,x
    sta objectTile,x
rts

resetObject:
    lda #$00
    sta objectType,x
    sta objectX,x
    sta objectX_hi,x
    sta objectY,x
    sta objectY_hi,x
    sta objectVelocityX,x
    sta objectVelocityX_hi,x
    sta objectVelocityY,x
    sta objectVelocityY_hi,x
    sta objectTile,x
rts

handleObjects:
    jsr removeAllSprites
    ldx #$00            ; object index
    ldy #$00            ; sprite index
-
    lda objectType,x
    beq skipThisObject
    
    lda objectVelocityX_hi,x
    asl
    adc #$00
    and #$01
    sta temp1                   ; stores 1 if x velocity is negative, 0 otherwise.
    lda objectVelocityY_hi,x
    asl
    adc #$00
    and #$01
    sta temp2                   ; stores 1 if y velocity is negative, 0 otherwise.
    
    lda objectX,x
    clc
    adc objectVelocityX,x
    sta objectX,x
    lda objectX_hi,x
    adc objectVelocityX_hi,x
    sta objectX_hi,x
    
    lda #$00
    adc #$00
    cmp temp1
    beq +
    
deleteThis:
    jsr deleteObject
    jmp skipThisObject
+
    lda objectY,x
    clc
    adc objectVelocityY,x
    sta objectY,x
    lda objectY_hi,x
    adc objectVelocityY_hi,x
    sta objectY_hi,x

    lda #$00
    adc #$00
    cmp temp2
    bne deleteThis
    
    
    lda objectTile,x
    sta SpriteTile,y
    
    lda objectX_hi,x
    sta SpriteX,y
    lda objectY_hi,x
    sta SpriteY,y
    lda objectAttributes,x
    sta SpriteAttributes,y
    iny
    iny
    iny
    iny
skipThisObject:
    inx
    cpx #maxObjects
    bne -
    
    
    lda shootCooldown
    beq +
    dec shootCooldown
+


    jsr handleBounds
rts


objectsTest:
    ; type, x, y
    .db $01, $40, $70
    .db $04, $e0, $50
    .db $04, $c0, $70
    .db $04, $e0, $90
    
    .db $05, $b0, $70
    
    .db $ff

