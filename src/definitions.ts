import type { PluginListenerHandle } from '@capacitor/core';

export interface DensoScannerPlugin {
  initialize(): Promise<void>;
  startRead(): Promise<void>;
  stopRead(): Promise<void>;

  addListener(
    eventName: DensoScannerEvent.OnScannerStatusChanged,
    listenerFunc: (event: OnScannerStatusChangedEvent) => void,
  ): Promise<PluginListenerHandle>;
  addListener(
    eventName: DensoScannerEvent.ReadData,
    listenerFunc: (event: ReadDataEvent) => void,
  ): Promise<PluginListenerHandle>;
}

export interface ReadDataEvent {
  code: string;
}

/**
 *  - SCANNER_STATUS_CLAIMED: スキャナが獲得されました
 *  - SCANNER_STATUS_CLOSE_WAIT: クローズ待ちです。切断検知するとCommScanner#closeされるまでこの状態となります
 *  - SCANNER_STATUS_CLOSED:  スキャナが解放されました
 *  - SCANNER_STATUS_UNKNOWN: 不明な状態です
 */
export interface OnScannerStatusChangedEvent {
  status: 'SCANNER_STATUS_CLAIMED' | 'SCANNER_STATUS_CLOSE_WAIT' | 'SCANNER_STATUS_CLOSED' | 'SCANNER_STATUS_UNKNOWN';
}

export enum DensoScannerEvent {
  OnScannerStatusChanged = 'OnScannerStatusChanged',
  ReadData = 'ReadData',
}
