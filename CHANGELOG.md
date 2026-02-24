# Changelog

## [3.0.1] - Pre-release

### Nuevo
- **Auto-updater** — detecta nueva versión en GitHub y avisa en el menú
- **Modo Competitivo** — optimización extra automática al iniciar partida
- **Multi-idioma** — inglés y español automático según el Windows del usuario
- **Discord RPC** — notificación al iniciar sesión de juego
- **Instalador automático** — `instalar.bat` configura todo desde cero
- **Benchmark** — mide rendimiento del sistema y guarda historial
- Versión visible en menú junto al estado de actualizaciones

### Mejorado
- Timer resolution de 1ms via NtSetTimerResolution (menos input lag)
- CPU affinity asigna todos los núcleos a Brave automáticamente
- Menú con opción `[U]` para ver estado de updates y `[B]` para benchmark

## [3.0.0] - 2025

### Nuevo
- Menú completo en CMD con 9 opciones
- Sección `[3] CONFIGURACION` separada para FPS y pixel
- Extensión de Brave que inyecta FPS y pixel en Bloxd.io
- Perfil personalizable (nombre, color del CMD)
- Contador de sesiones y tiempo total jugado
- Sección `[2] MIS JUEGOS` para agregar URLs personalizadas
- Sistema de exportar/importar cuenta de Bloxd.io
- Anti-mineros mejorado (8+ procesos)
- Compatible Windows 7 / 8 / 8.1 / 10 / 11
- Archivo `desbloquear.bat` para omitir SmartScreen

### Mejorado
- Optimización más agresiva en Win10/11
- NetworkThrottlingIndex desactivado
- Prioridad de GPU al máximo via registro
- Restauración automática al cerrar el juego

### Corregido
- Error "Se produjo un error en el perfil" de Brave
- CMD se cerraba al usar MIS JUEGOS
- Flags de Brave que bajaban FPS a 45

## [2.0.0] - 2025

### Nuevo
- Panel HTML reemplazado por panel CMD
- Detección automática de RAM con 4 modos
- Limpiador en vivo cada 30 segundos
- Logger de sesiones

## [1.0.0] - 2025

### Inicial
- Panel HTML con diseño terminal
- Brave Portable con flags básicas
- Scripts en `functions/`
