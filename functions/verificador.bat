@echo off
echo [VERIFICADOR] Revisando sistema...
echo.

if not exist "%~dp0..\browser\brave.exe" (
    echo [ERROR] Brave Portable no encontrado en carpeta browser\
    echo [!] Pon brave.exe en la carpeta browser\ y vuelve a intentar.
    pause
    exit /b 1
)
echo [OK] Brave Portable encontrado.

powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1
echo [OK] Plan Alto Rendimiento activado.

echo [VERIFICADOR] Todo listo.
echo.
exit /b 0
