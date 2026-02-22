@echo off
setlocal enabledelayedexpansion
title FLUXIONICS v3.0
mode con: cols=62 lines=36

:: ── CARPETAS ──────────────────────────────────────────────────
if not exist "%~dp0logs"    mkdir "%~dp0logs"
if not exist "%~dp0saves"   mkdir "%~dp0saves"
if not exist "%~dp0config"  mkdir "%~dp0config"

:: ── CARGAR PERFIL ─────────────────────────────────────────────
set "CFG=%~dp0config\perfil.cfg"
set "USER_NAME=Jugador"
set "USER_COLOR=0a"
set "USER_PIXEL=8"
set "USER_FPS=60"
if exist "%CFG%" (
    for /f "tokens=1,2 delims==" %%a in (%CFG%) do (
        if "%%a"=="NAME"  set "USER_NAME=%%b"
        if "%%a"=="COLOR" set "USER_COLOR=%%b"
        if "%%a"=="PIXEL" set "USER_PIXEL=%%b"
        if "%%a"=="FPS"   set "USER_FPS=%%b"
    )
)

:: ── CARGAR CONTADOR ───────────────────────────────────────────
set "STATS=%~dp0config\stats.cfg"
set "TOTAL_SES=0"
set "TOTAL_MIN=0"
if exist "%STATS%" (
    for /f "tokens=1,2 delims==" %%a in (%STATS%) do (
        if "%%a"=="SESIONES" set "TOTAL_SES=%%b"
        if "%%a"=="MINUTOS"  set "TOTAL_MIN=%%b"
    )
)

:MENU
color %USER_COLOR%
cls
echo.
echo  ==========================================================
echo    FLUXIONICS v3.0  ^|  !USER_NAME!
echo  ==========================================================
echo    Sesiones: !TOTAL_SES!  ^|  Tiempo: !TOTAL_MIN! min  ^|  FPS: !USER_FPS!
echo  ----------------------------------------------------------
echo.
echo    [1]  JUGAR            Bloxd.io optimizado
echo    [2]  MIS JUEGOS       Otros juegos y URLs
echo    [3]  CONFIGURACION    FPS, calidad, opciones
echo    [4]  ESTADO           Info del sistema
echo    [5]  LOG              Historial de sesiones
echo    [6]  PROGRESO         Guardar / Restaurar cuenta
echo    [7]  PERFIL           Nombre, color, pixel
echo    [8]  REINICIAR        Borrar datos
echo    [9]  SALIR
echo.
echo  ==========================================================
echo.
set "OPC="
set /p "OPC=    Elige (1-9): "

if "!OPC!"=="1" goto JUGAR
if "!OPC!"=="2" goto MIS_JUEGOS
if "!OPC!"=="3" goto CONFIGURACION
if "!OPC!"=="4" goto ESTADO
if "!OPC!"=="5" goto LOG
if "!OPC!"=="6" goto PROGRESO
if "!OPC!"=="7" goto PERFIL
if "!OPC!"=="8" goto REINICIAR
if "!OPC!"=="9" goto SALIR
goto MENU

:: ============================================================
:JUGAR
cls
echo.
echo  ==========================================================
echo   [>>] OPTIMIZANDO SISTEMA - MODO TURBO EXTREMO
echo  ==========================================================
echo.
call :LANZAR "https://bloxd.io" "Bloxd.io"
goto MENU

:: ============================================================
:MIS_JUEGOS
cls
echo.
echo  ==========================================================
echo   MIS JUEGOS Y URLs
echo  ==========================================================
echo.

:: Crear lista por defecto si no existe
if not exist "%~dp0saves\urls.txt" (
    echo Bloxd.io=https://bloxd.io > "%~dp0saves\urls.txt"
    echo Krunker=https://krunker.io >> "%~dp0saves\urls.txt"
    echo Shell Shockers=https://shellshock.io >> "%~dp0saves\urls.txt"
)

:: Leer y mostrar
set "IDX=0"
for /f "usebackq tokens=1,2 delims==" %%a in ("%~dp0saves\urls.txt") do (
    set /a IDX+=1
    set "GNAME_!IDX!=%%a"
    set "GURL_!IDX!=%%b"
    echo    [!IDX!]  %%a
)
set "TOTAL_URL=!IDX!"

echo.
echo  ----------------------------------------------------------
echo    [A]  Agregar URL
echo    [B]  Eliminar URL
echo    [0]  Volver
echo  ==========================================================
echo.
set "JUEGOOP="
set /p "JUEGOOP=    Elige: "

if /i "!JUEGOOP!"=="0" goto MENU
if /i "!JUEGOOP!"=="A" goto AGREGAR_URL
if /i "!JUEGOOP!"=="B" goto ELIMINAR_URL

:: Validar que sea numero valido
set "SEL_URL="
if defined GURL_!JUEGOOP! (
    set "SEL_URL=!GURL_%JUEGOOP%!"
    set "SEL_NAME=!GNAME_%JUEGOOP%!"
)
if defined SEL_URL (
    call :LANZAR "!SEL_URL!" "!SEL_NAME!"
) else (
    echo.
    echo    Opcion invalida.
    timeout /t 1 /nobreak >nul
)
goto MIS_JUEGOS

:AGREGAR_URL
echo.
set "NEWNAME="
set "NEWURL="
set /p "NEWNAME=    Nombre del juego: "
set /p "NEWURL=    URL (ej: https://krunker.io): "
if defined NEWNAME if defined NEWURL (
    echo !NEWNAME!=!NEWURL! >> "%~dp0saves\urls.txt"
    echo.
    echo    [OK] "!NEWNAME!" agregado.
) else (
    echo    [!!] Datos incompletos.
)
timeout /t 2 /nobreak >nul
goto MIS_JUEGOS

:ELIMINAR_URL
echo.
set "DELNUM="
set /p "DELNUM=    Numero a eliminar: "
set "DELNAME=!GNAME_%DELNUM%!"
if defined DELNAME (
    set "TMPF=%~dp0saves\urls_tmp.txt"
    type nul > "!TMPF!"
    for /f "usebackq delims=" %%a in ("%~dp0saves\urls.txt") do (
        set "LINE=%%a"
        echo !LINE! | findstr /b "!DELNAME!" >nul || echo !LINE! >> "!TMPF!"
    )
    move /y "!TMPF!" "%~dp0saves\urls.txt" >nul
    echo    [OK] Eliminado.
) else (
    echo    [!!] Numero invalido.
)
timeout /t 2 /nobreak >nul
goto MIS_JUEGOS

:: ============================================================
:ESTADO
cls
echo.
echo  ==========================================================
echo   ESTADO DEL SISTEMA
echo  ==========================================================
echo.

for /f "tokens=3" %%a in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v CurrentBuild 2^>nul') do set "BUILD=%%a"
set "WINNAME=Windows"
if defined BUILD (
    if !BUILD! GEQ 22000 set "WINNAME=Windows 11"
    if !BUILD! LSS 22000 set "WINNAME=Windows 10"
    if !BUILD! LSS 10000 set "WINNAME=Windows 8"
    if !BUILD! LSS 9200  set "WINNAME=Windows 7"
)
echo    Windows       : !WINNAME! (Build !BUILD!)

for /f %%a in ('powershell -nologo -command "[math]::Round((Get-CimInstance Win32_OperatingSystem).FreePhysicalMemory/1024)" 2^>nul') do echo    RAM libre     : %%a MB
for /f %%a in ('powershell -nologo -command "[math]::Round((Get-CimInstance Win32_OperatingSystem).TotalVisibleMemorySize/1024)" 2^>nul') do echo    RAM total     : %%a MB
for /f %%a in ('powershell -nologo -command "(Get-CimInstance Win32_VideoController).Name" 2^>nul') do echo    GPU           : %%a
for /f %%a in ('powershell -nologo -command "(Get-CimInstance Win32_Processor).Name" 2^>nul') do echo    CPU           : %%a
echo.
echo    Perfil        : !USER_NAME!
echo    Color CMD     : !USER_COLOR!
echo    Pixel defecto : !USER_PIXEL!px
echo    Sesiones      : !TOTAL_SES!
echo    Tiempo jugado : !TOTAL_MIN! min
echo.
if exist "%~dp0browser\User Data\Default\Cookies" (
    echo    Cuenta Bloxd  : GUARDADA
) else (
    echo    Cuenta Bloxd  : Sin perfil
)
echo.
echo  ==========================================================
echo.
pause
goto MENU

:: ============================================================
:LOG
cls
echo.
echo  ==========================================================
echo   HISTORIAL DE SESIONES
echo  ==========================================================
echo.
if exist "%~dp0logs\sesiones.log" (
    type "%~dp0logs\sesiones.log"
) else (
    echo    Sin sesiones registradas todavia.
)
echo.
echo  ==========================================================
echo    [1] Limpiar log    [0] Volver
echo  ==========================================================
echo.
set "LOGOP="
set /p "LOGOP=    Opcion: "
if "!LOGOP!"=="1" (
    del "%~dp0logs\sesiones.log" >nul 2>&1
    echo    [OK] Log limpiado.
    timeout /t 2 /nobreak >nul
)
goto MENU

:: ============================================================
:PROGRESO
cls
echo.
echo  ==========================================================
echo   GUARDAR / RESTAURAR CUENTA
echo  ==========================================================
echo.
echo    [1]  Exportar cuenta Bloxd.io
echo    [2]  Importar cuenta Bloxd.io
echo    [3]  Exportar config Fluxionics
echo    [4]  Ver saves guardados
echo    [0]  Volver
echo.
echo  ==========================================================
echo.
set "PROP="
set /p "PROP=    Opcion: "

if "!PROP!"=="0" goto MENU
if "!PROP!"=="1" goto EXPORTAR_CUENTA
if "!PROP!"=="2" goto IMPORTAR_CUENTA
if "!PROP!"=="3" goto EXPORTAR_CONFIG
if "!PROP!"=="4" goto VER_SAVES
goto PROGRESO

:EXPORTAR_CUENTA
cls
echo.
echo    [>>] Exportando perfil...
set "PERFIL=%~dp0browser\User Data\Default"
set "DT=%date:~-4%%date:~3,2%%date:~0,2%"
set "DEST=%~dp0saves\cuenta_!DT!"
if not exist "!PERFIL!" (
    echo    [!!] No hay perfil. Juega una vez primero.
    pause
    goto MENU
)
if not exist "!DEST!" mkdir "!DEST!"
if exist "!PERFIL!\Cookies"          copy  "!PERFIL!\Cookies"          "!DEST!\"                       >nul 2>&1
if exist "!PERFIL!\Local Storage"    xcopy "!PERFIL!\Local Storage"    "!DEST!\Local Storage\"    /E /I /Y /Q >nul 2>&1
if exist "!PERFIL!\Session Storage"  xcopy "!PERFIL!\Session Storage"  "!DEST!\Session Storage\"  /E /I /Y /Q >nul 2>&1
if exist "!PERFIL!\IndexedDB"        xcopy "!PERFIL!\IndexedDB"        "!DEST!\IndexedDB\"        /E /I /Y /Q >nul 2>&1
if exist "!PERFIL!\Preferences"      copy  "!PERFIL!\Preferences"      "!DEST!\"                       >nul 2>&1
echo    [OK] Cuenta exportada en saves\cuenta_!DT!\
pause
goto MENU

:IMPORTAR_CUENTA
cls
echo.
echo    Cuentas disponibles:
echo.
set "HAY=0"
for /d %%a in ("%~dp0saves\cuenta_*") do (
    echo    %%~nxa
    set "HAY=1"
)
if "!HAY!"=="0" (
    echo    No hay cuentas guardadas.
    pause
    goto MENU
)
echo.
set "FNAME="
set /p "FNAME=    Nombre de carpeta: "
if not exist "%~dp0saves\!FNAME!" (
    echo    [!!] No encontrado.
    pause
    goto MENU
)
set "PERFIL=%~dp0browser\User Data\Default"
if not exist "!PERFIL!" mkdir "!PERFIL!"
xcopy "%~dp0saves\!FNAME!\*" "!PERFIL!\" /E /I /Y /Q >nul 2>&1
echo    [OK] Cuenta restaurada.
pause
goto MENU

:EXPORTAR_CONFIG
cls
set "DT=%date:~-4%%date:~3,2%%date:~0,2%"
set "SF=%~dp0saves\config_!DT!.flux"
(
    echo FLUXIONICS_CONFIG_v3
    echo FECHA=%date% %time%
    echo NOMBRE=!USER_NAME!
    echo SESIONES=!TOTAL_SES!
    echo MINUTOS=!TOTAL_MIN!
    echo.
    echo == HISTORIAL ==
    if exist "%~dp0logs\sesiones.log" type "%~dp0logs\sesiones.log"
) > "!SF!"
echo.
echo    [OK] Config guardada en saves\
timeout /t 2 /nobreak >nul
goto MENU

:VER_SAVES
cls
echo.
echo    Archivos en saves\:
echo.
if exist "%~dp0saves\*" (
    dir /b "%~dp0saves\"
) else (
    echo    No hay nada guardado.
)
echo.
pause
goto MENU

:: ============================================================
:PERFIL
cls
echo.
echo  ==========================================================
echo   CONFIGURAR PERFIL
echo  ==========================================================
echo.
echo    Nombre actual  : !USER_NAME!
echo    Color actual   : !USER_COLOR!
echo    Pixel actual   : !USER_PIXEL!px
echo.
echo    [1]  Cambiar nombre
echo    [2]  Cambiar color del CMD
echo    [0]  Volver
echo.
echo  ==========================================================
echo.
set "POP="
set /p "POP=    Opcion: "

if "!POP!"=="0" goto MENU

if "!POP!"=="1" (
    echo.
    set "NEWNM="
    set /p "NEWNM=    Nuevo nombre: "
    if defined NEWNM set "USER_NAME=!NEWNM!"
    call :GUARDAR_PERFIL
    echo    [OK] Nombre actualizado.
    timeout /t 1 /nobreak >nul
    goto PERFIL
)

if "!POP!"=="2" (
    echo.
    echo    Colores disponibles:
    echo    0a Verde ^(default^)   0b Cian
    echo    0c Rojo              0e Amarillo
    echo    0f Blanco            1f Azul/Blanco
    echo    2a Verde oscuro      5f Magenta/Blanco
    echo.
    set "NEWCOL="
    set /p "NEWCOL=    Codigo de color (ej: 0b): "
    if defined NEWCOL (
        set "USER_COLOR=!NEWCOL!"
        color !NEWCOL!
        call :GUARDAR_PERFIL
        echo    [OK] Color actualizado.
    )
    timeout /t 1 /nobreak >nul
    goto PERFIL
)

goto PERFIL

:: ============================================================
:CONFIGURACION
cls
echo.
echo  ==========================================================
echo   CONFIGURACION DEL JUEGO
echo  ==========================================================
echo.
echo    FPS actual     : !USER_FPS!
echo    Pixel actual   : !USER_PIXEL!px
echo.
echo  ----------------------------------------------------------
echo.
echo    [1]  Limite de FPS
echo    [2]  Calidad de pixeles
echo    [3]  Ver configuracion actual
echo    [0]  Volver
echo.
echo  ==========================================================
echo.
set "CFGOP="
set /p "CFGOP=    Elige (0-3): "

if "!CFGOP!"=="0" goto MENU
if "!CFGOP!"=="1" goto CFG_FPS
if "!CFGOP!"=="2" goto CFG_PIXEL
if "!CFGOP!"=="3" goto CFG_VER
goto CONFIGURACION

:CFG_FPS
cls
echo.
echo  ==========================================================
echo   LIMITE DE FPS
echo  ==========================================================
echo.
echo    El limite de FPS controla cuantos fotogramas por
echo    segundo genera el juego. Mas FPS = mas CPU usado.
echo    Si tu PC es debil, pon 60. Si es buena, pon mas.
echo.
echo  ----------------------------------------------------------
echo.
echo    [1]   60 FPS   Estable - para cualquier PC
echo    [2]  140 FPS   Alto    - para PCs con buena RAM
echo    [3]  195 FPS   Maximo  - para PCs potentes
echo    [4]    0 FPS   Sin limite (riesgo de stutters)
echo    [5]  Personalizado (escribe el numero)
echo    [0]  Volver
echo.
echo    Configuracion actual: !USER_FPS! FPS
echo.
echo  ==========================================================
echo.
set "FPSOP="
set /p "FPSOP=    Elige: "

if "!FPSOP!"=="0" goto CONFIGURACION
if "!FPSOP!"=="1" ( set "USER_FPS=60"  & goto CFG_FPS_SAVE )
if "!FPSOP!"=="2" ( set "USER_FPS=140" & goto CFG_FPS_SAVE )
if "!FPSOP!"=="3" ( set "USER_FPS=195" & goto CFG_FPS_SAVE )
if "!FPSOP!"=="4" ( set "USER_FPS=0"   & goto CFG_FPS_SAVE )
if "!FPSOP!"=="5" (
    echo.
    set "FPSCUSTOM="
    set /p "FPSCUSTOM=    Escribe el FPS deseado (ej: 120): "
    if defined FPSCUSTOM (
        set "USER_FPS=!FPSCUSTOM!"
        goto CFG_FPS_SAVE
    )
)
goto CFG_FPS

:CFG_FPS_SAVE
call :GUARDAR_PERFIL
echo.
if "!USER_FPS!"=="0" (
    echo    [OK] Sin limite de FPS activado.
    echo    [!]  Cuidado: puede causar stutters en PCs debiles.
) else (
    echo    [OK] Limite de FPS guardado: !USER_FPS! FPS
)
timeout /t 2 /nobreak >nul
goto CONFIGURACION

:CFG_PIXEL
cls
echo.
echo  ==========================================================
echo   CALIDAD DE PIXELES
echo  ==========================================================
echo.
echo    Los pixeles controlan la calidad visual del juego.
echo    Menos pixeles = mas FPS pero peor calidad visual.
echo    Mas pixeles = mejor calidad pero menos FPS.
echo.
echo  ----------------------------------------------------------
echo.
echo    [1]   1px  Ultra bajo  (maximos FPS, calidad minima)
echo    [2]   2px  Bajo        (muy buenos FPS)
echo    [3]   4px  Medio       (balance)
echo    [4]   8px  Alto        (recomendado)
echo    [5]  16px  Ultra       (mejor calidad, menos FPS)
echo    [0]  Volver
echo.
echo    Configuracion actual: !USER_PIXEL!px
echo.
echo  ==========================================================
echo.
set "PXOP="
set /p "PXOP=    Elige: "

if "!PXOP!"=="0" goto CONFIGURACION
if "!PXOP!"=="1" set "USER_PIXEL=1"
if "!PXOP!"=="2" set "USER_PIXEL=2"
if "!PXOP!"=="3" set "USER_PIXEL=4"
if "!PXOP!"=="4" set "USER_PIXEL=8"
if "!PXOP!"=="5" set "USER_PIXEL=16"
call :GUARDAR_PERFIL
echo.
echo    [OK] Calidad de pixel guardada: !USER_PIXEL!px
timeout /t 2 /nobreak >nul
goto CONFIGURACION

:CFG_VER
cls
echo.
echo  ==========================================================
echo   CONFIGURACION ACTUAL
echo  ==========================================================
echo.
echo    Limite de FPS    : !USER_FPS! FPS
echo    Calidad pixel    : !USER_PIXEL!px
echo    Nombre perfil    : !USER_NAME!
echo    Color CMD        : !USER_COLOR!
echo    Sesiones totales : !TOTAL_SES!
echo    Tiempo jugado    : !TOTAL_MIN! min
echo.
echo  ==========================================================
echo.
pause
goto CONFIGURACION

:: ============================================================
:REINICIAR
cls
echo.
echo  ==========================================================
echo   REINICIO DE DATOS
echo  ==========================================================
echo.
echo    [1]  Borrar saves          (conserva perfil y log)
echo    [2]  Borrar log            (conserva saves y perfil)
echo    [3]  Resetear estadisticas (sesiones y tiempo)
echo    [4]  Borrar TODO           (IRREVERSIBLE)
echo    [0]  Volver
echo.
echo  ==========================================================
echo.
set "REINOP="
set /p "REINOP=    Opcion: "

if "!REINOP!"=="0" goto MENU
if "!REINOP!"=="1" (
    del /f /q "%~dp0saves\*" >nul 2>&1
    echo    [OK] Saves borrados.
    timeout /t 2 /nobreak >nul
    goto MENU
)
if "!REINOP!"=="2" (
    del "%~dp0logs\sesiones.log" >nul 2>&1
    echo    [OK] Log borrado.
    timeout /t 2 /nobreak >nul
    goto MENU
)
if "!REINOP!"=="3" (
    set "TOTAL_SES=0"
    set "TOTAL_MIN=0"
    call :GUARDAR_STATS
    echo    [OK] Estadisticas reseteadas.
    timeout /t 2 /nobreak >nul
    goto MENU
)
if "!REINOP!"=="4" (
    echo.
    set "CONF="
    set /p "CONF=    Escribe CONFIRMAR para continuar: "
    if /i "!CONF!"=="CONFIRMAR" (
        del /f /q "%~dp0logs\*"   >nul 2>&1
        del /f /q "%~dp0saves\*"  >nul 2>&1
        del /f /q "%~dp0config\*" >nul 2>&1
        set "TOTAL_SES=0"
        set "TOTAL_MIN=0"
        set "USER_NAME=Jugador"
        set "USER_COLOR=0a"
        set "USER_PIXEL=8"
        echo    [OK] Todo borrado. Reiniciando...
        timeout /t 2 /nobreak >nul
        goto MENU
    ) else (
        echo    [--] Cancelado.
        timeout /t 2 /nobreak >nul
    )
    goto MENU
)
goto REINICIAR

:: ============================================================
:SALIR
cls
echo.
echo    Hasta la proxima. Espero verte pronto.
echo.
sc start "WSearch"  >nul 2>&1
sc start "SysMain"  >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v Win32PrioritySeparation /t REG_DWORD /d 2 /f >nul 2>&1
timeout /t 2 /nobreak >nul
exit

:: ============================================================
:: FUNCION PRINCIPAL: OPTIMIZAR Y LANZAR
:LANZAR
cls
echo.
echo  ==========================================================
echo   [>>] OPTIMIZACION TURBO EXTREMA...
echo  ==========================================================
echo.

:: Detectar Windows por build number (compatible Win7-Win11)
set "WINVER_ID=10"
set "WINVER_NOMBRE=Windows"
for /f "tokens=3" %%a in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v CurrentBuild 2^>nul') do set "BUILD=%%a"
if defined BUILD (
    if !BUILD! GEQ 22000 ( set "WINVER_NOMBRE=Windows 11" & set "WINVER_ID=11" )
    if !BUILD! LSS 22000  ( set "WINVER_NOMBRE=Windows 10" & set "WINVER_ID=10" )
    if !BUILD! LSS 10000  ( set "WINVER_NOMBRE=Windows 8"  & set "WINVER_ID=8"  )
    if !BUILD! LSS 9200   ( set "WINVER_NOMBRE=Windows 7"  & set "WINVER_ID=7"  )
)
echo    [OK] Sistema: !WINVER_NOMBRE!

:: RAM y modo automatico
set "JS_MEMORY=256"
set "MODO_RAM=TURBO"
for /f %%a in ('powershell -nologo -command "[math]::Round((Get-CimInstance Win32_OperatingSystem).FreePhysicalMemory/1024)" 2^>nul') do set "RAMMB=%%a"
if defined RAMMB (
    if !RAMMB! LSS 800  ( set "MODO_RAM=MINIMO"  & set "JS_MEMORY=128"  )
    if !RAMMB! GEQ 800  ( set "MODO_RAM=TURBO"   & set "JS_MEMORY=256"  )
    if !RAMMB! GEQ 2000 ( set "MODO_RAM=ALTO"    & set "JS_MEMORY=512"  )
    if !RAMMB! GEQ 6000 ( set "MODO_RAM=MAXIMO"  & set "JS_MEMORY=1024" )
    echo    [OK] RAM: !RAMMB! MB libres - Modo !MODO_RAM!
)

:: Matar procesos pesados
echo    [>>] Liberando RAM...
for %%P in (
    SearchIndexer.exe SearchHost.exe OneDrive.exe Widgets.exe
    WidgetService.exe Teams.exe ms-teams.exe Cortana.exe
    SgrmBroker.exe TiWorker.exe MoUsoCoreWorker.exe
    Discord.exe Spotify.exe Slack.exe OfficeClickToRun.exe
    MicrosoftEdgeUpdate.exe YourPhone.exe PhoneExperienceHost.exe
    WerFault.exe WerFaultSecure.exe PcaSvc.exe
) do taskkill /f /im %%P >nul 2>&1
del /f /s /q "%temp%\*" >nul 2>&1
echo    [OK] RAM liberada.

:: Servicios - Win10/11 (los mas agresivos)
if "!WINVER_ID!"=="10" (
    for %%S in (WSearch SysMain DiagTrack wuauserv BITS
                TabletInputService WMPNetworkSvc
                RetailDemo XblAuthManager XblGameSave) do (
        sc stop "%%S" >nul 2>&1
    )
)
if "!WINVER_ID!"=="11" (
    for %%S in (WSearch SysMain DiagTrack wuauserv BITS
                TabletInputService WMPNetworkSvc
                RetailDemo XblAuthManager XblGameSave
                GameBarPresenceWriter Widgets) do (
        sc stop "%%S" >nul 2>&1
    )
)
:: Servicios compatibles Win7/8
if "!WINVER_ID!"=="7"  sc stop "WSearch" >nul 2>&1 & sc stop "wuauserv" >nul 2>&1
if "!WINVER_ID!"=="8"  sc stop "WSearch" >nul 2>&1 & sc stop "wuauserv" >nul 2>&1
echo    [OK] Servicios pausados.

:: Optimizacion del sistema
powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1
:: Prioridad maxima al primer plano
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v Win32PrioritySeparation /t REG_DWORD /d 38 /f >nul 2>&1
:: Sin efectos visuales
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v UserPreferencesMask /t REG_BINARY /d 90120280 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d 0 /f >nul 2>&1
:: Sin notificaciones
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /v ToastEnabled /t REG_DWORD /d 0 /f >nul 2>&1
:: Network throttling off (mejora latencia en juegos online)
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v NetworkThrottlingIndex /t REG_DWORD /d 4294967295 /f >nul 2>&1
:: Prioridad de juegos al maximo
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d 8 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /t REG_DWORD /d 6 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d "High" /f >nul 2>&1
echo    [OK] Sistema optimizado al maximo.

:: Anti mineros
for %%P in (xmrig.exe ethminer.exe nicehash.exe cpuminer.exe nbminer.exe claymore.exe t-rex.exe gminer.exe) do taskkill /f /im %%P >nul 2>&1
echo    [OK] Anti-mineros OK.

:: Limpiar SOLO cache temporal (no tocar perfil ni preferencias)
set "BDATA=%~dp0browser\User Data\Default"
if exist "!BDATA!\Cache\Cache_Data" del /f /q "!BDATA!\Cache\Cache_Data\*" >nul 2>&1
if exist "!BDATA!\GPUCache"          del /f /q "!BDATA!\GPUCache\*"          >nul 2>&1
echo    [OK] Cache limpiado.

:: Verificar Brave
if not exist "%~dp0browser\brave.exe" (
    echo.
    echo    [!!] brave.exe no encontrado en browser\
    echo    [!]  Descarga Brave Portable y coloca brave.exe en browser\
    echo.
    pause
    exit /b
)

:: Registrar inicio y guardar hora de inicio
echo [%date% %time%] INICIO: %~2 - !WINVER_NOMBRE! - !MODO_RAM! >> "%~dp0logs\sesiones.log"
set "HORA_INI=%time:~0,2%%time:~3,2%"
set /a "HORA_INI_MIN=(%time:~0,2% * 60) + %time:~3,2%"

echo.
echo    [>>] Abriendo %~2...
echo.

:: Script JS que aplica el pixel setting automaticamente al cargar
set "PIXEL_VAL=!USER_PIXEL!"

:: Lanzar con todas las optimizaciones
:: Escribir config en archivo para que la extension la inyecte
:: content.js lee este archivo via fetch() al cargar bloxd.io
set "FLXCFG=%~dp0extension\fluxconfig.js"
(
    echo // Config generada por FLUXIONICS - no editar
    echo window.FLUXIONICS_FPS   = !USER_FPS!;
    echo window.FLUXIONICS_PIXEL = !USER_PIXEL!;
) > "!FLXCFG!"

:: NOTA: --app desactiva extensiones, usamos modo normal con start maximizado
:: La extension SOLO funciona sin --app
start "" /HIGH "%~dp0browser\brave.exe" ^
  "https://bloxd.io" ^
  --start-maximized ^
  --load-extension="%~dp0extension" ^
  --disable-notifications ^
  --disable-background-networking ^
  --disable-background-timer-throttling ^
  --disable-renderer-backgrounding ^
  --disable-backgrounding-occluded-windows ^
  --disable-hang-monitor ^
  --disable-sync ^
  --no-first-run ^
  --disable-gpu-vsync ^
  --disable-frame-rate-limit ^
  --disable-ipc-flooding-protection ^
  --no-proxy-server ^
  --js-flags="--max-old-space-size=!JS_MEMORY! --gc-interval=500"

:: Aplicar limite de FPS via archivo de preferencias de Brave
if "!USER_FPS!"=="0" goto :SKIP_FPS
set "PREFS=%~dp0browser\User Data\Default\Preferences"
if exist "!PREFS!" (
    powershell -nologo -command "$p='!PREFS!'.Replace('\\','\');$c=Get-Content $p -Raw;if($c -notmatch 'animation_policy'){$c=$c -replace '\{','{ "animation_policy": 0,'};Set-Content $p $c" >nul 2>&1
)
:SKIP_FPS

timeout /t 4 /nobreak >nul

:: Prioridad HIGH a todos los procesos de Brave
powershell -nologo -command "Get-Process brave -ErrorAction SilentlyContinue | ForEach-Object { $_.PriorityClass = 'High' }" >nul 2>&1

echo  ==========================================================
echo   [OK] !%~2! abierto
echo   [OK] Modo: !MODO_RAM! - Sistema: !WINVER_NOMBRE!
echo   [OK] Pixel defecto : !USER_PIXEL!px
if "!USER_FPS!"=="0" (
    echo   [OK] Limite FPS    : Sin limite
) else (
    echo   [OK] Limite FPS    : !USER_FPS! FPS
)
echo  ==========================================================
echo.
echo    Presiona cualquier tecla cuando termines de jugar...
pause >nul

:: Calcular tiempo jugado
set /a "HORA_FIN_MIN=(%time:~0,2% * 60) + %time:~3,2%"
set /a "DIFF=HORA_FIN_MIN - HORA_INI_MIN"
if !DIFF! LSS 0 set /a "DIFF=DIFF + 1440"
set /a "TOTAL_MIN=TOTAL_MIN + DIFF"
set /a "TOTAL_SES=TOTAL_SES + 1"
call :GUARDAR_STATS

:: Registrar fin
echo [%date% %time%] FIN: %~2 - !DIFF! min jugados >> "%~dp0logs\sesiones.log"

:: Restaurar sistema
sc start "WSearch"  >nul 2>&1
sc start "SysMain"  >nul 2>&1
sc start "wuauserv" >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v Win32PrioritySeparation /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /v ToastEnabled /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v NetworkThrottlingIndex /t REG_DWORD /d 10 /f >nul 2>&1

echo    [OK] PC restaurada. Sesion !TOTAL_SES! - !DIFF! min jugados.
timeout /t 2 /nobreak >nul
exit /b

:: ── GUARDAR PERFIL ────────────────────────────────────────────
:GUARDAR_PERFIL
(
    echo NAME=!USER_NAME!
    echo COLOR=!USER_COLOR!
    echo PIXEL=!USER_PIXEL!
    echo FPS=!USER_FPS!
) > "%~dp0config\perfil.cfg"
exit /b

:: ── GUARDAR ESTADISTICAS ──────────────────────────────────────
:GUARDAR_STATS
(
    echo SESIONES=!TOTAL_SES!
    echo MINUTOS=!TOTAL_MIN!
) > "%~dp0config\stats.cfg"
exit /b
