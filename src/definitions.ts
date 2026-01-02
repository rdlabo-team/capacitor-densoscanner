import type { PluginListenerHandle } from '@capacitor/core';

export interface DensoScannerPlugin {
  /**
   * DENSO SP1 RFIDリーダーに接続します。
   *
   * 接続が成功すると、OnScannerStatusChanged イベントで 'SCANNER_STATUS_CLAIMED' が通知されます。
   *
   * @param options 接続オプション
   * @since 0.0.1
   */
  attach(options: DensoScannerAttachOptions): Promise<void>;

  /**
   * DENSO SP1 RFIDリーダーから切断します。
   *
   * 接続を解除し、リソースを解放します。
   *
   * @since 0.0.1
   */
  detach(): Promise<void>;

  /**
   * インベントリモードでRFIDタグの読み取りを開始します。
   *
   * トリガーを押すたびに連続してタグを読み取ります。
   * 読み取られたデータは ReadData イベントで通知されます。
   * 読み取りを停止するには close() を呼び出してください。
   *
   * @since 0.0.1
   */
  openInventory(): Promise<void>;

  /**
   * プルデータモードでRFIDタグを1回だけ読み取ります。
   *
   * トリガーを1回押したときに1回だけタグを読み取ります。
   * 読み取られたデータは ReadData イベントで通知されます。
   * 再度読み取る場合は、このメソッドを再度呼び出してください。
   *
   * @since 0.0.1
   */
  pullData(): Promise<void>;

  /**
   * RFIDタグの読み取りを停止します。
   *
   * openInventory() または pullData() で開始した読み取りを終了します。
   *
   * @since 0.0.1
   */
  close(): Promise<void>;

  /**
   * 現在のスキャナ設定を取得します。
   *
   * トリガーモード、出力レベル、セッション、偏波、接続モードなどの設定値を取得できます。
   *
   * @returns 現在のスキャナ設定
   * @since 0.0.1
   */
  getSettings(): Promise<DensoScannerSettings>;

  /**
   * スキャナ設定を変更します。
   *
   * トリガーモード、出力レベル、セッション、偏波、接続モードなどを変更できます。
   * 変更後の設定値が返されます。
   *
   * @param options 変更する設定値
   * @returns 変更後のスキャナ設定
   * @since 0.0.1
   */
  setSettings(options: DensoScannerSettings): Promise<DensoScannerSettings>;

  /**
   * スキャナの状態変更イベントをリッスンします。
   *
   * スキャナが接続された、切断された、または状態が変わったときに通知されます。
   *
   * @param eventName 'OnScannerStatusChanged' を指定
   * @param listenerFunc 状態変更時に呼び出されるコールバック関数
   * @returns イベントリスナーのハンドル（削除時に使用）
   * @since 0.0.1
   */
  addListener(
    eventName: DensoScannerEvent.OnScannerStatusChanged,
    listenerFunc: (event: OnScannerStatusChangedEvent) => void,
  ): Promise<PluginListenerHandle>;

  /**
   * RFIDタグの読み取りデータイベントをリッスンします。
   *
   * openInventory() または pullData() でタグが読み取られたときに通知されます。
   *
   * @param eventName 'ReadData' を指定
   * @param listenerFunc データ読み取り時に呼び出されるコールバック関数
   * @returns イベントリスナーのハンドル（削除時に使用）
   * @since 0.0.1
   */
  addListener(
    eventName: DensoScannerEvent.ReadData,
    listenerFunc: (event: ReadDataEvent) => void,
  ): Promise<PluginListenerHandle>;
}

/**
 * RFIDタグの読み取りデータイベント
 *
 * openInventory() または pullData() でタグが読み取られたときに通知されます。
 */
export interface ReadDataEvent {
  /** 読み取られたRFIDタグのコード（16進数文字列、スペース区切りなし） */
  codes: string[];
  /** 読み取られたRFIDタグの16進数値（スペース区切り） */
  hexValues: string[];
}

/**
 * スキャナの状態変更イベント
 *
 * attach() や detach() の実行時、またはスキャナの接続状態が変わったときに通知されます。
 */
export interface OnScannerStatusChangedEvent {
  /** スキャナの現在の状態 */
  status: DensoOnScannerStatusChangedEvent;
}

/**
 * スキャナの状態を表す列挙型
 */
export enum DensoOnScannerStatusChangedEvent {
  /** スキャナが正常に接続され、使用可能な状態 */
  SCANNER_STATUS_CLAIMED = 'SCANNER_STATUS_CLAIMED',
  /** スキャナの切断が検知され、クローズ待ちの状態。close() が呼ばれるまでこの状態となります */
  SCANNER_STATUS_CLOSE_WAIT = 'SCANNER_STATUS_CLOSE_WAIT',
  /** スキャナが切断され、解放された状態 */
  SCANNER_STATUS_CLOSED = 'SCANNER_STATUS_CLOSED',
  /** 不明な状態 */
  SCANNER_STATUS_UNKNOWN = 'SCANNER_STATUS_UNKNOWN',
}

/**
 * スキャナで発生するイベント名を表す列挙型
 */
export enum DensoScannerEvent {
  /** スキャナの状態が変更されたときに発火するイベント */
  OnScannerStatusChanged = 'OnScannerStatusChanged',
  /** RFIDタグが読み取られたときに発火するイベント */
  ReadData = 'ReadData',
}

/**
 * トリガーモードを表す列挙型
 *
 * スキャナのトリガーボタンの動作を制御します。
 */
export enum DensoScannerTriggerMode {
  /** トリガーを離すと読み取りを停止 */
  RFID_TRIGGER_MODE_AUTO_OFF = 'RFID_TRIGGER_MODE_AUTO_OFF',
  /** トリガーを押している間のみ読み取り */
  RFID_TRIGGER_MODE_MOMENTARY = 'RFID_TRIGGER_MODE_MOMENTARY',
  /** トリガーを押すたびに読み取り開始/停止を切り替え */
  RFID_TRIGGER_MODE_ALTERNATE = 'RFID_TRIGGER_MODE_ALTERNATE',
  /** トリガーを1回押すと連続読み取りを開始、再度押すと停止 */
  RFID_TRIGGER_MODE_CONTINUOUS1 = 'RFID_TRIGGER_MODE_CONTINUOUS1',
  /** トリガーを1回押すと連続読み取りを開始、再度押すと停止（別の動作パターン） */
  RFID_TRIGGER_MODE_CONTINUOUS2 = 'RFID_TRIGGER_MODE_CONTINUOUS2',
}

/**
 * 偏波（アンテナの偏波方向）を表す列挙型
 *
 * RFIDタグの読み取り方向を制御します。
 */
export enum DensoScannerPolarization {
  /** 垂直方向のタグを読み取りやすくします */
  POLARIZATION_V = 'POLARIZATION_V',
  /** 水平方向のタグを読み取りやすくします */
  POLARIZATION_H = 'POLARIZATION_H',
  /** 垂直・水平どちらのタグも読み取ります（デフォルト） */
  POLARIZATION_BOTH = 'POLARIZATION_BOTH',
}

/**
 * attach() メソッドのオプション
 */
export interface DensoScannerAttachOptions {
  /**
   * スキャナの検索タイプ
   *
   * 初回接続時は INITIAL、再接続時は RECONNECT を指定します。
   * SLAVE（多対多）として運用する場合は常に INITIAL を指定してください。
   */
  searchType: DensoScannerAttachSearchType;

  /**
   * 接続モード
   *
   * 1対1で運用する場合は MASTER、多対多で運用する場合は SLAVE を指定します。
   * SLAVE では、毎回Bluetoothの接続設定が必要です。
   */
  connectMode: DensoScannerAttachConnectMode;
}

/**
 * スキャナの検索タイプを表す列挙型
 */
export enum DensoScannerAttachSearchType {
  /** 初回接続時に使用。既存の接続済みスキャナを検索します */
  INITIAL = 'INITIAL',
  /** 再接続時に使用。スキャナからの接続を待機します */
  RECONNECT = 'RECONNECT',
}

/**
 * スキャナの接続モードを表す列挙型
 */
export enum DensoScannerAttachConnectMode {
  /** 1対1で運用する場合に使用。アプリがスキャナを制御します */
  MASTER = 'MASTER',
  /** 多対多で運用する場合に使用。複数のデバイスから接続可能です */
  SLAVE = 'SLAVE',
  /** 自動でモードを選択します */
  AUTO = 'AUTO',
}

/**
 * スキャナの設定を表すインターフェース
 *
 * setSettings() で設定を変更する際に使用します。
 */
export interface DensoScannerSettings {
  /** トリガーモード。デフォルト: RFID_TRIGGER_MODE_CONTINUOUS1 */
  triggerMode: DensoScannerTriggerMode;
  /** 読み取り出力レベル。範囲: 4-30、デフォルト: 30 */
  powerLevelRead: number;
  /** セッション番号。範囲: 0-3、デフォルト: 0 */
  session: number;
  /** 偏波設定。デフォルト: POLARIZATION_BOTH */
  polarization: DensoScannerPolarization;
  /** 接続モード */
  connectMode: DensoScannerAttachConnectMode;

  // 初期値のままで多分大丈夫
  // sessionFlag: SESSION_FLAG_S0
  // channel: number; // default: 0 / 0 - 3
  // doubleReading: 'DOUBLE_READING_FREE' | 'DOUBLE_READING_PREVENT1' | 'DOUBLE_READING_PREVENT2'V'
  // qParam: 4;
  // linkProfile: 1;
}
