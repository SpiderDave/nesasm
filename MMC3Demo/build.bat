@echo off
echo .db "v%date:~10,4%.%date:~7,2%.%date:~4,2%">data\version.asm
..\asm6\asm6 -l main.asm game.nes list.txt

IF NOT EXIST game.nes goto error
goto theend

:error
pause
exit

:theend
rem start game.nes