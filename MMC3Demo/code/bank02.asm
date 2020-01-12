
include code\ggsound\ggsound.asm
;include code\ggsound\track_data.inc
include code\ggsound\shmup.asm

; with ggsound, DPCM data MUST be at $C000 or later
; so the dpcm file is in the fixed bank (in main.txt)

;.align 64
;include code\ggsound\track_dpcm.inc
;include code\ggsound\shmup_dpcm.asm