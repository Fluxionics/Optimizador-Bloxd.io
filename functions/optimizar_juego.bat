@echo off
:: ─────────────────────────────────────────────────────────────
:: OPTIMIZAR_JUEGO.BAT
:: Lo mas importante: preparar la PC para maximos FPS
:: ─────────────────────────────────────────────────────────────

echo [OPT] Iniciando optimizacion profunda...

:: 1. LIMPIAR RAM - matar lo que no sirve para jugar
taskkill /f /im SearchIndexer.exe    >nul 2>&1
taskkill /f /im SearchHost.exe       >nul 2>&1
taskkill /f /im OneDrive.exe         >nul 2>&1
taskkill /f /im Widgets.exe          >nul 2>&1
taskkill /f /im WidgetService.exe    >nul 2>&1
taskkill /f /im Teams.exe            >nul 2>&1
taskkill /f /im ms-teams.exe         >nul 2>&1
taskkill /f /im Cortana.exe          >nul 2>&1
taskkill /f /im SgrmBroker.exe       >nul 2>&1
taskkill /f /im TiWorker.exe         >nul 2>&1
taskkill /f /im MoUsoCoreWorker.exe  >nul 2>&1
taskkill /f /im OfficeClickToRun.exe >nul 2>&1
taskkill /f /im msteams.exe          >nul 2>&1
taskkill /f /im Slack.exe            >nul 2>&1
taskkill /f /im Discord.exe          >nul 2>&1
taskkill /f /im Spotify.exe          >nul 2>&1
echo [OPT] Procesos basura eliminados.

:: 2. LIMPIAR TEMPORALES (libera disco = menos stutters)
del /f /s /q "%temp%\*"           >nul 2>&1
del /f /s /q "C:\Windows\Temp\*"  >nul 2>&1
echo [OPT] Temporales limpiados.

:: 3. PAUSAR SERVICIOS PESADOS (solo Win10/11)
if "%WINVER_ID%"=="10" (
    sc stop "WSearch"        >nul 2>&1
    sc stop "SysMain"        >nul 2>&1
    sc stop "DiagTrack"      >nul 2>&1
    sc stop "wuauserv"       >nul 2>&1
    sc stop "BITS"           >nul 2>&1
)
if "%WINVER_ID%"=="11" (
    sc stop "WSearch"        >nul 2>&1
    sc stop "SysMain"        >nul 2>&1
    sc stop "DiagTrack"      >nul 2>&1
    sc stop "wuauserv"       >nul 2>&1
    sc stop "BITS"           >nul 2>&1
)
echo [OPT] Servicios pesados pausados.

:: 4. PLAN DE ENERGIA - ALTO RENDIMIENTO
powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1
echo [OPT] Plan de energia: Alto Rendimiento.

:: 5. PRIORIDAD DEL SISTEMA A PRIMER PLANO
:: Valor 38 = maximo para aplicaciones activas
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v Win32PrioritySeparation /t REG_DWORD /d 38 /f >nul 2>&1
echo [OPT] Prioridad de CPU al primer plano.

:: 6. DESACTIVAR ANIMACIONES DE WINDOWS
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v UserPreferencesMask /t REG_BINARY /d 90120280 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d 0 /f >nul 2>&1
echo [OPT] Animaciones desactivadas.

:: 7. DESHABILITAR NOTIFICACIONES DEL SISTEMA
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /v ToastEnabled /t REG_DWORD /d 0 /f >nul 2>&1
echo [OPT] Notificaciones desactivadas.

:: 8. TIMER DE RESOLUCION ALTA (reduce input lag)
:: Solo Win8+
if not "%WINVER_ID%"=="7" (
    powershell -command "& { Add-Type -TypeDefinition 'using System;using System.Runtime.InteropServices;public class WinAPI{[DllImport(\"winmm.dll\")]public static extern int timeBeginPeriod(int t);}'; [WinAPI]::timeBeginPeriod(1) }" >nul 2>&1
)
echo [OPT] Timer de alta resolucion activado.

echo [OPT] Optimizacion completa. Sistema listo para jugar.
exit /b 0
