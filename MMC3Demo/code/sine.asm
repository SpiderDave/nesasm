; http://forum.6502.org/viewtopic.php?t=1004
;----------------------------------------------------------------
;
; SIN(A) COS(A) routines. a full circle is represented by $00 to
; $00 in 256 1.40625 degree steps. returned value is signed 15
; bit with X being the high byte and ranges over +/-0.99997

;----------------------------------------------------------------
;
; get COS(A) in AX

cos_A
      CLC                     ; clear carry for add
      ADC   #$40              ; add 1/4 rotation

;----------------------------------------------------------------
;
; get SIN(A) in AX. enter with flags reflecting the contents of A

sin_A
      BPL   sin_cos           ; just get SIN/COS and return if +ve

      AND   #$7F              ; else make +ve
      JSR   sin_cos           ; get SIN/COS
                              ; now do twos complement
      EOR   #$FF              ; toggle low byte
      CLC                     ; clear carry for add
      ADC   #$01              ; add to low byte
      PHA                     ; save low byte
      TXA                     ; copy high byte
      EOR   #$FF              ; toggle high byte
      ADC   #$00              ; add carry from low byte
      TAX                     ; copy back to X
      PLA                     ; restore low byte
      RTS

;----------------------------------------------------------------
;
; get AX from SIN/COS table

sin_cos
      CMP   #$41              ; compare with max+1
      BCC   quadrant          ; branch if less

      EOR   #$7F              ; wrap $41 to $7F ..
      ADC   #$00              ; .. to $3F to $00
quadrant
      ASL                     ; * 2 bytes per value
      TAX                     ; copy to index
      LDA   sintab,X          ; get SIN/COS table value low byte
      PHA                     ; save it
      LDA   sintab+1,X        ; get SIN/COS table value high byte
      TAX                     ; copy to X
      PLA                     ; restore low byte
      RTS

;----------------------------------------------------------------
;
; SIN/COS table. returns values between $0000 and $7FFF

sintab
      .word $0000,$0324,$0647,$096A,$0C8B,$0FAB,$12C8,$15E2
      .word $18F8,$1C0B,$1F19,$2223,$2528,$2826,$2B1F,$2E11
      .word $30FB,$33DE,$36BE,$398C,$3C56,$3F17,$41CE,$447A
      .word $471C,$49B4,$4C3F,$4EBF,$5133,$539B,$55F5,$5842
      .word $5A82,$5CB4,$5ED7,$60EC,$62F2,$64EB,$66CF,$68A6
      .word $6A6D,$6C24,$6DC4,$6F5F,$70E2,$7255,$73B5,$7504
      .word $7641,$776C,$7884,$798A,$7A7D,$7B5D,$7C2A,$7CE3
      .word $7D8A,$7E1D,$7E9D,$7F09,$7F62,$7FA7,$7FD8,$7FF6
      .word $7FFF

;----------------------------------------------------------------