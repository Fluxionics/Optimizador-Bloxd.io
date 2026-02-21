@echo off
:: Detectar version de Windows compatible con Win7/8.1/10/11

for /f "tokens=4-5 delims=. " %%a in ('ver') do (
    set WIN_MAJOR=%%a
    set WIN_MINOR=%%b
)

:: Obtener build number
for /f "tokens=3" %%a in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v CurrentBuild 2^>nul') do set WIN_BUILD=%%a

:: Clasificar
set WINVER_ID=desconocido
set WINVER_NOMBRE=Windows Desconocido

if "%WIN_MAJOR%"=="6" (
    if "%WIN_MINOR%"=="1" ( set WINVER_ID=7  & set WINVER_NOMBRE=Windows 7 )
    if "%WIN_MINOR%"=="2" ( set WINVER_ID=8  & set WINVER_NOMBRE=Windows 8 )
    if "%WIN_MINOR%"=="3" ( set WINVER_ID=81 & set WINVER_NOMBRE=Windows 8.1 )
)
if "%WIN_MAJOR%"=="10" (
    if %WIN_BUILD% GEQ 22000 (
        set WINVER_ID=11
        set WINVER_NOMBRE=Windows 11
    ) else (
        set WINVER_ID=10
        set WINVER_NOMBRE=Windows 10
    )
)

echo [OK] Sistema detectado: %WINVER_NOMBRE% (Build %WIN_BUILD%)

:: Advertencia para Win7
if "%WINVER_ID%"=="7" (
    echo [!!] AVISO: Windows 7 tiene soporte limitado.
    echo [!!] Brave puede no funcionar en Win7 muy antiguo.
)
exit /b 0
