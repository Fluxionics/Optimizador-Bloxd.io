@echo off
:: Logger de sesion - guarda registro de cada uso
:: Uso: call logger.bat "INICIO" o call logger.bat "FIN"

set LOG_DIR=%~dp0..\logs
set LOG_FILE=%LOG_DIR%\sesiones.log

if not exist "%LOG_DIR%" mkdir "%LOG_DIR%"

:: Fecha y hora
for /f "tokens=1-3 delims=/" %%a in ("%date%") do (
    set DIA=%%a
    set MES=%%b
    set ANIO=%%c
)
set FECHA=%DIA%/%MES%/%ANIO%
set HORA=%time%

if "%1"=="INICIO" (
    echo [%FECHA% %HORA%] === SESION INICIADA === >> "%LOG_FILE%"
    echo [%FECHA% %HORA%] Windows: %WINVER_NOMBRE% >> "%LOG_FILE%"
    echo [%FECHA% %HORA%] Modo RAM: %MODO_RAM% >> "%LOG_FILE%"
    echo [%FECHA% %HORA%] JS Memory: %JS_MEMORY% MB >> "%LOG_FILE%"
)

if "%1"=="FIN" (
    echo [%FECHA% %HORA%] === SESION TERMINADA === >> "%LOG_FILE%"
    echo. >> "%LOG_FILE%"
)

exit /b 0
