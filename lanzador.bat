@echo off
title FLUXIONICS v2.0
color 0a
mode con: cols=60 lines=35

:MENU
cls
echo.
echo  ========================================================
echo   FLUXIONICS v2.0 ^| GUILLERMO RAFAEL
echo  ========================================================
echo.
echo   [1]  JUGAR          Optimizar y abrir Bloxd.io
echo   [2]  ESTADO         Ver info del sistema
echo   [3]  LOG            Historial de sesiones
echo   [4]  PROGRESO       Exportar ^/ Importar saves
echo   [5]  REINICIAR      Borrar progreso
echo   [6]  SALIR
echo.
echo  ========================================================
echo.
set "OPC="
set /p "OPC=   Elige (1-6): "
echo.

if "%OPC%"=="1" goto JUGAR
if "%OPC%"=="2" goto ESTADO
if "%OPC%"=="3" goto LOG
if "%OPC%"=="4" goto PROGRESO
if "%OPC%"=="5" goto REINICIAR
if "%OPC%"=="6" goto SALIR
echo   Opcion invalida. Intenta de nuevo.
timeout /t 1 /nobreak >nul
goto MENU

:: ============================================================
:JUGAR
cls
echo.
echo  ========================================================
echo   OPTIMIZANDO SISTEMA...
echo  ========================================================
echo.

:: Crear carpetas si no existen
if not exist "%~dp0logs"  mkdir "%~dp0logs"
if not exist "%~dp0saves" mkdir "%~dp0saves"

:: Detectar Windows
set "WINVER_NOMBRE=Windows"
set "WINVER_ID=10"
for /f "tokens=3" %%a in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v CurrentBuild 2^>nul') do set "BUILD=%%a"
if defined BUILD (
    if %BUILD% GEQ 22000 ( set "WINVER_NOMBRE=Windows 11" & set "WINVER_ID=11" )
    if %BUILD% LSS 22000  ( set "WINVER_NOMBRE=Windows 10" & set "WINVER_ID=10" )
    if %BUILD% LSS 10000  ( set "WINVER_NOMBRE=Windows 8"  & set "WINVER_ID=8"  )
    if %BUILD% LSS 9200   ( set "WINVER_NOMBRE=Windows 7"  & set "WINVER_ID=7"  )
)
echo   [OK] Sistema: %WINVER_NOMBRE%

:: RAM libre
set "JS_MEMORY=256"
set "MODO_RAM=TURBO"
for /f %%a in ('powershell -nologo -command "[math]::Round((Get-CimInstance Win32_OperatingSystem).FreePhysicalMemory/1024)" 2^>nul') do set "RAMMB=%%a"
if defined RAMMB (
    if %RAMMB% LSS 800  ( set "MODO_RAM=MINIMO"  & set "JS_MEMORY=128"  )
    if %RAMMB% GEQ 800  ( set "MODO_RAM=TURBO"   & set "JS_MEMORY=256"  )
    if %RAMMB% GEQ 2000 ( set "MODO_RAM=ALTO"    & set "JS_MEMORY=512"  )
    if %RAMMB% GEQ 6000 ( set "MODO_RAM=MAXIMO"  & set "JS_MEMORY=1024" )
    echo   [OK] RAM libre: %RAMMB% MB ^| Modo: %MODO_RAM%
)

:: Matar procesos pesados
echo   [>>] Liberando RAM...
taskkill /f /im SearchIndexer.exe    >nul 2>&1
taskkill /f /im OneDrive.exe         >nul 2>&1
taskkill /f /im Widgets.exe          >nul 2>&1
taskkill /f /im Teams.exe            >nul 2>&1
taskkill /f /im Cortana.exe          >nul 2>&1
taskkill /f /im SgrmBroker.exe       >nul 2>&1
taskkill /f /im TiWorker.exe         >nul 2>&1
taskkill /f /im MoUsoCoreWorker.exe  >nul 2>&1
taskkill /f /im Discord.exe          >nul 2>&1
taskkill /f /im Spotify.exe          >nul 2>&1
del /f /s /q "%temp%\*"              >nul 2>&1
echo   [OK] RAM liberada.

:: Servicios (Win10/11)
if "%WINVER_ID%"=="10" (
    sc stop "WSearch"   >nul 2>&1
    sc stop "SysMain"   >nul 2>&1
    sc stop "DiagTrack" >nul 2>&1
    sc stop "wuauserv"  >nul 2>&1
)
if "%WINVER_ID%"=="11" (
    sc stop "WSearch"   >nul 2>&1
    sc stop "SysMain"   >nul 2>&1
    sc stop "DiagTrack" >nul 2>&1
    sc stop "wuauserv"  >nul 2>&1
)
echo   [OK] Servicios pausados.

:: Optimizaciones
powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v Win32PrioritySeparation /t REG_DWORD /d 38 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d 0 /f >nul 2>&1
echo   [OK] Sistema optimizado.

:: Anti mineros
echo   [>>] Escaneando mineros...
for %%P in (xmrig.exe ethminer.exe nicehash.exe cpuminer.exe nbminer.exe claymore.exe) do (
    taskkill /f /im %%P >nul 2>&1
)
echo   [OK] Escaneo completo.

:: Log
echo [%date% %time%] JUEGO INICIADO - %WINVER_NOMBRE% - %MODO_RAM% >> "%~dp0logs\sesiones.log"

:: Verificar Brave
if not exist "%~dp0browser\brave.exe" (
    echo.
    echo   [!!] ERROR: brave.exe no encontrado en browser\
    echo   [!]  Pon Brave Portable en la carpeta browser\
    echo.
    pause
    goto MENU
)

:: Lanzar juego
echo.
echo   [>>] Abriendo Bloxd.io en Brave...
start "" /HIGH "%~dp0browser\brave.exe" --app="https://bloxd.io" --incognito --disable-extensions --disable-notifications --disable-background-networking --disable-background-timer-throttling --disable-renderer-backgrounding --disable-backgrounding-occluded-windows --disable-sync --no-first-run --process-per-site --disable-gpu-vsync --disable-frame-rate-limit --disable-ipc-flooding-protection --aggressive-cache-discard --disk-cache-size=524288 --js-flags="--max-old-space-size=%JS_MEMORY%"

timeout /t 3 /nobreak >nul
powershell -nologo -command "Get-Process brave -ErrorAction SilentlyContinue | ForEach-Object { $_.PriorityClass = 'High' }" >nul 2>&1

echo.
echo  ========================================================
echo   [OK] Bloxd.io abierto en MODO TURBO
echo   [OK] Modo: %MODO_RAM% ^| Sistema: %WINVER_NOMBRE%
echo   [!]  No abras nada mas mientras juegas
echo  ========================================================
echo.
echo   Presiona cualquier tecla cuando termines de jugar...
pause >nul

:: Restaurar
sc start "WSearch"  >nul 2>&1
sc start "SysMain"  >nul 2>&1
sc start "wuauserv" >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v Win32PrioritySeparation /t REG_DWORD /d 2 /f >nul 2>&1
echo [%date% %time%] SESION TERMINADA >> "%~dp0logs\sesiones.log"
echo   [OK] PC restaurada.
timeout /t 2 /nobreak >nul
goto MENU

:: ============================================================
:ESTADO
cls
echo.
echo  ========================================================
echo   ESTADO DEL SISTEMA
echo  ========================================================
echo.

for /f "tokens=3" %%a in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v CurrentBuild 2^>nul') do set "BUILD=%%a"
echo   Build de Windows : %BUILD%

for /f %%a in ('powershell -nologo -command "[math]::Round((Get-CimInstance Win32_OperatingSystem).FreePhysicalMemory/1024)" 2^>nul') do echo   RAM libre        : %%a MB
for /f %%a in ('powershell -nologo -command "[math]::Round((Get-CimInstance Win32_OperatingSystem).TotalVisibleMemorySize/1024)" 2^>nul') do echo   RAM total        : %%a MB
for /f %%a in ('powershell -nologo -command "(Get-CimInstance Win32_VideoController).Name" 2^>nul') do echo   GPU              : %%a
for /f %%a in ('powershell -nologo -command "(Get-CimInstance Win32_Processor).Name" 2^>nul') do echo   CPU              : %%a

echo.
echo  ========================================================
echo.
echo   Presiona cualquier tecla para volver...
pause >nul
goto MENU

:: ============================================================
:LOG
cls
echo.
echo  ========================================================
echo   HISTORIAL DE SESIONES
echo  ========================================================
echo.
if exist "%~dp0logs\sesiones.log" (
    type "%~dp0logs\sesiones.log"
) else (
    echo   Sin sesiones registradas todavia.
)
echo.
echo  ========================================================
echo   [1] Limpiar log    [2] Volver
echo  ========================================================
echo.
set "LOGOP="
set /p "LOGOP=   Opcion: "
if "%LOGOP%"=="1" (
    del "%~dp0logs\sesiones.log" >nul 2>&1
    echo   [OK] Log limpiado.
    timeout /t 2 /nobreak >nul
)
goto MENU

:: ============================================================
:PROGRESO
cls
echo.
echo  ========================================================
echo   GESTION DE PROGRESO
echo  ========================================================
echo.
echo   [1] Exportar progreso  (guarda .flux en saves\)
echo   [2] Ver saves          (lista archivos guardados)
echo   [3] Volver
echo.
echo  ========================================================
echo.
set "PROP="
set /p "PROP=   Opcion: "

if "%PROP%"=="1" (
    if not exist "%~dp0saves" mkdir "%~dp0saves"
    set "SF=%~dp0saves\progreso_%date:~-4%%date:~3,2%%date:~0,2%.flux"
    (
        echo FLUXIONICS_SAVE_v2
        echo FECHA=%date% %time%
        if exist "%~dp0logs\sesiones.log" type "%~dp0logs\sesiones.log"
    ) > "%~dp0saves\progreso_%date:~-4%%date:~3,2%%date:~0,2%.flux"
    echo.
    echo   [OK] Guardado en saves\
    timeout /t 2 /nobreak >nul
)
if "%PROP%"=="2" (
    echo.
    if exist "%~dp0saves\*.flux" (
        dir /b "%~dp0saves\*.flux"
    ) else (
        echo   No hay archivos guardados todavia.
    )
    echo.
    pause
)
goto MENU

:: ============================================================
:REINICIAR
cls
echo.
echo  ========================================================
echo   REINICIO DE CUENTA
echo  ========================================================
echo.
echo   [1] Empezar de cero   (borra saves, conserva log)
echo   [2] Borrar TODO       (log + saves - IRREVERSIBLE)
echo   [3] Volver
echo.
echo  ========================================================
echo.
set "REINOP="
set /p "REINOP=   Opcion: "

if "%REINOP%"=="1" (
    del /f /q "%~dp0saves\*" >nul 2>&1
    echo   [OK] Saves borrados. Log conservado.
    timeout /t 2 /nobreak >nul
)
if "%REINOP%"=="2" (
    echo.
    echo   ATENCION: Se borrara TODO. No hay vuelta atras.
    set "CONF="
    set /p "CONF=   Escribe CONFIRMAR para continuar: "
    if /i "%CONF%"=="CONFIRMAR" (
        del /f /q "%~dp0logs\*"  >nul 2>&1
        del /f /q "%~dp0saves\*" >nul 2>&1
        echo   [OK] Todo borrado.
    ) else (
        echo   [--] Cancelado.
    )
    timeout /t 2 /nobreak >nul
)
goto MENU

:: ============================================================
:SALIR
cls
echo.
sc start "WSearch"  >nul 2>&1
sc start "SysMain"  >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 0 /f >nul 2>&1
echo   Hasta la proxima, Guillermo!
echo.
timeout /t 2 /nobreak >nul
exit
