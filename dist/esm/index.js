import { registerPlugin } from '@capacitor/core';
const DensoScanner = registerPlugin('DensoScanner', {
    web: () => import('./web').then((m) => new m.DensoScannerWeb()),
});
export * from './definitions';
export { DensoScanner };
//# sourceMappingURL=index.js.map