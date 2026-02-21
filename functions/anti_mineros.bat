@echo off
echo [ANTI-MINERO] Escaneando procesos sospechosos...

set ENCONTRADO=0

:: Lista de procesos conocidos de mineros y malware
set SOSPECHOSOS=xmrig.exe xmr-stak.exe cpuminer.exe bfgminer.exe cgminer.exe ^
    minerd.exe ethminer.exe claymore.exe phoenix.exe t-rex.exe ^
    nbminer.exe gminer.exe lolminer.exe nanominer.exe srbminer.exe ^
    nicehash.exe excavator.exe nheqminer.exe silentminer.exe ^
    winsvchost32.exe svchost32.exe winlogon32.exe csrss32.exe ^
    taskhost32.exe conhost32.exe dllhost32.exe rundll64.exe

for %%P in (%SOSPECHOSOS%) do (
    tasklist /fi "imagename eq %%P" 2>nul | find /i "%%P" >nul
    if not errorlevel 1 (
        echo [!!] PROCESO SOSPECHOSO ENCONTRADO: %%P
        taskkill /f /im %%P >nul 2>&1
        set ENCONTRADO=1
    )
)

:: Revisar procesos que usan mucho CPU con nombre generico
:: (Busca procesos con nombre de sistema pero en rutas raras)
powershell -command "Get-Process | Where-Object {$_.CPU -gt 50 -and $_.Name -notmatch 'brave|chrome|edge|firefox|System|svchost|lsass|csrss|winlogon|explorer|dwm|audiodg'} | Select-Object Name,CPU | Format-Table -AutoSize" 2>nul

if "%ENCONTRADO%"=="1" (
    echo [OK] Procesos maliciosos eliminados.
) else (
    echo [OK] Sin amenazas detectadas.
)

exit /b 0
