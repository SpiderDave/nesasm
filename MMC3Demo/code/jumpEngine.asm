; Usage:
;
; jumpTable:
;     lda index         ; run subroutine below according to this index
;     jsr jumpEngine    ; execution will return to the sub it was in before this one.
;     .dw subroutine1
;     .dw subroutine2
;     .dw subroutine3

jumpEngine:
    asl             ; Prepare jump table index by multiplying by two.
    
    tay             ; Transfer it to y
    
    pla             ; Pull return address from the stack
    sta temp1       ;   The next RTS will now return to the subroutine it was in before the one 
    pla             ;   calling the jumpEngine.  Also save this address for below.
    sta temp2       ;
    
    lda (temp1),y   ; Get address from the jump table.
    sta temp16      ; Store to indirect
    iny
    lda (temp1),y
    sta temp16+1
    
    jmp(temp16)     ; Jump to our table entry.
