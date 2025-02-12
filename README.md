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

- ios/Sources/DENSOScannerSDK.framework
  - Headers/
  - Modules/
  - DENSOScannerSDK
  - Info.plist

## API

<docgen-index>

* [`initialize()`](#initialize)
* [`startRead()`](#startread)
* [`stopRead()`](#stopread)
* [`addListener(DensoScannerEvent.OnScannerStatusChanged, ...)`](#addlistenerdensoscannereventonscannerstatuschanged-)
* [`addListener(DensoScannerEvent.ReadData, ...)`](#addlistenerdensoscannereventreaddata-)
* [Interfaces](#interfaces)
* [Enums](#enums)

</docgen-index>

<docgen-api>
<!--Update the source file JSDoc comments and rerun docgen to update the docs below-->

### initialize()

```typescript
initialize() => Promise<void>
```

--------------------


### startRead()

```typescript
startRead() => Promise<void>
```

--------------------


### stopRead()

```typescript
stopRead() => Promise<void>
```

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


#### DensoScannerEvent

| Members                      | Value                                 |
| ---------------------------- | ------------------------------------- |
| **`OnScannerStatusChanged`** | <code>'OnScannerStatusChanged'</code> |
| **`ReadData`**               | <code>'ReadData'</code>               |

</docgen-api>
