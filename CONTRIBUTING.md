# Contribuir a FLUXIONICS

¡Gracias por querer contribuir! Este es un proyecto open source bajo licencia MIT.

## ¿Cómo contribuir?

### Reportar un bug
1. Ve a [Issues](https://github.com/fluxionics/Optimizador-Bloxd.io/issues)
2. Click en **New Issue**
3. Describe el problema con:
   - Tu versión de Windows
   - Qué pasó exactamente
   - Qué esperabas que pasara

### Sugerir una función
1. Abre un Issue con el título `[SUGERENCIA] Tu idea aquí`
2. Explica para qué sirviría y cómo funcionaría

### Enviar código (Pull Request)
1. Haz Fork del repositorio
2. Crea una rama: `git checkout -b mi-mejora`
3. Haz tus cambios
4. Commit: `git commit -m "Descripción de qué cambiaste"`
5. Push: `git push origin mi-mejora`
6. Abre un Pull Request en GitHub

## Estructura del proyecto

```
Fluxionics/
├── lanzador.bat          ← Menú principal y lógica central
├── extension/
│   ├── manifest.json     ← Configuración de la extensión
│   ├── fluxconfig.js     ← Valores de FPS y pixel (generado)
│   └── content.js        ← Inyector en Bloxd.io
├── config/               ← Generado automáticamente
├── logs/                 ← Generado automáticamente
└── saves/                ← Generado automáticamente
```

## Reglas básicas
- El código debe funcionar en Windows 7, 8, 8.1, 10 y 11
- Comentar el código en español
- No incluir archivos de configuración personal (`config/`, `logs/`, `saves/`)
- No incluir `brave.exe` ni ningún ejecutable de terceros

## Contacto
- Web: [fluxionics.github.io](https://fluxionics.github.io)
