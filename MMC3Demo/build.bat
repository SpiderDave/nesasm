@echo off
echo .db "v%date:~10,4%.%date:~4,2%.%date:~7,2%">data\version.asm
..\asm6\asm6 -l main.asm game.nes list.txt

IF NOT EXIST game.nes goto error
goto theend

:error
pause
exit

:theend
start game.nes