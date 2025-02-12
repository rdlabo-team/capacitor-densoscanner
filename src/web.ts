import { WebPlugin } from '@capacitor/core';

import type { DensoScannerPlugin } from './definitions';

export class DensoScannerWeb extends WebPlugin implements DensoScannerPlugin {
  async initialize(): Promise<void> {
    console.log('initialize');
  }
  async startRead(): Promise<void> {
    console.log('startScan');
  }
  async stopRead(): Promise<void> {
    console.log('stopScan');
  }
}
