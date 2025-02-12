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

* [`echo(...)`](#echo)

</docgen-index>

<docgen-api>
<!--Update the source file JSDoc comments and rerun docgen to update the docs below-->

### echo(...)

```typescript
echo(options: { value: string; }) => Promise<{ value: string; }>
```

| Param         | Type                            |
| ------------- | ------------------------------- |
| **`options`** | <code>{ value: string; }</code> |

**Returns:** <code>Promise&lt;{ value: string; }&gt;</code>

--------------------

</docgen-api>
