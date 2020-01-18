messages_lo:
    .db <message_main, <message_error, <version_date, <hud, <message_title
messages_hi:
    .db >message_main, >message_error, >version_date, >hud, >message_title

message_title:
message_main:
    .db $21,$65,"Press start.         ",0
    .db $21,$85,"                     ",0

    .db $21,$23, $80,$81,$81,$81,$81,$81,$81,$81,$81,$81,$81,$81,$81,$81,$81,$81,$81,$81,$81,$81,$81,$81,$81,$81,$82,$00
    .db $21,$43, $90, $00
    .db $21,$63, $90, $00
    .db $21,$83, $90, $00
    .db $21,$a3, $90, $00
    .db $21,$c3, $90, $00

    .db $21,$5b, $92, $00
    .db $21,$7b, $92, $00
    .db $21,$9b, $92, $00
    .db $21,$bb, $92, $00
    .db $21,$db, $92, $00

    .db $21,$e3, $a0,$a1,$a1,$a1,$a1,$a1,$a1,$a1,$a1,$a1,$a1,$a1,$a1,$a1,$a1,$a1,$a1,$a1,$a1,$a1,$a1,$a1,$a1,$a1,$a2,$00
    .db $00
message_error:
    .db $21,$65,"                      ",0
    .db $21,$85, "WHAT HAVE YOU DONE?!!",0
    .db $00
version_date:
    .db $23, $43
    .include data\version.asm
    .db 0
    .db $00
hud:
    .db $20, $00
    .db "                                ",0
    .db $28, $00
    .db "                                ",0
    .db $20, $20
    .db "HUD GOES HERE                   ",0
    .db $20, $40
    .db "                                ",0
    ;.db "HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH",0
    ;.db $20, $60
    ;.db "HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH",0
    
    ;.db $23, $c0, $55,$55,$55,0
    
    .db $00
    
testData:
    .db $20, $40, $09, "TEST: ---"
    
hexTable:
    .db $30, $31, $32, $33, $34, $35, $36, $37, $38, $39, $41, $42, $43, $44, $45, $46
