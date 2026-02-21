<div align="center">

```
███████╗██╗     ██╗   ██╗██╗  ██╗██╗ ██████╗ ███╗   ██╗██╗ ██████╗███████╗
██╔════╝██║     ██║   ██║╚██╗██╔╝██║██╔═══██╗████╗  ██║██║██╔════╝██╔════╝
█████╗  ██║     ██║   ██║ ╚███╔╝ ██║██║   ██║██╔██╗ ██║██║██║     ███████╗
██╔══╝  ██║     ██║   ██║ ██╔██╗ ██║██║   ██║██║╚██╗██║██║██║     ╚════██║
██║     ███████╗╚██████╔╝██╔╝ ██╗██║╚██████╔╝██║ ╚████║██║╚██████╗███████║
╚═╝     ╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝ ╚═════╝╚══════╝
```

# FLUXIONICS v2.0

**Optimizador de rendimiento para Bloxd.io**

[![Windows](https://img.shields.io/badge/Windows-7%20%7C%208%20%7C%2010%20%7C%2011-00cc66?style=flat-square&logo=windows&logoColor=white)](https://fluxionics.github.io)
[![Version](https://img.shields.io/badge/Version-2.0-00ff88?style=flat-square)](https://fluxionics.github.io)
[![Brave](https://img.shields.io/badge/Navegador-Brave%20Portable-FF5733?style=flat-square&logo=brave&logoColor=white)](https://fluxionics.github.io)
[![Status](https://img.shields.io/badge/Status-Activo-00ff88?style=flat-square)](https://fluxionics.github.io)

🌐 **[fluxionics.github.io](https://fluxionics.github.io)**

</div>

---

## ¿Qué es FLUXIONICS?

FLUXIONICS es un sistema de optimización automática para jugar **Bloxd.io** a la máxima cantidad de FPS posible en cualquier PC con Windows. El usuario solo hace doble clic en `lanzador.bat` y el resto ocurre automáticamente:

- Detecta tu versión de Windows (7 / 8 / 8.1 / 10 / 11)
- Calcula la RAM disponible y elige el modo óptimo
- Elimina procesos y servicios innecesarios de forma segura
- Optimiza la prioridad de CPU y GPU
- Abre Bloxd.io en Brave con +15 flags de rendimiento activas
- Restaura todo automáticamente al terminar de jugar

---

## Instalación rápida

```
1. Descarga o clona este repositorio
2. Descarga Brave Portable y coloca brave.exe en la carpeta browser\
3. Haz doble clic en lanzador.bat
4. Elige [1] JUGAR y listo
```

> **Nota:** Solo necesitas internet la primera vez para descargar Brave Portable.  
> En otras PCs solo copia toda la carpeta y funciona sin instalar nada.

---

## Menú principal

Al abrir `lanzador.bat` aparece este menú en el CMD:

```
==========================================================
  FLUXIONICS v2.0 — GUILLERMO RAFAEL
==========================================================

  [ 1 ]  JUGAR         Optimizar y abrir Bloxd.io
  [ 2 ]  ESTADO        Ver info del sistema
  [ 3 ]  LOG           Historial de sesiones
  [ 4 ]  PROGRESO      Exportar / Importar saves
  [ 5 ]  REINICIAR     Empezar de cero o borrar todo
  [ 6 ]  SALIR

==========================================================
```

| Opción | Función |
|--------|---------|
| `[1] JUGAR` | Ejecuta toda la optimización y abre Bloxd.io |
| `[2] ESTADO` | Muestra Windows, RAM, GPU, CPU y estado del limpiador |
| `[3] LOG` | Historial de sesiones con opción de exportar o limpiar |
| `[4] PROGRESO` | Exporta/importa tu configuración como archivo `.flux` |
| `[5] REINICIAR` | Borra configuración o todo el progreso (pide confirmación) |
| `[6] SALIR` | Restaura la PC y cierra |

---

## ¿Qué hace la optimización?

Cuando eliges **JUGAR**, se ejecutan 6 pasos en orden:

### Paso 1 — Detectar Windows
Identifica automáticamente Win 7, 8, 8.1, 10 u 11 usando el Build Number del registro. Determina qué optimizaciones son compatibles con tu sistema.

### Paso 2 — Modo RAM automático

| RAM libre | Modo asignado | JS Memory |
|-----------|--------------|-----------|
| < 800 MB | MÍNIMO | 128 MB |
| 800 MB – 2 GB | TURBO 4GB | 256 MB |
| 2 GB – 6 GB | ALTO 8GB | 512 MB |
| > 6 GB | MÁXIMO | 1024 MB |

### Paso 3 — Liberar RAM y CPU
Elimina procesos que consumen recursos sin ser necesarios para jugar:

```
SearchIndexer  OneDrive    Widgets     Teams
Cortana        SgrmBroker  TiWorker    MoUsoCoreWorker
Spotify        Discord     Slack       OfficeClickToRun
```

> ⚠️ **Importante:** `explorer.exe` y procesos del sistema nunca se tocan.  
> Solo se eliminan procesos que no afectan el funcionamiento de Windows.

### Paso 4 — Pausar servicios (Win10/11)

| Servicio | Descripción |
|----------|-------------|
| `WSearch` | Indexador de búsqueda |
| `SysMain` | Superfetch / precarga de apps |
| `DiagTrack` | Telemetría de Microsoft |
| `wuauserv` | Windows Update |
| `BITS` | Transferencias en segundo plano |

Todos se **reinician automáticamente** al terminar de jugar.

### Paso 5 — Optimizaciones del sistema

```
Plan de energía        →  Alto Rendimiento
Win32PrioritySep       →  38 (máxima prioridad al juego)
Efectos visuales       →  Desactivados
Animaciones de Win11   →  Desactivadas
Notificaciones         →  Desactivadas
Timer resolución       →  1ms (reduce input lag)
```

### Paso 6 — Flags de Brave

```
--disable-background-timer-throttling
--disable-renderer-backgrounding
--disable-backgrounding-occluded-windows
--disable-gpu-vsync
--disable-frame-rate-limit
--enable-features=VaapiVideoDecoder,CanvasOopRasterization
--disable-ipc-flooding-protection
--aggressive-cache-discard
--process-per-site
```

El proceso de Brave recibe prioridad `HIGH` vía PowerShell automáticamente.

---

## Estructura de archivos

```
Fluxionics/
│
├── 📄 lanzador.bat                 ← EJECUTAR ESTE (doble clic)
├── 📄 LEEME.txt                    ← Instrucciones rápidas
│
├── 📁 browser/
│   └── brave.exe                   ← Brave Portable aquí
│
├── 📁 config/
│   └── brave_flags.txt             ← Referencia de flags de optimización
│
├── 📁 data/                        ← Generado automáticamente
│   └── estado.txt                  ← Estado del sistema última sesión
│
├── 📁 logs/                        ← Generado automáticamente
│   └── sesiones.log                ← Historial de todas las sesiones
│
├── 📁 saves/                       ← Generado automáticamente
│   └── *.flux                      ← Archivos de progreso exportados
│
└── 📁 functions/                   ← Scripts internos (no modificar)
    ├── detectar_win.bat            ← Detecta Windows 7/8/8.1/10/11
    ├── modo_ram.bat                ← Lee RAM y elige modo automático
    ├── optimizar_juego.bat         ← Optimización principal del sistema
    ├── anti_mineros.bat            ← Detecta y elimina mineros/malware
    ├── limpiador_vivo.bat          ← Limpieza continua cada 30 segundos
    ├── restaurar.bat               ← Restaura el sistema al terminar
    ├── logger.bat                  ← Guarda registro de cada sesión
    └── verificador.bat             ← Verifica que brave.exe exista
```

---

## Compatibilidad

| Windows | Soporte | Servicios pausados | Notas |
|---------|---------|-------------------|-------|
| Windows 7 | ✅ Básico | ❌ | Brave puede tener limitaciones menores |
| Windows 8 / 8.1 | ✅ Bueno | ❌ | Funciona correctamente |
| Windows 10 | ✅ Completo | ✅ | Todos los pasos activos |
| Windows 11 | ✅ Completo | ✅ | Mejor rendimiento general |

---

## Gestión de progreso

FLUXIONICS guarda tu historial de sesiones y configuración localmente.

**Exportar progreso:**
```
Menú → [4] PROGRESO → [1] Exportar
Genera: saves\progreso_YYYYMMDD_HHMM.flux
```

**Importar progreso en otra PC:**
```
1. Copia tu archivo .flux a la carpeta saves\ de la otra PC
2. Menú → [4] PROGRESO → [2] Importar
3. Escribe el nombre del archivo cuando se pida
```

**El archivo `.flux` contiene:** historial de sesiones, configuración guardada y fecha de exportación. Funciona en cualquier PC con Fluxionics instalado.

---

## Limpiador en vivo

Mientras juegas, `limpiador_vivo.bat` corre en segundo plano **cada 30 segundos** y hace:

- Mata procesos de redes de publicidad conocidos
- Limpia el caché de red de Brave
- Elimina procesos pesados que se hayan reiniciado solos (SearchIndexer, TiWorker, etc.)

Usa `timeout /t 30` internamente — consume **casi cero CPU** entre ciclos.

---

## Anti-mineros

`anti_mineros.bat` escanea más de 20 procesos conocidos de mineros y malware antes de iniciar:

```
xmrig      ethminer    nicehash    nbminer
claymore   t-rex       gminer      lolminer
srbminer   nanominer   cpuminer    bfgminer
```

También muestra en consola qué procesos están usando más del 50% de CPU para detectar actividad sospechosa.

---

## Consejos para más FPS

- Cierra el navegador con Claude u otras páginas **antes** de jugar
- No tengas Discord, Spotify ni YouTube abiertos al mismo tiempo
- Con 4 GB de RAM, cada programa extra puede costarte **10–20 FPS**
- Si tienes GPU dedicada, activa el modo de alto rendimiento en el panel de la GPU también
- Reinicia la PC antes de jugar si llevas muchas horas sin hacerlo
- Usa la opción `[2] ESTADO` para ver cuánta RAM libre tienes antes de jugar

---

## Preguntas frecuentes

**¿Por qué bajaron los FPS si abro otro programa mientras juego?**  
Con 4 GB de RAM, Windows ya ocupa casi 3 GB en reposo. Cualquier programa adicional compite directamente por la RAM restante del juego.

**¿Se puede usar en varias PCs?**  
Sí. Copia toda la carpeta `Fluxionics` a la otra PC, coloca `brave.exe` en `browser\` y ejecuta `lanzador.bat`. No necesita instalación.

**¿El sistema se queda dañado si cierro el CMD a la fuerza?**  
No. Los cambios son temporales. Al reiniciar la PC todo vuelve a la normalidad. Para restaurar manualmente ejecuta `functions\restaurar.bat`.

**¿Por qué Brave y no Edge o Chrome?**  
Brave tiene bloqueador de anuncios integrado (los ads de Bloxd.io no cargan), consume entre 30–40% menos RAM que Edge, y no tiene procesos de telemetría de Microsoft en segundo plano.

**¿Qué pasa si brave.exe no está en la carpeta browser\?**  
El verificador detecta que falta y muestra un mensaje claro indicando dónde colocarlo. El sistema no continúa hasta que esté presente.

---

## Restaurar manualmente

Si algo sale mal o cerraste el CMD sin terminar correctamente:

```batch
:: Ejecuta esto para restaurar todo
functions\restaurar.bat
```

O manualmente desde CMD como administrador:

```batch
sc start WSearch
sc start SysMain
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v Win32PrioritySeparation /t REG_DWORD /d 2 /f
```

---

<div align="center">

**FLUXIONICS v2.0**  
Desarrollado para Guillermo Rafael  
🌐 [fluxionics.github.io](https://fluxionics.github.io)

</div>
