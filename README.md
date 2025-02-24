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

### Android

Download DENSOScannerSDK.aar from the DENSO website and place it in the following path. Note that the configuration under DENSOScannerSDK.aar is the default configuration. 

- [YOUR CAPACITOR PROJECT]android/DENSOScannerSDK/DENSOScannerSDK.aar

And update the following files: variables.gradle

```gradle
ext {
    minSdkVersion = 23
    compileSdkVersion = 35
```

## API

<docgen-index>

* [`attach()`](#attach)
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

### attach()

```typescript
attach() => Promise<void>
```

--------------------


### detach()

```typescript
detach() => Promise<void>
```

--------------------


### openInventory()

```typescript
openInventory() => Promise<void>
```

--------------------


### pullData()

```typescript
pullData() => Promise<void>
```

--------------------


### close()

```typescript
close() => Promise<void>
```

--------------------


### getSettings()

```typescript
getSettings() => Promise<DensoScannerSettings>
```

**Returns:** <code>Promise&lt;<a href="#densoscannersettings">DensoScannerSettings</a>&gt;</code>

--------------------


### setSettings(...)

```typescript
setSettings(options: DensoScannerSettings) => Promise<DensoScannerSettings>
```

| Param         | Type                                                                  |
| ------------- | --------------------------------------------------------------------- |
| **`options`** | <code><a href="#densoscannersettings">DensoScannerSettings</a></code> |

**Returns:** <code>Promise&lt;<a href="#densoscannersettings">DensoScannerSettings</a>&gt;</code>

--------------------


### addListener(DensoScannerEvent.OnScannerStatusChanged, ...)

```typescript
addListener(eventName: DensoScannerEvent.OnScannerStatusChanged, listenerFunc: (event: OnScannerStatusChangedEvent) => void) => Promise<PluginListenerHandle>
```

| Param              | Type                                                                                                    |
| ------------------ | ------------------------------------------------------------------------------------------------------- |
| **`eventName`**    | <code><a href="#densoscannerevent">DensoScannerEvent.OnScannerStatusChanged</a></code>                  |
| **`listenerFunc`** | <code>(event: <a href="#onscannerstatuschangedevent">OnScannerStatusChangedEvent</a>) =&gt; void</code> |

**Returns:** <code>Promise&lt;<a href="#pluginlistenerhandle">PluginListenerHandle</a>&gt;</code>

--------------------


### addListener(DensoScannerEvent.ReadData, ...)

```typescript
addListener(eventName: DensoScannerEvent.ReadData, listenerFunc: (event: ReadDataEvent) => void) => Promise<PluginListenerHandle>
```

| Param              | Type                                                                        |
| ------------------ | --------------------------------------------------------------------------- |
| **`eventName`**    | <code><a href="#densoscannerevent">DensoScannerEvent.ReadData</a></code>    |
| **`listenerFunc`** | <code>(event: <a href="#readdataevent">ReadDataEvent</a>) =&gt; void</code> |

**Returns:** <code>Promise&lt;<a href="#pluginlistenerhandle">PluginListenerHandle</a>&gt;</code>

--------------------


### Interfaces


#### DensoScannerSettings

| Prop                 | Type                                                                          |
| -------------------- | ----------------------------------------------------------------------------- |
| **`triggerMode`**    | <code><a href="#densoscannertriggermode">DensoScannerTriggerMode</a></code>   |
| **`powerLevelRead`** | <code>number</code>                                                           |
| **`session`**        | <code>number</code>                                                           |
| **`polarization`**   | <code><a href="#densoscannerpolarization">DensoScannerPolarization</a></code> |


#### PluginListenerHandle

| Prop         | Type                                      |
| ------------ | ----------------------------------------- |
| **`remove`** | <code>() =&gt; Promise&lt;void&gt;</code> |


#### OnScannerStatusChangedEvent

- SCANNER_STATUS_CLAIMED: スキャナが獲得されました
- SCANNER_STATUS_CLOSE_WAIT: クローズ待ちです。切断検知するとCommScanner#closeされるまでこの状態となります
- SCANNER_STATUS_CLOSED:  スキャナが解放されました
- SCANNER_STATUS_UNKNOWN: 不明な状態です

| Prop         | Type                                                                                                                        |
| ------------ | --------------------------------------------------------------------------------------------------------------------------- |
| **`status`** | <code>'SCANNER_STATUS_CLAIMED' \| 'SCANNER_STATUS_CLOSE_WAIT' \| 'SCANNER_STATUS_CLOSED' \| 'SCANNER_STATUS_UNKNOWN'</code> |


#### ReadDataEvent

| Prop       | Type                |
| ---------- | ------------------- |
| **`code`** | <code>string</code> |


### Enums


#### DensoScannerTriggerMode

| Members                             | Value                                        |
| ----------------------------------- | -------------------------------------------- |
| **`RFID_TRIGGER_MODE_AUTO_OFF`**    | <code>'RFID_TRIGGER_MODE_AUTO_OFF'</code>    |
| **`RFID_TRIGGER_MODE_MOMENTARY`**   | <code>'RFID_TRIGGER_MODE_MOMENTARY'</code>   |
| **`RFID_TRIGGER_MODE_ALTERNATE`**   | <code>'RFID_TRIGGER_MODE_ALTERNATE'</code>   |
| **`RFID_TRIGGER_MODE_CONTINUOUS1`** | <code>'RFID_TRIGGER_MODE_CONTINUOUS1'</code> |
| **`RFID_TRIGGER_MODE_CONTINUOUS2`** | <code>'RFID_TRIGGER_MODE_CONTINUOUS2'</code> |


#### DensoScannerPolarization

| Members                 | Value                            |
| ----------------------- | -------------------------------- |
| **`POLARIZATION_V`**    | <code>'POLARIZATION_V'</code>    |
| **`POLARIZATION_H`**    | <code>'POLARIZATION_H'</code>    |
| **`POLARIZATION_BOTH`** | <code>'POLARIZATION_BOTH'</code> |


#### DensoScannerEvent

| Members                      | Value                                 |
| ---------------------------- | ------------------------------------- |
| **`OnScannerStatusChanged`** | <code>'OnScannerStatusChanged'</code> |
| **`ReadData`**               | <code>'ReadData'</code>               |

</docgen-api>
