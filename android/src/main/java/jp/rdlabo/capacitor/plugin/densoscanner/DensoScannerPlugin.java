package jp.rdlabo.capacitor.plugin.densoscanner;

import android.util.Log;

import com.densowave.scannersdk.Common.CommStatusChangedEvent;
import com.densowave.scannersdk.Const.CommConst;
import com.densowave.scannersdk.Listener.ScannerStatusListener;
import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;

import com.densowave.scannersdk.Common.CommException;
import com.densowave.scannersdk.Common.CommManager;
import com.densowave.scannersdk.Common.CommScanner;
import com.densowave.scannersdk.Listener.ScannerAcceptStatusListener;

@CapacitorPlugin(name = "DensoScanner")
public class DensoScannerPlugin extends Plugin implements ScannerAcceptStatusListener, ScannerStatusListener {
    public static CommScanner commScanner;
    public static boolean scannerConnected = false;
    public static boolean isOpened = false;

    private DensoScanner implementation = new DensoScanner();

    @PluginMethod
    public void attach(PluginCall call) {
        if (!isCommScanner()) {
            CommManager.addAcceptStatusListener(this);
            CommManager.startAccept();
        }
        call.resolve();
    }

    @PluginMethod
    public void detach(PluginCall call) {
        if (commScanner != null) {
            try {
                commScanner.close();
                commScanner.removeStatusListener(this);
                scannerConnected = false;
                commScanner = null;
                call.resolve();
            } catch (CommException e) {
                call.reject(e.getLocalizedMessage());
            }
        } else {
            call.resolve();
        }
    }

    @PluginMethod
    public void openInventory(PluginCall call) {
        if (commScanner == null) {
            call.reject("scanner not connected");
            return;
        }
        if (!isOpened) {
            try {
                isOpened = true;
                commScanner.getRFIDScanner().openInventory();
                call.resolve();
            } catch (Exception e) {
                call.reject(e.getLocalizedMessage());
            }
        } else {
            call.resolve();
        }
    }

    @PluginMethod
    public void pullData(PluginCall call) {
        if (commScanner == null) {
            call.reject("scanner not connected");
            return;
        }
        if (!isOpened) {
            try {
                isOpened = true;
                commScanner.getRFIDScanner().pullData(1);
                call.resolve();
            } catch (Exception e) {
                call.reject(e.getLocalizedMessage());
            }
        } else {
            call.resolve();
        }
    }

    @PluginMethod
    public void close(PluginCall call) {
        if (isOpened) {
            try {
                isOpened = false;
                commScanner.getRFIDScanner().close();
                call.resolve();
            } catch (Exception e) {
                call.reject(e.getLocalizedMessage());
            }
        } else {
            call.resolve();
        }
    }

    @PluginMethod
    public void getSettings(PluginCall call) {
    }

    @PluginMethod
    public void setSettings(PluginCall call) {
    }

    public CommScanner getCommScanner() {
        return commScanner;
    }


    @Override
    public void OnScannerAppeared(CommScanner mCommScanner) {
        boolean successFlag = false;
        try {
            mCommScanner.claim();
            // Abort the connection request
            CommManager.endAccept();
            CommManager.removeAcceptStatusListener(this);
            successFlag = true;
        } catch (CommException e) {
            e.printStackTrace();
        }

        try {
            setConnectedCommScanner(mCommScanner);
            commScanner = getCommScanner();
            if (successFlag) {
                // TODO: 接続成功をListenerで通知
            }
        } catch (Exception e) {
            Log.d("denso", "Exception " + e.getMessage());
        }
    }

    @Override
    public void onScannerStatusChanged(CommScanner scanner, CommStatusChangedEvent state) {
        CommConst.ScannerStatus scannerStatus = state.getStatus();
        if (scannerStatus.equals(CommConst.ScannerStatus.CLOSE_WAIT)) {
            // TODO: ステータスの変更をイベントで通知
        }
    }

    public boolean isCommScanner() {
        return scannerConnected;
    }


    public void setConnectedCommScanner(CommScanner connectedCommScanner) {
        if (connectedCommScanner != null) {
            scannerConnected = true;
            connectedCommScanner.addStatusListener(this);
        } else {
            scannerConnected = false;
            if (commScanner != null) {
                commScanner.removeStatusListener(this);
            }
        }
        commScanner = connectedCommScanner;
    }
}

