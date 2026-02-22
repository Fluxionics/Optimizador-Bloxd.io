// FLUXIONICS Background - guarda config del bat via chrome.storage
// El bat escribe los valores en un archivo y el content.js los lee

chrome.runtime.onInstalled.addListener(() => {
  // Valores por defecto al instalar
  chrome.storage.local.set({ fluxionics_fps: 60, fluxionics_pixel: 8 });
});
