import { WebPlugin } from '@capacitor/core';
import { DensoScannerAttachConnectMode, DensoScannerPolarization, DensoScannerTriggerMode } from './definitions';
export class DensoScannerWeb extends WebPlugin {
    async attach() {
        console.log('attach');
    }
    async detach() {
        console.log('detach');
    }
    async openInventory() {
        console.log('openInventory');
    }
    async close() {
        console.log('stopScan');
    }
    async pullData() {
        console.log('pullData');
    }
    async getSettings() {
        return {
            triggerMode: DensoScannerTriggerMode.RFID_TRIGGER_MODE_CONTINUOUS1,
            powerLevelRead: 30,
            session: 0,
            polarization: DensoScannerPolarization.POLARIZATION_BOTH,
            connectMode: DensoScannerAttachConnectMode.AUTO,
        };
    }
    async setSettings(options) {
        console.log(options);
        return {
            triggerMode: DensoScannerTriggerMode.RFID_TRIGGER_MODE_CONTINUOUS1,
            powerLevelRead: 30,
            session: 0,
            polarization: DensoScannerPolarization.POLARIZATION_BOTH,
            connectMode: DensoScannerAttachConnectMode.AUTO,
        };
    }
}
//# sourceMappingURL=web.js.map