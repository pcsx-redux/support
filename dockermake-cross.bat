@echo off
set OLDCWD=%cd%
cd %~dp0
set ROOT=%cd%
cd %OLDCWD%

set REL=%OLDCWD%

SETLOCAL EnableDelayedExpansion

set MAT=
set UPP=
for /f "tokens=*" %%a in ('echo.%ROOT:\=^&echo.%') do (
    set SUB=!SUB!%%a\
    call set TMP=%%src:!SUB!=%%
    set MAT=!SUB!
)
set REL=%UPP%!REL:%MAT%=!
if "!REL!" EQU "!ROOT!" (set REL=) ELSE (set "REL=!REL:\=/!")
set REL=/!REL!

docker pull ghcr.io/grumpycoders/pcsx-redux-build-cross:latest
docker run --rm --env-file "%ROOT%/cross-env.list" -i -w"/project%REL%" -v "%ROOT%:/project" ghcr.io/grumpycoders/pcsx-redux-build-cross make CROSS=arm64 %*
