; bank 0 
;bank 0
.base $8000
.db $00                     ; bank identifier
.include code\bank00.asm
.pad $c000

;bank 1
; bank 1
.base $8000
.db $01                     ; bank identifier
.include code\bank01.asm
.pad $c000

;bank 2
; bank 2
.base $8000
.db $02                     ; bank identifier
.include code\bank02.asm
.pad $c000

;bank 3
; fixed bank
.org $c000
