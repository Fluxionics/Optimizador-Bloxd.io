@echo off
title FLUXIONICS - LIMPIADOR EN VIVO
color 0a

echo ============================================================
echo      FLUXIONICS - LIMPIADOR EN VIVO (segundo plano)
echo      Presiona CTRL+C para detener
echo ============================================================
echo.

:LOOP

:: ─── 1. MATAR PROCESOS DE REDES DE ANUNCIOS ───────────────────
:: Estos son procesos reales que algunas ad-networks levantan
taskkill /f /im adobearm.exe     >nul 2>&1
taskkill /f /im adobeupdater.exe >nul 2>&1
taskkill /f /im GoogleCrashHandler.exe >nul 2>&1
taskkill /f /im GoogleCrashHandler64.exe >nul 2>&1
taskkill /f /im MicrosoftEdgeUpdate.exe  >nul 2>&1
taskkill /f /im OfficeClickToRun.exe     >nul 2>&1

:: ─── 2. MATAR PROCESOS QUE ROBAN CPU EN SEGUNDO PLANO ─────────
taskkill /f /im SearchIndexer.exe >nul 2>&1
taskkill /f /im SgrmBroker.exe    >nul 2>&1
taskkill /f /im MoUsoCoreWorker.exe >nul 2>&1
taskkill /f /im TiWorker.exe      >nul 2>&1
taskkill /f /im WmiPrvSE.exe      >nul 2>&1

:: ─── 3. LIMPIAR CACHE DE EDGE (carpeta de red / anuncios) ──────
:: Solo borra archivos de cache de red, NO perfil ni historial
set "EDGE_CACHE=%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Cache\Cache_Data"
if exist "%EDGE_CACHE%" (
    del /f /q "%EDGE_CACHE%\*" >nul 2>&1
)

:: Tambien limpiar Code Cache (scripts compilados basura)
set "EDGE_CODE=%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Code Cache\js"
if exist "%EDGE_CODE%" (
    del /f /q "%EDGE_CODE%\*" >nul 2>&1
)

:: ─── 4. ESPERAR 30 SEGUNDOS ANTES DEL SIGUIENTE CICLO ─────────
:: 30 seg = casi sin impacto en CPU, pero limpia seguido
echo [%time%] Ciclo completado. Siguiente limpieza en 30 seg...
timeout /t 30 /nobreak >nul

goto LOOP
