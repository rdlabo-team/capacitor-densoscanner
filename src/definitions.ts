import type { PluginListenerHandle } from '@capacitor/core';

export interface DensoScannerPlugin {
  attach(options: DensoScannerAttachOptions): Promise<void>;
  detach(): Promise<void>;
  openInventory(): Promise<void>;
  pullData(): Promise<void>;
  close(): Promise<void>;

  getSettings(): Promise<DensoScannerSettings>;
  setSettings(options: DensoScannerSettings): Promise<DensoScannerSettings>;

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
  codes: string[];
  hexValues: string[];
}

/**
 *  - SCANNER_STATUS_CLAIMED: スキャナが獲得されました
 *  - SCANNER_STATUS_CLOSE_WAIT: クローズ待ちです。切断検知するとCommScanner#closeされるまでこの状態となります
 *  - SCANNER_STATUS_CLOSED:  スキャナが解放されました
 *  - SCANNER_STATUS_UNKNOWN: 不明な状態です
 */
export interface OnScannerStatusChangedEvent {
  status: DensoOnScannerStatusChangedEvent;
}

export enum DensoOnScannerStatusChangedEvent {
  SCANNER_STATUS_CLAIMED = 'SCANNER_STATUS_CLAIMED',
  SCANNER_STATUS_CLOSE_WAIT = 'SCANNER_STATUS_CLOSE_WAIT',
  SCANNER_STATUS_CLOSED = 'SCANNER_STATUS_CLOSED',
  SCANNER_STATUS_UNKNOWN = 'SCANNER_STATUS_UNKNOWN',
}

export enum DensoScannerEvent {
  OnScannerStatusChanged = 'OnScannerStatusChanged',
  ReadData = 'ReadData',
}

export enum DensoScannerTriggerMode {
  RFID_TRIGGER_MODE_AUTO_OFF = 'RFID_TRIGGER_MODE_AUTO_OFF',
  RFID_TRIGGER_MODE_MOMENTARY = 'RFID_TRIGGER_MODE_MOMENTARY',
  RFID_TRIGGER_MODE_ALTERNATE = 'RFID_TRIGGER_MODE_ALTERNATE',
  RFID_TRIGGER_MODE_CONTINUOUS1 = 'RFID_TRIGGER_MODE_CONTINUOUS1',
  RFID_TRIGGER_MODE_CONTINUOUS2 = 'RFID_TRIGGER_MODE_CONTINUOUS2',
}

export enum DensoScannerPolarization {
  POLARIZATION_V = 'POLARIZATION_V',
  POLARIZATION_H = 'POLARIZATION_H',
  POLARIZATION_BOTH = 'POLARIZATION_BOTH',
}

export interface DensoScannerAttachOptions {
  /**
   * 初回接続はINITIAL、再接続はRECONNECTを指定します。
   * ただし、SLAVE（多対多）として運用する時は常にINITIALを指定してください。
   */
  searchType: DensoScannerAttachSearchType;

  /**
   * 1対1で運用する時はMASTER、多対多で運用する時はSLAVEを指定します。
   * なお、SLAVEでは、毎回Bluetoothの接続設定が必要です。
   */
  connectMode: DensoScannerAttachConnectMode;
}

export enum DensoScannerAttachSearchType {
  INITIAL = 'INITIAL',
  RECONNECT = 'RECONNECT',
}

export enum DensoScannerAttachConnectMode {
  MASTER = 'MASTER',
  SLAVE = 'SLAVE',
  AUTO = 'AUTO',
}

export interface DensoScannerSettings {
  triggerMode: DensoScannerTriggerMode; // default: 'RFID_TRIGGER_MODE_CONTINUOUS1'
  powerLevelRead: number; // default: 30 / 4 - 30
  session: number; // default: 0 / 0 - 3
  polarization: DensoScannerPolarization; // default: 'POLARIZATION_BOTH
  connectMode: DensoScannerAttachConnectMode;

  // 初期値のままで多分大丈夫
  // sessionFlag: SESSION_FLAG_S0
  // channel: number; // default: 0 / 0 - 3
  // doubleReading: 'DOUBLE_READING_FREE' | 'DOUBLE_READING_PREVENT1' | 'DOUBLE_READING_PREVENT2'V'
  // qParam: 4;
  // linkProfile: 1;
}
