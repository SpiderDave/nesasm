Palettes_low:
    .db <Palette00, <Palette01, <Palette02, <Palette03
    .db <Palette04, <Palette05, <Palette06, <Palette07
    .db <Palette08, <Palette09

Palettes_high:
    .db >Palette00, >Palette01, >Palette02, >Palette03
    .db >Palette04, >Palette05, >Palette06, >Palette07
    .db >Palette08, >Palette09

Palette00: .db $0f, $21, $11, $01
Palette01: .db $0f, $26, $16, $06
Palette02: .db $0f, $33, $23, $03
Palette03: .db $0f, $26, $16, $06
Palette04: .db $0f, $27, $17, $07
Palette05: .db $0f, $28, $18, $08
Palette06: .db $0f, $20, $10, $00
Palette07: .db $0f, $20, $10, $00
Palette08: .db $0f, $20, $10, $00
Palette09: .db $0f, $20, $10, $00
