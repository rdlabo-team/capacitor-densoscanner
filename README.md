# capacitor-densoscanner

Capacitor plugin for DENSO Scanner

## Install

This project must be built and used locally due to the DENSO license.

```bash
% git clone git@github.com:rdlabo-team/capacitor-densoscanner.git
% cd capacitor-densoscanner
% npm install && npm run build
% npm link
```

### iOS

Download DENSOScannerSDK.framework from the DENSO website and place it in the following path. Note that the configuration under DENSOScannerSDK.framework is the default configuration.

- [THIS PLUGIN]ios/Sources/DENSOScannerSDK.framework
  - Headers/
  - Modules/
  - DENSOScannerSDK
  - Info.plist

And update the following files: Info.plist

- Supported external accessory protocols
  - com.denso-wave.scanner

### Android

Download DENSOScannerSDK.aar from the DENSO website and place it in the following path. Note that the configuration under DENSOScannerSDK.aar is the default configuration. 

- [YOUR CAPACITOR PROJECT]android/DENSOScannerSDK/DENSOScannerSDK.aar

And update the following files: variables.gradle

```gradle
ext {
    minSdkVersion = 23
    compileSdkVersion = 35
```

And update the following files: AndroidManifest.xml

```xml
    <uses-permission android:name="android.permission.BLUETOOTH" />
    <uses-permission android:name="android.permission.BLUETOOTH_ADMIN" />
    <uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />
    <uses-permission android:name="android.permission.BLUETOOTH_SCAN" />
```

## API

<docgen-index>

* [`attach(...)`](#attach)
* [`detach()`](#detach)
* [`openInventory()`](#openinventory)
* [`pullData()`](#pulldata)
* [`close()`](#close)
* [`getSettings()`](#getsettings)
* [`setSettings(...)`](#setsettings)
* [`addListener(DensoScannerEvent.OnScannerStatusChanged, ...)`](#addlistenerdensoscannereventonscannerstatuschanged-)
* [`addListener(DensoScannerEvent.ReadData, ...)`](#addlistenerdensoscannereventreaddata-)
* [Interfaces](#interfaces)
* [Enums](#enums)

</docgen-index>

<docgen-api>
<!--Update the source file JSDoc comments and rerun docgen to update the docs below-->

### attach(...)

```typescript
attach(options: DensoScannerAttachOptions) => Promise<void>
```

DENSO SP1 RFIDリーダーに接続します。

接続が成功すると、OnScannerStatusChanged イベントで 'SCANNER_STATUS_CLAIMED' が通知されます。

| Param         | Type                                                                            | Description |
| ------------- | ------------------------------------------------------------------------------- | ----------- |
| **`options`** | <code><a href="#densoscannerattachoptions">DensoScannerAttachOptions</a></code> | 接続オプション     |

**Since:** 0.0.1

--------------------


### detach()

```typescript
detach() => Promise<void>
```

DENSO SP1 RFIDリーダーから切断します。

接続を解除し、リソースを解放します。

**Since:** 0.0.1

--------------------


### openInventory()

```typescript
openInventory() => Promise<void>
```

インベントリモードでRFIDタグの読み取りを開始します。

トリガーを押すたびに連続してタグを読み取ります。
読み取られたデータは ReadData イベントで通知されます。
読み取りを停止するには close() を呼び出してください。

**Since:** 0.0.1

--------------------


### pullData()

```typescript
pullData() => Promise<void>
```

プルデータモードでRFIDタグを1回だけ読み取ります。

トリガーを1回押したときに1回だけタグを読み取ります。
読み取られたデータは ReadData イベントで通知されます。
再度読み取る場合は、このメソッドを再度呼び出してください。

**Since:** 0.0.1

--------------------


### close()

```typescript
close() => Promise<void>
```

RFIDタグの読み取りを停止します。

openInventory() または pullData() で開始した読み取りを終了します。

**Since:** 0.0.1

--------------------


### getSettings()

```typescript
getSettings() => Promise<DensoScannerSettings>
```

現在のスキャナ設定を取得します。

トリガーモード、出力レベル、セッション、偏波、接続モードなどの設定値を取得できます。

**Returns:** <code>Promise&lt;<a href="#densoscannersettings">DensoScannerSettings</a>&gt;</code>

**Since:** 0.0.1

--------------------


### setSettings(...)

```typescript
setSettings(options: DensoScannerSettings) => Promise<DensoScannerSettings>
```

スキャナ設定を変更します。

トリガーモード、出力レベル、セッション、偏波、接続モードなどを変更できます。
変更後の設定値が返されます。

| Param         | Type                                                                  | Description |
| ------------- | --------------------------------------------------------------------- | ----------- |
| **`options`** | <code><a href="#densoscannersettings">DensoScannerSettings</a></code> | 変更する設定値     |

**Returns:** <code>Promise&lt;<a href="#densoscannersettings">DensoScannerSettings</a>&gt;</code>

**Since:** 0.0.1

--------------------


### addListener(DensoScannerEvent.OnScannerStatusChanged, ...)

```typescript
addListener(eventName: DensoScannerEvent.OnScannerStatusChanged, listenerFunc: (event: OnScannerStatusChangedEvent) => void) => Promise<PluginListenerHandle>
```

スキャナの状態変更イベントをリッスンします。

スキャナが接続された、切断された、または状態が変わったときに通知されます。

| Param              | Type                                                                                                    | Description                  |
| ------------------ | ------------------------------------------------------------------------------------------------------- | ---------------------------- |
| **`eventName`**    | <code><a href="#densoscannerevent">DensoScannerEvent.OnScannerStatusChanged</a></code>                  | 'OnScannerStatusChanged' を指定 |
| **`listenerFunc`** | <code>(event: <a href="#onscannerstatuschangedevent">OnScannerStatusChangedEvent</a>) =&gt; void</code> | 状態変更時に呼び出されるコールバック関数         |

**Returns:** <code>Promise&lt;<a href="#pluginlistenerhandle">PluginListenerHandle</a>&gt;</code>

**Since:** 0.0.1

--------------------


### addListener(DensoScannerEvent.ReadData, ...)

```typescript
addListener(eventName: DensoScannerEvent.ReadData, listenerFunc: (event: ReadDataEvent) => void) => Promise<PluginListenerHandle>
```

RFIDタグの読み取りデータイベントをリッスンします。

openInventory() または pullData() でタグが読み取られたときに通知されます。

| Param              | Type                                                                        | Description             |
| ------------------ | --------------------------------------------------------------------------- | ----------------------- |
| **`eventName`**    | <code><a href="#densoscannerevent">DensoScannerEvent.ReadData</a></code>    | 'ReadData' を指定          |
| **`listenerFunc`** | <code>(event: <a href="#readdataevent">ReadDataEvent</a>) =&gt; void</code> | データ読み取り時に呼び出されるコールバック関数 |

**Returns:** <code>Promise&lt;<a href="#pluginlistenerhandle">PluginListenerHandle</a>&gt;</code>

**Since:** 0.0.1

--------------------


### Interfaces


#### DensoScannerAttachOptions

attach() メソッドのオプション

| Prop              | Type                                                                                    | Description                                                                                 |
| ----------------- | --------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------- |
| **`searchType`**  | <code><a href="#densoscannerattachsearchtype">DensoScannerAttachSearchType</a></code>   | スキャナの検索タイプ 初回接続時は INITIAL、再接続時は RECONNECT を指定します。 SLAVE（多対多）として運用する場合は常に INITIAL を指定してください。 |
| **`connectMode`** | <code><a href="#densoscannerattachconnectmode">DensoScannerAttachConnectMode</a></code> | 接続モード 1対1で運用する場合は MASTER、多対多で運用する場合は SLAVE を指定します。 SLAVE では、毎回Bluetoothの接続設定が必要です。          |


#### DensoScannerSettings

スキャナの設定を表すインターフェース

setSettings() で設定を変更する際に使用します。

| Prop                 | Type                                                                                    | Description                                  |
| -------------------- | --------------------------------------------------------------------------------------- | -------------------------------------------- |
| **`triggerMode`**    | <code><a href="#densoscannertriggermode">DensoScannerTriggerMode</a></code>             | トリガーモード。デフォルト: RFID_TRIGGER_MODE_CONTINUOUS1 |
| **`powerLevelRead`** | <code>number</code>                                                                     | 読み取り出力レベル。範囲: 4-30、デフォルト: 30                 |
| **`session`**        | <code>number</code>                                                                     | セッション番号。範囲: 0-3、デフォルト: 0                     |
| **`polarization`**   | <code><a href="#densoscannerpolarization">DensoScannerPolarization</a></code>           | 偏波設定。デフォルト: POLARIZATION_BOTH                |
| **`connectMode`**    | <code><a href="#densoscannerattachconnectmode">DensoScannerAttachConnectMode</a></code> | 接続モード                                        |


#### PluginListenerHandle

| Prop         | Type                                      |
| ------------ | ----------------------------------------- |
| **`remove`** | <code>() =&gt; Promise&lt;void&gt;</code> |


#### OnScannerStatusChangedEvent

スキャナの状態変更イベント

attach() や detach() の実行時、またはスキャナの接続状態が変わったときに通知されます。

| Prop         | Type                                                                                          | Description |
| ------------ | --------------------------------------------------------------------------------------------- | ----------- |
| **`status`** | <code><a href="#densoonscannerstatuschangedevent">DensoOnScannerStatusChangedEvent</a></code> | スキャナの現在の状態  |


#### ReadDataEvent

RFIDタグの読み取りデータイベント

openInventory() または pullData() でタグが読み取られたときに通知されます。

| Prop            | Type                  | Description                         |
| --------------- | --------------------- | ----------------------------------- |
| **`codes`**     | <code>string[]</code> | 読み取られたRFIDタグのコード（16進数文字列、スペース区切りなし） |
| **`hexValues`** | <code>string[]</code> | 読み取られたRFIDタグの16進数値（スペース区切り）         |


### Enums


#### DensoScannerAttachSearchType

| Members         | Value                    | Description                |
| --------------- | ------------------------ | -------------------------- |
| **`INITIAL`**   | <code>'INITIAL'</code>   | 初回接続時に使用。既存の接続済みスキャナを検索します |
| **`RECONNECT`** | <code>'RECONNECT'</code> | 再接続時に使用。スキャナからの接続を待機します    |


#### DensoScannerAttachConnectMode

| Members      | Value                 | Description                   |
| ------------ | --------------------- | ----------------------------- |
| **`MASTER`** | <code>'MASTER'</code> | 1対1で運用する場合に使用。アプリがスキャナを制御します  |
| **`SLAVE`**  | <code>'SLAVE'</code>  | 多対多で運用する場合に使用。複数のデバイスから接続可能です |
| **`AUTO`**   | <code>'AUTO'</code>   | 自動でモードを選択します                  |


#### DensoScannerTriggerMode

| Members                             | Value                                        | Description                           |
| ----------------------------------- | -------------------------------------------- | ------------------------------------- |
| **`RFID_TRIGGER_MODE_AUTO_OFF`**    | <code>'RFID_TRIGGER_MODE_AUTO_OFF'</code>    | トリガーを離すと読み取りを停止                       |
| **`RFID_TRIGGER_MODE_MOMENTARY`**   | <code>'RFID_TRIGGER_MODE_MOMENTARY'</code>   | トリガーを押している間のみ読み取り                     |
| **`RFID_TRIGGER_MODE_ALTERNATE`**   | <code>'RFID_TRIGGER_MODE_ALTERNATE'</code>   | トリガーを押すたびに読み取り開始/停止を切り替え              |
| **`RFID_TRIGGER_MODE_CONTINUOUS1`** | <code>'RFID_TRIGGER_MODE_CONTINUOUS1'</code> | トリガーを1回押すと連続読み取りを開始、再度押すと停止           |
| **`RFID_TRIGGER_MODE_CONTINUOUS2`** | <code>'RFID_TRIGGER_MODE_CONTINUOUS2'</code> | トリガーを1回押すと連続読み取りを開始、再度押すと停止（別の動作パターン） |


#### DensoScannerPolarization

| Members                 | Value                            | Description               |
| ----------------------- | -------------------------------- | ------------------------- |
| **`POLARIZATION_V`**    | <code>'POLARIZATION_V'</code>    | 垂直方向のタグを読み取りやすくします        |
| **`POLARIZATION_H`**    | <code>'POLARIZATION_H'</code>    | 水平方向のタグを読み取りやすくします        |
| **`POLARIZATION_BOTH`** | <code>'POLARIZATION_BOTH'</code> | 垂直・水平どちらのタグも読み取ります（デフォルト） |


#### DensoScannerEvent

| Members                      | Value                                 | Description              |
| ---------------------------- | ------------------------------------- | ------------------------ |
| **`OnScannerStatusChanged`** | <code>'OnScannerStatusChanged'</code> | スキャナの状態が変更されたときに発火するイベント |
| **`ReadData`**               | <code>'ReadData'</code>               | RFIDタグが読み取られたときに発火するイベント |


#### DensoOnScannerStatusChangedEvent

| Members                         | Value                                    | Description                                     |
| ------------------------------- | ---------------------------------------- | ----------------------------------------------- |
| **`SCANNER_STATUS_CLAIMED`**    | <code>'SCANNER_STATUS_CLAIMED'</code>    | スキャナが正常に接続され、使用可能な状態                            |
| **`SCANNER_STATUS_CLOSE_WAIT`** | <code>'SCANNER_STATUS_CLOSE_WAIT'</code> | スキャナの切断が検知され、クローズ待ちの状態。close() が呼ばれるまでこの状態となります |
| **`SCANNER_STATUS_CLOSED`**     | <code>'SCANNER_STATUS_CLOSED'</code>     | スキャナが切断され、解放された状態                               |
| **`SCANNER_STATUS_UNKNOWN`**    | <code>'SCANNER_STATUS_UNKNOWN'</code>    | 不明な状態                                           |

</docgen-api>
