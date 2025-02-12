# capacitor-densoscanner

Capacitor plugin for DENSO Scanner

## Install

```bash
npm install capacitor-densoscanner
npx cap sync
```

### iOS

DENSOのWebサイトから、DENSOScannerSDK.frameworkをダウンロードして、以下のパスに配置してください。なお、DENSOScannerSDK.framework以下はデフォルトの構成です。

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
