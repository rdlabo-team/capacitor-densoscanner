import { WebPlugin } from '@capacitor/core';

import type { DensoScannerPlugin , DensoScannerSettings} from './definitions';
import {DensoScannerPolarization, DensoScannerTriggerMode} from './definitions';

export class DensoScannerWeb extends WebPlugin implements DensoScannerPlugin {
  async attach(): Promise<void> {
    console.log('attach');
  }
  async detach(): Promise<void> {
    console.log('detach');
  }
  async openRead(): Promise<void> {
    console.log('openRead');
  }
  async openInventory(): Promise<void> {
    console.log('openInventory');
  }
  async close(): Promise<void> {
    console.log('stopScan');
  }
  async pullData(): Promise<void> {
    console.log('pullData');
  }
  async getSettings(): Promise<DensoScannerSettings> {
    return {
      triggerMode: DensoScannerTriggerMode.RFID_TRIGGER_MODE_CONTINUOUS1,
      powerLevelRead: 30,
      session: 0,
      polarization: DensoScannerPolarization.POLARIZATION_BOTH,
    };
  }
  async setSettings(options: Partial<DensoScannerSettings>): Promise<DensoScannerSettings> {
    console.log(options);
    return {
      triggerMode: DensoScannerTriggerMode.RFID_TRIGGER_MODE_CONTINUOUS1,
      powerLevelRead: 30,
      session: 0,
      polarization: DensoScannerPolarization.POLARIZATION_BOTH,
    };
  }
}
