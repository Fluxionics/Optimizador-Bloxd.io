@echo off
setlocal enabledelayedexpansion
title FLUXIONICS - Instalador v3.0.1
color 0a
mode con: cols=62 lines=35

cls
echo.
echo  ==========================================================
echo   FLUXIONICS v3.0.1 - INSTALADOR
echo  ==========================================================
echo.
echo   El instalador configurara todo automaticamente.
echo   Solo necesitas internet y unos minutos.
echo.
echo   Presiona cualquier tecla para comenzar...
pause >nul

:: ── PASO 1: CARPETAS ─────────────────────────────────────────
cls
echo.
echo   [1/4] Creando carpetas...
for %%D in (browser config logs saves extension) do (
    if not exist "%~dp0%%D" mkdir "%~dp0%%D"
)
echo   [OK] Carpetas creadas.

:: ── PASO 2: INTERNET ─────────────────────────────────────────
echo.
echo   [2/4] Verificando internet...
ping -n 1 8.8.8.8 >nul 2>&1
if errorlevel 1 (
    echo   [!!] Sin internet. Conectate e intenta de nuevo.
    pause
    exit
)
echo   [OK] Conexion activa.

:: ── PASO 3: BRAVE ────────────────────────────────────────────
echo.
echo   [3/4] Instalando Brave...

if exist "%~dp0browser\brave.exe" (
    echo   [OK] Brave ya esta instalado. Saltando...
    goto DESBLOQUEAR
)

echo   [>>] Descargando instalador oficial de Brave...
echo   [!]  Puede tardar 1-3 minutos segun tu internet.
echo.

:: Guardar script de descarga en archivo temporal
set "PS1=%temp%\flux_brave.ps1"
(
    echo [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    echo $setup = '%~dp0browser\BraveSetup.exe'
    echo $url = 'https://referrals.brave.com/latest/BraveBrowserSetup.exe'
    echo $wc = New-Object System.Net.WebClient
    echo $wc.DownloadFile^($url, $setup^)
) > "!PS1!"

powershell -nologo -executionpolicy bypass -file "!PS1!"
del "!PS1!" >nul 2>&1

if not exist "%~dp0browser\BraveSetup.exe" (
    echo   [!!] Fallo la descarga. Verifica tu internet.
    pause
    exit
)

echo   [OK] Descarga completada.
echo   [>>] Instalando Brave en silencio...

start /wait "" "%~dp0browser\BraveSetup.exe" /silent /install
del "%~dp0browser\BraveSetup.exe" >nul 2>&1

:: Esperar a que termine de instalarse
timeout /t 3 /nobreak >nul

:: Buscar brave.exe y copiarlo a browser\
set "BRAVE_EXE="
for %%P in (
    "%LOCALAPPDATA%\BraveSoftware\Brave-Browser\Application\brave.exe"
    "%PROGRAMFILES%\BraveSoftware\Brave-Browser\Application\brave.exe"
    "%PROGRAMFILES(X86)%\BraveSoftware\Brave-Browser\Application\brave.exe"
) do (
    if exist %%P if not defined BRAVE_EXE set "BRAVE_EXE=%%~P"
)

if defined BRAVE_EXE (
    copy "!BRAVE_EXE!" "%~dp0browser\brave.exe" >nul 2>&1
    echo   [OK] brave.exe copiado a browser\
) else (
    echo   [!!] No se encontro brave.exe tras instalar.
    echo   [!]  Busca brave.exe en tu PC y copialo a browser\
    pause
)

:: ── PASO 4: DESBLOQUEAR ──────────────────────────────────────
:DESBLOQUEAR
echo.
echo   [4/4] Desbloqueando archivos...

set "PS1=%temp%\flux_unblock.ps1"
(
    echo Get-ChildItem -Path '%~dp0' -Recurse -Include *.bat,*.ps1,*.js,*.json,*.md,*.txt,*.html ^| ForEach-Object {
    echo     Unblock-File -Path $_.FullName -ErrorAction SilentlyContinue
    echo }
    echo Add-MpPreference -ExclusionPath '%~dp0' -ErrorAction SilentlyContinue
) > "!PS1!"
powershell -nologo -executionpolicy bypass -file "!PS1!"
del "!PS1!" >nul 2>&1
echo   [OK] Archivos desbloqueados.

:: ── RESULTADO ────────────────────────────────────────────────
cls
echo.
echo  ==========================================================
echo   INSTALACION COMPLETADA
echo  ==========================================================
echo.
if exist "%~dp0browser\brave.exe" (
    echo   [OK] Brave          : Instalado y listo
) else (
    echo   [!!] Brave          : Copia brave.exe a browser\ manualmente
)
echo   [OK] Carpetas       : Creadas
echo   [OK] SmartScreen    : Desactivado para esta carpeta
echo.
echo  ----------------------------------------------------------
echo   Todo listo. Abre lanzador.bat para jugar.
echo  ==========================================================
echo.
pause
