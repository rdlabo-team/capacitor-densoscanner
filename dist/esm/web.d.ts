import { WebPlugin } from '@capacitor/core';
import type { DensoScannerPlugin, DensoScannerSettings } from './definitions';
export declare class DensoScannerWeb extends WebPlugin implements DensoScannerPlugin {
    attach(): Promise<void>;
    detach(): Promise<void>;
    openInventory(): Promise<void>;
    close(): Promise<void>;
    pullData(): Promise<void>;
    getSettings(): Promise<DensoScannerSettings>;
    setSettings(options: Partial<DensoScannerSettings>): Promise<DensoScannerSettings>;
}
