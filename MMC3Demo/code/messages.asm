messages_lo:
    .db <message_main, <message_error, <version_date
messages_hi:
    .db >message_main, >message_error, >version_date

message_main:
    .db $20,$68,"NES MMC3 Thing ",0
    .db $20,$88,"by SpiderDave",0
    
    .db $21,$65,"Whatever you do, ",0
    .db $21,$85,"don't press A.",0

    .db $21,$23, $80,$81,$81,$81,$81,$81,$81,$81,$81,$81,$81,$81,$81,$81,$81,$81,$81,$81,$81,$81,$81,$81,$81,$81,$81,$82,$00
    .db $21,$43, $90, $00
    .db $21,$63, $90, $00
    .db $21,$83, $90, $00
    .db $21,$a3, $90, $00
    .db $21,$c3, $90, $00

    .db $21,$5c, $92, $00
    .db $21,$7c, $92, $00
    .db $21,$9c, $92, $00
    .db $21,$bc, $92, $00
    .db $21,$dc, $92, $00

    .db $21,$e3, $a0,$a1,$a1,$a1,$a1,$a1,$a1,$a1,$a1,$a1,$a1,$a1,$a1,$a1,$a1,$a1,$a1,$a1,$a1,$a1,$a1,$a1,$a1,$a1,$a1,$a2,$00
    .db $00
message_error:
    .db $21,$65,"                      ",0
    .db $21,$85, "WHAT HAVE YOU DONE?!!",0
    .db $00
version_date:
    .db $2b, $43
    .include data\version.asm
    .db $00
    .db $00