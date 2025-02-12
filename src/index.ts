import { registerPlugin } from '@capacitor/core';

import type { DensoScannerPlugin } from './definitions';

const DensoScanner = registerPlugin<DensoScannerPlugin>('DensoScanner', {
  web: () => import('./web').then((m) => new m.DensoScannerWeb()),
});

export * from './definitions';
export { DensoScanner };
