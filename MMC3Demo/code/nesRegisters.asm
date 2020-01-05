; PPU registers --------------------------
PPUCTRL   = $2000
PPUMASK   = $2001
PPUSTATUS = $2002
OAMADDR   = $2003  ; always write 0 here and use DMA from OAM
OAMDATA   = $2004
PPUSCROLL = $2005
PPUADDR   = $2006
PPUDATA   = $2007
OAMDMA    = $4014
; ----------------------------------------

; APU registers --------------------------
SQ1VOL    = $4000
SQ1SWEEP  = $4001
SQ1LO     = $4002
SQ1HI     = $4003

SQ2VOL    = $4004
SQ2SWEEP  = $4005
SQ2LO     = $4006
SQ2HI     = $4007

TRILINEAR = $4008
TRILO     = $400A
TRIHI     = $400B

NOISEVOL  = $400C
NOISELO   = $400E
NOISEHI   = $400F

DMCFREQ   = $4010
DMCRAW    = $4011
DMCSTART  = $4012
DMCLEN    = $4013

APUSTATUS = $4015
APUFRAME  = $4017
; ----------------------------------------

; Controllers ----------------------------
JOY       = $4016
JOY1      = $4016
JOY2      = $4017
; ----------------------------------------

