@echo off
title FLUXIONICS v2.0 - Guillermo Rafael
color 0a
mode con: cols=62 lines=40

:: Crear carpetas necesarias
if not exist "%~dp0logs"  mkdir "%~dp0logs"
if not exist "%~dp0data"  mkdir "%~dp0data"
if not exist "%~dp0saves" mkdir "%~dp0saves"

:: Detectar Windows al inicio
call "%~dp0functions\detectar_win.bat" >nul 2>&1
call "%~dp0functions\modo_ram.bat"     >nul 2>&1

:MENU
cls
color 0a
echo.
echo  ==========================================================
echo    ______ _    _   ___  _____ ___  _  _ ___ ___ ___ 
echo   ^|  ____^| ^|  ^| ^| ^\ \/ ^/ __^|^|_ _^| ^\^| ^|_ _/ __/ __^|
echo   ^| ^|__  ^| ^|  ^| ^|  ^>  ^< ^(__ ^| ^|^| .^` ^| ^| ^|\__ \__ \
echo   ^|  __^| ^|_^|  ^|_^| /_/\_\___^||___^|_^|\_^|___^|___/___/
echo   ^|_^|                          v2.0
echo  ==========================================================
echo   Windows: %-20s Modo: %MODO_RAM%
echo  ==========================================================
echo.
echo   ^[ 1 ^]  JUGAR         Optimizar y abrir Bloxd.io
echo   ^[ 2 ^]  ESTADO        Ver info del sistema
echo   ^[ 3 ^]  LOG           Historial de sesiones
echo   ^[ 4 ^]  PROGRESO      Exportar / Importar saves
echo   ^[ 5 ^]  REINICIAR     Empezar de cero o borrar todo
echo   ^[ 6 ^]  SALIR
echo.
echo  ==========================================================
set /p "OPC=   Elige (1-6): "

if "%OPC%"=="1" goto JUGAR
if "%OPC%"=="2" goto ESTADO
if "%OPC%"=="3" goto LOG
if "%OPC%"=="4" goto PROGRESO
if "%OPC%"=="5" goto REINICIAR
if "%OPC%"=="6" goto SALIR
goto MENU

:: ══════════════════════════════════════════════════════
:JUGAR
cls
color 0b
echo.
echo  ==========================================================
echo   ^[^^] OPTIMIZANDO SISTEMA...
echo  ==========================================================
echo.
echo   ^[1/5^] Detectando sistema...
call "%~dp0functions\detectar_win.bat" >nul 2>&1
echo         Windows: %WINVER_NOMBRE%

echo   ^[2/5^] Calculando modo RAM...
call "%~dp0functions\modo_ram.bat" >nul 2>&1
echo         Modo: %MODO_RAM% / JS: %JS_MEMORY%MB

echo   ^[3/5^] Liberando RAM y procesos...
call "%~dp0functions\optimizar_juego.bat" >nul 2>&1
echo         Listo.

echo   ^[4/5^] Escaneando mineros/virus...
call "%~dp0functions\anti_mineros.bat" >nul 2>&1
echo         Listo.

echo   ^[5/5^] Iniciando limpiador en vivo...
taskkill /f /fi "WINDOWTITLE eq FLUXIONICS_BG" >nul 2>&1
start /min "FLUXIONICS_BG" cmd /c "%~dp0functions\limpiador_vivo.bat"
echo         Activo.

echo.
echo  ==========================================================
echo   ^[OK^] SISTEMA LISTO - Abriendo Bloxd.io...
echo  ==========================================================
echo.

:: Registrar sesion
call "%~dp0functions\logger.bat" "JUEGO INICIADO - %WINVER_NOMBRE% - %MODO_RAM%"

:: Lanzar Bloxd.io optimizado
start "" /HIGH "%~dp0browser\brave.exe" ^
  --app="https://bloxd.io" ^
  --incognito ^
  --disable-extensions ^
  --disable-notifications ^
  --disable-background-networking ^
  --disable-background-timer-throttling ^
  --disable-renderer-backgrounding ^
  --disable-backgrounding-occluded-windows ^
  --disable-hang-monitor ^
  --disable-sync ^
  --disable-translate ^
  --disable-features=TranslateUI,OptimizationHints,AutofillServerCommunication ^
  --enable-features=VaapiVideoDecoder,CanvasOopRasterization ^
  --no-first-run ^
  --process-per-site ^
  --disable-gpu-vsync ^
  --disable-frame-rate-limit ^
  --disable-ipc-flooding-protection ^
  --aggressive-cache-discard ^
  --disk-cache-size=524288 ^
  --js-flags="--max-old-space-size=%JS_MEMORY% --optimize-for-size"

timeout /t 3 /nobreak >nul
powershell -command "Get-Process brave -ErrorAction SilentlyContinue | ForEach-Object { $_.PriorityClass = 'High' }" >nul 2>&1

color 0a
echo   ^[OK^] Bloxd.io corriendo en MODO TURBO
echo   ^[!^]  No abras nada mas mientras juegas
echo.
echo   Presiona cualquier tecla cuando termines...
pause >nul

call "%~dp0functions\restaurar.bat" >nul 2>&1
call "%~dp0functions\logger.bat" "SESION TERMINADA"
goto MENU

:: ══════════════════════════════════════════════════════
:ESTADO
cls
color 0b
echo.
echo  ==========================================================
echo   ESTADO DEL SISTEMA
echo  ==========================================================
echo.

call "%~dp0functions\detectar_win.bat" >nul 2>&1
call "%~dp0functions\modo_ram.bat"     >nul 2>&1

echo   Windows  :  %WINVER_NOMBRE%
echo   Modo RAM :  %MODO_RAM%
echo   JS Mem   :  %JS_MEMORY% MB
echo.

for /f %%a in ('powershell -command "[math]::Round((Get-CimInstance Win32_OperatingSystem).FreePhysicalMemory/1024)" 2^>nul') do (
    echo   RAM libre:  %%a MB
)
for /f %%a in ('powershell -command "(Get-CimInstance Win32_VideoController).Name" 2^>nul') do (
    echo   GPU      :  %%a
)
for /f %%a in ('powershell -command "(Get-CimInstance Win32_Processor).Name" 2^>nul') do (
    echo   CPU      :  %%a
)

:: Estado del limpiador
tasklist /fi "WINDOWTITLE eq FLUXIONICS_BG" 2>nul | find "cmd" >nul
if errorlevel 1 (echo   Limpiador:  INACTIVO) else (echo   Limpiador:  ACTIVO)

echo.
echo  ==========================================================
echo.
echo   Presiona cualquier tecla para volver...
pause >nul
goto MENU

:: ══════════════════════════════════════════════════════
:LOG
cls
color 0e
echo.
echo  ==========================================================
echo   HISTORIAL DE SESIONES
echo  ==========================================================
echo.

if exist "%~dp0logs\sesiones.log" (
    type "%~dp0logs\sesiones.log"
) else (
    echo   Sin sesiones registradas todavia.
)

echo.
echo  ==========================================================
echo   ^[1^] Limpiar log   ^[2^] Exportar log   ^[3^] Volver
echo  ==========================================================
set /p "LOGOP=   Opcion: "

if "%LOGOP%"=="1" (
    del "%~dp0logs\sesiones.log" >nul 2>&1
    echo   ^[OK^] Log limpiado.
    timeout /t 2 /nobreak >nul
)
if "%LOGOP%"=="2" (
    set "EXPORT=%~dp0logs\log_export_%date:~-4%-%date:~3,2%-%date:~0,2%.txt"
    copy "%~dp0logs\sesiones.log" "%EXPORT%" >nul 2>&1
    echo   ^[OK^] Log exportado a: logs\
    timeout /t 2 /nobreak >nul
)
goto MENU

:: ══════════════════════════════════════════════════════
:PROGRESO
cls
color 0d
echo.
echo  ==========================================================
echo   GESTION DE PROGRESO
echo  ==========================================================
echo.
echo   ^[1^] Exportar progreso  (guarda archivo .flux en saves\)
echo   ^[2^] Importar progreso  (pega tu .flux en saves\ primero)
echo   ^[3^] Volver
echo.
echo  ==========================================================
set /p "PROP=   Opcion: "

if "%PROP%"=="1" goto EXPORTAR
if "%PROP%"=="2" goto IMPORTAR
goto MENU

:EXPORTAR
cls
echo.
echo   Exportando progreso...
set "SAVEFILE=%~dp0saves\progreso_%date:~-4%%date:~3,2%%date:~0,2%_%time:~0,2%%time:~3,2%.flux"
(
echo FLUXIONICS_SAVE_v2
echo FECHA=%date% %time%
echo WINVER=%WINVER_NOMBRE%
echo MODO=%MODO_RAM%
if exist "%~dp0logs\sesiones.log" type "%~dp0logs\sesiones.log"
) > "%SAVEFILE%"
echo   ^[OK^] Guardado en: saves\
echo   ^[OK^] Archivo: %SAVEFILE%
echo.
echo   Presiona cualquier tecla...
pause >nul
goto MENU

:IMPORTAR
cls
echo.
echo   Archivos .flux disponibles en saves\:
echo.
if exist "%~dp0saves\*.flux" (
    dir /b "%~dp0saves\*.flux"
) else (
    echo   No hay archivos .flux en saves\
    echo   Pon tu archivo .flux en la carpeta saves\ y vuelve.
)
echo.
set /p "FNAME=   Nombre del archivo (sin extension): "
if exist "%~dp0saves\%FNAME%.flux" (
    copy "%~dp0saves\%FNAME%.flux" "%~dp0saves\importado_activo.flux" >nul 2>&1
    echo   ^[OK^] Progreso importado correctamente.
) else (
    echo   ^[!!^] Archivo no encontrado.
)
echo.
echo   Presiona cualquier tecla...
pause >nul
goto MENU

:: ══════════════════════════════════════════════════════
:REINICIAR
cls
color 0c
echo.
echo  ==========================================================
echo   REINICIO DE CUENTA
echo  ==========================================================
echo.
echo   ^[1^] Empezar de cero   (borra config, conserva log)
echo   ^[2^] Borrar TODO       (log, saves, config - IRREVERSIBLE)
echo   ^[3^] Volver
echo.
echo  ==========================================================
set /p "REINOP=   Opcion: "

if "%REINOP%"=="1" (
    del "%~dp0saves\importado_activo.flux" >nul 2>&1
    echo   ^[OK^] Configuracion reiniciada. Log conservado.
    timeout /t 2 /nobreak >nul
    goto MENU
)
if "%REINOP%"=="2" (
    echo.
    echo   ATENCION: Esto borrara TODO. No se puede deshacer.
    set /p "CONF=   Escribe CONFIRMAR para continuar: "
    if /i "%CONF%"=="CONFIRMAR" (
        del /f /q "%~dp0logs\*"  >nul 2>&1
        del /f /q "%~dp0saves\*" >nul 2>&1
        del /f /q "%~dp0data\*"  >nul 2>&1
        echo   ^[OK^] Todo borrado. Progreso reiniciado.
    ) else (
        echo   ^[--^] Cancelado.
    )
    timeout /t 2 /nobreak >nul
    goto MENU
)
goto MENU

:: ══════════════════════════════════════════════════════
:SALIR
cls
color 0a
call "%~dp0functions\restaurar.bat" >nul 2>&1
taskkill /f /fi "WINDOWTITLE eq FLUXIONICS_BG" >nul 2>&1
call "%~dp0functions\logger.bat" "PANEL CERRADO"
echo.
echo   Hasta la proxima, Guillermo!
echo.
timeout /t 2 /nobreak >nul
exit
