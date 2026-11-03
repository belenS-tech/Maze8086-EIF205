@echo off
setlocal
cd /d "%~dp0build"
if exist "C:\DOSBox-X\dosbox-x.exe" (
    start "" "C:\DOSBox-X\dosbox-x.exe" -conf play.conf
    exit /b
)
if exist "%ProgramFiles%\DOSBox-X\dosbox-x.exe" (
    start "" "%ProgramFiles%\DOSBox-X\dosbox-x.exe" -conf play.conf
    exit /b
)
echo No se encontro DOSBox-X. Abre DOSBox y monta la carpeta build.
pause
