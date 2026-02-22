<div align="center">

```
███████╗██╗     ██╗   ██╗██╗  ██╗██╗ ██████╗ ███╗   ██╗██╗ ██████╗███████╗
██╔════╝██║     ██║   ██║╚██╗██╔╝██║██╔═══██╗████╗  ██║██║██╔════╝██╔════╝
█████╗  ██║     ██║   ██║ ╚███╔╝ ██║██║   ██║██╔██╗ ██║██║██║     ███████╗
██╔══╝  ██║     ██║   ██║ ██╔██╗ ██║██║   ██║██║╚██╗██║██║██║     ╚════██║
██║     ███████╗╚██████╔╝██╔╝ ██╗██║╚██████╔╝██║ ╚████║██║╚██████╗███████║
╚═╝     ╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝ ╚═════╝╚══════╝
```

# FLUXIONICS v3.0

**Optimizador de rendimiento para Bloxd.io — Open Source**

[![License: MIT](https://img.shields.io/badge/License-MIT-00cc66?style=flat-square)](LICENSE)
[![Open Source](https://img.shields.io/badge/Open%20Source-%E2%9D%A4-00ff88?style=flat-square)](https://github.com)
[![Windows](https://img.shields.io/badge/Windows-7%20%7C%208%20%7C%2010%20%7C%2011-00cc66?style=flat-square&logo=windows&logoColor=white)](https://fluxionics.github.io)
[![Version](https://img.shields.io/badge/Version-3.0-00ff88?style=flat-square)](https://fluxionics.github.io)
[![Brave](https://img.shields.io/badge/Navegador-Brave%20Portable-FF5733?style=flat-square&logo=brave&logoColor=white)](https://fluxionics.github.io)
[![Status](https://img.shields.io/badge/Status-Activo-00ff88?style=flat-square)](https://fluxionics.github.io)

🌐 **[fluxionics.github.io](https://fluxionics.github.io)**

*El código fuente es 100% visible. Revísalo antes de ejecutarlo.*

</div>

---

## ¿Qué es FLUXIONICS?

FLUXIONICS es un optimizador open source para jugar **Bloxd.io** a la máxima cantidad de FPS posible en cualquier PC con Windows 7, 8, 8.1, 10 u 11.

Todo el código es visible en este repositorio — sin ejecutables ocultos, sin telemetría, sin sorpresas.

---

## ⚠️ Advertencia de SmartScreen

Si Windows muestra *"Editor desconocido"* al abrir `lanzador.bat`, es normal para cualquier `.bat` descargado de internet. Tienes tres opciones:

**Opción rápida:** Clic en `Más información` → `Ejecutar de todas formas`

**Opción permanente:**
```
1. Clic derecho en lanzador.bat
2. Propiedades → marcar "Desbloquear" al final
3. Aceptar
```

**Opción automática:** Ejecutar `desbloquear.bat` incluido en el proyecto

> El código completo está visible aquí. Puedes leer cada línea antes de ejecutar.

---

## Instalación

```
1. Descarga o clona este repositorio
2. Descarga Brave Portable → coloca brave.exe en browser\
3. Ejecuta lanzador.bat
4. Elige [1] JUGAR
```

---

## Menú principal

```
==========================================================
  FLUXIONICS v3.0  |  TuNombre
==========================================================
  Sesiones: 5  |  Tiempo: 120 min  |  FPS: 60

  [1]  JUGAR          Bloxd.io optimizado
  [2]  MIS JUEGOS     Otros juegos y URLs
  [3]  CONFIGURACION  FPS, calidad, opciones
  [4]  ESTADO         Info del sistema
  [5]  LOG            Historial de sesiones
  [6]  PROGRESO       Guardar / Restaurar cuenta
  [7]  PERFIL         Nombre, color del CMD
  [8]  REINICIAR      Borrar datos
  [9]  SALIR
==========================================================
```

---

## Configuración de FPS y Pixel

Desde el menú `[3] CONFIGURACION`:

| Opción | Descripción |
|--------|-------------|
| **Límite de FPS** | 60 / 140 / 195 / Sin límite / Personalizado |
| **Calidad pixel** | 1px / 2px / 4px / 8px / 16px |

Los valores se aplican automáticamente via extensión de Brave al abrir el juego.

---

## ¿Qué hace la optimización?

Al elegir JUGAR se ejecutan estos pasos:

| Paso | Acción | Compatible |
|------|--------|-----------|
| Detectar Windows | Lee Build Number del registro | Win 7-11 |
| Modo RAM | Asigna memoria JS según RAM libre | Todos |
| Liberar RAM | Termina procesos no esenciales | Todos |
| Pausar servicios | WSearch, SysMain, DiagTrack, etc. | Win 10/11 |
| Optimizar sistema | Plan energía, prioridad CPU, sin animaciones | Todos |
| Anti-mineros | Escanea 8+ procesos maliciosos | Todos |
| Lanzar juego | Brave + extensión FLUXIONICS | Todos |

> Todo se **restaura automáticamente** al cerrar el juego.

---

## Extensión de Brave

La carpeta `extension/` contiene una extensión de Brave que:

- Se inyecta **únicamente** en `https://bloxd.io`
- Limita FPS via `requestAnimationFrame`
- Aplica pixel ratio al canvas del juego
- No accede a ninguna otra página
- No envía datos a ningún servidor

```
extension/
├── manifest.json    ← permisos (solo bloxd.io)
├── fluxconfig.js    ← tus valores de FPS y pixel
└── content.js       ← inyector (léelo tú mismo)
```

---

## Estructura de archivos

```
Fluxionics/
├── lanzador.bat          ← Menú principal (todo el código aquí)
├── desbloquear.bat       ← Quita advertencia SmartScreen
├── README.md
├── LICENSE               ← MIT
├── CONTRIBUTING.md
├── SECURITY.md
├── .gitignore
│
├── extension/
│   ├── manifest.json
│   ├── content.js
│   └── fluxconfig.js     ← generado al jugar
│
├── browser/              ← NO incluido (poner brave.exe aquí)
├── config/               ← NO incluido (generado automático)
├── logs/                 ← NO incluido (generado automático)
└── saves/                ← NO incluido (generado automático)
```

---

## Compatibilidad

| Windows | Soporte | Servicios pausados |
|---------|---------|-------------------|
| Windows 7 | ✅ Básico | ❌ |
| Windows 8 / 8.1 | ✅ Bueno | ❌ |
| Windows 10 | ✅ Completo | ✅ |
| Windows 11 | ✅ Completo | ✅ |

---

## Contribuir

¿Quieres mejorar FLUXIONICS? Lee [CONTRIBUTING.md](CONTRIBUTING.md).

- 🐛 **Bugs** → Abre un Issue
- 💡 **Ideas** → Abre un Issue con `[SUGERENCIA]`
- 🔧 **Código** → Fork + Pull Request

---

## Licencia

MIT — libre para usar, modificar y distribuir.  
Ver [LICENSE](LICENSE) para detalles completos.

---

<div align="center">

**FLUXIONICS v3.0** · Open Source · MIT License  
Desarrollado por Guillermo Rafael  
🌐 [fluxionics.github.io](https://fluxionics.github.io)

</div>
