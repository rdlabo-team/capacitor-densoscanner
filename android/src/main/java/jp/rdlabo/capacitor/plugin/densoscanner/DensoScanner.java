package jp.rdlabo.capacitor.plugin.densoscanner;

import android.util.Log;
import com.densowave.scannersdk.Common.CommScanner;
import com.densowave.scannersdk.Dto.CommScannerBtSettings;
import com.densowave.scannersdk.Dto.RFIDScannerSettings;
import com.getcapacitor.JSObject;
import java.util.Objects;

public class DensoScanner {

    public JSObject createSettingsResponse(RFIDScannerSettings settings, CommScannerBtSettings btSettings) {
        JSObject response = new JSObject();
        response.put("triggerMode", TriggerModeMapper.toString(settings.scan.triggerMode));
        response.put("powerLevelRead", settings.scan.powerLevelRead);
        response.put("polarization", DensoScannerPolarizationMapper.toString(settings.scan.polarization));
        Integer session =
            switch (settings.scan.sessionFlag) {
                case S0 -> 0;
                case S1 -> 1;
                case S2 -> 2;
                case S3 -> 3;
            };
        response.put("session", session);
        response.put("connectMode", ConnectModeMapper.toString(btSettings.mode));

        Log.d("denso", response.toString());

        return response;
    }

    public CommScannerBtSettings updateConnectMode(CommScanner connectedCommScanner, String connectMode) {
        CommScannerBtSettings btSet = null;
        try {
            btSet = connectedCommScanner.getBtSettings();

            if (Objects.equals(connectMode, "MASTER") && btSet.mode != CommScannerBtSettings.Mode.MASTER) {
                btSet.mode = CommScannerBtSettings.Mode.SLAVE;
                connectedCommScanner.setBtSettings(btSet);
            } else if (Objects.equals(connectMode, "SLAVE") && btSet.mode != CommScannerBtSettings.Mode.SLAVE) {
                btSet.mode = CommScannerBtSettings.Mode.MASTER;
                connectedCommScanner.setBtSettings(btSet);
            } else if (Objects.equals(connectMode, "AUTO") && btSet.mode != CommScannerBtSettings.Mode.AUTO) {
                btSet.mode = CommScannerBtSettings.Mode.AUTO;
                connectedCommScanner.setBtSettings(btSet);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return btSet;
    }
}
