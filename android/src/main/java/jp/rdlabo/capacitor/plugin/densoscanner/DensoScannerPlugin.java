package jp.rdlabo.capacitor.plugin.densoscanner;

import android.Manifest;
import android.util.Log;
import com.densowave.scannersdk.Common.CommException;
import com.densowave.scannersdk.Common.CommManager;
import com.densowave.scannersdk.Common.CommScanner;
import com.densowave.scannersdk.Common.CommStatusChangedEvent;
import com.densowave.scannersdk.Const.CommConst;
import com.densowave.scannersdk.Dto.CommScannerBtSettings;
import com.densowave.scannersdk.Dto.RFIDScannerSettings;
import com.densowave.scannersdk.Listener.RFIDDataDelegate;
import com.densowave.scannersdk.Listener.ScannerAcceptStatusListener;
import com.densowave.scannersdk.Listener.ScannerStatusListener;
import com.densowave.scannersdk.RFID.RFIDDataReceivedEvent;
import com.densowave.scannersdk.RFID.RFIDException;
import com.getcapacitor.JSArray;
import com.getcapacitor.JSObject;
import com.getcapacitor.PermissionState;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;
import com.getcapacitor.annotation.Permission;
import com.getcapacitor.annotation.PermissionCallback;
import java.util.List;
import java.util.Objects;
import org.json.JSONException;

@CapacitorPlugin(
    name = "DensoScanner",
    permissions = {
        @Permission(
            alias = "bluetooth",
            strings = {
                Manifest.permission.BLUETOOTH,
                Manifest.permission.BLUETOOTH_ADMIN,
                Manifest.permission.BLUETOOTH_CONNECT,
                Manifest.permission.BLUETOOTH_SCAN
            }
        )
    }
)
public class DensoScannerPlugin extends Plugin implements ScannerAcceptStatusListener, ScannerStatusListener, RFIDDataDelegate {

    public static CommScanner commScanner;
    public static boolean scannerConnected = false;
    public static boolean isOpened = false;
    public static String connectMode = "MASTER";

    private DensoScanner implementation = new DensoScanner();

    @PluginMethod
    public void attach(PluginCall call) {
        if (!isBluetoothPermissionGranted()) {
            requestPermissionForAlias("bluetooth", call, "permissionCallback");
            return;
        }

        if (isCommScanner() || scannerConnected) {
            call.resolve();
            return;
        }

        connectMode = call.getString("connectMode", "MASTER");

        if (Objects.equals(call.getString("searchType", "INITIAL"), "INITIAL")) {
            List<CommScanner> listCommScanner = CommManager.getScanners();
            if (listCommScanner != null) {
                for (CommScanner scanner : listCommScanner) {
                    if (scanner.getBTLocalName().contains("SP1")) {
                        setupCommScanner(scanner);
                        break;
                    }
                }
            }
        } else {
            CommManager.addAcceptStatusListener(this);
            CommManager.startAccept();
            Log.d("denso", "startAccept");
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
                commScanner.getRFIDScanner().setDataDelegate(this);
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
                commScanner.getRFIDScanner().setDataDelegate(this);
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
                commScanner.getRFIDScanner().setDataDelegate(null);
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
        if (commScanner == null) {
            call.reject("scanner not connected");
            return;
        }

        try {
            RFIDScannerSettings settings = commScanner.getRFIDScanner().getSettings();
            CommScannerBtSettings btSet = commScanner.getBtSettings();
            call.resolve(implementation.createSettingsResponse(settings, btSet));
        } catch (Exception e) {
            call.reject(e.getLocalizedMessage());
        }
    }

    @PluginMethod
    public void setSettings(PluginCall call) {
        if (commScanner == null) {
            call.reject("scanner not connected");
            return;
        }

        try {
            RFIDScannerSettings settings = commScanner.getRFIDScanner().getSettings();

            if (call.getString("triggerMode") != null) {
                settings.scan.triggerMode = TriggerModeMapper.fromString(call.getString("triggerMode"));
            }

            if (call.getInt("powerLevelRead") != null) {
                settings.scan.powerLevelRead = call.getInt("powerLevelRead");
            }

            if (call.getInt("session") != null) {
                settings.scan.sessionFlag = switch (call.getInt("session")) {
                    case 0 -> RFIDScannerSettings.Scan.SessionFlag.S0;
                    case 1 -> RFIDScannerSettings.Scan.SessionFlag.S1;
                    case 2 -> RFIDScannerSettings.Scan.SessionFlag.S2;
                    default -> RFIDScannerSettings.Scan.SessionFlag.S0;
                };
            }

            if (call.getString("polarization") != null) {
                settings.scan.polarization = DensoScannerPolarizationMapper.fromString(call.getString("polarization"));
            }

            CommScannerBtSettings btSet = null;
            if (call.getString("connectMode") != null) {
                btSet = implementation.updateConnectMode(commScanner, call.getString("connectMode"));
            } else {
                try {
                    btSet = commScanner.getBtSettings();
                } catch (Exception e) {
                    call.reject(e.getLocalizedMessage());
                }
            }

            try {
                commScanner.getRFIDScanner().setSettings(settings);
                call.resolve(implementation.createSettingsResponse(settings, btSet));
            } catch (Exception e) {
                call.reject(e.getLocalizedMessage());
            }
        } catch (RFIDException e) {
            call.reject(e.getLocalizedMessage());
        }
    }

    public CommScanner getCommScanner() {
        return commScanner;
    }

    @Override
    public void OnScannerAppeared(CommScanner mCommScanner) {
        setupCommScanner(mCommScanner);

        CommManager.endAccept();
        CommManager.removeAcceptStatusListener(this);
    }

    @Override
    public void onScannerStatusChanged(CommScanner scanner, CommStatusChangedEvent state) {
        CommConst.ScannerStatus scannerStatus = state.getStatus();

        if (scannerStatus.equals(CommConst.ScannerStatus.CLAIMED)) {
            notifyListeners(
                DensoScannerEvents.OnScannerStatusChanged.getWebEventName(),
                new JSObject().put("status", DensoScannerStatusEvents.SCANNER_STATUS_CLAIMED.getStatus())
            );
        } else if (scannerStatus.equals(CommConst.ScannerStatus.CLOSE_WAIT)) {
            notifyListeners(
                DensoScannerEvents.OnScannerStatusChanged.getWebEventName(),
                new JSObject().put("status", DensoScannerStatusEvents.SCANNER_STATUS_CLOSE_WAIT.getStatus())
            );
        } else if (scannerStatus.equals(CommConst.ScannerStatus.CLOSED)) {
            notifyListeners(
                DensoScannerEvents.OnScannerStatusChanged.getWebEventName(),
                new JSObject().put("status", DensoScannerStatusEvents.SCANNER_STATUS_CLOSED.getStatus())
            );
        } else {
            notifyListeners(
                DensoScannerEvents.OnScannerStatusChanged.getWebEventName(),
                new JSObject().put("status", DensoScannerStatusEvents.SCANNER_STATUS_UNKNOWN.getStatus())
            );
        }
    }

    @Override
    public void onRFIDDataReceived(CommScanner scanner, final RFIDDataReceivedEvent rfidDataReceivedEvent) {
        JSArray stringValues = new JSArray();
        JSArray hexValues = new JSArray();
        StringBuilder hexString = new StringBuilder();

        for (int i = 0; i < rfidDataReceivedEvent.getRFIDData().size(); i++) {
            byte[] uii = rfidDataReceivedEvent.getRFIDData().get(i).getUII();
            for (byte loop : uii) {
                stringValues.put(String.format("%02X ", loop).trim());
                hexString.append(String.format("%02X ", loop));
            }
            String result = hexString.toString().trim();
            hexValues.put(result);
        }

        notifyListeners(
            DensoScannerEvents.ReadData.getWebEventName(),
            new JSObject().put("codes", stringValues).put("hexValues", hexValues)
        );
    }

    public boolean isCommScanner() {
        return scannerConnected;
    }

    public void setupCommScanner(CommScanner connectedCommScanner) {
        try {
            connectedCommScanner.claim();
            implementation.updateConnectMode(connectedCommScanner, connectMode);
        } catch (CommException e) {
            e.printStackTrace();
            return;
        }

        notifyListeners(
            DensoScannerEvents.OnScannerStatusChanged.getWebEventName(),
            new JSObject().put("status", DensoScannerStatusEvents.SCANNER_STATUS_CLAIMED.getStatus())
        );

        scannerConnected = true;
        connectedCommScanner.addStatusListener(this);
        commScanner = connectedCommScanner;
    }

    private Boolean isBluetoothPermissionGranted() {
        return getPermissionState("bluetooth") == PermissionState.GRANTED;
    }

    @PermissionCallback
    private void permissionCallback(PluginCall call) {
        if (getPermissionState("bluetooth") == PermissionState.GRANTED) {
            attach(call);
        } else {
            call.reject("Permission is required to use bluetooth");
        }
    }
}
