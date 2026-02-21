@echo off
:: Restaurar todo al estado normal al terminar de jugar

echo [REST] Restaurando sistema...

:: Restaurar servicios
sc start "WSearch"   >nul 2>&1
sc start "SysMain"   >nul 2>&1
sc start "DiagTrack" >nul 2>&1
sc start "wuauserv"  >nul 2>&1

:: Restaurar prioridad normal
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v Win32PrioritySeparation /t REG_DWORD /d 2 /f >nul 2>&1

:: Restaurar animaciones
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 0 /f >nul 2>&1

:: Restaurar notificaciones
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /v ToastEnabled /t REG_DWORD /d 1 /f >nul 2>&1

:: Detener limpiador en vivo
taskkill /f /fi "WINDOWTITLE eq FLUXIONICS_BG" >nul 2>&1

echo [REST] PC restaurada correctamente.
exit /b 0
