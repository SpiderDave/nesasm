OAM = $0200

SpriteData = OAM
SpriteY = SpriteData
SpriteTile = SpriteData+1
SpriteAttributes = SpriteData+2
SpriteX = SpriteData+3

DUMMY = $1234                   ; This is just something to set a breakpoint 
                                ; for in emulators.  ex: lda DUMMY
                                
                                
ifdef sfx_list
    sfx_num_tracks = (sfx_list - song_list)/2
else
    sfx_num_tracks = (instrument_list - song_list)/2
endif


player = $00
shipSpeed = $80
shipSpeed_hi = $01
maxObjects = 40

scrollSpeed_hi = $00
scrollSpeed = $c0
