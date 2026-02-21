@echo off
:: Detectar RAM total y elegir modo automatico

:: Compatible Win7/8/10/11 usando systeminfo
for /f "tokens=2 delims=:" %%a in ('systeminfo ^| findstr /C:"Memoria fisica disponible"') do set RAMDISP=%%a
if "%RAMDISP%"=="" (
    for /f "tokens=2 delims=:" %%a in ('systeminfo ^| findstr /C:"Available Physical Memory"') do set RAMDISP=%%a
)

:: Limpiar espacios y MB del string
set RAMDISP=%RAMDISP: =%
set RAMDISP=%RAMDISP:,=%
for /f "tokens=1" %%a in ("%RAMDISP%") do set RAMMB=%%a

:: Si falla systeminfo usar powershell
if "%RAMMB%"=="" (
    for /f %%a in ('powershell -command "[math]::Round((Get-CimInstance Win32_OperatingSystem).FreePhysicalMemory/1024)"') do set RAMMB=%%a
)

:: Elegir modo segun RAM libre
set MODO_RAM=ESTANDAR
set JS_MEMORY=256

if defined RAMMB (
    if %RAMMB% LSS 800 (
        set MODO_RAM=MINIMO - RAM CRITICA
        set JS_MEMORY=128
        echo [!!] RAM muy baja (%RAMMB% MB libres) - Modo MINIMO activado
        :: Matar mas procesos en modo minimo
        taskkill /f /im OneDrive.exe         >nul 2>&1
        taskkill /f /im SearchIndexer.exe    >nul 2>&1
        taskkill /f /im Widgets.exe          >nul 2>&1
        taskkill /f /im Teams.exe            >nul 2>&1
        taskkill /f /im SgrmBroker.exe       >nul 2>&1
        taskkill /f /im TiWorker.exe         >nul 2>&1
        taskkill /f /im MoUsoCoreWorker.exe  >nul 2>&1
        del /f /s /q "%temp%\*"              >nul 2>&1
    ) else if %RAMMB% LSS 2000 (
        set MODO_RAM=TURBO - 4GB
        set JS_MEMORY=256
        echo [OK] RAM: %RAMMB% MB libres - Modo TURBO 4GB
        taskkill /f /im SearchIndexer.exe >nul 2>&1
        taskkill /f /im OneDrive.exe      >nul 2>&1
        taskkill /f /im Widgets.exe       >nul 2>&1
        del /f /s /q "%temp%\*"           >nul 2>&1
    ) else if %RAMMB% LSS 6000 (
        set MODO_RAM=ALTO RENDIMIENTO - 8GB
        set JS_MEMORY=512
        echo [OK] RAM: %RAMMB% MB libres - Modo ALTO RENDIMIENTO 8GB
        taskkill /f /im SearchIndexer.exe >nul 2>&1
    ) else (
        set MODO_RAM=MAXIMO - 16GB+
        set JS_MEMORY=1024
        echo [OK] RAM: %RAMMB% MB libres - Modo MAXIMO 16GB+
    )
) else (
    echo [??] No se pudo leer RAM - usando modo estandar
    set JS_MEMORY=256
    set MODO_RAM=ESTANDAR
)

exit /b 0
