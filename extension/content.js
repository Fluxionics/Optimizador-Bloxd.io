// FLUXIONICS v3.0 - Inyector para Bloxd.io
(function () {

  const FPS   = (typeof window.FLUXIONICS_FPS   !== 'undefined') ? window.FLUXIONICS_FPS   : 60;
  const PIXEL = (typeof window.FLUXIONICS_PIXEL !== 'undefined') ? window.FLUXIONICS_PIXEL : 8;

  console.log('[FLUXIONICS] Cargado - FPS:', FPS, '| Pixel:', PIXEL);

  // ── LIMITAR FPS VIA requestAnimationFrame ─────────────────
  // Este es el unico metodo 100% efectivo en juegos de navegador
  if (FPS > 0) {
    const msPerFrame = 1000 / FPS;
    let lastFrame = 0;
    const _raf = window.requestAnimationFrame.bind(window);

    window.requestAnimationFrame = function (cb) {
      return _raf(function (now) {
        const elapsed = now - lastFrame;
        if (elapsed >= msPerFrame) {
          lastFrame = now - (elapsed % msPerFrame);
          cb(now);
        } else {
          window.requestAnimationFrame(cb);
        }
      });
    };
    console.log('[FLUXIONICS] RAF parcheado a', FPS, 'FPS');
  }

  // ── APLICAR PIXEL AL LOCALSTORAGE ─────────────────────────
  function setPixel() {
    // Bloxd.io guarda el pixel ratio con estas claves
    const keys = [
      'bloxd_pixelRatio',
      'pixelRatio',
      'renderScale',
      'bloxd_renderScale',
      'pixelScale',
    ];
    keys.forEach(k => {
      try { localStorage.setItem(k, String(PIXEL)); } catch(e){}
    });
  }

  // Aplicar pixel inmediatamente y en cada etapa de carga
  setPixel();
  document.addEventListener('DOMContentLoaded', () => {
    setPixel();
    setTimeout(setPixel, 500);
    setTimeout(setPixel, 1500);
    setTimeout(setPixel, 3000);

    // Buscar el canvas y forzar el pixel ratio en el contexto WebGL
    setTimeout(function() {
      const canvas = document.querySelector('canvas');
      if (!canvas) return;
      // Intentar setear devicePixelRatio
      try {
        Object.defineProperty(window, 'devicePixelRatio', {
          get: function() { return PIXEL; },
          configurable: true
        });
        console.log('[FLUXIONICS] devicePixelRatio forzado a', PIXEL);
      } catch(e) {
        console.log('[FLUXIONICS] No se pudo forzar devicePixelRatio:', e);
      }
    }, 2000);
  });

  // ── MANTENER VALORES SI EL JUEGO LOS SOBREESCRIBE ─────────
  const _set = Storage.prototype.setItem;
  const pixelKeys = new Set(['bloxd_pixelRatio','pixelRatio','renderScale','pixelScale']);

  Storage.prototype.setItem = function (k, v) {
    if (pixelKeys.has(k)) return _set.call(this, k, String(PIXEL));
    return _set.call(this, k, v);
  };

})();
