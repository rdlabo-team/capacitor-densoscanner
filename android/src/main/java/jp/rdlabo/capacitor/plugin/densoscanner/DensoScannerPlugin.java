package jp.rdlabo.capacitor.plugin.densoscanner;

import android.Manifest;
import android.util.Log;

import com.densowave.scannersdk.Common.CommStatusChangedEvent;
import com.densowave.scannersdk.Const.CommConst;
import com.densowave.scannersdk.Dto.BarcodeScannerSettings;
import com.densowave.scannersdk.Dto.CommScannerBtSettings;
import com.densowave.scannersdk.Dto.RFIDScannerSettings;
import com.densowave.scannersdk.Listener.RFIDDataDelegate;
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

import com.densowave.scannersdk.Common.CommException;
import com.densowave.scannersdk.Common.CommManager;
import com.densowave.scannersdk.Common.CommScanner;
import com.densowave.scannersdk.Listener.ScannerAcceptStatusListener;
import com.getcapacitor.annotation.Permission;
import com.getcapacitor.annotation.PermissionCallback;

import java.util.List;

@CapacitorPlugin(
       name = "DensoScanner",
       permissions = {
               @Permission(
                       alias = "bluetooth",
                       strings = {
                               Manifest.permission.BLUETOOTH,
                               Manifest.permission.BLUETOOTH_ADMIN,
                               Manifest.permission.BLUETOOTH_CONNECT,
                               Manifest.permission.BLUETOOTH_SCAN,
                       }
               ),
       }
)
public class DensoScannerPlugin extends Plugin implements ScannerAcceptStatusListener, ScannerStatusListener, RFIDDataDelegate {
    public static CommScanner commScanner;
    public static boolean scannerConnected = false;
    public static boolean isOpened = false;

    private DensoScanner implementation = new DensoScanner();

    @PluginMethod
    public void attach(PluginCall call) {
        if (!isBluetoothPermissionGranted()) {
            requestPermissionForAlias("bluetooth", call, "permissionCallback");
            return;
        }

        if (isCommScanner()) {
            call.resolve();
            return;
        }

        List<CommScanner> listCommScanner = CommManager.getScanners();
        if (listCommScanner != null) {
            for (CommScanner scanner: listCommScanner) {
                if (scanner.getBTLocalName().contains("SP1")) {
                    try {
                        Log.d("denso", "Try connect to " + scanner.getBTLocalName());
                        scanner.claim();
                        notifyListeners(DensoScannerStatusEvents.SCANNER_STATUS_CLAIMED.getStatus(), new JSObject());
                        scannerConnected = true;
                        commScanner = scanner;
                    } catch (CommException e) {
                        Log.d("denso", "Exception " + e.getMessage());
                    }
                    break;
                }
            }
        }

        if (!scannerConnected) {
            CommManager.addAcceptStatusListener(this);
            CommManager.startAccept();
            Log.d("denso", "startAccept");
        }
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
            call.resolve(implementation.createSettingsResponse(settings));
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

            commScanner.getRFIDScanner().setSettings(settings);
            call.resolve(implementation.createSettingsResponse(settings));
            
        } catch (RFIDException e) {
            call.reject(e.getLocalizedMessage());
        }
    }

    public CommScanner getCommScanner() {
        return commScanner;
    }


    @Override
    public void OnScannerAppeared(CommScanner mCommScanner) {
        Log.d("denso", "OnScannerAppeared");
        try {
            mCommScanner.claim();
            notifyListeners(DensoScannerStatusEvents.SCANNER_STATUS_CLAIMED.getStatus(), new JSObject());
            // Abort the connection request
            CommManager.endAccept();
            CommManager.removeAcceptStatusListener(this);
        } catch (CommException e) {
            e.printStackTrace();
        }

        try {
            setConnectedCommScanner(mCommScanner);
            commScanner = getCommScanner();
        } catch (Exception e) {
            Log.d("denso", "Exception " + e.getMessage());
        }
    }

    @Override
    public void onScannerStatusChanged(CommScanner scanner, CommStatusChangedEvent state) {
        Log.d("denso", "onScannerStatusChanged");
        CommConst.ScannerStatus scannerStatus = state.getStatus();

        if (scannerStatus.equals(CommConst.ScannerStatus.CLAIMED)) {
            notifyListeners(DensoScannerStatusEvents.SCANNER_STATUS_CLAIMED.getStatus(), new JSObject());
        } else if (scannerStatus.equals(CommConst.ScannerStatus.CLOSE_WAIT)) {
            notifyListeners(DensoScannerStatusEvents.SCANNER_STATUS_CLOSE_WAIT.getStatus(), new JSObject());
        } else if (scannerStatus.equals(CommConst.ScannerStatus.CLOSED)) {
            notifyListeners(DensoScannerStatusEvents.SCANNER_STATUS_CLOSED.getStatus(), new JSObject());
        } else {
            notifyListeners(DensoScannerStatusEvents.SCANNER_STATUS_UNKNOWN.getStatus(), new JSObject());
        }
    }

    @Override
    public void onRFIDDataReceived(CommScanner scanner, final RFIDDataReceivedEvent rfidDataReceivedEvent) {
        JSArray data = new JSArray();

        for (int i = 0; i < rfidDataReceivedEvent.getRFIDData().size(); i++) {
            byte[] uii = rfidDataReceivedEvent.getRFIDData().get(i).getUII();
            for (byte loop: uii) {
                data.put(String.format("%02X ", loop).trim());
            }
        }

        notifyListeners(DensoScannerEvents.ReadData.getWebEventName(), new JSObject().put("codes", data));
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

    private Boolean isBluetoothPermissionGranted()  {
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

