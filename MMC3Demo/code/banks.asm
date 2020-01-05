; bank 0 
.base $8000
.include code\bank00.asm
.pad $c000

; bank 1
.base $8000
.include code\bank01.asm
.pad $c000

; bank 2
.base $8000
.include code\bank02.asm
.pad $c000

; fixed bank
.org $c000
