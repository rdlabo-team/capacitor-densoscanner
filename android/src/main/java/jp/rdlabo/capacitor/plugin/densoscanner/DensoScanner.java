package jp.rdlabo.capacitor.plugin.densoscanner;

import android.util.Log;

import com.densowave.scannersdk.Dto.RFIDScannerSettings;
import com.getcapacitor.JSObject;

public class DensoScanner {

    public JSObject createSettingsResponse(RFIDScannerSettings settings) {
        JSObject response = new JSObject();
        response.put("triggerMode", TriggerModeMapper.toString(settings.scan.triggerMode));
        response.put("powerLevelRead", settings.scan.powerLevelRead);
        response.put("polarization", DensoScannerPolarizationMapper.toString(settings.scan.polarization));
        Integer session = switch (settings.scan.sessionFlag) {
            case S0 -> 0;
            case S1 -> 1;
            case S2 -> 2;
            case S3 -> 3;
        };
        response.put("session", session);

        return response;
    }
}
