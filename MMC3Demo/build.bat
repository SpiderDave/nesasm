@echo off
..\asm6\asm6 -l main.asm game.nes list.txt

IF NOT EXIST game.nes goto error
goto theend

:error
pause
exit

:theend
rem start game.nes