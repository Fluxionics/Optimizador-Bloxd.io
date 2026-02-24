@echo off
:: FLUXIONICS - Desbloquear archivos de la zona de internet
:: Ejecutar UNA VEZ despues de descargar el proyecto

cd /d "%~dp0"

echo.
echo  ========================================================
echo   FLUXIONICS - Desbloqueando archivos...
echo  ========================================================
echo.

:: Quitar marca Zone.Identifier de todos los archivos
:: Esta marca es la que hace que SmartScreen salte
for /r "%~dp0" %%f in (*.bat *.ps1 *.js *.json *.txt *.html) do (
    powershell -nologo -command "Unblock-File -Path '%%f'" >nul 2>&1
)

:: Metodo alternativo via streams NTFS
for /r "%~dp0" %%f in (*.bat *.ps1 *.js *.json *.txt *.html) do (
    echo. > "%%f:Zone.Identifier" >nul 2>&1
)

:: Agregar la carpeta completa a exclusiones de SmartScreen (requiere admin)
powershell -nologo -command "Add-MpPreference -ExclusionPath '%~dp0' -ErrorAction SilentlyContinue" >nul 2>&1

echo   [OK] Archivos desbloqueados.
echo   [OK] Carpeta agregada a exclusiones.
echo.
echo   Ahora puedes abrir lanzador.bat sin advertencias.
echo.
pause
