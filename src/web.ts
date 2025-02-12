import { WebPlugin } from '@capacitor/core';

import type { DensoScannerPlugin } from './definitions';

export class DensoScannerWeb extends WebPlugin implements DensoScannerPlugin {
  async echo(options: { value: string }): Promise<{ value: string }> {
    console.log('ECHO', options);
    return options;
  }
}
