# Seguridad

## ¿Por qué Windows marca FLUXIONICS como "Editor desconocido"?

FLUXIONICS es **100% código abierto**. Puedes leer cada línea en este repositorio antes de ejecutarlo.

La advertencia de SmartScreen aparece porque:
1. El archivo fue descargado de internet (marca `Zone.Identifier`)
2. No tiene firma digital de pago (~$200/año con Microsoft)

**FLUXIONICS nunca tendrá firma de pago — es open source y gratuito para siempre.**

## ¿Cómo verificar que es seguro?

Antes de ejecutar, puedes revisar el código completo:
- `lanzador.bat` — todo el código del menú y optimización
- `extension/content.js` — lo que se inyecta en Bloxd.io
- `extension/manifest.json` — permisos de la extensión

## Cómo omitir la advertencia

**Opción 1 — Una sola vez:**
1. Clic en `Más información`
2. Clic en `Ejecutar de todas formas`

**Opción 2 — Permanente:**
1. Clic derecho en `lanzador.bat`
2. Propiedades
3. Al final: marcar **Desbloquear** ✓
4. Aceptar

**Opción 3 — Script automático:**
Ejecutar `desbloquear.bat` incluido en el proyecto (quita la marca de descarga de todos los archivos).

## ¿Qué hace FLUXIONICS exactamente?

### lanzador.bat
- Detecta versión de Windows
- Pausa servicios de Windows temporalmente (se restauran al salir)
- Activa plan de energía "Alto Rendimiento"
- Elimina procesos no esenciales (OneDrive, Teams, etc.)
- Abre Brave con flags de optimización
- **No modifica archivos del sistema permanentemente**
- **No accede a internet por sí solo**
- **No recopila datos**

### extension/content.js
- Se inyecta únicamente en `https://bloxd.io`
- Limita FPS via `requestAnimationFrame`
- Aplica pixel ratio en `localStorage`
- **No accede a datos de otras páginas**
- **No envía información a ningún servidor**

## Reportar una vulnerabilidad

Si encuentras algo sospechoso, abre un Issue en GitHub con la etiqueta `security`.
