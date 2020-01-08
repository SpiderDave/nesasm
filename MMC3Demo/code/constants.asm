OAM = $0200


SpriteData = OAM
SpriteY = SpriteData
SpriteTile = SpriteData+1
SpriteAttributes = SpriteData+2
SpriteX = SpriteData+3

DUMMY = $1234                   ; This is just something to set a breakpoint 
                                ; for in emulators.  ex: lda DUMMY