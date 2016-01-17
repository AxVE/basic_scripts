@echo off

rem Use it to start your Primal Carnage Extinction if it doesn't work
rem Note: even if you're on 64bits, you should try 32bits if 64bits version doesn't work
rem Author : Axel Verdier (drahull) :  AxVE@users.noreply.github.com

set binPath=D:\jeux\Steam\SteamApps\common\Primal Carnage Extinction\Binaries
set opt=-seekfreeloadingpcconsole

echo Primal Carnage Extinction launcher.
echo \t1- 32 bits11
echo \t2- 64 bits
@CHOICE /C:12
IF %ERRORLEVEL%==1 GOTO 32b
IF %ERRORLEVEL%==2 GOTO 64b
GOTO end
:32b
set binPath=%binPath%\Win32\PrimalCarnageGame.exe
GOTO end

:64b
set binPath=%binPath%\Win64\PrimalCarnageGame.exe
GOTO end

:end
set run="%binPath%" %opt%
echo Run %run%
%run%
pause